#!/bin/bash

# Script để deploy và debug Minikube

set -e

# Fix PATH to include Homebrew and system binaries
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

echo "🚀 Starting deployment process..."
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Step 1: Check Minikube status
echo -e "${YELLOW}Step 1: Checking Minikube status...${NC}"
if ! minikube status > /dev/null 2>&1; then
    echo -e "${RED}❌ Minikube is not running!${NC}"
    echo "Starting minikube..."
    minikube start
fi
echo -e "${GREEN}✅ Minikube is running${NC}"
echo ""

# Step 2: Configure Docker environment
echo -e "${YELLOW}Step 2: Configuring Docker to use Minikube...${NC}"
eval $(minikube docker-env)
echo -e "${GREEN}✅ Docker environment configured${NC}"
echo ""

# Step 3: Build Docker image
echo -e "${YELLOW}Step 3: Building Docker image...${NC}"
docker build -t demo-ci-cd:latest .
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Docker image built successfully${NC}"
else
    echo -e "${RED}❌ Docker build failed!${NC}"
    exit 1
fi
echo ""

# Step 4: Check if deployment exists
echo -e "${YELLOW}Step 4: Checking existing deployment...${NC}"
if minikube kubectl -- get deployment demo-frontend-chart -n demo > /dev/null 2>&1; then
    echo "Deployment exists. Uninstalling..."
    helm uninstall demo-frontend -n demo || true
    sleep 5
fi
echo -e "${GREEN}✅ Ready for fresh deployment${NC}"
echo ""

# Step 5: Deploy with Helm
echo -e "${YELLOW}Step 5: Deploying with Helm...${NC}"
helm upgrade --install demo-frontend demo-frontend-chart \
  --namespace demo \
  --create-namespace \
  --set image.repository=demo-ci-cd \
  --set image.tag=latest \
  --set image.pullPolicy=Never \
  --timeout 10m \
  --wait

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Deployment successful!${NC}"
else
    echo -e "${RED}❌ Deployment failed!${NC}"
    echo ""
    echo "Checking pod status..."
    minikube kubectl -- get pods -n demo
    echo ""
    echo "Checking events..."
    minikube kubectl -- get events -n demo --sort-by='.lastTimestamp'
    exit 1
fi
echo ""

# Step 6: Check deployment status
echo -e "${YELLOW}Step 6: Checking deployment status...${NC}"
minikube kubectl -- get all -n demo
echo ""

# Step 7: Get service URL
echo -e "${YELLOW}Step 7: Getting service URL...${NC}"
URL=$(minikube service demo-frontend -n demo --url)
echo -e "${GREEN}✅ Application is available at: ${URL}${NC}"
echo ""

# Step 8: Open in browser
echo -e "${YELLOW}Step 8: Opening in browser...${NC}"
minikube service demo-frontend -n demo

echo ""
echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
echo ""
echo "Useful commands:"
echo "  View pods:        minikube kubectl -- get pods -n demo"
echo "  View logs:        minikube kubectl -- logs -n demo -l app.kubernetes.io/name=chart"
echo "  Delete app:       helm uninstall demo-frontend -n demo"
echo "  Stop minikube:    minikube stop"
