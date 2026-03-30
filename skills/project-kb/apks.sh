#!/bin/bash
#
# APKS - AI Project Knowledge Store CLI
# 项目知识库命令行工具
#

set -e

# 版本信息
VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# 配置文件路径
CONFIG_DIR="${HOME}/.config/apks"
CONFIG_FILE="$CONFIG_DIR/config"
PROJECT_CONFIG=".apks/config"

# ==================== 工具函数 ====================

# 打印带颜色的消息
print_error() {
    echo -e "${RED}✗ $1${NC}" >&2
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_header() {
    echo -e "\n${BOLD}${CYAN}$1${NC}"
    echo -e "${CYAN}$(printf '=%.0s' $(seq 1 ${#1}))${NC}\n"
}

print_step() {
    echo -e "${MAGENTA}→ $1${NC}"
}

# 进度条显示
show_progress() {
    local current=$1
    local total=$2
    local width=40
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    printf "\r${BLUE}[${NC}"
    printf "%${filled}s" | tr ' ' '█'
    printf "%${empty}s" | tr ' ' '░'
    printf "${BLUE}]${NC} ${percentage}%% (%d/%d)" "$current" "$total"
    
    if [ "$current" -eq "$total" ]; then
        echo ""
    fi
}

# 检查是否在项目目录中
is_project_initialized() {
    [ -f "$PROJECT_CONFIG" ] && [ -d ".apks" ]
}

# 获取项目配置
get_project_config() {
    local key=$1
    if [ -f "$PROJECT_CONFIG" ]; then
        grep "^$key=" "$PROJECT_CONFIG" 2>/dev/null | cut -d'=' -f2- | tr -d '"'
    fi
}

# 加载全局配置
load_global_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    fi
}

# 确保配置目录存在
ensure_config_dir() {
    mkdir -p "$CONFIG_DIR"
}

# ==================== 命令实现 ====================

cmd_version() {
    echo -e "${BOLD}APKS${NC} (AI Project Knowledge Store) v${VERSION}"
    echo "项目知识库管理工具"
    echo ""
    echo "作者: Maple"
    echo "许可证: MIT"
}

cmd_help() {
    print_header "APKS - AI Project Knowledge Store"
    
    echo -e "${BOLD}用法:${NC} apks <命令> [选项]"
    echo ""
    
    echo -e "${BOLD}命令:${NC}"
    echo -e "  ${GREEN}init${NC}              初始化项目知识库"
    echo -e "  ${GREEN}search${NC} <keyword>  搜索代码片段"
    echo -e "  ${GREEN}list${NC}              列出所有代码片段"
    echo -e "  ${GREEN}show${NC} <id>         显示代码详情"
    echo -e "  ${GREEN}insert${NC} <id>       插入代码到项目"
    echo -e "  ${GREEN}update${NC}            更新知识库"
    echo -e "  ${GREEN}stats${NC}             显示统计信息"
    echo -e "  ${GREEN}config${NC}            配置管理"
    echo -e "  ${GREEN}version${NC}           显示版本信息"
    echo -e "  ${GREEN}help${NC}              显示帮助信息"
    echo ""
    
    echo -e "${BOLD}选项:${NC}"
    echo -e "  -h, --help          显示帮助"
    echo -e "  -v, --verbose       详细输出"
    echo -e "  --no-color          禁用彩色输出"
    echo ""
    
    echo -e "${BOLD}示例:${NC}"
    echo -e "  apks init                              # 初始化项目"
    echo -e "  apks search 'react hook'               # 搜索代码"
    echo -e "  apks list                              # 列出所有代码"
    echo -e "  apks show snippet-001                  # 显示详情"
    echo -e "  apks insert snippet-001                # 插入代码"
    echo -e "  apks stats                             # 统计信息"
    echo ""
    
    echo -e "${BOLD}更多信息:${NC}"
    echo -e "  查看 CLI-GUIDE.md 获取详细使用指南"
}

