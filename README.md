# Kubespray in Docker

## Description

This project uses Docker and Kubespray to deploy Kubernetes clusters.

## Prerequisites

- Docker
- SSH key

## Setup

1. Clone the repository.
2. Copy `.env.dist` to `.env` and modify the variables to fit your needs.

## Usage

### Generate Inventory

To generate inventory, create a dedicated `.env` file for the generate command. For example:

```sh
# .env/.env.generate
CLUSTER_NAME=cluster1
IPS=(10.0.0.20 10.0.0.21)
```

Then run the script with the following command:

```bash
./run.sh generate ./.env/.env.generate
```

### Deploy Cluster

To deploy a cluster, create a dedicated `.env` file for the deploy command. For example:

```sh
# .env/.env.deploy
CLUSTER_NAME=cluster1
```

Then run the script with the following command:

```bash
./run.sh cluster $CLUSTER_NAME
```

### Clean Up

To clean up Docker images after use, run the following command:

```bash
./run.sh clean
```
