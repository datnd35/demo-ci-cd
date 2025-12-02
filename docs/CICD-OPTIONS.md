# CI/CD Setup cho Minikube

## 🎯 Tình huống hiện tại

Bạn đang dùng **Minikube** trên máy Mac local (`127.0.0.1:56815`). Để chạy CI/CD với GitHub Actions, có 2 options:

---

## ✅ Option 1: Self-Hosted Runner (Recommended - FREE)

Chạy GitHub Actions trên chính máy Mac của bạn.

### Setup:

1. **Cài đặt Self-Hosted Runner:**

   ```bash
   # Vào GitHub repo → Settings → Actions → Runners → New self-hosted runner
   # Copy và chạy các lệnh GitHub cung cấp
   ```

2. **Đảm bảo Minikube đang chạy:**

   ```bash
   minikube start
   minikube status
   ```

3. **Deploy lần đầu:**

   ```bash
   # Build image trong Minikube Docker
   eval $(minikube docker-env)
   docker build -t demo-ci-cd:latest .

   # Deploy với Helm
   helm upgrade --install demo-frontend demo-frontend-chart \
     --namespace demo --create-namespace \
     --set image.repository=demo-ci-cd \
     --set image.tag=latest \
     --set image.pullPolicy=Never
   ```

4. **Test CI/CD:**

   ```bash
   git add .
   git commit -m "Test self-hosted runner"
   git push origin main
   ```

5. **Access application:**
   ```bash
   minikube service demo-frontend -n demo
   ```

### Ưu điểm:

- ✅ FREE - không tốn tiền
- ✅ Build nhanh - sử dụng local Docker
- ✅ Không cần push image lên registry

### Nhược điểm:

- ❌ Máy phải bật khi chạy CI/CD
- ❌ Chỉ dùng cho private repos

📖 **Chi tiết**: Xem file `docs/SETUP-SELF-HOSTED-RUNNER.md`

---

## ✅ Option 2: Cloud Kubernetes Cluster

Deploy lên cloud cluster để GitHub Actions (cloud runners) có thể access.

### Recommended Cloud Providers:

#### A. Google Kubernetes Engine (GKE) - $300 Free Credit

```bash
# Cài gcloud CLI
brew install google-cloud-sdk

# Login và setup
gcloud auth login
gcloud config set project YOUR_PROJECT_ID

# Tạo cluster
gcloud container clusters create demo-cluster \
  --zone=asia-southeast1-a \
  --num-nodes=2 \
  --machine-type=e2-small

# Lấy credentials
gcloud container clusters get-credentials demo-cluster --zone=asia-southeast1-a

# Encode kubeconfig
cat ~/.kube/config | base64 | pbcopy
```

#### B. DigitalOcean Kubernetes - $12/tháng, Đơn giản nhất

```bash
# Cài doctl
brew install doctl

# Auth
doctl auth init

# Tạo cluster từ Web UI hoặc CLI
doctl kubernetes cluster create demo-cluster \
  --region sgp1 \
  --size s-2vcpu-2gb \
  --count 2

# Lấy credentials
doctl kubernetes cluster kubeconfig save demo-cluster

# Encode kubeconfig
cat ~/.kube/config | base64 | pbcopy
```

#### C. AWS EKS

```bash
# Cài AWS CLI và eksctl
brew install awscli eksctl

# Tạo cluster
eksctl create cluster \
  --name demo-cluster \
  --region ap-southeast-1 \
  --nodegroup-name standard-workers \
  --node-type t3.small \
  --nodes 2

# Lấy credentials
aws eks update-kubeconfig --name demo-cluster --region ap-southeast-1

# Encode kubeconfig
cat ~/.kube/config | base64 | pbcopy
```

### Sau khi có cloud cluster:

1. **Thêm KUBECONFIG_DATA vào GitHub Secrets**

   - Settings → Secrets and variables → Actions
   - New repository secret
   - Name: `KUBECONFIG_DATA`
   - Value: Paste base64 string

2. **Sử dụng workflow gốc**
   ```bash
   # Workflow gốc (.github/workflows/ci-cd.yml) sẽ hoạt động
   git push origin main
   ```

### Ưu điểm:

- ✅ Hoạt động từ bất kỳ đâu
- ✅ Production-ready
- ✅ Có thể scale

### Nhược điểm:

- ❌ Tốn tiền hàng tháng
- ❌ Setup phức tạp hơn

---

## 🚀 Quick Start Scripts

### Test Minikube Local Deploy:

```bash
cd /Users/macbookairm1/Desktop/angular-v20/demo-ci-cd

# Build trong Minikube
eval $(minikube docker-env)
docker build -t demo-ci-cd:latest .

# Deploy
helm upgrade --install demo-frontend demo-frontend-chart \
  --namespace demo --create-namespace \
  --set image.repository=demo-ci-cd \
  --set image.tag=latest \
  --set image.pullPolicy=Never \
  --wait

# Open browser
minikube service demo-frontend -n demo
```

### Cleanup:

```bash
# Xóa deployment
helm uninstall demo-frontend -n demo

# Xóa namespace
kubectl delete namespace demo

# Stop minikube (if needed)
minikube stop
```

---

## 📊 So sánh Options

| Feature          | Self-Hosted + Minikube | Cloud Cluster |
| ---------------- | ---------------------- | ------------- |
| Chi phí          | FREE                   | $10-50/tháng  |
| Setup            | Trung bình             | Khó           |
| Production Ready | ❌                     | ✅            |
| Cần máy bật      | ✅                     | ❌            |
| Build speed      | Nhanh                  | Trung bình    |
| Bảo mật          | Cẩn thận               | Tốt           |

---

## 💡 Khuyến nghị

- **Development/Learning**: Dùng Self-Hosted Runner + Minikube
- **Production/Team**: Dùng Cloud Cluster (GKE/EKS/DigitalOcean)
- **Hybrid**: Dev trên Minikube, Production trên Cloud

---

## ❓ Next Steps

Bạn muốn setup theo cách nào?

1. **Self-Hosted Runner** - Tôi sẽ hướng dẫn setup runner
2. **Cloud Cluster** - Tôi sẽ hướng dẫn tạo cluster trên cloud provider
3. **Test local trước** - Deploy thử trên Minikube không dùng CI/CD
