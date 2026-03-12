#!/bin/bash
# model-failover: 切换模型

set -e

CONFIG_FILE="$HOME/.openclaw/openclaw.json"
LOG_FILE="$HOME/.openclaw/logs/model-switch.log"
BACKUP_DIR="$HOME/.openclaw/backups"

# 确保备份目录存在
mkdir -p "$BACKUP_DIR"

# 记录日志
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" | tee -a "$LOG_FILE"
}

# 备份当前配置
backup_config() {
    cp "$CONFIG_FILE" "$BACKUP_DIR/openclaw.json.$(date +%Y%m%d-%H%M%S)" 2>/dev/null || true
    log "📂 配置已备份"
}

# 获取当前模型
current_model() {
    openclaw config get agents.defaults.model.primary 2>/dev/null || echo "unknown"
}

# 获取fallback列表
get_fallbacks() {
    openclaw config get agents.defaults.model.fallbacks 2>/dev/null | jq -r '.[]' 2>/dev/null
}

# 切换到下一个模型
switch_to_next_model() {
    local current="$1"
    local fallbacks
    local next_model=""
    local found=false
    
    while IFS= read -r model; do
        if [ "$found" = true ]; then
            next_model="$model"
            break
        fi
        if [ "$model" = "$current" ]; then
            found=true
        fi
    done <<< "$(get_fallbacks)"
    
    # 如果没找到下一个，使用fallbacks第一个
    if [ -z "$next_model" ]; then
        next_model=$(get_fallbacks | head -1)
    fi
    
    echo "$next_model"
}

# 更新配置
update_config() {
    local new_model="$1"
    
    log "🔄 切换到模型: $new_model"
    
    # 先备份
    backup_config
    
    # 尝试更新配置
    if openclaw config set "agents.defaults.model.primary" "$new_model" 2>/dev/null; then
        log "✅ 配置更新成功"
        
        # 平滑重载（不重启整个gateway）
        if openclaw gateway reload 2>/dev/null; then
            log "✅ Gateway 已平滑重载"
        else
            log "⚠️  Gateway reload 失败，可能需要手动重启"
        fi
    else
        log "❌ 配置更新失败"
        return 1
    fi
}

# 主流程
main() {
    log "=== 开始模型切换 ==="
    
    local current
    current=$(current_model)
    log "当前模型: $current"
    
    local next
    next=$(switch_to_next_model "$current")
    
    if [ -z "$next" ]; then
        log "❌ 无法找到备用模型"
        exit 1
    fi
    
    if [ "$next" = "$current" ]; then
        log "⚠️  已经是最后一个备用模型"
        exit 1
    fi
    
    update_config "$next"
    
    log "🎉 模型切换完成：$current -> $next"
    log "=== 切换结束 ==="
}

main "$@"
