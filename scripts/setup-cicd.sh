#!/bin/bash

# Script setup GitHub Actions CI/CD

echo "🚀 Setup GitHub Actions CI/CD"
echo "=============================="
echo ""
echo "Repository: https://github.com/datnd35/demo-ci-cd"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Bạn muốn setup CI/CD theo cách nào?${NC}"
echo ""
echo "1. Self-Hosted Runner + Minikube (FREE - Dùng máy Mac này)"
echo "2. Cloud Kubernetes Cluster (Tốn tiền - Production ready)"
echo ""
read -p "Chọn option (1 hoặc 2): " option
echo ""

if [ "$option" == "1" ]; then
    echo -e "${YELLOW}=== Self-Hosted Runner Setup ===${NC}"
    echo ""
    echo "Bước 1: Setup GitHub Runner"
    echo "----------------------------"
    echo "1. Mở browser: https://github.com/datnd35/demo-ci-cd/settings/actions/runners/new"
    echo "2. Chọn: macOS"
    echo "3. Copy và chạy các commands từ GitHub"
    echo ""
    echo "Ví dụ commands:"
    echo ""
    echo "  mkdir ~/actions-runner && cd ~/actions-runner"
    echo "  curl -o actions-runner-osx-arm64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-osx-arm64-2.311.0.tar.gz"
    echo "  tar xzf ./actions-runner-osx-arm64-2.311.0.tar.gz"
    echo "  ./config.sh --url https://github.com/datnd35/demo-ci-cd --token YOUR_TOKEN"
    echo "  ./run.sh"
    echo ""
    read -p "Đã setup runner xong? (y/n): " runner_done
    
    if [ "$runner_done" == "y" ]; then
        echo ""
        echo -e "${GREEN}✅ Runner đã setup${NC}"
        echo ""
        echo "Bước 2: Push code lên GitHub"
        echo "----------------------------"
        
        # Add new file
        git add docs/GITHUB-ACTIONS-SETUP.md
        
        # Commit all changes
        git commit -m "Setup CI/CD with self-hosted runner for Minikube"
        
        echo ""
        echo "Bước 3: Push to GitHub"
        git push origin master
        
        if [ $? -eq 0 ]; then
            echo ""
            echo -e "${GREEN}✅ Code đã push lên GitHub!${NC}"
            echo ""
            echo "Bước 4: Kiểm tra workflow"
            echo "-------------------------"
            echo "Mở: https://github.com/datnd35/demo-ci-cd/actions"
            echo ""
            echo "Workflow 'CI/CD Demo (Local Runner)' sẽ tự động chạy!"
        fi
    fi
    
elif [ "$option" == "2" ]; then
    echo -e "${YELLOW}=== Cloud Kubernetes Cluster Setup ===${NC}"
    echo ""
    echo "Bạn muốn dùng cloud provider nào?"
    echo "1. Google Kubernetes Engine (GKE) - $300 free credit"
    echo "2. DigitalOcean Kubernetes - $12/tháng"
    echo "3. AWS EKS"
    echo "4. Azure AKS"
    echo ""
    read -p "Chọn provider (1-4): " provider
    echo ""
    
    case $provider in
        1)
            echo "Google Kubernetes Engine Setup:"
            echo "-------------------------------"
            echo "brew install google-cloud-sdk"
            echo "gcloud auth login"
            echo "gcloud container clusters create demo-cluster --zone=asia-southeast1-a --num-nodes=2"
            echo "gcloud container clusters get-credentials demo-cluster --zone=asia-southeast1-a"
            ;;
        2)
            echo "DigitalOcean Kubernetes Setup:"
            echo "------------------------------"
            echo "brew install doctl"
            echo "doctl auth init"
            echo "doctl kubernetes cluster create demo-cluster --region sgp1 --size s-2vcpu-2gb --count 2"
            echo "doctl kubernetes cluster kubeconfig save demo-cluster"
            ;;
        3)
            echo "AWS EKS Setup:"
            echo "-------------"
            echo "brew install awscli eksctl"
            echo "eksctl create cluster --name demo-cluster --region ap-southeast-1 --nodegroup-name standard-workers --node-type t3.small --nodes 2"
            ;;
        4)
            echo "Azure AKS Setup:"
            echo "---------------"
            echo "brew install azure-cli"
            echo "az aks create --resource-group myResourceGroup --name demo-cluster --node-count 2 --node-vm-size Standard_B2s"
            echo "az aks get-credentials --resource-group myResourceGroup --name demo-cluster"
            ;;
    esac
    
    echo ""
    echo "Sau khi tạo cluster xong:"
    echo "1. Encode kubeconfig:"
    echo "   cat ~/.kube/config | base64 | pbcopy"
    echo ""
    echo "2. Thêm GitHub Secret:"
    echo "   https://github.com/datnd35/demo-ci-cd/settings/secrets/actions/new"
    echo "   Name: KUBECONFIG_DATA"
    echo "   Value: Paste base64 string"
    echo ""
    echo "3. Push code:"
    echo "   git add ."
    echo "   git commit -m 'Setup CI/CD for cloud'"
    echo "   git push origin master"
    
else
    echo -e "${YELLOW}Invalid option${NC}"
fi

echo ""
echo -e "${GREEN}Setup guide completed!${NC}"
echo "Chi tiết: docs/GITHUB-ACTIONS-SETUP.md"
