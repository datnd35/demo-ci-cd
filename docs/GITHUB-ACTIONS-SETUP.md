# Hướng dẫn Deploy lên GitHub Actions CI/CD

## 📋 Overview

Bạn có 2 options để deploy với GitHub Actions:

1. **Self-Hosted Runner + Minikube** (FREE, dùng máy Mac của bạn)
2. **Cloud Kubernetes Cluster** (Tốn tiền, production-ready)

---

## 🎯 Option 1: Self-Hosted Runner + Minikube (Recommended cho learning)

### Bước 1: Tạo/Check Git Repository

```bash
# Kiểm tra git remote
git remote -v

# Nếu chưa có, tạo repo trên GitHub rồi:
git remote add origin https://github.com/YOUR_USERNAME/demo-ci-cd.git

# Hoặc nếu đã có:
git remote set-url origin https://github.com/YOUR_USERNAME/demo-ci-cd.git
```

### Bước 2: Setup Self-Hosted Runner

1. **Vào GitHub Repository:**

   - Settings → Actions → Runners → New self-hosted runner

2. **Chọn macOS** và copy commands

3. **Chạy commands trên máy Mac:**

   ```bash
   # Tạo thư mục riêng cho runner
   mkdir ~/actions-runner && cd ~/actions-runner

   # Download runner (lấy link từ GitHub)
   curl -o actions-runner-osx-arm64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-osx-arm64-2.311.0.tar.gz

   # Extract
   tar xzf ./actions-runner-osx-arm64-2.311.0.tar.gz

   # Configure (token từ GitHub)
   ./config.sh --url https://github.com/YOUR_USERNAME/YOUR_REPO --token YOUR_TOKEN

   # Start runner
   ./run.sh
   ```

### Bước 3: Đảm bảo Minikube chạy

```bash
# Fix PATH
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Start minikube (nếu chưa chạy)
minikube start

# Check status
minikube status
```

### Bước 4: Push code lên GitHub

```bash
cd /Users/macbookairm1/Desktop/angular-v20/demo-ci-cd

# Add all files
git add .

# Commit
git commit -m "Setup CI/CD for Minikube with self-hosted runner"

# Push
git push origin main
```

### Bước 5: Check workflow

- Vào GitHub → Actions tab
- Xem workflow "CI/CD Demo (Local Runner)" đang chạy
- Đợi build và deploy

### Bước 6: Access app

```bash
minikube service demo-frontend -n demo
```

---

## ☁️ Option 2: Cloud Kubernetes Cluster

### Bước 1: Chọn Cloud Provider

#### A. Google Kubernetes Engine (FREE $300 credit)

```bash
# Install gcloud
brew install google-cloud-sdk

# Login
gcloud auth login

# Set project
gcloud config set project YOUR_PROJECT_ID

# Create cluster
gcloud container clusters create demo-cluster \
  --zone=asia-southeast1-a \
  --num-nodes=2 \
  --machine-type=e2-small \
  --enable-autoscaling \
  --min-nodes=1 \
  --max-nodes=3

# Get credentials
gcloud container clusters get-credentials demo-cluster --zone=asia-southeast1-a

# Encode kubeconfig
cat ~/.kube/config | base64 | pbcopy
```

#### B. DigitalOcean Kubernetes ($12/month)

```bash
# Install doctl
brew install doctl

# Auth
doctl auth init

# Create cluster (hoặc dùng web UI)
doctl kubernetes cluster create demo-cluster \
  --region sgp1 \
  --size s-2vcpu-2gb \
  --count 2

# Get credentials
doctl kubernetes cluster kubeconfig save demo-cluster

# Encode kubeconfig
cat ~/.kube/config | base64 | pbcopy
```

### Bước 2: Thêm GitHub Secrets

1. **Vào Repository Settings:**

   - Settings → Secrets and variables → Actions

2. **New repository secret:**
   - Name: `KUBECONFIG_DATA`
   - Value: Paste base64 string từ clipboard

### Bước 3: Update workflow để dùng cloud

Workflow gốc `.github/workflows/ci-cd.yml` đã sẵn sàng cho cloud cluster!

### Bước 4: Push code

```bash
git add .
git commit -m "Setup CI/CD for cloud Kubernetes"
git push origin main
```

### Bước 5: Get service URL

```bash
# Đợi deployment xong, sau đó:
kubectl get svc -n demo

# Hoặc expose với LoadBalancer (cloud provider)
kubectl patch svc demo-frontend -n demo -p '{"spec":{"type":"LoadBalancer"}}'

# Get external IP
kubectl get svc demo-frontend -n demo
```

---

## 📊 So sánh 2 options

| Feature      | Self-Hosted + Minikube | Cloud Cluster   |
| ------------ | ---------------------- | --------------- |
| Chi phí      | 🟢 FREE                | 🟡 $10-50/tháng |
| Setup        | 🟡 Trung bình          | 🔴 Khó          |
| Production   | 🔴 Không               | 🟢 Có           |
| Máy phải bật | 🔴 Có                  | 🟢 Không        |
| Build speed  | 🟢 Nhanh               | 🟡 Trung bình   |

---

## 🚀 Quick Start Commands

### Cho Self-Hosted Runner:

```bash
# 1. Setup runner (làm 1 lần)
mkdir ~/actions-runner && cd ~/actions-runner
# ... follow GitHub instructions

# 2. Start runner (mỗi khi reboot)
cd ~/actions-runner
./run.sh &

# 3. Ensure Minikube running
minikube start

# 4. Push code
cd /Users/macbookairm1/Desktop/angular-v20/demo-ci-cd
git add .
git commit -m "Deploy"
git push origin main
```

### Cho Cloud Cluster:

```bash
# 1. Create cluster (1 lần)
gcloud container clusters create demo-cluster --zone=asia-southeast1-a --num-nodes=2

# 2. Get kubeconfig
cat ~/.kube/config | base64 | pbcopy

# 3. Add to GitHub Secrets
# KUBECONFIG_DATA = paste from clipboard

# 4. Push code
git push origin main
```

---

## 🔍 Troubleshooting

### Self-Hosted Runner không connect:

```bash
# Check runner status
cd ~/actions-runner
./run.sh

# Check PATH
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Check Minikube
minikube status
```

### Cloud deployment fails:

```bash
# Check kubeconfig
echo "$KUBECONFIG_DATA" | base64 --decode > test-kubeconfig.yaml
export KUBECONFIG=test-kubeconfig.yaml
kubectl cluster-info

# Check GitHub secrets
# Vào Settings → Secrets → Actions
```

---

## 📝 Files cần check trước khi push

```bash
# .github/workflows/ci-cd.yml - cho cloud
# .github/workflows/ci-cd-local.yml - cho self-hosted
# Dockerfile
# demo-frontend-chart/values.yaml
# server/index.js - có /health endpoint
```

---

## 💡 Recommendation

**Nếu bạn đang học/test:**
→ Dùng **Self-Hosted Runner + Minikube**

**Nếu cho production/team:**
→ Dùng **Cloud Cluster (GKE/DigitalOcean)**

---

## 🎯 Next Steps

Bạn muốn setup theo cách nào?

1. **Self-Hosted Runner** - Tôi sẽ hướng dẫn chi tiết setup runner
2. **Cloud Cluster** - Tôi sẽ giúp tạo cluster và config secrets
3. **Test local trước** - Deploy thử trên Minikube trước khi setup CI/CD
