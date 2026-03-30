#!/bin/bash
#
# APKS 交互式代码选择器
# 支持上下选择、预览、确认插入
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

# 终端尺寸
TERM_ROWS=0
TERM_COLS=0

# 状态
SNIPPETS=()
SNIPPET_IDS=()
SNIPPET_TITLES=()
SNIPPET_TAGS=()
SELECTED_INDEX=0
SCROLL_OFFSET=0
PREVIEW_VISIBLE=true
LIST_WIDTH=35

# 获取终端尺寸
get_terminal_size() {
    TERM_ROWS=$(tput lines 2>/dev/null || echo "24")
    TERM_COLS=$(tput cols 2>/dev/null || echo "80")
}

# 清屏并隐藏光标
clear_screen() {
    clear
    tput civis 2>/dev/null || true
}

# 显示光标
show_cursor() {
    tput cnorm 2>/dev/null || true
}

# 设置光标位置
set_cursor() {
    local row=$1
    local col=$2
    printf "\033[%d;%dH" "$row" "$col"
}

# 加载代码片段列表
load_snippets() {
    local snippet_dir=".apks/snippets"
    
    SNIPPETS=()
    SNIPPET_IDS=()
    SNIPPET_TITLES=()
    SNIPPET_TAGS=()
    
    if [ -d "$snippet_dir" ]; then
        for file in "$snippet_dir"/*.md; do
            [ -f "$file" ] || continue
            
            local filename
            filename=$(basename "$file" .md)
            local title
            title=$(grep "^# " "$file" 2>/dev/null | head -1 | sed 's/^# //' || echo "$filename")
            local tags
            tags=$(grep -E "^tags:" "$file" 2>/dev/null | cut -d':' -f2- | tr ',' ' ' || echo "")
            
            SNIPPETS+=("$file")
            SNIPPET_IDS+=("$filename")
            SNIPPET_TITLES+=("$title")
            SNIPPET_TAGS+=("$tags")
        done
    fi
}

# 截断字符串
truncate() {
    local str="$1"
    local max_len=$2
    
    if [ "${#str}" -gt "$max_len" ]; then
        echo "${str:0:$((max_len-3))}..."
    else
        printf "%-${max_len}s" "$str"
    fi
}

# 绘制列表区域
draw_list() {
    local start_row=3
    local max_visible=$((TERM_ROWS - 6))
    local content_width=$((LIST_WIDTH - 4))
    
    # 调整滚动偏移
    if [ "$SELECTED_INDEX" -lt "$SCROLL_OFFSET" ]; then
        SCROLL_OFFSET=$SELECTED_INDEX
    elif [ "$SELECTED_INDEX" -ge $((SCROLL_OFFSET + max_visible)) ]; then
        SCROLL_OFFSET=$((SELECTED_INDEX - max_visible + 1))
    fi
    
    # 绘制列表项
    local i=0
    local display_idx=0
    for ((i=0; i<${#SNIPPETS[@]}; i++)); do
        if [ "$i" -lt "$SCROLL_OFFSET" ]; then
            continue
        fi
        if [ "$display_idx" -ge "$max_visible" ]; then
            break
        fi
        
        local row=$((start_row + display_idx))
        local id="${SNIPPET_IDS[$i]}"
        local title="${SNIPPET_TITLES[$i]}"
        
        # 截断标题
        local display_title
        display_title=$(truncate "$title" $((content_width - 2)))
        
        set_cursor "$row" 2
        
        if [ "$i" -eq "$SELECTED_INDEX" ]; then
            echo -en "${BOLD}${WHITE}> ${CYAN}${display_title}${NC}"
        else
            echo -en "  ${GRAY}${display_title}${NC}"
        fi
        
        # 清除行尾
        echo -en "\033[K"
        
        ((display_idx++))
    done
    
    # 清除剩余行
    while [ "$display_idx" -lt "$max_visible" ]; do
        local row=$((start_row + display_idx))
        set_cursor "$row" 2
        echo -en "\033[K"
        ((display_idx++))
    done
}

# 绘制预览区域
draw_preview() {
    local start_row=3
    local start_col=$((LIST_WIDTH + 2))
    local width=$((TERM_COLS - start_col - 2))
    local height=$((TERM_ROWS - 5))
    local content_width=$((width - 4))
    
    if [ "$PREVIEW_VISIBLE" = false ] || [ ${#SNIPPETS[@]} -eq 0 ]; then
        return
    fi
    
    local selected_file="${SNIPPETS[$SELECTED_INDEX]}"
    local selected_id="${SNIPPET_IDS[$SELECTED_INDEX]}"
    local selected_title="${SNIPPET_TITLES[$SELECTED_INDEX]}"
    local selected_tags="${SNIPPET_TAGS[$SELECTED_INDEX]}"
    
    # 绘制边框
    set_cursor 2 "$start_col"
    echo -en "${BLUE}+--[${selected_id}]${NC}"
    local title_len=$(( ${#selected_id} + 4 ))
    local remaining=$((width - title_len - 1))
    printf '%*s' "$remaining" | tr ' ' '-'
    echo -en "${BLUE}+${NC}"
    
    # 左右边框
    for ((i=1; i<height-1; i++)); do
        set_cursor $((2+i)) "$start_col"
        echo -en "${BLUE}|${NC}"
        set_cursor $((2+i)) $((start_col+width-1))
        echo -en "${BLUE}|${NC}"
    done
    
    # 下边框
    set_cursor $((2+height-1)) "$start_col"
    echo -en "${BLUE}+"
    printf '%*s' "$((width-2))" | tr ' ' '-'
    echo -en "+${NC}"
    
    # 显示元数据
    set_cursor 3 $((start_col + 2))
    echo -en "${BOLD}${selected_title:0:$((content_width-2))}${NC}\033[K"
    
    if [ -n "$selected_tags" ]; then
        set_cursor 4 $((start_col + 2))
        echo -en "${CYAN}Tags:${NC} ${selected_tags:0:$((content_width-10))}${NC}\033[K"
    fi
    
    # 分隔线
    set_cursor 5 $((start_col + 2))
    printf '%*s' "$((content_width))" | tr ' ' '-'
    
    # 显示代码预览
    local row=6
    local in_code_block=false
    local code_lang=""
    local max_code_lines=$((height - 8))
    local line_count=0
    
    while IFS= read -r line && [ "$line_count" -lt "$max_code_lines" ]; do
        # 处理代码块
        if [[ "$line" =~ ^\`\`\`([a-zA-Z0-9_]*)$ ]]; then
            if [ "$in_code_block" = false ]; then
                in_code_block=true
                code_lang="${BASH_REMATCH[1]}"
                set_cursor "$row" $((start_col + 2))
                echo -en "${MAGENTA}[${code_lang}]${NC}\033[K"
                ((row++))
                ((line_count++))
            else
                in_code_block=false
            fi
            continue
        fi
        
        set_cursor "$row" $((start_col + 2))
        
        if [ "$in_code_block" = true ]; then
            # 截断代码行
            local code_line="${line:0:$content_width}"
            echo -en "${GREEN}${code_line}${NC}\033[K"
        else
            # 普通文本（描述等）
            local text_line="${line:0:$content_width}"
            echo -en "${GRAY}${text_line}${NC}\033[K"
        fi
        
        ((row++))
        ((line_count++))
    done < "$selected_file"
    
    # 清除剩余行
    while [ "$line_count" -lt "$max_code_lines" ]; do
        set_cursor "$row" $((start_col + 2))
        echo -en "\033[K"
        ((row++))
        ((line_count++))
    done
    
    # 底部提示
    set_cursor $((height+1)) $((start_col + 2))
    echo -en "${DIM}Enter 插入 | q 退出 | ? 帮助${NC}\033[K"
}

# 绘制帮助信息
draw_help() {
    local start_row=$((TERM_ROWS / 2 - 6))
    local start_col=$((TERM_COLS / 2 - 25))
    local width=50
    local height=13
    
    # 绘制帮助窗口
    set_cursor "$start_row" "$start_col"
    echo -en "${BLUE}+--[帮助]${NC}"
    printf '%*s' $((width-9)) | tr ' ' '-'
    echo -en "${BLUE}+${NC}"
    
    for ((i=1; i<height-1; i++)); do
        set_cursor $((start_row+i)) "$start_col"
        echo -en "${BLUE}|${NC}"
        set_cursor $((start_row+i)) $((start_col+width-1))
        echo -en "${BLUE}|${NC}"
    done
    
    set_cursor $((start_row+height-1)) "$start_col"
    echo -en "${BLUE}+"
    printf '%*s' $((width-2)) | tr ' ' '-'
    echo -en "+${NC}"
    
    local row=$((start_row + 2))
    set_cursor "$row" $((start_col + 4))
    echo -en "${WHITE}↑/k         向上移动${NC}"
    ((row++))
    set_cursor "$row" $((start_col + 4))
    echo -en "${WHITE}↓/j         向下移动${NC}"
    ((row++))
    set_cursor "$row" $((start_col + 4))
    echo -en "${WHITE}Enter       插入选中代码${NC}"
    ((row++))
    set_cursor "$row" $((start_col + 4))
    echo -en "${WHITE}p           切换预览${NC}"
    ((row++))
    set_cursor "$row" $((start_col + 4))
    echo -en "${WHITE}g           跳到开头${NC}"
    ((row++))
    set_cursor "$row" $((start_col + 4))
    echo -en "${WHITE}G           跳到结尾${NC}"
    ((row++))
    set_cursor "$row" $((start_col + 4))
    echo -en "${WHITE}q/Esc       退出${NC}"
    ((row++))
    set_cursor "$row" $((start_col + 4))
    echo -en "${WHITE}?           显示帮助${NC}"
    ((row++))
    set_cursor "$row" $((start_col + 4))
    echo -en "${DIM}按任意键继续...${NC}"
}

# 绘制界面
draw_ui() {
    clear_screen
    
    # 标题
    set_cursor 1 2
    echo -en "${BOLD}${BLUE}APKS 交互式代码选择器${NC}"
    echo -en "${GRAY} | ${#SNIPPETS[@]} 个片段${NC}"
    
    # 列表
    draw_list
    
    # 预览
    draw_preview
    
    # 底部状态栏
    set_cursor $((TERM_ROWS - 1)) 2
    echo -en "${DIM}[$((SELECTED_INDEX + 1))/${#SNIPPETS[@]}] ${SNIPPET_IDS[$SELECTED_INDEX]:-''}${NC}\033[K"
}

# 插入代码
insert_snippet() {
    local selected_file="${SNIPPETS[$SELECTED_INDEX]}"
    local selected_id="${SNIPPET_IDS[$SELECTED_INDEX]}"
    
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
    done < "$selected_file"
    
    if [ -z "$code_content" ]; then
        show_cursor
        echo -e "${RED}错误: 代码片段中没有找到代码块${NC}"
        return 1
    fi
    
    # 显示光标并清屏
    show_cursor
    clear
    
    echo -e "${BOLD}${GREEN}已选择: $selected_id${NC}\n"
    echo -e "${CYAN}代码预览:${NC}"
    echo -e "${BLUE}────────────────────────────────────────${NC}"
    echo -n "$code_content"
    echo -e "${BLUE}────────────────────────────────────────${NC}\n"
    
    # 询问目标文件
    local target_file
    read -p "请输入目标文件路径 (直接回车复制到剪贴板): " target_file
    
    if [ -z "$target_file" ]; then
        # 复制到剪贴板
        if command -v xclip &> /dev/null; then
            echo -n "$code_content" | xclip -selection clipboard
            echo -e "${GREEN}✓ 代码已复制到剪贴板${NC}"
        elif command -v pbcopy &> /dev/null; then
            echo -n "$code_content" | pbcopy
            echo -e "${GREEN}✓ 代码已复制到剪贴板${NC}"
        elif command -v clip.exe &> /dev/null; then
            echo -n "$code_content" | clip.exe
            echo -e "${GREEN}✓ 代码已复制到剪贴板${NC}"
        elif command -v wl-copy &> /dev/null; then
            echo -n "$code_content" | wl-copy
            echo -e "${GREEN}✓ 代码已复制到剪贴板${NC}"
        else
            echo -e "${YELLOW}未找到剪贴板工具，请手动复制:${NC}"
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
                echo -e "${GREEN}✓ 代码已追加到 $target_file${NC}"
            else
                echo -e "${YELLOW}取消操作${NC}"
            fi
        else
            # 确保目录存在
            mkdir -p "$(dirname "$target_file")"
            echo "$code_content" > "$target_file"
            echo -e "${GREEN}✓ 代码已写入 $target_file${NC}"
        fi
    fi
    
    return 0
}

# 主循环
main_loop() {
    local running=true
    local show_help=false
    
    while $running; do
        if $show_help; then
            draw_help
            show_help=false
            # 等待按键
            read -rs -n1
            draw_ui
        fi
        
        # 读取按键
        local key
        read -rs -n1 key
        
        case "$key" in
            $'\x1b')
                # 处理转义序列
                read -rs -n2 -t 0.1 rest
                local seq="$key$rest"
                case "$seq" in
                    $'\x1b[A'|$'\x1bOA')  # 上箭头
                        if [ "$SELECTED_INDEX" -gt 0 ]; then
                            ((SELECTED_INDEX--))
                            draw_ui
                        fi
                        ;;
                    $'\x1b[B'|$'\x1bOB')  # 下箭头
                        if [ "$SELECTED_INDEX" -lt $((${#SNIPPETS[@]} - 1)) ]; then
                            ((SELECTED_INDEX++))
                            draw_ui
                        fi
                        ;;
                    $'\x1b')  # Esc
                        running=false
                        ;;
                esac
                ;;
            'k'|'K')
                if [ "$SELECTED_INDEX" -gt 0 ]; then
                    ((SELECTED_INDEX--))
                    draw_ui
                fi
                ;;
            'j'|'J')
                if [ "$SELECTED_INDEX" -lt $((${#SNIPPETS[@]} - 1)) ]; then
                    ((SELECTED_INDEX++))
                    draw_ui
                fi
                ;;
            'g')
                SELECTED_INDEX=0
                SCROLL_OFFSET=0
                draw_ui
                ;;
            'G')
                SELECTED_INDEX=$((${#SNIPPETS[@]} - 1))
                draw_ui
                ;;
            'p'|'P')
                if [ "$PREVIEW_VISIBLE" = true ]; then
                    PREVIEW_VISIBLE=false
                    LIST_WIDTH=$((TERM_COLS - 4))
                else
                    PREVIEW_VISIBLE=true
                    LIST_WIDTH=35
                fi
                draw_ui
                ;;
            '?')
                show_help=true
                ;;
            'q'|'Q')
                running=false
                ;;
            '')
                # Enter 键
                insert_snippet
                running=false
                ;;
        esac
    done
}

# 主函数
main() {
    # 检查是否在项目目录
    if [ ! -d ".apks" ]; then
        echo -e "${RED}错误: 项目未初始化${NC}"
        echo -e "请先运行: ${YELLOW}apks init${NC}"
        exit 1
    fi
    
    # 加载代码片段
    load_snippets
    
    if [ ${#SNIPPETS[@]} -eq 0 ]; then
        echo -e "${YELLOW}暂无代码片段${NC}"
        echo -e "运行 ${YELLOW}apks update${NC} 更新知识库"
        exit 0
    fi
    
    # 获取终端尺寸
    get_terminal_size
    
    # 捕获窗口大小变化
    trap 'get_terminal_size; draw_ui' WINCH
    
    # 捕获退出信号
    trap 'show_cursor; clear; exit' EXIT INT TERM
    
    # 绘制初始界面
    draw_ui
    
    # 进入主循环
    main_loop
    
    # 清理
    show_cursor
    clear
}

main "$@"
