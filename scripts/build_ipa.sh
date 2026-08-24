#!/bin/bash
set -e

echo "=== 构建 2048 游戏 IPA (无签名, TrollStore 安装) ==="

# 检查环境
if ! command -v xcodegen &> /dev/null; then
    echo "安装 XcodeGen..."
    brew install xcodegen
fi

# 转换图标为 PNG
echo "转换应用图标..."
cd "$(dirname "$0")/.."
if [ -f Assets.xcassets/AppIcon.appiconset/icon.jpg ]; then
    sips -s format png Assets.xcassets/AppIcon.appiconset/icon.jpg --out Assets.xcassets/AppIcon.appiconset/icon.png
fi

# 生成 Xcode 工程
echo "生成 Xcode 工程..."
xcodegen generate

# 编译 (无签名)
echo "编译中..."
xcodebuild \
    -project Game2048.xcodeproj \
    -scheme Game2048 \
    -configuration Release \
    -destination 'generic/platform=iOS' \
    -derivedDataPath build \
    CODE_SIGNING_ALLOWED=NO \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGN_IDENTITY="" \
    DEVELOPMENT_TEAM=""

# 打包 IPA
echo "打包 IPA..."
mkdir -p Payload
cp -r build/Build/Products/Release-iphoneos/Game2048.app Payload/
zip -r Game2048.ipa Payload
rm -rf Payload

echo ""
echo "=== 构建完成! ==="
echo "IPA 文件: $(pwd)/Game2048.ipa"
echo "将此 IPA 传到 iPhone, 用 TrollStore 安装即可。"
