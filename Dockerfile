FROM ubuntu:24.04

# --- DEFINE VERSION VARIABLE ---
# Default is 'latest'. You can specify a version like: '1.85.1', '1.84.0', etc.
ARG VSCODE_VERSION='1.107.1'

# 1. Install necessary packages
# Added 'jq' to process JSON responses from GitHub API
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    sudo \
    jq \
    && rm -rf /var/lib/apt/lists/*

# 2. Logic to resolve Version -> Commit SHA -> Download URL
RUN echo "Processing version: ${VSCODE_VERSION}" && \
    # CASE A: If 'latest', retrieve the latest commit SHA from Microsoft's download redirect
    if [ "${VSCODE_VERSION}" = "latest" ]; then \
        COMMIT_ID=$(curl -sIL "https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64" \
            | grep -i "location:" | sed -E 's/.*\/stable\/([a-f0-9]+)\/.*/\1/' | tr -d '\r'); \
    # CASE B: If a specific version is provided (e.g., 1.85.1), query GitHub API for the Commit SHA
    else \
        # Note: VS Code uses tags like "1.85.1", not "v1.85.1"
        COMMIT_ID=$(curl -s "https://api.github.com/repos/microsoft/vscode/git/ref/tags/${VSCODE_VERSION}" | jq -r '.object.sha'); \
        # Error handling: Check if the version is invalid or API returned null
        if [ "$COMMIT_ID" = "null" ] || [ -z "$COMMIT_ID" ]; then \
            echo "ERROR: Version ${VSCODE_VERSION} not found. Please check the version number."; exit 1; \
        fi; \
    fi && \
    \
    echo "-> Resolved Commit SHA: $COMMIT_ID" && \
    \
    # Download the VS Code CLI based on the resolved Commit ID
    URL="https://vscode.download.prss.microsoft.com/dbazure/download/stable/${COMMIT_ID}/vscode_cli_alpine_x64_cli.tar.gz" && \
    echo "Downloading from: $URL" && \
    curl -sL "$URL" --output /tmp/vscode-cli.tar.gz && \
    tar -xf /tmp/vscode-cli.tar.gz -C /usr/local/bin && \
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