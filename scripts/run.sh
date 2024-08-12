#!/usr/bin/env bash

# This script is used to run Kubespray in Docker.
# It checks if Docker is installed and pulls the Kubespray image if it is not present.
# It then runs the Kubespray commands inside the container.
#
# Usage:
#   ./run.sh [command] [arguments]
#
# Example:
#   ./run.sh cluster mycluster
#   ./run.sh generate .env.generate
set -e

ARGS=("$@")

# Change to the project root directory.
WD="$(dirname "${BASH_SOURCE[0]}")"
pwd

source .env.dist

# If podman installed use podman instead of docker
if [ -x "$(command -v podman)" ]; then
  export DOCKER=podman
else
  export DOCKER=docker
fi

function run_cmd_in_container {
  # Function to run a command in the container
  # It mounts the SSH key, inventory, scripts and .env files
  # It also passes the arguments to the command
  local ARGS=("$@")
  $DOCKER run --rm -it \
    --mount type=bind,source="${SSH_KEY}",target=/root/.ssh/${SSH_KEY_FILE} \
    --mount type=bind,source="${SSH_CONFIG}",target=/root/.ssh/config \
    --mount type=bind,source="${WD}/inventory",target=/inventory \
    --mount type=bind,source="${WD}/scripts",target=/kubespray/scripts \
    --mount type=bind,source="${WD}/.env",target=/kubespray/.env \
    "${DOCKER_IMAGE}" "${ARGS[@]}"
}

function fix_inventory_owner {
  # Fix inventory owner
  # This is needed because the inventory is generated inside the container
  # and the files are owned by root
  echo "Fixing inventory owner..."
  sudo chown -R $USER:$USER inventory
}

function generate {
  # Function to generate inventory
  # It uses run_cmd_in_container function to run the generate-inventory script
  # You should create a dedicated .env file for the generate command
  # Example:
  # CLUSTER_NAME=cluster1
  # IPS=(10.0.0.20 10.0.0.21)
  # And then run the script with the following command:
  # ./run.sh generate ./.env/.env.generate
  ENV_FILE=$1
  run_cmd_in_container bash ./scripts/generate-inventory.sh $ENV_FILE &&
    fix_inventory_owner
}

# Handle arguments
case "${ARGS[0]}" in
  cluster)
    run_cmd_in_container bash ./scripts/cluster.sh "${ARGS[@]:1}"
    ;;
  generate)
    generate "${ARGS[@]:1}"
    ;;
  fix_owner)
    fix_inventory_owner
    ;;
  cleanup)
    cleanup
    ;;
  *)
    run_cmd_in_container "${ARGS[@]}"
    ;;
esac
