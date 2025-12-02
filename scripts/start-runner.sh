#!/bin/bash

# Script để start runner nhanh

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

echo "🚀 Starting GitHub Actions Runner"
echo "=================================="
echo ""

# Check if runner directory exists
if [ ! -d ~/actions-runner ]; then
    echo "❌ Thư mục ~/actions-runner không tồn tại!"
    echo ""
    echo "Bạn cần setup runner trước:"
    echo "  ./scripts/setup-runner-simple.sh"
    exit 1
fi

cd ~/actions-runner

# Check if configured
if [ ! -f .runner ]; then
    echo "❌ Runner chưa được configure!"
    echo ""
    echo "Chạy lại setup:"
    echo "  ./scripts/setup-runner-simple.sh"
    exit 1
fi

echo "✅ Runner đã configure"
echo ""
echo "Starting runner..."
echo ""
echo "⚠️  Terminal này sẽ block!"
echo "⚠️  KHÔNG tắt terminal khi CI/CD đang chạy!"
echo ""
echo "Khi thấy 'Listening for Jobs' → Runner sẵn sàng!"
echo ""

./run.sh
