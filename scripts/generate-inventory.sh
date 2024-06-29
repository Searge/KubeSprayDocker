#!/usr/bin/env bash

set -e

ENV_FILE=$1
source $ENV_FILE
declare -a IPS=("$IPS")

cp -rfp inventory/sample /inventory/$CLUSTER_NAME
CONFIG_FILE=/inventory/$CLUSTER_NAME/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
