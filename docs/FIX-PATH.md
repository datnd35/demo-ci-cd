# Fix PATH Issues với Conda/Minikube

## Vấn đề

Khi dùng Conda environment `(base)`, PATH bị override và không tìm thấy `minikube`, `docker`, `helm`, `kubectl`.

## ✅ Giải pháp nhanh

### Option 1: Dùng script đã fix PATH (Recommended)

```bash
./scripts/quick-deploy.sh
```

### Option 2: Fix PATH trong terminal session

```bash
# Thêm PATH vào terminal hiện tại
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# Kiểm tra
which minikube
which docker
which helm

# Sau đó chạy deploy
./scripts/deploy-local.sh
```

### Option 3: Fix PATH vĩnh viễn

Thêm vào file `~/.zshrc`:

```bash
# Thêm dòng này vào cuối file ~/.zshrc
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Reload terminal
source ~/.zshrc
```

## 🚀 Deploy ngay

### Bước 1: Start Minikube (nếu chưa chạy)

Mở terminal mới hoặc chạy:

```bash
# Fix PATH tạm thời
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Start minikube
minikube start
```

### Bước 2: Deploy

Quay lại terminal project và chạy:

```bash
./scripts/quick-deploy.sh
```

## 🔍 Debug

Nếu vẫn có lỗi:

```bash
# Check PATH
echo $PATH

# Check các commands
which minikube
which docker
which helm
which kubectl

# Nếu không tìm thấy, thêm PATH:
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
```

## 📝 Các commands hữu ích

```bash
# Start minikube
minikube start

# Check status
minikube status

# Deploy
./scripts/quick-deploy.sh

# Debug
./scripts/debug.sh

# Clean up
helm uninstall demo-frontend -n demo
```

## 💡 Tips

- Scripts đã tự động fix PATH, không cần config gì thêm
- Nếu dùng Conda, nên fix PATH trong `~/.zshrc` để vĩnh viễn
- Kiểm tra Docker Desktop đã mở chưa trước khi start Minikube
