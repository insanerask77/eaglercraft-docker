# Eaglercraft Helm Chart

This Helm chart deploys the Eaglercraft application stack on Kubernetes, including:

- Nginx reverse proxy (main entry point)
- Landing page
- Eaglercraft game server

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- PV provisioner support in the underlying infrastructure (for persistent storage)

## Installation

### Create registry secret (required for private images)

Before installing the chart, create a Kubernetes secret for authenticating with the Forgejo registry:

```bash
# Option 1: Use the helper script
./k8s/create-registry-secret.sh

# Option 2: Manual creation
kubectl create secret docker-registry forgejo-registry \
  --docker-server=forgejo.easypanel.madolell.com \
  --docker-username=<your-username> \
  --docker-password=<your-password> \
  --docker-email=<your-email>
```

### Install from local chart

```bash
# From the repository root
helm install eaglercraft k8s/eaglercraft/

# Or with custom values
helm install eaglercraft k8s/eaglercraft/ -f my-values.yaml
```

### Install with custom namespace

```bash
kubectl create namespace eaglercraft

# Create the secret in the namespace
kubectl create secret docker-registry forgejo-registry \
  --docker-server=forgejo.easypanel.madolell.com \
  --docker-username=<your-username> \
  --docker-password=<your-password> \
  --docker-email=<your-email> \
  -n eaglercraft

helm install eaglercraft k8s/eaglercraft/ -n eaglercraft
```

## Configuration

The following table lists the configurable parameters of the Eaglercraft chart and their default values.

### Global Configuration

| Parameter                 | Description                             | Default                          |
| ------------------------- | --------------------------------------- | -------------------------------- |
| `global.imageRegistry`    | Default image registry for all images   | `forgejo.easypanel.madolell.com` |
| `global.imagePullSecrets` | Image pull secrets for private registry | `[{name: forgejo-registry}]`     |

### Nginx Proxy Configuration

| Parameter                              | Description              | Default        |
| -------------------------------------- | ------------------------ | -------------- |
| `nginxProxy.image.repository`          | Nginx image repository   | `nginx`        |
| `nginxProxy.image.tag`                 | Nginx image tag          | `alpine`       |
| `nginxProxy.image.pullPolicy`          | Image pull policy        | `IfNotPresent` |
| `nginxProxy.replicaCount`              | Number of nginx replicas | `1`            |
| `nginxProxy.service.type`              | Service type             | `LoadBalancer` |
| `nginxProxy.service.port`              | Service port             | `80`           |
| `nginxProxy.resources.limits.cpu`      | CPU limit                | `500m`         |
| `nginxProxy.resources.limits.memory`   | Memory limit             | `512Mi`        |
| `nginxProxy.resources.requests.cpu`    | CPU request              | `100m`         |
| `nginxProxy.resources.requests.memory` | Memory request           | `128Mi`        |

### Landing Page Configuration

| Parameter                               | Description                     | Default                                                   |
| --------------------------------------- | ------------------------------- | --------------------------------------------------------- |
| `landingPage.image.repository`          | Landing page image repository   | `forgejo.easypanel.madolell.com/eaglercraft/landing-page` |
| `landingPage.image.tag`                 | Landing page image tag          | `latest`                                                  |
| `landingPage.image.pullPolicy`          | Image pull policy               | `IfNotPresent`                                            |
| `landingPage.replicaCount`              | Number of landing page replicas | `1`                                                       |
| `landingPage.service.port`              | Service port                    | `80`                                                      |
| `landingPage.resources.limits.cpu`      | CPU limit                       | `200m`                                                    |
| `landingPage.resources.limits.memory`   | Memory limit                    | `256Mi`                                                   |
| `landingPage.resources.requests.cpu`    | CPU request                     | `50m`                                                     |
| `landingPage.resources.requests.memory` | Memory request                  | `64Mi`                                                    |

### Eaglercraft Game Server Configuration

