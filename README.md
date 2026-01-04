## VS Code Server - Docker Edition

A lightweight, flexible Docker environment running the **official Microsoft Visual Studio Code Server (CLI)**.

This repository provides a `Dockerfile` to build a remote development environment that retains full compatibility with proprietary Microsoft extensions, including **GitHub Copilot** and **Copilot Chat**, which often fail to run on standard open-source web IDE implementations.

## 🚀 Why Use This Image?

While many web-based IDE solutions exist, most are built on the "Code OSS" (Open Source) foundation. While excellent, those versions lack the specific proprietary APIs and licenses required to authenticate and run certain official extensions.

**Key Advantages:**

* **🤖 Full GitHub Copilot Support:** Unlike generic open-source builds, this image runs the official server binary. This means **GitHub Copilot and Copilot Chat work out-of-the-box** without complex workarounds or authentication errors.
  * ![](https://33333.cdn.cke-cs.com/kSW7V9NHUXugvhoQeFaf/images/75a53409ed3e4b7a0ac119723943c77f3c3d48c55989d5c0.png)
* **🛒 Official Marketplace Access:** Direct access to the full Visual Studio Code Marketplace (not a third-party registry).
* **🎯 Smart Versioning:** You are not forced to use the "latest" unstable build. You can pin specific versions (e.g., `1.85.1`) during the build process, and the Dockerfile intelligently resolves the correct Commit SHA for you.
* **⚡ Sudo Access:** The environment comes with a non-root user (`coder`) pre-configured with passwordless `sudo` privileges, allowing you to install system packages on the fly.

## 🛠 Usage

### 1. Build the Image

You can build the latest version or target a specific VS Code release.

**Option A: Build the Latest Version**

```plaintext
docker build -t vscode-server:latest .
```

Option B: Build a Specific Version (Recommended for Stability)

The build process automatically queries the API to find the correct commit hash for the version you provide.

```plaintext
# Example: Build version 1.85.1
docker build --build-arg VSCODE_VERSION=1.85.1 -t vscode-server:1.85.1 .
```

### 2. Run the Container

Run the container and map your project directory.

```plaintext
docker run -it -p 8000:8000 \
  -v $(pwd):/home/coder/project \
  vscode-server:latest
```

* **Access the IDE:** Open your browser and navigate to `http://localhost:8000`.
* **Persist Data:** The command above maps your current directory to `/home/coder/project`. Any changes made inside that folder will be saved to your host machine.

## ⚙️ Configuration

| **Argument**     | **Default** | **Description**                                                                                                          |
| ---------------- | ----------- | ------------------------------------------------------------------------------------------------------------------------ |
| `VSCODE_VERSION` | `latest`    | The specific version tag (e.g., `1.86.0`) or `latest`. The build script handles the Commit SHA resolution automatically. |

Here is a professional, comprehensive `README.md` file designed for your repository. It highlights the advantages of using the official binary (specifically for Copilot) without explicitly naming other open-source alternatives, and includes the necessary legal disclaimers.

---

## ⚠️ Legal Disclaimer

**Please read carefully before using:**

1. **No Affiliation:** This project is **not affiliated, associated, authorized, endorsed by, or in any way officially connected with Microsoft Corporation** or Visual Studio Code.
2. **Proprietary Software:** This `Dockerfile` downloads and installs the official Visual Studio Code Server CLI, which is proprietary software owned by Microsoft.
3. **License Agreement:** By building and using this Docker image, you are effectively accepting the [**Visual Studio Code Server License Terms**](https://code.visualstudio.com/license).
4. **No Redistribution:** This repository contains **only** the `Dockerfile` (build instructions). It does **not** host, distribute, or include any Microsoft binaries or executable files. All binaries are downloaded directly from Microsoft's official servers during the build process on your machine.

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