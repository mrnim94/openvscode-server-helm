FROM ubuntu:24.04

# --- DEFINE VERSION VARIABLE ---
# Default is 'latest'. You can specify a version like: '1.85.1', '1.84.0', etc.
# https://code.visualstudio.com/updates
ARG VSCODE_VERSION='1.119.1'

# 1. Install necessary packages
# Added 'jq' to process JSON responses from GitHub API
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    sudo \
    jq \
    vim \
    nano \
    && rm -rf /var/lib/apt/lists/*

# 2. Resolve and download the VS Code CLI via Microsoft's official update endpoint.
# Do not derive the download commit from microsoft/vscode Git tags: some patch tags point
# to source commits that are not valid download artifact commits.
RUN set -eux; \
    echo "Processing version: ${VSCODE_VERSION}"; \
    if [ "${VSCODE_VERSION}" = "latest" ]; then \
        URL="https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64"; \
    else \
        URL="https://update.code.visualstudio.com/${VSCODE_VERSION}/cli-alpine-x64/stable"; \
    fi; \
    echo "Downloading VS Code CLI from: ${URL}"; \
    for attempt in 1 2 3 4 5; do \
        echo "Download attempt ${attempt}/5"; \
        if curl -fL --retry 3 --retry-delay 10 --retry-all-errors \
            --connect-timeout 20 --max-time 300 \
            "${URL}" --output /tmp/vscode-cli.tar.gz; then \
            break; \
        fi; \
        if [ "${attempt}" = "5" ]; then \
            echo "ERROR: failed to download VS Code CLI for version ${VSCODE_VERSION}"; \
            exit 1; \
        fi; \
        sleep 30; \
    done; \
    file /tmp/vscode-cli.tar.gz; \
    gzip -t /tmp/vscode-cli.tar.gz; \
    tar -xzf /tmp/vscode-cli.tar.gz -C /usr/local/bin; \
    command -v code; \
    code --version; \
    rm /tmp/vscode-cli.tar.gz

# 3. Setup User 'antiantiops' and Sudo access
# Create user and add to sudo group with passwordless access
RUN useradd -m -s /bin/bash antiantiops && \
    usermod -aG sudo antiantiops && \
    echo "antiantiops ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

# Switch to non-root user
USER antiantiops
WORKDIR /home/antiantiops

# Expose port for web access
EXPOSE 8000

# Start VS Code Server
CMD ["code", "serve-web", "--port", "8000", "--host", "0.0.0.0", "--accept-server-license-terms", "--without-connection-token"]