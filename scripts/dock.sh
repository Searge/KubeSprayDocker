#!/usr/bin/env bash
# Wrapper script for running the Docker image.
# It could be used to run with Podman or Docker Engine.

set -euo pipefail

ARGS=("$@")

# Change to the project root directory.
WD="$(dirname "${BASH_SOURCE[0]}")"
cd "$WD"/.. && pwd

source .env

# If podman installed use podman instead of docker
if [ -x "$(command -v podman)" ]; then
  export _is_docker_=false
  export DOCKER=podman
else
  export _is_docker_=true
  export DOCKER=docker
fi

# Check if docker image is present in the system
# If not, pull the image
if [ -z "$($DOCKER images -q "${DOCKER_IMAGE}" 2> /dev/null)" ]; then
  echo "Docker image not found. Pulling the image..."
  $DOCKER pull "${DOCKER_IMAGE}"
fi

function up {
  # Function to start the docker image
  if [ "$_is_docker_" = true ]; then
    $DOCKER compose up -d
  else
    podman-compose up -d
  fi
}

function down {
  # Function to stop the docker image
  if [ "$_is_docker_" = true ]; then
    $DOCKER compose down
  else
    podman-compose down
  fi
}

function start {
  # Function to start the docker image
  if [ "$_is_docker_" = true ]; then
    $DOCKER compose start
  else
    podman-compose start
}

function stop {
  # Function to stop the docker image
  if [ "$_is_docker_" = true ]; then
    $DOCKER compose stop
  else
    podman-compose stop
  fi
}

function  ps {
  # Function to list the docker image
  if [ "$_is_docker_" = true ]; then
    $DOCKER compose ps
  else
    podman-compose ps
  fi
}

function shell {
  # Function to open a shell in the docker image
  $DOCKER exec -it kubespray_local /bin/bash
}

function cleanup {
  # Function to cleanup the docker image
  if [ "$_is_docker_" = true ]; then
    $DOCKER compose down -v
    $DOCKER rmi "${CUSTOM_IMAGE}"
  else
    podman-compose down -v
    $DOCKER rmi "${CUSTOM_IMAGE}"
  fi
}

function help {
  # Function to print the help message
  echo "Usage: $0 [command]"
  echo ""
  echo "Commands:"
  echo "  up       Start the docker image"
  echo "  down     Stop the docker image"
  echo "  start    Start the docker image"
  echo "  stop     Stop the docker image"
  echo "  ps       List the docker image"
  echo "  shell    Open a shell in the docker image"
  echo "  cleanup  Cleanup the docker image"
}

# Handle arguments
case "${ARGS[0]}" in
  up)
    up
    ;;
  down)
    down
    ;;
  start)
    start
    ;;
  stop)
    stop
    ;;
  ps)
    ps
    ;;
  shell)
    shell
    ;;
  cleanup)
    cleanup
    ;;
  *)
    help
    ;;
esac