| Parameter                               | Description                    | Default                                             |
| --------------------------------------- | ------------------------------ | --------------------------------------------------- |
| `eaglercraft.image.repository`          | Eaglercraft image repository   | `forgejo.easypanel.madolell.com/eaglercraft/server` |
| `eaglercraft.image.tag`                 | Eaglercraft image tag          | `latest`                                            |
| `eaglercraft.image.pullPolicy`          | Image pull policy              | `IfNotPresent`                                      |
| `eaglercraft.replicaCount`              | Number of game server replicas | `1`                                                 |
| `eaglercraft.service.port1`             | Game service port 1            | `5200`                                              |
| `eaglercraft.service.port2`             | Game service port 2            | `5201`                                              |
| `eaglercraft.resources.limits.cpu`      | CPU limit                      | `2000m`                                             |
| `eaglercraft.resources.limits.memory`   | Memory limit                   | `4Gi`                                               |
| `eaglercraft.resources.requests.cpu`    | CPU request                    | `1000m`                                             |
| `eaglercraft.resources.requests.memory` | Memory request                 | `2Gi`                                               |
| `eaglercraft.persistence.enabled`       | Enable persistent storage      | `true`                                              |
| `eaglercraft.persistence.storageClass`  | Storage class                  | `""` (default)                                      |
| `eaglercraft.persistence.accessMode`    | Access mode                    | `ReadWriteOnce`                                     |
| `eaglercraft.persistence.size`          | Storage size                   | `10Gi`                                              |
| `eaglercraft.persistence.existingClaim` | Use existing PVC               | `""`                                                |

## Upgrading

```bash
helm upgrade eaglercraft k8s/eaglercraft/
```

## Uninstalling

```bash
helm uninstall eaglercraft
```

**Note:** This will not delete the PersistentVolumeClaim by default. To delete it:

```bash
kubectl delete pvc -l app.kubernetes.io/instance=eaglercraft
```

## Accessing the Application

After installation, get the application URL:

### LoadBalancer (default)

```bash
export SERVICE_IP=$(kubectl get svc eaglercraft-nginx-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Visit http://$SERVICE_IP"
```

### NodePort

If you changed the service type to NodePort:

```bash
export NODE_PORT=$(kubectl get svc eaglercraft-nginx-proxy -o jsonpath='{.spec.ports[0].nodePort}')
export NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}')
echo "Visit http://$NODE_IP:$NODE_PORT"
```

### Port Forward (for testing)

```bash
kubectl port-forward svc/eaglercraft-nginx-proxy 8080:80
# Visit http://localhost:8080
```

## Application Endpoints

- **Landing Page**: `http://<SERVICE_IP>/`
- **Game**: `http://<SERVICE_IP>/game/`

## Customization

### Using Custom Images

Before deploying, you'll need to build and push your custom images:

```bash
# Build and tag images
docker build -t your-registry/eaglercraft-landing:v1.0.0 ./landing-page
docker build -t your-registry/eaglercraft-server:v1.0.0 -f Dockerfile .

# Push to your registry
docker push your-registry/eaglercraft-landing:v1.0.0
docker push your-registry/eaglercraft-server:v1.0.0
```

Then update `values.yaml`:

```yaml
landingPage:
  image:
    repository: your-registry/eaglercraft-landing
    tag: v1.0.0

eaglercraft:
  image:
    repository: your-registry/eaglercraft-server
    tag: v1.0.0
```

### Using Existing PersistentVolumeClaim

```yaml
eaglercraft:
  persistence:
    enabled: true
    existingClaim: my-existing-pvc
```

### Disabling Persistence

```yaml
eaglercraft:
  persistence:
    enabled: false
```

## Troubleshooting

### Check pod status

```bash
kubectl get pods -l app.kubernetes.io/instance=eaglercraft
```

### View logs

```bash
# Nginx proxy logs
kubectl logs -l app.kubernetes.io/component=nginx-proxy

# Landing page logs
kubectl logs -l app.kubernetes.io/component=landing-page

# Game server logs
kubectl logs -l app.kubernetes.io/component=game-server
```

### Describe resources

```bash
kubectl describe deployment eaglercraft-nginx-proxy
kubectl describe svc eaglercraft-nginx-proxy
```

## License

This chart is provided as-is for the Eaglercraft project.

## Maintainer

- Rafa Madolell - [GitHub](https://github.com/insanerask77)
