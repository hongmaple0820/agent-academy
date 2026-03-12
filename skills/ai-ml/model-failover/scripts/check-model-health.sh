#!/bin/bash
# model-failover: 检测模型健康状态

set -e

CONFIG_FILE="$HOME/.openclaw/openclaw.json"
LOG_FILE="$HOME/.openclaw/logs/model-switch.log"

# 记录日志
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
}

# 检查当前模型
check_current_model() {
    local current_model
    current_model=$(openclaw config get agents.defaults.model.primary 2>/dev/null || echo "unknown")
    echo "$current_model"
}

# 发送测试请求检测模型健康
check_model_health() {
    local model="$1"
    local timeout=10
    
    # 尝试简单的echo测试
    if timeout "$timeout" openclaw run --model "$model" --message "echo 'test'" 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# 主流程
main() {
    log "=== 开始模型健康检查 ==="
    
    local current_model
    current_model=$(check_current_model)
    log "当前模型: $current_model"
    
    # 尝试使用doctor检查
    local doctor_output
    if doctor_output=$(openclaw doctor 2>&1); then
        # 检查输出中是否有错误关键词
        if echo "$doctor_output" | grep -qi "error\|failed\|timeout"; then
            log "⚠️  检测到问题"
            log "$doctor_output"
            exit 1
        else
            log "✅ 模型健康"
            exit 0
        fi
    else
        log "❌ doctor 命令失败，可能模型不可用"
        log "$doctor_output"
        exit 1
    fi
}

main "$@"
