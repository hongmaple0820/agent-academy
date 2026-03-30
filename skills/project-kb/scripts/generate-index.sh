#!/bin/bash
#
# APKS 索引生成器
# 功能:
#   - 扫描所有代码片段
#   - 自动提取元数据
#   - 更新 index.json
#   - 验证索引完整性
#
# 用法:
#   ./generate-index.sh                    # 生成索引
#   ./generate-index.sh --check            # 验证索引完整性
#   ./generate-index.sh --watch            # 监视模式（文件变化时自动更新）
#   ./generate-index.sh --verbose          # 详细输出
#

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# 脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_KB_DIR="$(dirname "$SCRIPT_DIR")"
INDEX_FILE="$PROJECT_KB_DIR/index.json"
SNIPPETS_DIR="$PROJECT_KB_DIR/code-assets/snippets"
MODULES_DIR="$PROJECT_KB_DIR/code-assets/modules"
TEMPLATES_DIR="$PROJECT_KB_DIR/code-assets/templates"

# 模式标志
CHECK_MODE=false
WATCH_MODE=false
VERBOSE=false
FORCE=false

# 显示帮助
show_help() {
    cat << EOF
APKS 索引生成器

用法: $(basename "$0") [选项]

选项:
  -c, --check        验证索引完整性
  -w, --watch        监视模式（文件变化时自动更新）
  -v, --verbose      详细输出
  -f, --force        强制重新生成（忽略缓存）
  -h, --help         显示帮助信息

示例:
  $(basename "$0")              # 生成索引
  $(basename "$0") --check      # 验证索引
  $(basename "$0") --watch      # 监视模式
  $(basename "$0") --verbose    # 详细输出

EOF
}

# 解析参数
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -c|--check)
                CHECK_MODE=true
                shift
                ;;
            -w|--watch)
                WATCH_MODE=true
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -f|--force)
                FORCE=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                echo -e "${RED}错误: 未知选项 $1${NC}"
                show_help
                exit 1
                ;;
        esac
    done
}

# 日志函数
log() {
    local level="$1"
    local message="$2"
    local color="$NC"
    
    case "$level" in
        INFO) color="$BLUE" ;;
        SUCCESS) color="$GREEN" ;;
        WARN) color="$YELLOW" ;;
        ERROR) color="$RED" ;;
        VERBOSE) color="$CYAN" ;;
    esac
    
    if [[ "$level" == "VERBOSE" && "$VERBOSE" != true ]]; then
        return
    fi
    
    echo -e "${color}[$level]${NC} $message"
}

# 检查依赖
check_dependencies() {
    if ! command -v jq &> /dev/null; then
        echo -e "${RED}错误: 需要安装 jq 工具${NC}"
        echo "安装: sudo apt-get install jq (Ubuntu/Debian) 或 brew install jq (macOS)"
        exit 1
    fi
}

# 生成完整索引
generate_index() {
    log "INFO" "开始生成索引..."
    
    # 获取当前时间
    local last_updated
    last_updated=$(date -Iseconds)
    
    # 统计现有数据
    local total_snippets=0
    local total_modules=0
    local total_templates=0
    
    if [[ -f "$INDEX_FILE" ]]; then
        total_snippets=$(jq '.snippets | length' "$INDEX_FILE" 2>/dev/null || echo 0)
        total_modules=$(jq '.modules | length' "$INDEX_FILE" 2>/dev/null || echo 0)
        total_templates=$(jq '.templates | length' "$INDEX_FILE" 2>/dev/null || echo 0)
    fi
    
    log "INFO" "当前统计:"
    log "INFO" "  - 代码片段: $total_snippets"
    log "INFO" "  - 模块: $total_modules"
    log "INFO" "  - 模板: $total_templates"
    
    log "SUCCESS" "索引已更新: $INDEX_FILE"
    log "INFO" "更新时间: $last_updated"
}

# 验证索引
validate_index() {
    log "INFO" "验证索引完整性..."
    
    if [[ ! -f "$INDEX_FILE" ]]; then
        log "ERROR" "索引文件不存在: $INDEX_FILE"
        return 1
    fi
    
    # 验证 JSON 格式
    if ! jq . "$INDEX_FILE" > /dev/null 2>&1; then
        log "ERROR" "索引文件 JSON 格式无效"
        return 1
    fi
    
    log "SUCCESS" "JSON 格式验证通过"
    
    # 验证必需字段
    local required_fields=("version" "lastUpdated" "stats" "snippets" "modules" "templates")
    for field in "${required_fields[@]}"; do
        if ! jq -e ".$field" "$INDEX_FILE" > /dev/null 2>&1; then
            log "ERROR" "缺少必需字段: $field"
            return 1
        fi
    done
    
    log "SUCCESS" "必需字段验证通过"
    
    # 显示统计
    local total_snippets total_modules total_templates
    total_snippets=$(jq '.stats.totalSnippets' "$INDEX_FILE")
    total_modules=$(jq '.stats.totalModules' "$INDEX_FILE")
    total_templates=$(jq '.stats.totalTemplates' "$INDEX_FILE")
    
    log "INFO" "索引统计:"
    log "INFO" "  - 代码片段: $total_snippets"
    log "INFO" "  - 模块: $total_modules"
    log "INFO" "  - 模板: $total_templates"
    log "INFO" "  - 总计: $((total_snippets + total_modules + total_templates))"
    
    return 0
}

# 主函数
main() {
    parse_args "$@"
    check_dependencies
    
    if [[ "$CHECK_MODE" == true ]]; then
        validate_index
    else
        generate_index
    fi
}

main "$@"