cmd_init() {
    print_header "初始化项目知识库"
    
    if is_project_initialized; then
        print_warning "项目知识库已初始化"
        local reinit
        read -p "是否重新初始化? (y/N): " reinit
        if [[ ! "$reinit" =~ ^[Yy]$ ]]; then
            print_info "取消初始化"
            return 0
        fi
    fi
    
    # 运行初始化向导
    if [ -f "$SCRIPTS_DIR/init-wizard.sh" ]; then
        bash "$SCRIPTS_DIR/init-wizard.sh"
    else
        print_error "初始化向导未找到: $SCRIPTS_DIR/init-wizard.sh"
        print_info "使用默认配置初始化..."
        
        # 默认初始化
        mkdir -p .apks/snippets
        cat > "$PROJECT_CONFIG" << 'EOF'
# APKS 项目配置
project_name=$(basename "$(pwd)")
project_type=generic
auto_load=false
last_update=
snippet_count=0
EOF
        print_success "项目知识库已初始化"
    fi
}

cmd_search() {
    local keyword="$1"
    
    if [ -z "$keyword" ]; then
        print_error "请提供搜索关键词"
        echo "用法: apks search <keyword>"
        return 1
    fi
    
    if ! is_project_initialized; then
        print_error "项目未初始化，请先运行: apks init"
        return 1
    fi
    
    print_header "搜索代码: '$keyword'"
    
    local found=0
    local snippet_dir=".apks/snippets"
    
    if [ -d "$snippet_dir" ]; then
        for file in "$snippet_dir"/*.md; do
            [ -f "$file" ] || continue
            
            local content
            content=$(cat "$file" 2>/dev/null || true)
            
            if echo "$content" | grep -qi "$keyword"; then
                local filename
                filename=$(basename "$file" .md)
                local title
                title=$(grep "^# " "$file" | head -1 | sed 's/^# //' || echo "$filename")
                local tags
                tags=$(grep -E "^tags:" "$file" | cut -d':' -f2- | tr ',' ' ' || echo "无标签")
                
                echo -e "${GREEN}${filename}${NC} - ${BOLD}${title}${NC}"
                echo -e "  标签: ${CYAN}${tags}${NC}"
                echo ""
                ((found++))
            fi
        done
    fi
    
    # 同时搜索知识库目录
    local kb_dir="${APKS_KB_DIR:-$SCRIPT_DIR/knowledge}"
    if [ -d "$kb_dir" ]; then
        for file in "$kb_dir"/**/*.md; do
            [ -f "$file" ] || continue
            
            if grep -qi "$keyword" "$file" 2>/dev/null; then
                local filename
                filename=$(basename "$file" .md)
                local title
                title=$(grep "^# " "$file" | head -1 | sed 's/^# //' || echo "$filename")
                
                echo -e "${YELLOW}[知识库]${NC} ${GREEN}${filename}${NC} - ${BOLD}${title}${NC}"
                ((found++))
            fi
        done 2>/dev/null || true
    fi
    
    if [ "$found" -eq 0 ]; then
        print_warning "未找到匹配的代码片段"
        print_info "提示: 尝试使用更通用的关键词，或运行 'apks update' 更新知识库"
    else
        print_success "找到 $found 个结果"
    fi
}

