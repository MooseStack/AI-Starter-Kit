#!/bin/bash
set -e

# Container definitions: name|hostport:containerport
CONTAINERS=(
  "granite|8080:8080"
  "n8n|5678:5678"
  "open-webui|3000:8080"
)

#network to create if it does not exist
NETWORK_NAME="shared-network"





#### START OF FUNCTIONS
create_network() {
  if ! podman network ls --format "{{.Name}}" | grep -w "$NETWORK_NAME" &>/dev/null; then
    echo "Creating network $NETWORK_NAME..."
    podman network create "$NETWORK_NAME"
  fi
}

build_container() {
  local NAME="$1"
  echo
  echo "########## Building $NAME... ##########"
  podman build -t "$NAME:latest" ./$NAME
}

run_container() {
  local NAME="$1"
  local PORT="$2"
  echo
  echo "Starting $NAME..."
  podman run -dit -p $PORT --name "$NAME" --network "$NETWORK_NAME" localhost/"$NAME":latest
  if [ "$NAME" = "granite" ]; then
    sleep 5
  elif [ "$NAME" = "n8n" ]; then
    sleep 10
  fi
}

stop_and_remove_container() {
  local NAME="$1"
  echo "Stopping $NAME..."
  podman stop "$NAME" || true
  echo "Removing $NAME..."
  podman rm "$NAME" || true
}

check_status() {
  echo
  echo '##### CHECKING STATUS OF CONTAINERS #####'
  sleep 10
  echo "Containers started successfully:"
  for ENTRY in "${CONTAINERS[@]}"; do
    IFS='|' read -r NAME PORT <<< "$ENTRY"
    if podman ps --format "{{.Names}}" | grep -w "$NAME" &>/dev/null; then
      echo "- $NAME is running"
    else
      echo "- $NAME failed to start"
    fi
  done
}
#### END OF FUNCTIONS



# Main script to execute above functions
create_network
for ENTRY in "${CONTAINERS[@]}"; do
  IFS='|' read -r NAME PORT <<< "$ENTRY"
  if podman ps -a --format "{{.Names}}" | grep -w "$NAME" &>/dev/null; then
    read -p "Container '$NAME' exists. Stop and remove it? (y/n): " CONFIRM
    if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
      stop_and_remove_container "$NAME"
      build_container "$NAME"
      run_container "$NAME" "$PORT"
    else
      echo "Skipping $NAME."
    fi
  else
    build_container "$NAME"
    run_container "$NAME" "$PORT"
  fi

done
check_status

