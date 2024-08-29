#!/usr/bin/env bash

# This script is used to run Ansible commands in the container

set -euo pipefail

# Change to the project root directory.
WD="$(dirname "${BASH_SOURCE[0]}")"
cd "$WD"/.. && pwd

source ./.env

echo "Provisioning $CLUSTER_NAME"

ARGS=("$@")

INVENTORY_PATH="~/inventory/${CLUSTER_NAME}"

function play() {
  local CMD="${ARGS[@]:1}"
  ansible-playbook --flush-cache -T 30 \
    -i $INVENTORY_PATH/hosts.yaml \
    -e @$INVENTORY_PATH/cluster-variables.yaml \
    -b --become-user=root ${CMD:-$@}
}

function cluster() {
  play cluster.yml
}

function reset() {
  play reset.yml
}

function help() {
  echo "Usage: $0 <command>"
  echo
  echo "Commands:"
  echo "  cluster"
  echo "  reset"
  echo "  help"
}

# Handle commands
case "${ARGS[0]}" in
  cluster)
    cluster
    ;;
  reset)
    reset
    ;;
  help)
    help
    ;;
  *)
    help
    ;;
esac
