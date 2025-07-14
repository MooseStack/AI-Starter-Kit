# LearningBuddy


## Bring up n8n and granite model
```
podman network create shared-network

podman run -it -p 5678:5678 --name n8n --network shared-network docker.n8n.io/n8nio/n8n

podman run -it -p 8080:8080 --name granite --network shared-network docker.io/redhat/granite-3-2b-instruct -s 
```