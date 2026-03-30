#!/bin/bash
#
# APKS 快速查找工具
# 功能:
#   - 简化搜索命令
#   - 支持模糊匹配
#   - 显示预览
#
# 用法:
#   ./apks-find "button"           # 模糊搜索 button
#   ./apks-find "auth" --preview   # 显示代码预览
#   ./apks-find "react" --json     # JSON 输出
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
SEARCH_SCRIPT="$SCRIPT_DIR/search.sh"

# 默认参数
QUERY=""
PREVIEW=false
JSON_OUTPUT=false
LIMIT=10

# 显示帮助
show_help() {
    cat << EOF
APKS 快速查找工具

用法: $(basename "$0") [选项] <关键词>

选项:
  -p, --preview       显示代码预览
  -j, --json          JSON 格式输出
  -l, --limit N       限制结果数量 (默认: 10)
  -h, --help          显示帮助信息

示例:
  $(basename "$0") "button"              # 搜索 button
  $(basename "$0") "auth" --preview      # 搜索并预览
  $(basename "$0") "react" --json        # JSON 输出
  $(basename "$0") "api" --limit 5       # 限制 5 个结果

EOF
}

# 解析参数
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--preview)
                PREVIEW=true
                shift
                ;;
            -j|--json)
                JSON_OUTPUT=true
                shift
                ;;
            -l|--limit)
                LIMIT="$2"
                shift 2
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            -*)
                echo -e "${RED}错误: 未知选项 $1${NC}"
                show_help
                exit 1
                ;;
            *)
                QUERY="$1"
                shift
                ;;
        esac
    done
}

# 检查依赖
check_dependencies() {
    if ! command -v jq &> /dev/null; then
        echo -e "${RED}错误: 需要安装 jq 工具${NC}"
        exit 1
    fi
    
    if [[ ! -f "$INDEX_FILE" ]]; then
        echo -e "${RED}错误: 索引文件不存在${NC}"
        echo "请运行: ./generate-index.sh"
        exit 1
    fi
}

# 模糊搜索
fuzzy_search() {
    local query="$1"
    local q_lower="${query,,}"
    
    # 在 snippets、modules、templates 中搜索
    jq --arg q "$query" --arg ql "$q_lower" '
    def matches(item):
        ((item.name // "") | ascii_downcase | contains($ql)) or
        ((item.title // "") | ascii_downcase | contains($ql)) or
        ((item.description // "") | ascii_downcase | contains($ql)) or
        ((item.tags // []) | map(ascii_downcase) | contains([$ql]));
    {
        snippets: [.snippets[]? | select(matches(.))],
        modules: [.modules[]? | select(matches(.))],
        templates: [.templates[]? | select(matches(.))]
    }
    ' "$INDEX_FILE"
}

# 显示结果
show_results() {
    local results="$1"
    
    local snippets_count
    local modules_count
    local templates_count
    
    snippets_count=$(echo "$results" | jq '.snippets | length')
    modules_count=$(echo "$results" | jq '.modules | length')
    templates_count=$(echo "$results" | jq '.templates | length')
    local total=$((snippets_count + modules_count + templates_count))
    
    if [[ $total -eq 0 ]]; then
        echo -e "${YELLOW}未找到包含 '$QUERY' 的结果${NC}"
        return
    fi
    
    echo -e "${GREEN}找到 $total 个结果 (关键词: '$QUERY')${NC}"
    echo ""
    
    # 显示代码片段
    if [[ $snippets_count -gt 0 ]]; then
        echo -e "${BOLD}${CYAN}=== 代码片段 ($snippets_count) ===${NC}"
        echo "$results" | jq -r '.snippets[] | "  \u001b[1m[\(.id)]\u001b[0m \(.title) \u001b[90m(\(.complexity))\u001b[0m\n     分类: \(.category) | 标签: \(.tags | join(", "))\n     \(.description)"' | head -n $((LIMIT * 4))
        echo ""
    fi
    
    # 显示模块
    if [[ $modules_count -gt 0 ]]; then
        echo -e "${BOLD}${CYAN}=== 模块 ($modules_count) ===${NC}"
        echo "$results" | jq -r '.modules[] | "  \u001b[1m[\(.id)]\u001b[0m \(.title) \u001b[90m(\(.complexity))\u001b[0m\n     分类: \(.category) | 标签: \(.tags | join(", "))\n     \(.description)"' | head -n $((LIMIT * 4))
        echo ""
    fi
    
    # 显示模板
    if [[ $templates_count -gt 0 ]]; then
        echo -e "${BOLD}${CYAN}=== 模板 ($templates_count) ===${NC}"
        echo "$results" | jq -r '.templates[] | "  \u001b[1m[\(.id)]\u001b[0m \(.title) \u001b[90m(\(.complexity))\u001b[0m\n     分类: \(.category) | 标签: \(.tags | join(", "))\n     \(.description)"' | head -n $((LIMIT * 4))
        echo ""
    fi
}

# 显示预览
show_preview() {
    local results="$1"
    
    echo -e "${BOLD}${CYAN}=== 代码预览 ===${NC}"
    echo ""
    
    # 预览代码片段
    echo "$results" | jq -r '.snippets[] | "\(.file)"' | while read -r file; do
        if [[ -n "$file" && -f "$PROJECT_KB_DIR/$file" ]]; then
            echo -e "${BOLD}文件: $file${NC}"
            head -20 "$PROJECT_KB_DIR/$file" | sed 's/^/  /'
            echo ""
        fi
    done
}

# 主函数
main() {
    parse_args "$@"
    
    if [[ -z "$QUERY" ]]; then
        echo -e "${RED}错误: 请提供搜索关键词${NC}"
        show_help
        exit 1
    fi
    
    check_dependencies
    
    # 执行搜索
    local results
    results=$(fuzzy_search "$QUERY")
    
    if [[ "$JSON_OUTPUT" == true ]]; then
        echo "$results" | jq .
    else
        show_results "$results"
        
        if [[ "$PREVIEW" == true ]]; then
            show_preview "$results"
        fi
    fi
}

main "$@"
