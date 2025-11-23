#!/bin/bash
# Script to create Kubernetes secret for Docker registry authentication

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Docker Registry Secret Creator ===${NC}\n"

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}Error: kubectl is not installed${NC}"
    exit 1
fi

# Get registry credentials
REGISTRY_SERVER="registry.easypanel.madolell.com"
SECRET_NAME="docker-registry"

echo "Registry server: $REGISTRY_SERVER"
echo ""

# Prompt for credentials
read -p "Enter your Docker username (email): " REGISTRY_USERNAME
read -sp "Enter your Docker password: " REGISTRY_PASSWORD
echo ""
read -p "Enter your email: " REGISTRY_EMAIL

echo ""
echo -e "${YELLOW}Creating Kubernetes secret...${NC}"

# Create the secret
kubectl create secret docker-registry $SECRET_NAME \
  --docker-server=$REGISTRY_SERVER \
  --docker-username=$REGISTRY_USERNAME \
  --docker-password=$REGISTRY_PASSWORD \
  --docker-email=$REGISTRY_EMAIL \
  --namespace eaglecraft

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Secret '$SECRET_NAME' created successfully!${NC}"
    echo ""
    echo "You can now deploy the Helm chart with:"
    echo "  helm install eaglercraft k8s/eaglercraft/"
else
    echo -e "${RED}✗ Failed to create secret${NC}"
    echo ""
    echo "If the secret already exists, you can delete it first with:"
    echo "  kubectl delete secret $SECRET_NAME"
    echo ""
    echo "Or update it with:"
    echo "  kubectl delete secret $SECRET_NAME"
    echo "  kubectl create secret docker-registry $SECRET_NAME \\"
    echo "    --docker-server=$REGISTRY_SERVER \\"
    echo "    --docker-username=<username> \\"
    echo "    --docker-password=<password> \\"
    echo "    --docker-email=<email>"
    exit 1
fi
