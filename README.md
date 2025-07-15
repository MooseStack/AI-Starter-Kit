# LearningBuddy

# Setup


## Using podman

### 1. Create shared network
`podman network create shared-network`

### 2. granite
```
podman build -t granite:latest ./granite/

podman run -dit -p 8080:8080 --name granite --network shared-network localhost/granite:latest
```

### 3. n8n
```
podman build -t n8n:latest ./n8n/

podman run -dit -p 5678:5678 --name n8n --network shared-network localhost/n8n:latest
```

- Default credentials:
```
User: test@test.com
Password: ThisisaTEST1
```

### 4. open-webui

```
podman build -t open-webui:latest ./open-webui 

podman run -dit -p 3000:8080 --name open-webui --network shared-network localhost/open-webui:latest
```

- Default credentials
```
User: test@test.com
Password: test
```