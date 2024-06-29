ARG DOCKER_IMAGE

FROM ${DOCKER_IMAGE}

USER root

# Add sudo support
RUN apt-get update && apt-get install -y sudo && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Ensure group with GID 1000 exists, and user with UID 1000 exists
RUN useradd -m -u 1000 -s /bin/bash kubespray_user && \
  usermod -aG sudo kubespray_user && \
  echo "kubespray_user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/kubespray_user && \
  chown -R kubespray_user:kubespray_user /kubespray

# Switch to the kubespray user
USER kubespray_user

# Set the working directory
WORKDIR /kubespray

# Use bash as the entrypoint
ENTRYPOINT [ "/bin/bash", "-l", "-c", "sleep 3600"]
