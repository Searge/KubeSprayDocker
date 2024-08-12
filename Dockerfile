# Use the official Kubespray image as the base
ARG DOCKER_IMAGE
FROM ${DOCKER_IMAGE}

# Set environment variables
ENV HOME=/home/kubespray \
    DEBIAN_FRONTEND=noninteractive

# Switch to root to install additional packages and set up the environment
USER root

# Install additional packages if needed
RUN apt-get update && apt-get install -y --no-install-recommends \
    vim \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g ${GROUP_ID} kubespray && \
    useradd -m -u ${USER_ID} -g ${GROUP_ID} -s /bin/bash kubespray && \
    echo "kubespray ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    chmod 0440 /etc/sudoers && \
    mkdir -p /home/kubespray/inventory && \
    mkdir -p /home/kubespray/.ssh && \
    chown -R kubespray:kubespray /home/kubespray && \
    chmod 755 /home/kubespray/inventory && \
    chmod 700 /home/kubespray/.ssh

# Copy SSH directory
COPY --chown=kubespray:kubespray ssh /home/kubespray/.ssh

# Set correct permissions for SSH files
RUN chmod 600 /home/kubespray/.ssh/id_ed25519 && \
    chmod 644 /home/kubespray/.ssh/config

# Switch back to the non-root user
USER kubespray

# Set the working directory
WORKDIR /kubespray

# Set the entrypoint
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["bash"]
