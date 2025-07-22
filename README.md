# AI-Starter-Kit

# Architecture
![Architecture](architecture.svg)


# Setup

# Resource

- 30GB of disk space
- 8 vCPUs
- 16GB Memory
- 64 bit architecture (amd/intel 64). 
  - ARM architecture (Mac) is not supported atm

## podman - using script
`./podman-build-run.sh` - this script is interactive and will:
- ask for confirmation before stopping running containers and deleting its image. In 1 ask (y/n).
- will run `podman build`, `podman run` for granite, n8n, and open-webui
- will provide status at the end of containers
- if the script does not work, make sure to change it by adding the permission to execute the file: chmod +x 755 podman-build-run.sh

## podman - Manually

### 1. Create shared network
`podman network create shared-network`

### 2. granite instruct GenAI model
```
podman build -t granite-instruct-llamacpp:latest ./granite/

podman run -dit -p 8080:8080 --name granite-instruct-llamacpp --network shared-network localhost/granite-instruct-llamacpp:latest
```

- http://localhost:8080

### 3. n8n - Low/No code automation with AI Agents
```
podman build -t n8n:latest ./n8n/

podman run -dit -p 5678:5678 --name n8n --network shared-network localhost/n8n:latest
```

- http://localhost:5678

- Default credentials:
```
User: test@test.com
Password: ThisisaTEST1
```

### 4. open-webui - ChatGPT UI alternative

```
podman build -t open-webui:latest ./open-webui 

podman run -dit -p 3000:8080 --name open-webui --network shared-network localhost/open-webui:latest
```

- http://localhost:3000

- Default credentials
```
User: test@test.com
Password: test
```

### 5. postgres / pgvector - vector enabled postgres database
```
podman build -t postgres:latest ./postgres/

podman run -dit -p 5432:5432 --name postgres --network shared-network localhost/postgres:latest
```

- `psql -h localhost -p 5432 -U postgres -d postgres` - password is "postgres" when prompted



### 6. granite embedding model - used to create vectors that save to postgres
```
podman build -t granite-embedding-llamacpp:latest ./granite-embedding-llamacpp/

podman run -dit -p 8888:8888 --name granite-embedding-llamacpp --network shared-network localhost/granite-embedding-llamacpp:latest
```

- http://localhost:8888

### 7. Troubleshooting tips 
```
To check if all containers are up, run:
```
podman ps -a
```
If you can not run a new container as the name is already in use, stop a container and then remove it.
```
To stop a container:
podman stop <container-name>
```
To stop all containers:
podman stop -a

```
To stop a container:
podman rm <container-name>
```
To stop all containers:
podman rm -a

``` 
If a container has crashed with an Exited message then get the logs using: 
podman logs <container-name>
```
To check the cpu and memory usage, run:
top
top -H
free -h
```
To check the storage space used and available:
df -h
```
To check the CPU specifications:
lscpu
``` 
To check the listing and size of each image on your local environment: 
podman images
```
To check if llama.cpp supports your architecture:
skopeo inspect <Image-path> | grep -i Architecture
```
Example:
skopeo inspect docker://ghcr.io/ggml-org/llama.cpp:full | grep -i Architecture
