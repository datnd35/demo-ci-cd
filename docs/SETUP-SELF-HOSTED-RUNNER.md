# Setup Self-Hosted Runner cho Minikube

## Cách setup GitHub Actions Self-Hosted Runner trên Mac

### Bước 1: Tạo Runner trên GitHub

1. Vào repository GitHub của bạn
2. Click **Settings** → **Actions** → **Runners**
3. Click **New self-hosted runner**
4. Chọn **macOS** và copy các lệnh

### Bước 2: Cài đặt Runner trên máy Mac

```bash
# Tạo thư mục cho runner
mkdir actions-runner && cd actions-runner

# Download runner (lệnh này lấy từ GitHub)
curl -o actions-runner-osx-arm64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-osx-arm64-2.311.0.tar.gz

# Extract
tar xzf ./actions-runner-osx-arm64-2.311.0.tar.gz

# Configure runner (token lấy từ GitHub)
./config.sh --url https://github.com/YOUR_USERNAME/YOUR_REPO --token YOUR_TOKEN

# Chạy runner
./run.sh
```

### Bước 3: Cài đặt Runner như Service (Optional)

Để runner tự động chạy khi khởi động máy:

```bash
# Cài đặt service
./svc.sh install

# Start service
./svc.sh start

# Check status
./svc.sh status
```

### Bước 4: Đảm bảo Minikube đang chạy

```bash
# Start minikube nếu chưa chạy
minikube start

# Check status
minikube status

# Enable metrics-server (optional, cho HPA)
minikube addons enable metrics-server
```

### Bước 5: Test Workflow

```bash
git add .
git commit -m "Add self-hosted runner workflow"
git push origin main
```

---

## Ưu điểm của Self-Hosted Runner

✅ Có thể dùng Minikube local  
✅ Không cần cloud cluster  
✅ Free, không tốn tiền  
✅ Build nhanh hơn (không cần push/pull image)

## Nhược điểm

❌ Máy phải bật khi chạy CI/CD  
❌ Cần bảo mật máy cẩn thận  
❌ Không scale được như cloud runners

---

## Security Notes

⚠️ **Quan trọng**: Self-hosted runners có thể chạy code tùy ý từ repository.

**Chỉ dùng cho:**

- Private repositories
- Repositories mà bạn tin tưởng
- Không accept public PRs

**Không dùng cho:**

- Public repositories với PRs từ strangers
- Shared computers
