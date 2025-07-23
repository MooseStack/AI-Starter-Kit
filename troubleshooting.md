
# Podman
To check status of all containers, run:
```
podman ps -a
```

To check the listing and size of each image on your local environment: 

```
podman images
```

If you can not run a new container as the name is already in use, stop a container and then remove it.
To stop a container:
```
podman stop <container-name>
```

To stop all containers:
```
podman stop -a
```

To stop a container:
```
podman rm <container-name>
```

To stop remove all containers:
```
podman rm -a
```

If a container has crashed with an Exited message then get the logs using: 
```
podman logs <container-name>
```

# Misc.
To check the cpu and memory usage, run:
```
## For containers
podman top <container-name>

## For host
top

top

free -h
```

To check the storage space used and available:
```
df -h
```

To check the CPU specifications:

```
lscpu
``` 


# Skopeo
To check the architecture that an image supports:
```
skopeo inspect docker://<Image-path> | grep -i architecture
```

Example:

```
skopeo inspect docker://ghcr.io/ggml-org/llama.cpp:full | grep -i architecture
```
