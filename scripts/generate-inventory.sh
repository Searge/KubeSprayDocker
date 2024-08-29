#!/usr/bin/env bash

# This script generates the inventory for a Kubernetes cluster using Kubespray.
#
# It reads the necessary configuration from the .env.local file and uses it to create
# the required directories and generate the hosts.yaml file using the inventory.py script.
#
# Usage:
#   ./generate-inventory.sh [.env.local]
#
# Where [.env.local] is the path to the environment configuration file.
#
# The script does the following:
# 1. Sets up the necessary variables from the environment file
# 2. Creates the inventory directory structure
# 3. Generates the hosts.yaml file using the inventory.py script
#
# Note: This script assumes that the inventory.py script is located in the contrib/inventory_builder directory,
#       so, you should use it inside the Docker container.

set -e

ENV_FILE=$1
source $ENV_FILE
declare -a IPS=("$IPS")

cp -rfp inventory/sample /inventory/$CLUSTER_NAME
CONFIG_FILE=/inventory/$CLUSTER_NAME/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
