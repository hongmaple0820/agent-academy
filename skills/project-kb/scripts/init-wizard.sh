#!/bin/bash
#
# APKS 项目初始化向导
# 交互式询问项目信息，生成项目画像
#

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
GRAY='\033[0;37m'
NC='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

# 项目配置
PROJECT_NAME=""
PROJECT_TYPE=""
PROJECT_DESCRIPTION=""
PROGRAMMING_LANGUAGE=""
FRAMEWORK=""
AUTO_LOAD=false

# 打印带颜色的消息
print_header() {
    clear
    echo -e "\n${BOLD}${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║${NC}         ${WHITE}APKS 项目初始化向导${NC}                            ${BOLD}${CYAN}║${NC}"
    echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════════════════╝${NC}\n"
}

print_step() {
    echo -e "\n${BOLD}${BLUE}[$1/5]${NC} ${WHITE}$2${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_prompt() {
    echo -en "${CYAN}> ${NC}"
}

# 显示选项列表
show_options() {
    local title=$1
    shift
    local options=("$@")
    
    echo -e "${DIM}$title${NC}"
    local i=1
    for option in "${options[@]}"; do
        echo -e "  ${CYAN}$i.${NC} $option"
        ((i++))
    done
}

# 获取用户选择
get_choice() {
    local max=$1
    local choice
    
    while true; do
        print_prompt
        read -r choice
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "$max" ]; then
            echo "$choice"
            return
        else
            echo -e "${RED}请输入 1-$max 之间的数字${NC}"
        fi
    done
}

# 获取用户输入（可空）
get_input() {
    local default=$1
    local input
    
    print_prompt
    read -r input
    
    if [ -z "$input" ] && [ -n "$default" ]; then
        echo "$default"
    else
        echo "$input"
    fi
}

# 获取用户确认
get_confirm() {
    local default=${1:-"n"}
    local prompt_text="y/N"
    [ "$default" = "y" ] && prompt_text="Y/n"
    
    local confirm
    print_prompt
    read -r confirm
    
    confirm=${confirm:-$default}
    [[ "$confirm" =~ ^[Yy]$ ]]
}

# 步骤 1: 项目名称
step_1_name() {
    print_step "1" "项目名称"
    
    # 默认使用当前目录名
    local default_name
    default_name=$(basename "$(pwd)")
    
    echo -e "请输入项目名称 ${DIM}(默认: $default_name)${NC}:"
    PROJECT_NAME=$(get_input "$default_name")
    
    print_success "项目名称: ${BOLD}$PROJECT_NAME${NC}"
    sleep 0.5
}

# 步骤 2: 项目类型
step_2_type() {
    print_step "2" "项目类型"
    
    local types=(
        "Web 前端项目 (React/Vue/Angular等)"
        "Web 后端项目 (Node.js/Python/Go等)"
        "全栈项目 (前后端结合)"
        "移动应用 (iOS/Android/Flutter)"
        "桌面应用 (Electron/Tauri等)"
        "命令行工具 (CLI)"
        "数据科学/机器学习项目"
        "DevOps/基础设施项目"
        "其他类型"
    )
    
    show_options "请选择项目类型:" "${types[@]}"
    
    local choice
    choice=$(get_choice ${#types[@]})
    
    case $choice in
        1) PROJECT_TYPE="frontend" ;;
        2) PROJECT_TYPE="backend" ;;
        3) PROJECT_TYPE="fullstack" ;;
        4) PROJECT_TYPE="mobile" ;;
        5) PROJECT_TYPE="desktop" ;;
        6) PROJECT_TYPE="cli" ;;
        7) PROJECT_TYPE="datascience" ;;
        8) PROJECT_TYPE="devops" ;;
        9) PROJECT_TYPE="other" ;;
    esac
    
    print_success "项目类型: ${BOLD}${types[$((choice-1))]}${NC}"
    sleep 0.5
}

