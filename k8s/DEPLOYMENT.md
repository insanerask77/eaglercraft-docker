# Deploying to Kubernetes

This guide explains how to build, push, and deploy the Eaglercraft application to Kubernetes using the Helm chart.

## Prerequisites

- Docker installed and configured
- Access to Forgejo registry: `forgejo.easypanel.madolell.com`
- Kubernetes cluster configured
- `kubectl` and `helm` installed

## Step 1: Build and Push Docker Images

### Build the images

```bash
# Build landing page image
docker build -t forgejo.easypanel.madolell.com/eaglercraft/landing-page:latest ./landing-page

# Build eaglercraft server image
docker build -t forgejo.easypanel.madolell.com/eaglercraft/server:latest -f Dockerfile .
```

### Login to Forgejo registry

```bash
docker login forgejo.easypanel.madolell.com
```

### Push the images

```bash
docker push forgejo.easypanel.madolell.com/eaglercraft/landing-page:latest
docker push forgejo.easypanel.madolell.com/eaglercraft/server:latest
```

## Step 2: Create Kubernetes Secret for Registry Authentication

You have two options:

### Option A: Use the helper script (recommended)

```bash
./k8s/create-registry-secret.sh
```

### Option B: Manual creation

```bash
kubectl create secret docker-registry forgejo-registry \
  --docker-server=forgejo.easypanel.madolell.com \
  --docker-username=<your-username> \
  --docker-password=<your-password> \
  --docker-email=<your-email>
```

## Step 3: Deploy with Helm

### Install the chart

```bash
helm install eaglercraft k8s/eaglercraft/
```

### Or install in a specific namespace

```bash
kubectl create namespace eaglercraft
helm install eaglercraft k8s/eaglercraft/ -n eaglercraft
```

### Verify the deployment

```bash
# Check pods
kubectl get pods -l app.kubernetes.io/instance=eaglercraft

# Check services
kubectl get svc -l app.kubernetes.io/instance=eaglercraft

# Check the LoadBalancer IP
kubectl get svc eaglercraft-nginx-proxy
```

## Step 4: Access the Application

Once the LoadBalancer has an external IP:

```bash
export SERVICE_IP=$(kubectl get svc eaglercraft-nginx-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Landing Page: http://$SERVICE_IP/"
echo "Game: http://$SERVICE_IP/game/"
```

## Customizing the Deployment

### Using different image tags

Edit `k8s/eaglercraft/values.yaml`:

```yaml
landingPage:
  image:
    tag: v1.0.0 # Change from 'latest'

eaglercraft:
  image:
    tag: v1.0.0 # Change from 'latest'
```

### Changing service type

For NodePort instead of LoadBalancer:

```yaml
nginxProxy:
  service:
    type: NodePort
```

### Adjusting resources

```yaml
eaglercraft:
  resources:
    limits:
      cpu: 4000m # Increase CPU
      memory: 8Gi # Increase memory
    requests:
      cpu: 2000m
      memory: 4Gi
```

## Upgrading

After making changes to images or configuration:

```bash
# Upgrade the release
helm upgrade eaglercraft k8s/eaglercraft/

# Or with custom values
helm upgrade eaglercraft k8s/eaglercraft/ -f custom-values.yaml
```

## Troubleshooting

### ImagePullBackOff errors

If pods show `ImagePullBackOff`:

1. Verify the secret exists:

   ```bash
   kubectl get secret forgejo-registry
   ```

2. Check secret details:

   ```bash
   kubectl describe secret forgejo-registry
   ```

3. Verify images exist in registry:
   ```bash
   docker pull forgejo.easypanel.madolell.com/eaglercraft/landing-page:latest
   docker pull forgejo.easypanel.madolell.com/eaglercraft/server:latest
   ```

### Check pod logs

```bash
# Nginx proxy
kubectl logs -l app.kubernetes.io/component=nginx-proxy

# Landing page
kubectl logs -l app.kubernetes.io/component=landing-page

# Game server
kubectl logs -l app.kubernetes.io/component=game-server
```

### Describe failing pods

```bash
kubectl describe pod <pod-name>
```

## Uninstalling

```bash
# Uninstall the release
helm uninstall eaglercraft

# Delete the secret (optional)
kubectl delete secret forgejo-registry

# Delete PVC (optional, will delete world data!)
kubectl delete pvc -l app.kubernetes.io/instance=eaglercraft
```
