#!/bin/bash
# Remotion 视频渲染脚本
# 用法: ./render.sh <composition-id> [output-path] [options]
# 
# 示例:
#   ./render.sh MyComposition
#   ./render.sh MyComposition out/video.mp4
#   ./render.sh MyComposition out/video.mp4 "--frames=0-100"
#   ./render.sh MyComposition out/video.gif

set -e

COMPOSITION_ID="${1:-MyComposition}"
OUTPUT_PATH="${2:-out/video.mp4}"
EXTRA_OPTS="${3:-}"

echo "🎬 Rendering Remotion video"
echo "   Composition: $COMPOSITION_ID"
echo "   Output: $OUTPUT_PATH"
echo ""

# 检查是否在 Remotion 项目目录
if [ ! -f "remotion.config.ts" ] && [ ! -f "remotion.config.js" ]; then
    echo "❌ Error: Not in a Remotion project directory"
    echo "Please cd into a Remotion project first"
    exit 1
fi

# 创建输出目录
mkdir -p "$(dirname "$OUTPUT_PATH")"

# 渲染视频
echo "🚀 Starting render..."
npx remotion render "$COMPOSITION_ID" "$OUTPUT_PATH" $EXTRA_OPTS

echo ""
echo "✅ Render complete!"
echo "📁 Output: $OUTPUT_PATH"

# 显示文件信息
if command -v ffprobe &> /dev/null; then
    echo ""
    echo "📊 Video info:"
    ffprobe -v quiet -print_format json -show_format -show_streams "$OUTPUT_PATH" 2>/dev/null | \
        grep -E '"duration"|"width"|"height"|"codec_name"' | head -5 || true
fi