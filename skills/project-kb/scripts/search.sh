#!/bin/bash
#
# APKS 代码片段搜索工具
#

set -e

# 颜色
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; NC='\033[0m'; BOLD='\033[1m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_KB_DIR="$(dirname "$SCRIPT_DIR")"
INDEX_FILE="$PROJECT_KB_DIR/index.json"

# 参数
KEYWORD=""; CATEGORY=""; TAGS=""; COMPLEXITY=""; TYPE=""
OUTPUT_FORMAT="table"; CASE_SENSITIVE=false

show_help() {
    cat << 'EOF'
APKS 代码片段搜索工具

用法: search.sh [选项]

选项:
  -k, --keyword KEYWORD      关键词搜索
  -c, --category CATEGORY    分类筛选
  -t, --tags TAGS            标签过滤（逗号分隔）
  -x, --complexity LEVEL     复杂度过滤
  -y, --type TYPE            类型过滤
  -f, --format FORMAT        输出格式 (table, json, list)
  -s, --case-sensitive       区分大小写
  -h, --help                 显示帮助

EOF
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -k|--keyword) KEYWORD="$2"; shift 2 ;;
            -c|--category) CATEGORY="$2"; shift 2 ;;
            -t|--tags) TAGS="$2"; shift 2 ;;
            -x|--complexity) COMPLEXITY="$2"; shift 2 ;;
            -y|--type) TYPE="$2"; shift 2 ;;
            -f|--format) OUTPUT_FORMAT="$2"; shift 2 ;;
            -s|--case-sensitive) CASE_SENSITIVE=true; shift ;;
            -h|--help) show_help; exit 0 ;;
            *) echo "错误: 未知选项 $1"; exit 1 ;;
        esac
    done
}

check_deps() {
    if ! command -v jq &> /dev/null; then
        echo "错误: 需要安装 jq"; exit 1
    fi
    if [[ ! -f "$INDEX_FILE" ]]; then
        echo "错误: 索引文件不存在"; exit 1
    fi
}