# 步骤 3: 技术栈
step_3_stack() {
    print_step "3" "技术栈"
    
    # 根据项目类型推荐语言
    local languages=()
    case $PROJECT_TYPE in
        frontend)
            languages=("JavaScript" "TypeScript" "其他")
            ;;
        backend)
            languages=("Node.js" "Python" "Go" "Java" "Ruby" "PHP" "Rust" "其他")
            ;;
        fullstack)
            languages=("JavaScript/TypeScript" "Python" "Go" "Java" "其他")
            ;;
        mobile)
            languages=("Swift" "Kotlin" "Flutter/Dart" "React Native" "其他")
            ;;
        desktop)
            languages=("JavaScript/Electron" "Rust/Tauri" "Python" "C#" "其他")
            ;;
        cli)
            languages=("Bash" "Python" "Go" "Rust" "Node.js" "其他")
            ;;
        datascience)
            languages=("Python" "R" "Julia" "其他")
            ;;
        devops)
            languages=("YAML" "HCL" "Bash" "Python" "Go" "其他")
            ;;
        *)
            languages=("JavaScript" "TypeScript" "Python" "Go" "Java" "Rust" "其他")
            ;;
    esac
    
    echo -e "${DIM}主要编程语言:${NC}"
    local i=1
    for lang in "${languages[@]}"; do
        echo -e "  ${CYAN}$i.${NC} $lang"
        ((i++))
    done
    
    local lang_choice
    lang_choice=$(get_choice ${#languages[@]})
    PROGRAMMING_LANGUAGE="${languages[$((lang_choice-1))]}"
    
    print_success "编程语言: ${BOLD}$PROGRAMMING_LANGUAGE${NC}"
    
    # 询问框架
    echo ""
    echo -e "使用的主要框架/库 ${DIM}(直接回车跳过)${NC}:"
    print_prompt
    read -r FRAMEWORK
    
    [ -n "$FRAMEWORK" ] && print_success "框架: ${BOLD}$FRAMEWORK${NC}"
    
    sleep 0.5
}

# 步骤 4: 项目描述
step_4_description() {
    print_step "4" "项目描述"
    
    echo -e "请简要描述项目用途 ${DIM}(可选)${NC}:"
    print_prompt
    read -r PROJECT_DESCRIPTION
    
    if [ -n "$PROJECT_DESCRIPTION" ]; then
        print_success "项目描述已记录"
    fi
    
    sleep 0.5
}

# 步骤 5: 高级选项
step_5_advanced() {
    print_step "5" "高级选项"
    
    echo -e "是否启用自动加载? ${DIM}(启动时自动加载知识库) [y/N]${NC}"
    if get_confirm "n"; then
        AUTO_LOAD=true
        print_success "自动加载已启用"
    else
        print_info "自动加载已禁用"
    fi
    
    sleep 0.5
}

# 生成项目配置
generate_config() {
    print_header
    
    echo -e "${BOLD}${GREEN}正在生成项目配置...${NC}\n"
    
    # 创建目录结构
    mkdir -p .apks/snippets
    mkdir -p .apks/templates
    
    # 生成配置文件
    cat > .apks/config << EOF
# APKS 项目配置文件
# 生成时间: $(date '+%Y-%m-%d %H:%M:%S')

# 基本信息
project_name="$PROJECT_NAME"
project_type="$PROJECT_TYPE"
project_description="$PROJECT_DESCRIPTION"

# 技术栈
programming_language="$PROGRAMMING_LANGUAGE"
framework="$FRAMEWORK"

# 功能设置
auto_load=$AUTO_LOAD

# 统计信息
last_update="$(date '+%Y-%m-%d %H:%M:%S')"
snippet_count=0
EOF
    
    # 生成项目画像文件
    cat > .apks/profile.json << EOF
{
  "project": {
    "name": "$PROJECT_NAME",
    "type": "$PROJECT_TYPE",
    "description": "$PROJECT_DESCRIPTION"
  },
  "stack": {
    "language": "$PROGRAMMING_LANGUAGE",
    "framework": "$FRAMEWORK"
  },
  "settings": {
    "auto_load": $AUTO_LOAD,
    "created_at": "$(date -Iseconds 2>/dev/null || date '+%Y-%m-%dT%H:%M:%S')"
  },
  "recommendations": $(generate_recommendations)
}
EOF
    
    # 创建 .gitignore
    cat > .apks/.gitignore << 'EOF'
# APKS 本地文件
local/
cache/
*.tmp
EOF
    
    print_success "配置文件已生成"
    echo ""
}

# 生成推荐配置
generate_recommendations() {
    local recs="["
    
    case $PROJECT_TYPE in
        frontend)
            recs+='"react-hooks", "vue-composition", "typescript-patterns", "css-tricks"'
            ;;
        backend)
            recs+='"api-design", "error-handling", "logging", "database-patterns"'
            ;;
        fullstack)
            recs+='"api-design", "react-hooks", "database-patterns", "auth-patterns"'
            ;;
        mobile)
            recs+='"mobile-patterns", "state-management", "navigation"'
            ;;
        cli)
            recs+='"cli-patterns", "argument-parsing", "progress-bars"'
            ;;
        datascience)
            recs+='"data-processing", "visualization", "ml-patterns"'
            ;;
        devops)
            recs+='"docker-patterns", "ci-cd", "infrastructure"'
            ;;
        *)
            recs+='"common-patterns", "error-handling", "logging"'
            ;;
    esac
    
    recs+="]"
    echo "$recs"
}

