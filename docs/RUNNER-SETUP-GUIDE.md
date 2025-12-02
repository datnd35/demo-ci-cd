# Setup GitHub Self-Hosted Runner - HƯỚNG DẪN CHI TIẾT

## ⚠️ QUAN TRỌNG

**BẠN KHÔNG THỂ COPY COMMANDS TỪ TÀI LIỆU NÀY!**

Mỗi repository có TOKEN riêng, bạn PHẢI lấy commands từ GitHub!

---

## 📝 Các bước thực hiện

### Bước 1: Mở GitHub Runner Settings

1. Mở browser
2. Truy cập: **https://github.com/datnd35/demo-ci-cd/settings/actions/runners/new**
3. Đăng nhập nếu cần

### Bước 2: Chọn Operating System

- Click chọn **macOS**
- Click **ARM64** (nếu bạn dùng Apple Silicon M1/M2/M3)

### Bước 3: Copy Commands từ GitHub

GitHub sẽ hiển thị một trang với các commands. 

**⚠️ QUY TẮC COPY:**
- ✅ **CHỈ copy phần sau dấu `$`**
- ❌ **KHÔNG copy dấu `$`**
- ❌ **KHÔNG copy dòng có dấu `#`**

**Ví dụ trên GitHub hiển thị:**
```
# Create a folder
$ mkdir actions-runner && cd actions-runner
```

**Bạn CHỈ copy:**
```
mkdir actions-runner && cd actions-runner
```

### Bước 4: Thực hiện từng lệnh

#### Lệnh 1: Tạo thư mục
```bash
# Copy lệnh từ GitHub có dạng:
mkdir actions-runner && cd actions-runner

# Paste vào terminal và Enter
```

#### Lệnh 2: Download runner
```bash
# Copy lệnh từ GitHub có dạng:
curl -o actions-runner-osx-arm64-2.319.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.319.1/actions-runner-osx-arm64-2.319.1.tar.gz

# Paste vào terminal và Enter
# Đợi download xong
```

#### Lệnh 3: Extract
```bash
# Copy lệnh từ GitHub có dạng:
tar xzf ./actions-runner-osx-arm64-2.319.1.tar.gz

# Paste vào terminal và Enter
```

#### Lệnh 4: Configure (⚠️ LƯU Ý: CÓ TOKEN)
```bash
# Copy lệnh từ GitHub có dạng:
./config.sh --url https://github.com/datnd35/demo-ci-cd --token AXXXXXXXXXXXXXXXXXXXXX

# ⚠️ Token này CHỈ có hiệu lực trong 1 giờ!
# Paste vào terminal và Enter

# Trả lời các câu hỏi:
# Enter the name of the runner: [nhấn Enter để dùng default]
# Enter additional labels: [nhấn Enter]
# Enter name of work folder: [nhấn Enter]
```

#### Lệnh 5: Start runner
```bash
# Copy lệnh từ GitHub:
./run.sh

# Terminal sẽ hiển thị:
# √ Connected to GitHub
# Current runner version: '2.319.1'
# Listening for Jobs
```

### Bước 5: Giữ Runner chạy

**Runner PHẢI chạy để CI/CD hoạt động!**

- Terminal chạy `./run.sh` KHÔNG được tắt
- Máy Mac KHÔNG được tắt/sleep khi chạy CI/CD

**Để chạy runner tự động khi khởi động máy:**

```bash
cd ~/actions-runner
./svc.sh install
./svc.sh start
```

---

## 🚀 Sau khi Runner đã chạy

### Test CI/CD

```bash
# Terminal mới
cd /Users/macbookairm1/Desktop/angular-v20/demo-ci-cd

# Commit và push
git add .
git commit -m "Test CI/CD with self-hosted runner"
git push origin master

# Xem workflow
open https://github.com/datnd35/demo-ci-cd/actions
```

---

## 🔍 Troubleshooting

### Lỗi: Token đã hết hạn

**Lỗi:**
```
Failed to connect. Try again or ctrl-c to quit
```

**Giải pháp:**
1. Quay lại browser
2. Refresh trang: https://github.com/datnd35/demo-ci-cd/settings/actions/runners/new
3. Copy lệnh `./config.sh` MỚI (có token mới)
4. Chạy lại

### Lỗi: Runner không connect

**Kiểm tra:**
```bash
# Check runner status
ps aux | grep run.sh

# Check network
ping github.com

# Restart runner
cd ~/actions-runner
./run.sh
```

### Lỗi: Workflow không chạy

**Kiểm tra:**
1. Runner có đang chạy? (terminal hiển thị "Listening for Jobs")
2. Workflow file có đúng `runs-on: self-hosted`?
3. Check Actions tab: https://github.com/datnd35/demo-ci-cd/actions

---

## 📊 Check Status

### Xem runner status trên GitHub:

https://github.com/datnd35/demo-ci-cd/settings/actions/runners

Sẽ thấy:
- ✅ Green dot = Runner online
- ⚪ Gray dot = Runner offline

---

## 🛑 Stop/Remove Runner

### Tạm dừng:
```bash
# Ctrl+C trong terminal đang chạy ./run.sh
```

### Xóa runner:
```bash
cd ~/actions-runner
./config.sh remove --token YOUR_REMOVAL_TOKEN
```

---

## 💡 Tips

1. **Dùng terminal riêng** cho runner, không dùng terminal code
2. **Giữ terminal chạy** khi test CI/CD
3. **Cài service** nếu muốn runner tự động start
4. **Check logs** nếu có lỗi: `~/actions-runner/_diag/`

---

## ✅ Checklist

- [ ] Mở GitHub runner settings
- [ ] Chọn macOS
- [ ] Copy commands ĐÚNG (không copy $, #)
- [ ] mkdir actions-runner && cd actions-runner
- [ ] curl download
- [ ] tar extract
- [ ] ./config.sh (với token từ GitHub)
- [ ] ./run.sh
- [ ] Terminal hiển thị "Listening for Jobs"
- [ ] Push code để test