# 构建搜索过滤器
build_filter() {
    local filters=()
    
    if [[ -n "$KEYWORD" ]]; then
        local kw="${KEYWORD,,}"
        filters+=("((.name // \"\") + (.title // \"\") + (.description // \"\")) | ascii_downcase | contains(\"$kw\")")
    fi
    
    if [[ -n "$CATEGORY" ]]; then
        filters+=(".category == \"$CATEGORY\"")
    fi
    
    if [[ -n "$COMPLEXITY" ]]; then
        filters+=(".complexity == \"$COMPLEXITY\"")
    fi
    
    if [[ ${#filters[@]} -eq 0 ]]; then
        echo "true"
    else
        local joined=""
        for f in "${filters[@]}"; do
            [[ -n "$joined" ]] && joined="$joined and "
            joined="$joined($f)"
        done
        echo "$joined"
    fi
}

# 搜索特定类型
search_type() {
    local t="$1"
    local filter=$(build_filter)
    jq -r ".${t} // [] | map(select($filter))" "$INDEX_FILE"
}

# 表格输出
output_table() {
    local type_name="$1"
    local data="$2"
    local count=$(echo "$data" | jq 'length')
    
    [[ $count -eq 0 ]] && return
    
    echo -e "\n${BOLD}${CYAN}=== ${type_name} ===${NC}\n"
    printf "${BOLD}%-12s %-25s %-15s %-12s %-40s${NC}\n" "ID" "名称" "分类" "复杂度" "描述"
    printf "%-12s %-25s %-15s %-12s %-40s\n" "------------" "-------------------------" "---------------" "------------" "----------------------------------------"
    
    echo "$data" | jq -c '.[]' | while read -r item; do
        local id=$(echo "$item" | jq -r '.id // "N/A"')
        local name=$(echo "$item" | jq -r '.name // "N/A"')
        local cat=$(echo "$item" | jq -r '.category // "N/A"')
        local comp=$(echo "$item" | jq -r '.complexity // "N/A"')
        local desc=$(echo "$item" | jq -r '.description // "N/A"')
        
        [[ ${#name} -gt 23 ]] && name="${name:0:20}..."
        [[ ${#desc} -gt 38 ]] && desc="${desc:0:35}..."
        
        local color="$NC"
        case "$comp" in simple) color="$GREEN" ;; medium) color="$YELLOW" ;; complex) color="$RED" ;; esac
        
        printf "%-12s %-25s %-15s ${color}%-12s${NC} %-40s\n" "$id" "$name" "$cat" "$comp" "$desc"
    done
    echo ""
}

# 列表输出
output_list() {
    local type_name="$1"
    local data="$2"
    local count=$(echo "$data" | jq 'length')
    
    [[ $count -eq 0 ]] && return
    
    echo -e "\n${BOLD}${CYAN}=== ${type_name} ===${NC}"
    
    echo "$data" | jq -c '.[]' | while read -r item; do
        echo ""
        echo -e "${BOLD}[$(echo "$item" | jq -r '.id // "N/A"')] $(echo "$item" | jq -r '.title // "N/A"')${NC}"
        echo "  名称: $(echo "$item" | jq -r '.name // "N/A"')"
        echo "  分类: $(echo "$item" | jq -r '.category // "N/A"')"
        echo "  复杂度: $(echo "$item" | jq -r '.complexity // "N/A"')"
        local lang=$(echo "$item" | jq -r '.language // "N/A"')
        [[ "$lang" != "N/A" ]] && echo "  语言: $lang"
        local fw=$(echo "$item" | jq -r '.framework // "N/A"')
        [[ "$fw" != "N/A" ]] && echo "  框架: $fw"
        echo "  标签: $(echo "$item" | jq -r '.tags // [] | join(", ")')"
        echo "  描述: $(echo "$item" | jq -r '.description // "N/A"')"
    done
    echo ""
}

main() {
    parse_args "$@"
    check_deps
    
    # 执行搜索
    local snippets='[]'; local modules='[]'; local templates='[]'
    
    if [[ -z "$TYPE" || "$TYPE" == "snippets" ]]; then
        snippets=$(search_type "snippets")
    fi
    if [[ -z "$TYPE" || "$TYPE" == "modules" ]]; then
        modules=$(search_type "modules")
    fi
    if [[ -z "$TYPE" || "$TYPE" == "templates" ]]; then
        templates=$(search_type "templates")
    fi
    
    local s_count=$(echo "$snippets" | jq 'length')
    local m_count=$(echo "$modules" | jq 'length')
    local t_count=$(echo "$templates" | jq 'length')
    local total=$((s_count + m_count + t_count))
    
    if [[ $total -eq 0 ]]; then
        echo -e "${YELLOW}未找到匹配的结果${NC}"
        [[ -n "$KEYWORD" ]] && echo "  关键词: $KEYWORD"
        [[ -n "$CATEGORY" ]] && echo "  分类: $CATEGORY"
        [[ -n "$COMPLEXITY" ]] && echo "  复杂度: $COMPLEXITY"
        exit 0
    fi
    
    # 输出
    case "$OUTPUT_FORMAT" in
        json)
            jq -n \
                --argjson s "$snippets" --argjson m "$modules" --argjson t "$templates" \
                --arg kw "$KEYWORD" --arg cat "$CATEGORY" --arg comp "$COMPLEXITY" \
                '{meta: {query: $kw, category: $cat, complexity: $comp}, results: {snippets: $s, modules: $m, templates: $t}, total: (($s | length) + ($m | length) + ($t | length))}'
            ;;
        list)
            [[ $s_count -gt 0 ]] && output_list "Snippets" "$snippets"
            [[ $m_count -gt 0 ]] && output_list "Modules" "$modules"
            [[ $t_count -gt 0 ]] && output_list "Templates" "$templates"
            ;;
        *)
            [[ $s_count -gt 0 ]] && output_table "Snippets" "$snippets"
            [[ $m_count -gt 0 ]] && output_table "Modules" "$modules"
            [[ $t_count -gt 0 ]] && output_table "Templates" "$templates"
            ;;
    esac
    
    echo -e "${GREEN}找到 $total 个结果${NC}"
    [[ $s_count -gt 0 ]] && echo "  - 代码片段: $s_count"
    [[ $m_count -gt 0 ]] && echo "  - 模块: $m_count"
    [[ $t_count -gt 0 ]] && echo "  - 模板: $t_count"
}

main "$@"
