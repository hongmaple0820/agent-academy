#!/bin/bash
# 设置每日复盘定时任务

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICE_FILE="$SCRIPT_DIR/daily-review.service"
TIMER_FILE="$SCRIPT_DIR/daily-review.timer"

echo "🚀 设置每日复盘定时任务..."
echo ""

# 创建 systemd 用户目录
mkdir -p ~/.config/systemd/user

# 复制服务文件
cp "$SERVICE_FILE" ~/.config/systemd/user/
cp "$TIMER_FILE" ~/.config/systemd/user/

# 重新加载 systemd
systemctl --user daemon-reload

# 启用并启动定时器
systemctl --user enable daily-review.timer
systemctl --user start daily-review.timer

# 检查状态
echo ""
echo "✅ 定时任务已设置："
systemctl --user list-timers daily-review.timer

echo ""
echo "📋 命令参考："
echo "  查看状态: systemctl --user status daily-review.timer"
echo "  查看日志: journalctl --user -u daily-review.service"
echo "  手动触发: systemctl --user start daily-review.service"
echo "  停止定时: systemctl --user stop daily-review.timer"
echo ""
echo "⏰ 每天晚上 12:00 自动复盘"