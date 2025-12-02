#!/bin/bash

# Script để chạy các lệnh setup runner từ GitHub
# Chạy script này trong terminal MỚI

echo "🚀 GitHub Runner Setup Helper"
echo "============================="
echo ""
echo "⚠️  LƯU Ý:"
echo "1. Đảm bảo đã chọn ARM64 architecture trên GitHub"
echo "2. Copy commands TỪ GITHUB, KHÔNG phải từ đây"
echo "3. Chỉ copy phần SAU dấu \$"
echo ""
echo "📍 Bạn đang ở thư mục: $(pwd)"
echo ""

# Step 1: Create folder
echo "─────────────────────────────────────"
echo "BƯỚC 1: Tạo thư mục actions-runner"
echo "─────────────────────────────────────"
echo "Từ GitHub, copy lệnh có dạng:"
echo "  mkdir actions-runner && cd actions-runner"
echo ""
read -p "Paste lệnh từ GitHub và nhấn Enter: " cmd1
echo ""
eval "$cmd1"
if [ $? -eq 0 ]; then
    echo "✅ Đã tạo thư mục và cd vào"
else
    echo "❌ Lỗi! Kiểm tra lại lệnh"
    exit 1
fi
echo ""

# Step 2: Download
echo "─────────────────────────────────────"
echo "BƯỚC 2: Download runner"
echo "─────────────────────────────────────"
echo "Từ GitHub, copy lệnh curl có dạng:"
echo "  curl -o actions-runner-osx-arm64-2.329.0.tar.gz -L https://..."
echo ""
read -p "Paste lệnh curl từ GitHub và nhấn Enter: " cmd2
echo ""
eval "$cmd2"
if [ $? -eq 0 ]; then
    echo "✅ Download hoàn tất"
else
    echo "❌ Download thất bại! Kiểm tra lại lệnh"
    exit 1
fi
echo ""

# Step 3: Extract
echo "─────────────────────────────────────"
echo "BƯỚC 3: Extract file"
echo "─────────────────────────────────────"
echo "Từ GitHub, copy lệnh tar có dạng:"
echo "  tar xzf ./actions-runner-osx-arm64-2.329.0.tar.gz"
echo ""
read -p "Paste lệnh tar từ GitHub và nhấn Enter: " cmd3
echo ""
eval "$cmd3"
if [ $? -eq 0 ]; then
    echo "✅ Extract thành công"
else
    echo "❌ Extract thất bại!"
    exit 1
fi
echo ""

# Step 4: Configure
echo "─────────────────────────────────────"
echo "BƯỚC 4: Configure runner"
echo "─────────────────────────────────────"
echo "Từ GitHub, copy lệnh ./config.sh có dạng:"
echo "  ./config.sh --url https://github.com/datnd35/demo-ci-cd --token AXXXXX..."
echo ""
echo "⚠️  Token chỉ có hiệu lực trong 1 giờ!"
echo ""
read -p "Paste lệnh ./config.sh từ GitHub và nhấn Enter: " cmd4
echo ""
eval "$cmd4"
if [ $? -eq 0 ]; then
    echo "✅ Configure thành công"
else
    echo "❌ Configure thất bại!"
    exit 1
fi
echo ""

# Step 5: Run
echo "─────────────────────────────────────"
echo "BƯỚC 5: Start runner"
echo "─────────────────────────────────────"
echo "Sẽ chạy: ./run.sh"
echo ""
echo "⚠️  Terminal này sẽ giữ runner chạy!"
echo "⚠️  KHÔNG tắt terminal này khi CI/CD đang chạy!"
echo ""
read -p "Nhấn Enter để start runner..." 
echo ""
./run.sh
