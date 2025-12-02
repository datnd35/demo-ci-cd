#!/bin/bash

# Simple step-by-step runner setup

echo "🚀 GitHub Actions Runner Setup"
echo "==============================="
echo ""
echo "⚠️  QUAN TRỌNG: Mở browser trước khi tiếp tục!"
echo ""
echo "1. Vào: https://github.com/datnd35/demo-ci-cd/settings/actions/runners/new"
echo "2. Chọn: macOS"
echo "3. Architecture: ARM64"
echo ""
read -p "Đã mở browser và chọn ARM64? (y/n): " ready

if [ "$ready" != "y" ]; then
    echo "Hãy mở browser trước, rồi chạy lại script!"
    exit 1
fi

echo ""
echo "════════════════════════════════════════"
echo "BƯỚC 1: Tạo thư mục"
echo "════════════════════════════════════════"
echo "Từ GitHub, tìm dòng:"
echo '  $ mkdir actions-runner && cd actions-runner'
echo ""
echo "CHỈ copy phần: mkdir actions-runner && cd actions-runner"
echo ""
read -p "Paste và Enter: " cmd1

if [[ -z "$cmd1" ]]; then
    echo "❌ Không có input!"
    exit 1
fi

echo "Chạy: $cmd1"
eval "$cmd1" || exit 1
echo "✅ OK"
echo ""

echo "════════════════════════════════════════"
echo "BƯỚC 2: Download"
echo "════════════════════════════════════════"
echo "Từ GitHub, tìm dòng bắt đầu bằng:"
echo '  $ curl -o actions-runner-osx-arm64...'
echo ""
echo "Copy TOÀN BỘ lệnh curl (rất dài)"
echo ""
read -p "Paste và Enter: " cmd2

if [[ -z "$cmd2" ]]; then
    echo "❌ Không có input!"
    exit 1
fi

echo "Downloading..."
eval "$cmd2" || exit 1
echo "✅ Download xong"
echo ""

echo "════════════════════════════════════════"
echo "BƯỚC 3: Extract"
echo "════════════════════════════════════════"
echo "Từ GitHub, tìm dòng:"
echo '  $ tar xzf ./actions-runner-osx-arm64...'
echo ""
read -p "Paste và Enter: " cmd3

if [[ -z "$cmd3" ]]; then
    echo "❌ Không có input!"
    exit 1
fi

echo "Extracting..."
eval "$cmd3" || exit 1
echo "✅ Extract xong"
echo ""

echo "════════════════════════════════════════"
echo "BƯỚC 4: Configure (QUAN TRỌNG!)"
echo "════════════════════════════════════════"
echo "Từ GitHub, kéo xuống phần 'Configure'"
echo "Tìm dòng:"
echo '  $ ./config.sh --url https://github.com/datnd35/demo-ci-cd --token AXXXXXX...'
echo ""
echo "⚠️  Lệnh này có TOKEN dài, phải copy đầy đủ!"
echo ""
read -p "Paste và Enter: " cmd4

if [[ -z "$cmd4" ]]; then
    echo "❌ Không có input!"
    exit 1
fi

if [[ ! "$cmd4" =~ "./config.sh" ]]; then
    echo "❌ Lỗi: Lệnh không bắt đầu bằng ./config.sh"
    echo "Bạn paste: $cmd4"
    exit 1
fi

echo "Configuring..."
eval "$cmd4"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅✅✅ Configure thành công! ✅✅✅"
    echo ""
    echo "════════════════════════════════════════"
    echo "BƯỚC 5: Start Runner"
    echo "════════════════════════════════════════"
    echo ""
    echo "⚠️  Terminal này sẽ BLOCK và hiển thị:"
    echo "    'Listening for Jobs'"
    echo ""
    echo "⚠️  Để runner chạy, KHÔNG tắt terminal này!"
    echo ""
    read -p "Nhấn Enter để start runner..."
    echo ""
    ./run.sh
else
    echo ""
    echo "❌ Configure thất bại!"
    echo "Có thể token đã hết hạn. Hãy:"
    echo "1. Refresh trang GitHub"
    echo "2. Copy lệnh ./config.sh mới"
    echo "3. Chạy lại script"
fi
