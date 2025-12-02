# 🚀 Quick Setup Runner - Copy Paste Commands

## ⚠️ QUAN TRỌNG: Mở terminal MỚI để chạy!

Đừng dùng terminal hiện tại. Mở terminal mới (Cmd+T)

---

## 📋 Các lệnh cần chạy (theo thứ tự):

### 1️⃣ Tạo thư mục

```bash
mkdir actions-runner && cd actions-runner
```

### 2️⃣ Download

**⚠️ PHẢI lấy từ GitHub! Token và URL thay đổi!**

Vào: https://github.com/datnd35/demo-ci-cd/settings/actions/runners/new

- Chọn: macOS
- Architecture: ARM64

Copy lệnh `curl` từ GitHub (dạng):

```bash
curl -o actions-runner-osx-arm64-2.329.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.329.0/actions-runner-osx-arm64-2.329.0.tar.gz
```

### 3️⃣ Extract

```bash
tar xzf ./actions-runner-osx-arm64-2.329.0.tar.gz
```

### 4️⃣ Configure

**⚠️ PHẢI lấy từ GitHub! Có TOKEN!**

Kéo xuống phần "Configure" trên GitHub, copy lệnh (dạng):

```bash
./config.sh --url https://github.com/datnd35/demo-ci-cd --token AXXXXXXXXXXXXXXXXXXXXX
```

**Trả lời các câu hỏi:**

- Runner name: [nhấn Enter]
- Labels: [nhấn Enter]
- Work folder: [nhấn Enter]

### 5️⃣ Start Runner

```bash
./run.sh
```

**Khi thấy:**

```
✓ Connected to GitHub
Listening for Jobs
```

→ ✅ **THÀNH CÔNG!** Giữ terminal này chạy!

---

## 🎯 Sau đó

Trong terminal KHÁC, xem workflow:

```bash
open https://github.com/datnd35/demo-ci-cd/actions
```

Workflow sẽ tự động chạy!

---

## 💡 Tips

- **Mở terminal MỚI** để chạy commands
- **Token có hiệu lực 1 giờ** - nếu hết hạn, refresh GitHub để lấy mới
- **CHỈ copy phần SAU dấu `$`** trên GitHub
- **Giữ terminal runner chạy** khi CI/CD đang hoạt động
