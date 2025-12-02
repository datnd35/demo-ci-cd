#!/bin/bash

# Quick deploy script với PATH fix

# Fix PATH
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

echo "🚀 Quick Deploy to Minikube"
echo "==========================="
echo ""

# Check if minikube is running
echo "Checking Minikube status..."
if ! minikube status &> /dev/null; then
    echo "⚠️  Minikube is not running. Please start it first:"
    echo "    minikube start"
    exit 1
fi

echo "✅ Minikube is running"
echo ""

# Configure Docker environment
echo "Configuring Docker environment..."
eval $(minikube docker-env)
echo "✅ Docker environment configured"
echo ""

# Build image
echo "Building Docker image..."
docker build -t demo-ci-cd:latest .
echo "✅ Image built"
echo ""

# Clean old deployment
echo "Cleaning old deployment..."
helm uninstall demo-frontend -n demo 2>/dev/null || echo "No existing deployment"
sleep 3
echo ""

# Deploy
echo "Deploying with Helm..."
helm upgrade --install demo-frontend demo-frontend-chart \
  --namespace demo \
  --create-namespace \
  --set image.repository=demo-ci-cd \
  --set image.tag=latest \
  --set image.pullPolicy=Never \
  --timeout 10m \
  --wait

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Deployment successful!"
    echo ""
    echo "Opening in browser..."
    minikube service demo-frontend -n demo
else
    echo ""
    echo "❌ Deployment failed!"
    echo "Run './scripts/debug.sh' for more info"
    exit 1
fi
