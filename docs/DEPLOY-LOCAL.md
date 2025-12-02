# Quick Deployment Guide

## ⚠️ Vấn đề gặp phải

Deployment bị timeout với lỗi: `Error: resource not ready, name: demo-frontend-chart, kind: Deployment, status: InProgress`

## ✅ Đã fix

1. ✅ Thêm `/health` endpoint vào `server/index.js`
2. ✅ Cập nhật health checks trong `values.yaml` với:
   - `initialDelaySeconds` để pod có thời gian start
   - Timeout và period hợp lý
3. ✅ Tạo deployment scripts tự động

---

## 🚀 Cách deploy (Đơn giản)

### Option 1: Dùng script tự động (Recommended)

```bash
# Chạy từ thư mục root project
./scripts/deploy-local.sh
```

Script sẽ tự động:

- ✅ Check Minikube status
- ✅ Build Docker image
- ✅ Deploy với Helm
- ✅ Mở browser

### Option 2: Debug nếu có lỗi

```bash
./scripts/debug.sh
```

### Option 3: Manual commands

```bash
# 1. Configure Docker
eval $(minikube docker-env)

# 2. Build image
docker build -t demo-ci-cd:latest .

# 3. Clean old deployment (if exists)
helm uninstall demo-frontend -n demo || true

# 4. Deploy
helm upgrade --install demo-frontend demo-frontend-chart \
  --namespace demo \
  --create-namespace \
  --set image.repository=demo-ci-cd \
  --set image.tag=latest \
  --set image.pullPolicy=Never \
  --timeout 10m \
  --wait

# 5. Open in browser
minikube service demo-frontend -n demo
```

---

## 🔧 Troubleshooting

### Nếu vẫn bị timeout:

1. **Kiểm tra pod status:**

   ```bash
   minikube kubectl -- get pods -n demo
   ```

2. **Xem logs:**

   ```bash
   minikube kubectl -- logs -n demo -l app.kubernetes.io/name=chart
   ```

3. **Xem events:**

   ```bash
   minikube kubectl -- get events -n demo --sort-by='.lastTimestamp'
   ```

4. **Describe pod:**
   ```bash
   POD_NAME=$(minikube kubectl -- get pods -n demo -o name | head -1)
   minikube kubectl -- describe $POD_NAME -n demo
   ```

### Common Issues:

#### Issue 1: Image pull error

```bash
# Đảm bảo đã chạy:
eval $(minikube docker-env)
docker images | grep demo-ci-cd
```

#### Issue 2: Pod CrashLoopBackOff

```bash
# Check logs
minikube kubectl -- logs -n demo <pod-name>
```

#### Issue 3: Port conflict

```bash
# Check service
minikube kubectl -- get svc -n demo
```

---

## 🧹 Cleanup

```bash
# Xóa deployment
helm uninstall demo-frontend -n demo

# Xóa namespace
minikube kubectl -- delete namespace demo

# Stop minikube
minikube stop

# Delete minikube cluster
minikube delete
```

---

## 📊 Useful Commands

```bash
# Check all resources
minikube kubectl -- get all -n demo

# Port forward (alternative to service)
minikube kubectl -- port-forward -n demo svc/demo-frontend 8080:8080

# Dashboard
minikube dashboard

# SSH into minikube
minikube ssh

# Check Docker images in minikube
minikube ssh -- docker images
```

---

## 🎯 Next Steps

Sau khi deployment thành công, bạn có thể:

1. **Test application**: Mở URL từ `minikube service`
2. **Setup CI/CD**: Follow hướng dẫn trong `docs/CICD-OPTIONS.md`
3. **Monitor**: Dùng `minikube dashboard` để xem metrics

---

## 💡 Tips

- Luôn chạy `eval $(minikube docker-env)` trước khi build image
- Dùng `--wait` flag với Helm để đợi pod ready
- Set `initialDelaySeconds` cho health checks
- Dùng `imagePullPolicy: Never` cho local images
