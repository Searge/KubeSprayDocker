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

This project uses Task for running common operations. Here are some available commands:

- `task start`: Start the container
- `task up`: Build and start the container
- `task down`: Stop and remove the container
- `task stop`: Stop the container
- `task ps`: Show container status
- `task shell`: Open a shell in the container
- `task cleanup`: Remove the container and associated volumes

To deploy a Kubernetes cluster:

1. Generate the inventory:

   ```bash
   task shell
   ./scripts/generate-inventory.sh .env.local
   exit
   ```

2. Deploy the cluster:

   ```bash
   task shell
   ./scripts/run.sh cluster
   ```

3. To reset the cluster:

   ```bash
   task shell
   ./scripts/run.sh reset
   ```

## Configuration

- Modify `cluster-variables.yaml` to customize your cluster configuration.
- Update `hosts.yaml` to specify your cluster nodes.

## Directory Structure

- `inventory/`: Contains cluster-specific configurations and variables.
- `scripts/`: Helper scripts for managing the deployment process.
- `ssh/`: SSH keys and configuration for connecting to cluster nodes.

## Troubleshooting

If you encounter issues:

1. Check the logs: `docker logs kubespray_local`
2. Ensure your SSH keys are correctly set up in the `ssh/` directory.
3. Verify that the IP addresses in `hosts.yaml` are correct and accessible.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
