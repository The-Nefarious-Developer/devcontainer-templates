FROM node:22

ARG USERNAME=node

# Set `DEVCONTAINER` environment variable to help with orientation
ENV DEVCONTAINER=true

RUN \
    apt update \
    && apt install -y sudo jq shellcheck rsync \
    # Ensure default `node` user has access to `sudo`
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    # Install tool for devcontainer template development
    && npm install --global @devcontainers/cli

USER $USERNAME