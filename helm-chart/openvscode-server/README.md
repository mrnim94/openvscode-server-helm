# openvscode-server-helm
Open VScode Server Helm

```
helm repo add openvscode-server-helm https://mrnim94.github.io/openvscode-server-helm/
"openvscode-server-helm" has been added to your repositories

helm search repo openvscode-server-helm
NAME                                            CHART VERSION   APP VERSION     DESCRIPTION
openvscode-server-helm/openvscode-server        0.1.5           v1.79.2         A Helm chart for Kubernetes
```

## Install Helm and create package and index helm

```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

helm package ./helm-chart/openvscode-server/
helm repo index ./
```