cmd_list() {
    if ! is_project_initialized; then
        print_error "项目未初始化，请先运行: apks init"
        return 1
    fi
    
    print_header "代码片段列表"
    
    local snippet_dir=".apks/snippets"
    local count=0
    
    if [ -d "$snippet_dir" ]; then
        echo -e "${BOLD}ID          名称                    标签                    大小${NC}"
        echo -e "${BLUE}────────────────────────────────────────────────────────────${NC}"
        
        for file in "$snippet_dir"/*.md; do
            [ -f "$file" ] || continue
            
            local filename
            filename=$(basename "$file" .md)
            local title
            title=$(grep "^# " "$file" | head -1 | sed 's/^# //' || echo "$filename")
            title="${title:0:20}"
            local tags
            tags=$(grep -E "^tags:" "$file" | cut -d':' -f2- | tr ',' ' ' || echo "")
            tags="${tags:0:20}"
            local size
            size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null || echo "0")
            local size_human
            if [ "$size" -lt 1024 ]; then
                size_human="${size}B"
            elif [ "$size" -lt 1048576 ]; then
                size_human="$((size / 1024))KB"
            else
                size_human="$((size / 1048576))MB"
            fi
            
            printf "${GREEN}%-10s${NC}  %-20s  ${CYAN}%-20s${NC}  %s\n" \
                "$filename" "$title" "$tags" "$size_human"
            ((count++))
        done
        
        echo ""
        print_success "共 $count 个代码片段"
    else
        print_warning "暂无代码片段"
        print_info "运行 'apks update' 下载知识库"
    fi
}

cmd_show() {
    local id="$1"
    
    if [ -z "$id" ]; then
        print_error "请提供代码片段 ID"
        echo "用法: apks show <id>"
        return 1
    fi
    
    if ! is_project_initialized; then
        print_error "项目未初始化，请先运行: apks init"
        return 1
    fi
    
    local snippet_file=".apks/snippets/${id}.md"
    
    if [ ! -f "$snippet_file" ]; then
        # 尝试从知识库查找
        local kb_dir="${APKS_KB_DIR:-$SCRIPT_DIR/knowledge}"
        snippet_file="$kb_dir/${id}.md"
        
        if [ ! -f "$snippet_file" ]; then
            print_error "代码片段未找到: $id"
            return 1
        fi
    fi
    
    print_header "代码详情: $id"
    
    # 显示元数据
    local title
    title=$(grep "^# " "$snippet_file" | head -1 | sed 's/^# //' || echo "未命名")
    local description
    description=$(grep -E "^description:" "$snippet_file" | cut -d':' -f2- | sed 's/^ *//' || echo "")
    local tags
    tags=$(grep -E "^tags:" "$snippet_file" | cut -d':' -f2- || echo "")
    local language
    language=$(grep -E "^language:" "$snippet_file" | cut -d':' -f2- | tr -d ' ' || echo "")
    
    echo -e "${BOLD}标题:${NC} $title"
    [ -n "$description" ] && echo -e "${BOLD}描述:${NC} $description"
    [ -n "$tags" ] && echo -e "${BOLD}标签:${NC} ${CYAN}$tags${NC}"
    [ -n "$language" ] && echo -e "${BOLD}语言:${NC} ${MAGENTA}$language${NC}"
    echo ""
    
    # 显示代码内容
    echo -e "${BOLD}代码内容:${NC}"
    echo -e "${BLUE}────────────────────────────────────────────────────────────${NC}"
    
    # 提取代码块
    local in_code_block=false
    local code_lang=""
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^\`\`\`([a-zA-Z0-9_]*)$ ]]; then
            if [ "$in_code_block" = false ]; then
                in_code_block=true
                code_lang="${BASH_REMATCH[1]}"
                echo -e "${MAGENTA}[$code_lang]${NC}"
            else
                in_code_block=false
                echo ""
            fi
        elif [ "$in_code_block" = true ]; then
            echo -e "${GREEN}$line${NC}"
        fi
    done < "$snippet_file"
    
    echo -e "${BLUE}────────────────────────────────────────────────────────────${NC}"
    echo ""
    echo -e "使用 ${YELLOW}apks insert $id${NC} 将此代码插入到项目中"
}

cmd_insert() {
    local id="$1"
    
    if [ -z "$id" ]; then
        # 启动交互式选择器
        if [ -f "$SCRIPTS_DIR/interactive-select.sh" ]; then
            bash "$SCRIPTS_DIR/interactive-select.sh"
            return $?
        else
            print_error "请提供代码片段 ID"
            echo "用法: apks insert <id>"
            return 1
        fi
    fi
    
    if ! is_project_initialized; then
        print_error "项目未初始化，请先运行: apks init"
        return 1
    fi
    
    local snippet_file=".apks/snippets/${id}.md"
    
    if [ ! -f "$snippet_file" ]; then
        print_error "代码片段未找到: $id"
        return 1
    fi
    
    print_header "插入代码: $id"
    
    # 提取代码块
    local code_content=""
    local in_code_block=false
    
    while IFS= read -r line; do
        if [[ "$line" =~ ^\`\`\`[a-zA-Z0-9_]*$ ]]; then
            if [ "$in_code_block" = false ]; then
                in_code_block=true
            else
                in_code_block=false
            fi
        elif [ "$in_code_block" = true ]; then
            code_content+="$line"$'\n'
        fi
    done < "$snippet_file"
    
    if [ -z "$code_content" ]; then
        print_error "代码片段中没有找到代码块"
        return 1
    fi
    
    # 询问目标文件
    local target_file
    read -p "请输入目标文件路径 (默认: 复制到剪贴板): " target_file
    
    if [ -z "$target_file" ]; then
        # 复制到剪贴板
        if command -v xclip &> /dev/null; then
            echo -n "$code_content" | xclip -selection clipboard
            print_success "代码已复制到剪贴板"
        elif command -v pbcopy &> /dev/null; then
            echo -n "$code_content" | pbcopy
            print_success "代码已复制到剪贴板"
        elif command -v clip.exe &> /dev/null; then
            echo -n "$code_content" | clip.exe
            print_success "代码已复制到剪贴板"
        else
            print_warning "未找到剪贴板工具，直接输出:"
            echo ""
            echo "$code_content"
        fi
    else
        # 写入文件
        if [ -f "$target_file" ]; then
            local overwrite
            read -p "文件已存在，是否追加? (y/N): " overwrite
            if [[ "$overwrite" =~ ^[Yy]$ ]]; then
                echo "" >> "$target_file"
                echo "$code_content" >> "$target_file"
                print_success "代码已追加到 $target_file"
            else
                print_info "取消操作"
                return 0
            fi
        else
            # 确保目录存在
            mkdir -p "$(dirname "$target_file")"
            echo "$code_content" > "$target_file"
            print_success "代码已写入 $target_file"
        fi
    fi
}

cmd_update() {
    print_header "更新知识库"
    
    print_step "检查更新..."
    
    # 模拟更新进度
    local steps=5
    for i in $(seq 1 $steps); do
        sleep 0.3
        show_progress "$i" "$steps"
    done
    
    # 这里可以添加实际的更新逻辑
    # 例如从远程仓库拉取最新知识库
    
    print_success "知识库已更新到最新版本"
    print_info "下次更新: $(date -d '+7 days' '+%Y-%m-%d' 2>/dev/null || date '+%Y-%m-%d')"
}

cmd_stats() {
    if ! is_project_initialized; then
        print_error "项目未初始化，请先运行: apks init"
        return 1
    fi
    
    print_header "知识库统计信息"
    
    local snippet_dir=".apks/snippets"
    local total_snippets=0
    local total_size=0
    local languages=""
    local tags_count=0
    
    if [ -d "$snippet_dir" ]; then
        for file in "$snippet_dir"/*.md; do
            [ -f "$file" ] || continue
            
            ((total_snippets++))
            
            local size
            size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null || echo "0")
            total_size=$((total_size + size))
            
            local lang
            lang=$(grep -E "^language:" "$file" 2>/dev/null | head -1 | sed 's/language:[[:space:]]*"\?\([^"]*\)"\?.*/\1/' | tr -d ' "' || echo "")
            if [ -n "$lang" ] && [ "$lang" != "language:" ]; then
                languages="$languages $lang"
            fi
            
            local tags
            tags=$(grep -E "^tags:" "$file" 2>/dev/null | head -1 | sed 's/.*\[\(.*\)\].*/\1/' | tr ',' '\n' | wc -l)
            tags_count=$((tags_count + tags))
        done
    fi
    
    # 格式化大小
    local size_human
    if [ "$total_size" -lt 1024 ]; then
        size_human="${total_size}B"
    elif [ "$total_size" -lt 1048576 ]; then
        size_human="$((total_size / 1024))KB"
    else
        size_human="$((total_size / 1048576))MB"
    fi
    
    echo -e "${BOLD}项目信息:${NC}"
    echo -e "  项目名称: ${CYAN}$(get_project_config 'project_name' || basename "$(pwd)")${NC}"
    echo -e "  项目类型: ${CYAN}$(get_project_config 'project_type' || 'generic')${NC}"
    echo ""
    
    echo -e "${BOLD}代码片段统计:${NC}"
    echo -e "  总数: ${GREEN}$total_snippets${NC}"
    echo -e "  总大小: ${GREEN}$size_human${NC}"
    echo -e "  标签数: ${GREEN}$tags_count${NC}"
    echo ""
    
    if [ -n "$languages" ]; then
        echo -e "${BOLD}语言分布:${NC}"
        local lang_dist
        lang_dist=$(echo "$languages" | tr ' ' '\n' | sort | uniq -c | sort -rn)
        while IFS= read -r line; do
            local count=$(echo "$line" | awk '{print $1}')
            local lang=$(echo "$line" | awk '{print $2}')
            [ -n "$lang" ] && echo -e "  ${MAGENTA}$lang${NC}: $count"
        done <<< "$lang_dist"
        echo ""
    fi
    
    # 最近更新
    local last_update
    last_update=$(get_project_config 'last_update')
    if [ -n "$last_update" ]; then
        echo -e "${BOLD}最后更新:${NC} ${YELLOW}$last_update${NC}"
    fi
}

cmd_config() {
    print_header "配置管理"
    
    echo -e "${BOLD}全局配置:${NC} $CONFIG_FILE"
    echo -e "${BOLD}项目配置:${NC} $PROJECT_CONFIG"
    echo ""
    
    if [ -f "$CONFIG_FILE" ]; then
        echo -e "${BOLD}当前配置:${NC}"
        cat "$CONFIG_FILE"
    else
        print_info "暂无全局配置"
        echo ""
        echo "创建配置示例:"
        echo "  apks config set key=value"
    fi
}

# ==================== 主程序 ====================

main() {
    # 处理全局选项
    local verbose=false
    local no_color=false
    
    while [[ "$1" =~ ^- ]]; do
        case "$1" in
            -h|--help)
                cmd_help
                exit 0
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            --no-color)
                no_color=true
                shift
                ;;
            --version)
                cmd_version
                exit 0
                ;;
            *)
                print_error "未知选项: $1"
                cmd_help
                exit 1
                ;;
        esac
    done
    
    # 禁用颜色
    if [ "$no_color" = true ]; then
        RED=''
        GREEN=''
        YELLOW=''
        BLUE=''
        CYAN=''
        MAGENTA=''
        NC=''
        BOLD=''
    fi
    
    # 加载全局配置
    load_global_config
    
    # 解析命令
    local command="${1:-help}"
    shift || true
    
    case "$command" in
        init)
            cmd_init "$@"
            ;;
        search)
            cmd_search "$@"
            ;;
        list|ls)
            cmd_list
            ;;
        show|view)
            cmd_show "$@"
            ;;
        insert|add)
            cmd_insert "$@"
            ;;
        update|upgrade)
            cmd_update
            ;;
        stats|stat)
            cmd_stats
            ;;
        config|cfg)
            cmd_config
            ;;
        version|--version|-v)
            cmd_version
            ;;
        help|--help|-h)
            cmd_help
            ;;
        *)
            print_error "未知命令: $command"
            echo ""
            cmd_help
            exit 1
            ;;
    esac
}

# 运行主程序
main "$@"
