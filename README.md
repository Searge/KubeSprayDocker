# Kubernetes Cluster Deployment with Kubespray

This project provides a streamlined way to deploy a Kubernetes cluster using Kubespray. It uses Docker (or Podman) to create a consistent environment for running Kubespray, making it easier to manage dependencies and ensure reproducibility.

## Prerequisites

- Docker or Podman
- Task (optional, for running predefined tasks)

## Setup

1. Clone this repository:

   ```bash
   git clone git@github.com:Searge/KubeSprayDocker.git
   cd KubeSprayDocker
   ```

2. Modify values inside `.env` and `.env.local` according your needs.
3. Generate or copy your SSH keys into the `ssh` directory:

   ```bash
   cp ~/.ssh/id_ed25519 ssh/
   cp ~/.ssh/config ssh/
   ```

4. Build the Docker image and enter the shell:

   ```bash
   task up && task shell
   ```

## Usage

### Generate Inventory

To generate inventory, create a dedicated `.env` file for the generate command. For example:

```sh
# .env.generate
CLUSTER_NAME=cluster1
IPS=(10.0.0.20 10.0.0.21)
```

Then run the script with the following command:

```bash
./run.sh generate .env.generate
```

### Deploy Cluster

To deploy a cluster, create a dedicated `.env` file for the deploy command. For example:

```sh
# .env/.env.deploy
CLUSTER_NAME=cluster1
```

Then run the script inside the Docker container with the following command:

```bash
./run.sh cluster $CLUSTER_NAME
```

### Clean Up

To clean up Docker images after use, run the following command:

```bash
task cleanup
```