# 显示配置摘要
show_summary() {
    print_header
    
    echo -e "${BOLD}${GREEN}✓ 项目初始化完成!${NC}\n"
    
    echo -e "${BOLD}配置摘要:${NC}"
    echo -e "  ${BLUE}项目名称:${NC}    $PROJECT_NAME"
    echo -e "  ${BLUE}项目类型:${NC}    $PROJECT_TYPE"
    echo -e "  ${BLUE}编程语言:${NC}    $PROGRAMMING_LANGUAGE"
    [ -n "$FRAMEWORK" ] && echo -e "  ${BLUE}框架:${NC}        $FRAMEWORK"
    [ -n "$PROJECT_DESCRIPTION" ] && echo -e "  ${BLUE}描述:${NC}        $PROJECT_DESCRIPTION"
    echo -e "  ${BLUE}自动加载:${NC}    $AUTO_LOAD"
    
    echo ""
    echo -e "${BOLD}推荐代码片段:${NC}"
    local recs=$(generate_recommendations | tr -d '[]"' | tr ',' '\n')
    while IFS= read -r rec; do
        [ -n "$rec" ] && echo -e "  ${CYAN}•${NC} ${rec}"
    done <<< "$recs"
    
    echo ""
    echo -e "${BOLD}${BLUE}下一步:${NC}"
    echo -e "  ${CYAN}1.${NC} 运行 ${YELLOW}apks update${NC} 下载知识库"
    echo -e "  ${CYAN}2.${NC} 运行 ${YELLOW}apks list${NC} 查看可用代码片段"
    echo -e "  ${CYAN}3.${NC} 运行 ${YELLOW}apks insert${NC} 交互式插入代码"
    
    echo ""
    echo -e "${DIM}配置文件位置: .apks/config${NC}"
}

# 主函数
main() {
    # 检查是否已初始化
    if [ -f ".apks/config" ]; then
        print_header
        echo -e "${YELLOW}⚠ 项目已初始化${NC}\n"
        echo -e "是否重新初始化? ${DIM}(这将覆盖现有配置)${NC} [y/N]"
        if ! get_confirm "n"; then
            echo -e "\n${BLUE}取消初始化${NC}"
            exit 0
        fi
        echo ""
    fi
    
    # 执行向导步骤
    step_1_name
    step_2_type
    step_3_stack
    step_4_description
    step_5_advanced
    
    # 生成配置
    generate_config
    
    # 显示摘要
    show_summary
}

main "$@"
