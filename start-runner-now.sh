#!/bin/bash

# Quick start runner script

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

echo "🚀 Starting Runner..."
echo ""

cd ~/actions-runner || cd actions-runner

if [ ! -f "./run.sh" ]; then
    echo "❌ Không tìm thấy run.sh"
    echo "Current directory: $(pwd)"
    exit 1
fi

echo "✅ Found run.sh"
echo ""
echo "⚠️  Terminal này sẽ block!"
echo "⚠️  Khi thấy 'Listening for Jobs' → Runner sẵn sàng!"
echo ""

./run.sh
