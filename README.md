## VS Code Server - Docker Edition

A lightweight, flexible Docker environment running the **official Microsoft Visual Studio Code Server (CLI)**.

This repository ships a Helm chart that deploys a prebuilt image: **antiantiops/vscode-browser-docker**. Viewers can run the container immediately without building anything locally.

## 🚀 Why Use This Image?

While many web-based IDE solutions exist, most are built on the "Code OSS" (Open Source) foundation. While excellent, those versions lack the specific proprietary APIs and licenses required to authenticate and run certain official extensions.

**Key Advantages:**

* **🤖 Full GitHub Copilot Support:** Unlike generic open-source builds, this image runs the official server binary. This means **GitHub Copilot and Copilot Chat work out-of-the-box** without complex workarounds or authentication errors.
  * ![](https://raw.githubusercontent.com/mrnim94/openvscode-server-helm/refs/heads/master/docs/img/copilot-ui.png)
* **🛒 Official Marketplace Access:** Direct access to the full Visual Studio Code Marketplace (not a third-party registry).
* **🎯 Smart Versioning:** You are not forced to use the "latest" unstable build. You can pin specific versions (e.g., `1.85.1`) during the build process, and the Dockerfile intelligently resolves the correct Commit SHA for you.
* **⚡ Sudo Access:** The environment comes with a non-root user (`coder`) pre-configured with passwordless `sudo` privileges, allowing you to install system packages on the fly.

## 🛠 Usage

You can run this image either locally with Docker/Docker Compose or on Kubernetes with the Helm chart.

### Option A: Run with Docker

Pull the image:

```bash
docker pull antiantiops/vscode-browser-docker:latest
```

Run the container:

```bash
docker run -it --rm \
  --name openvscode-server \
  -p 8000:8000 \
  -v "$(pwd)/workspace:/home/antiantiops/project" \
  antiantiops/vscode-browser-docker:latest
```

Open your browser and navigate to:

```text
http://localhost:8000
```

The command above mounts `./workspace` from your host to `/home/antiantiops/project` inside the container. Files created there are persisted on your host machine.

### Option B: Run with Docker Compose

Create the local workspace directory:

```bash
mkdir -p workspace
```

Start VS Code Server:

```bash
docker compose up -d
```

Open:

```text
http://localhost:8000
```

Stop it when finished:

```bash
docker compose down
```

This repository includes a ready-to-use [`docker-compose.yml`](docker-compose.yml) that:

* exposes VS Code Server on port `8000`
* mounts `./workspace` to `/home/antiantiops/project`
* keeps `/home/antiantiops` data in a named Docker volume (`openvscode-home`)

## ⚙️ Configuration

For Helm values, see [helm-chart/openvscode-server/values.yaml](helm-chart/openvscode-server/values.yaml).

## ☸️ Install on Kubernetes (Helm)

Install the chart from Artifact Hub:

https://artifacthub.io/packages/helm/openvscode-server-helm/openvscode-server

## ⚠️ Legal Disclaimer

**Please read carefully before using:**

1. **No Affiliation:** This project is **not affiliated, associated, authorized, endorsed by, or in any way officially connected with Microsoft Corporation** or Visual Studio Code.
2. **Proprietary Software:** This image includes the official Visual Studio Code Server CLI, which is proprietary software owned by Microsoft.
3. **License Agreement:** By using this image, you are accepting the [**Visual Studio Code Server License Terms**](https://code.visualstudio.com/license).
4. **Redistribution Notice:** This repository references a prebuilt image hosted on a container registry. Please ensure your usage complies with the applicable license terms.

**Note on Usage:** This image is intended for personal development environments and testing. Please ensure your usage complies with Microsoft's terms of service regarding remote development and commercial hosting.

---

License

MIT (Applies to the Dockerfile and scripts in this repo only).

## Install Helm and create package and index helm

```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

helm package ./helm-chart/openvscode-server/
helm repo index ./
```