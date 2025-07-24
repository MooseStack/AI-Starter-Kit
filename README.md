# AI-Starter-Kit
The AI Starter Kit is designed to showcase popular AI projects working together using podman/docker containers on a 64-bit(intel/AMD) architecture CPU. While not intended for production or high-scale workloads, it offers a practical foundation to explore AI integrations in constrained or secure settings without requiring GPU resources or external services. Built with entirely open or fair source code components, it features:

- [n8n](https://n8n.io/) - no/low code automation with AI Agents
- [Open-WebUI](https://openwebui.com/) - self-hosted alternative to ChatGPT's UI
- [Granite 2B Instruct](https://huggingface.co/ibm-granite/granite-3.3-2b-instruct) Model - Text Generation and Function Calling(RAG support)
- [Granite Embedding](https://huggingface.co/ibm-granite/granite-embedding-125m-english) Model - generate Embeddings/Vectors out of input
- [llama.cpp](https://github.com/ggml-org/llama.cpp) - serving of the models on CPU
- [PostgreSQL](https://www.postgresql.org/) with [pgvector](https://github.com/pgvector/pgvector) - SQL database with vector support

# Architecture
![Architecture](architecture.svg)


# Requirements
 - `podman` installed. `docker` can also be used as an alternative.
- 30GB of disk space
- 8 vCPUs
- 16GB Memory
- 64 bit architecture (amd/intel) CPU.
  - ARM architecture (Mac) is not supported atm

# Getting Started - Options:
## A - podman - using script
`chmod 755 podman-build-run.sh && ./podman-build-run.sh` - this script is interactive and will:
- ask for confirmation before stopping running containers and deleting its image.
- will run `podman build`, `podman run` for all containers needed to get started.
- will provide status at the end of containers along with credential information.


## B - podman - Manually

### 1. Create shared network
`podman network create shared-network`

### 2. granite instruct GenAI model
```
podman build -t granite-instruct-llamacpp:latest ./granite-instruct-llamacpp/

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



## Troubleshooting commands
[./troubleshooting.md](troubleshooting.md)
