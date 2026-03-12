#!/bin/bash
# Remotion 项目创建脚本
# 用法: ./create-project.sh <项目名称> [模板]
# 模板选项: blank, hello-world, troubleshooting

set -e

PROJECT_NAME="${1:-my-video}"
TEMPLATE="${2:-hello-world}"

echo "🎬 Creating Remotion project: $PROJECT_NAME"
echo "📦 Template: $TEMPLATE"
echo ""

# 检查 npx 是否可用
if ! command -v npx &> /dev/null; then
    echo "❌ Error: npx is not installed"
    echo "Please install Node.js first: https://nodejs.org/"
    exit 1
fi

# 创建项目
echo "🚀 Running create-video..."
npx create-video@latest "$PROJECT_NAME" --template "$TEMPLATE"

cd "$PROJECT_NAME"

echo ""
echo "✅ Project created successfully!"
echo ""
echo "📁 Project structure:"
ls -la
echo ""
echo "📝 Next steps:"
echo "   cd $PROJECT_NAME"
echo "   npx remotion studio    # Start development server"
echo "   npx remotion render MyComposition out/video.mp4   # Render video"
echo ""
echo "📚 Documentation: https://www.remotion.dev/docs/the-fundamentals"