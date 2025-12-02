#!/bin/bash

# Script để debug deployment issues

# Fix PATH to include Homebrew and system binaries
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

echo "🔍 Debugging Kubernetes Deployment"
echo "=================================="
echo ""

# Check namespace
echo "📦 Namespace status:"
minikube kubectl -- get namespace demo
echo ""

# Check pods
echo "🐳 Pods in demo namespace:"
minikube kubectl -- get pods -n demo -o wide
echo ""

# Check deployments
echo "🚀 Deployments:"
minikube kubectl -- get deployments -n demo
echo ""

# Check services
echo "🌐 Services:"
minikube kubectl -- get services -n demo
echo ""

# Check events
echo "📋 Recent events:"
minikube kubectl -- get events -n demo --sort-by='.lastTimestamp' | tail -20
echo ""

# Get pod name
POD_NAME=$(minikube kubectl -- get pods -n demo -l app.kubernetes.io/name=chart -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)

if [ ! -z "$POD_NAME" ]; then
    echo "📝 Pod details for: $POD_NAME"
    minikube kubectl -- describe pod $POD_NAME -n demo
    echo ""
    
    echo "📜 Pod logs:"
    minikube kubectl -- logs $POD_NAME -n demo --tail=50
else
    echo "⚠️  No pods found in demo namespace"
fi

echo ""
echo "🔍 Debug commands you can run:"
echo "  minikube kubectl -- describe pod <pod-name> -n demo"
echo "  minikube kubectl -- logs <pod-name> -n demo"
echo "  minikube kubectl -- get events -n demo"
echo "  minikube dashboard"
