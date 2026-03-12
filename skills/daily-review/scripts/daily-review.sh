#!/bin/bash
# 每日复盘定时触发脚本

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

# 设置环境变量
export OPENCLAW_STATE_DIR="$HOME/.openclaw"

# 获取今天的日期
TODAY=$(date +"%Y-%m-%d")
REVIEW_FILE="$HOME/.openclaw/workspace/memory/reviews/${TODAY}-review.md"

# 检查今天是否已经复盘
if [ -f "$REVIEW_FILE" ]; then
    echo "今日复盘已存在: $REVIEW_FILE"
    exit 0
fi

# 创建复盘目录
mkdir -p "$(dirname "$REVIEW_FILE")"

# 触发 OpenClaw 进行复盘
echo "触发每日复盘: $TODAY"

# 发送消息到 OpenClaw 触发复盘
# 通过 Redis 或直接调用 API
curl -s -X POST http://localhost:8273/api/message \
    -H "Content-Type: application/json" \
    -d "{
        \"action\": \"daily-review\",
        \"date\": \"$TODAY\",
        \"trigger\": \"scheduled\"
    }" 2>/dev/null || echo "API 调用失败，请手动触发复盘"

# 记录日志
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 每日复盘触发完成" >> "$HOME/.openclaw/logs/daily-review.log"