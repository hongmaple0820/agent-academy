#!/bin/bash
#
# context-aware-insert.sh - 上下文感知代码插入工具
#
# 功能:
# - 分析当前代码上下文
# - 自动调整导入路径
# - 插入代码并适配项目风格
#
# 使用方法:
#   ./context-aware-insert.sh [选项] <目标文件> <代码片段>
#   ./context-aware-insert.sh --file snippet.ts --target src/app.ts
#
# 作者: APKS 智能加载系统
# 版本: 1.0.0

set -e

# 调试模式
DEBUG=${DEBUG:-false}
APKS_DEBUG() {
    if [[ "$DEBUG" == "true" ]]; then
        echo "[APKS DEBUG] $*" >&2
    fi
}

# 颜色定义
APKS_COLOR_INFO="\033[36m"
APKS_COLOR_SUCCESS="\033[32m"
APKS_COLOR_WARN="\033[33m"
APKS_COLOR_ERROR="\033[31m"
APKS_COLOR_HIGHLIGHT="\033[35m"
APKS_COLOR_RESET="\033[0m"

# 输出函数
apks_info() { echo -e "${APKS_COLOR_INFO}[APKS INFO]${APKS_COLOR_RESET} $*"; }
apks_success() { echo -e "${APKS_COLOR_SUCCESS}[APKS SUCCESS]${APKS_COLOR_RESET} $*"; }
apks_warn() { echo -e "${APKS_COLOR_WARN}[APKS WARN]${APKS_COLOR_RESET} $*"; }
apks_error() { echo -e "${APKS_COLOR_ERROR}[APKS ERROR]${APKS_COLOR_RESET} $*"; }
apks_highlight() { echo -e "${APKS_COLOR_HIGHLIGHT}$*${APKS_COLOR_RESET}"; }

# 项目根目录
APKS_PROJECT_ROOT="${APKS_PROJECT_ROOT:-$(pwd)}"

# 获取文件语言类型
get_file_language() {
    local file="$1"
    local ext="${file##*.}"
    case "$ext" in
        js|jsx) echo "javascript" ;;
        ts|tsx) echo "typescript" ;;
        py) echo "python" ;;
        go) echo "go" ;;
        rs) echo "rust" ;;
        java) echo "java" ;;
        *) echo "unknown" ;;
    esac
}

# 分析文件导入语句
analyze_imports() {
    local file="$1"
    local lang=$(get_file_language "$file")
    
    APKS_DEBUG "分析文件导入: $file (语言: $lang)"
    
    case "$lang" in
        javascript|typescript)
            grep -E "^import|^const.*=.*require" "$file" 2>/dev/null || true
            ;;
        python)
            grep -E "^import|^from" "$file" 2>/dev/null || true
            ;;
        go)
            grep -E "^import" "$file" 2>/dev/null || true
            ;;
        rust)
            grep -E "^use\s+" "$file" 2>/dev/null || true
            ;;
        *)
            echo ""
            ;;
    esac
}

# 分析文件缩进风格
analyze_indentation() {
    local file="$1"
    local lang=$(get_file_language "$file")
    
    APKS_DEBUG "分析缩进风格: $file"
    
    # 检测缩进类型
    local spaces=$(grep -c "^    " "$file" 2>/dev/null | tr -d '\n' || echo 0)
    local tabs=$(grep -c "^\t" "$file" 2>/dev/null | tr -d '\n' || echo 0)
    
    # 确保是数字
    spaces=${spaces:-0}
    tabs=${tabs:-0}
    
    if [[ "$spaces" -gt "$tabs" ]]; then
        echo "spaces:4"
    elif [[ "$tabs" -gt 0 ]]; then
        echo "tabs"
    else
        # 默认根据语言
        case "$lang" in
            python|rust) echo "spaces:4" ;;
            javascript|typescript) echo "spaces:2" ;;
            go) echo "tabs" ;;
            *) echo "spaces:2" ;;
        esac
    fi
}

# 分析引号风格
analyze_quote_style() {
    local file="$1"
    
    APKS_DEBUG "分析引号风格: $file"
    
    local single=$(grep -o "'[^']*'" "$file" 2>/dev/null | wc -l)
    local double=$(grep -o '"[^"]*"' "$file" 2>/dev/null | wc -l)
    
    if [[ $single -gt $double ]]; then
        echo "single"
    else
        echo "double"
    fi
}

# 分析分号使用
analyze_semicolon() {
    local file="$1"
    local lang=$(get_file_language "$file")
    
    if [[ "$lang" == "javascript" || "$lang" == "typescript" ]]; then
        local with_semi=$(grep -c ";$" "$file" 2>/dev/null || echo 0)
        local total_lines=$(wc -l < "$file")
        
        if [[ $with_semi -gt $((total_lines / 3)) ]]; then
            echo "true"
        else
            echo "false"
        fi
    else
        echo "not_applicable"
    fi
}

# 调整代码缩进
adjust_indentation() {
    local code="$1"
    local indent_style="$2"
    local base_indent="${3:-0}"
    
    APKS_DEBUG "调整缩进: style=$indent_style, base=$base_indent"
    
    local indent_str=""
    if [[ "$indent_style" == "tabs" ]]; then
        indent_str="	"
    else
        local spaces=$(echo "$indent_style" | cut -d: -f2)
        indent_str=$(printf '%*s' "$spaces" '')
    fi
    
    # 应用基础缩进
    local prefix=""
    for ((i=0; i<base_indent; i++)); do
        prefix="${prefix}${indent_str}"
    done
    
    # 处理代码每一行
    echo "$code" | while IFS= read -r line; do
        if [[ -n "$line" ]]; then
            echo "${prefix}${line}"
        else
            echo ""
        fi
    done
}

# 转换导入路径
convert_import_path() {
    local import_path="$1"
    local source_file="$2"
    local target_file="$3"
    local lang=$(get_file_language "$target_file")
    
    APKS_DEBUG "转换导入路径: $import_path"
    APKS_DEBUG "源文件: $source_file -> 目标文件: $target_file"
    
    # 计算相对路径
    local source_dir=$(dirname "$source_file")
    local target_dir=$(dirname "$target_file")
    
    # 如果导入路径是相对路径，需要重新计算
    if [[ "$import_path" == ./* ]] || [[ "$import_path" == ../* ]]; then
        # 获取绝对路径
        local abs_import="$source_dir/$import_path"
        abs_import=$(cd "$(dirname "$abs_import")" && pwd)/$(basename "$abs_import")
        
        # 计算从目标文件到导入文件的相对路径
        local rel_path=$(python3 -c "
import os
source = '$target_dir'
target = '$abs_import'
print(os.path.relpath(target, source))
" 2>/dev/null || echo "$import_path")
        
        # 确保路径格式正确
        if [[ ! "$rel_path" == ./* ]] && [[ ! "$rel_path" == ../* ]]; then
            rel_path="./$rel_path"
        fi
        
        echo "$rel_path"
    else
        # 非相对路径，保持不变
        echo "$import_path"
    fi
}

# 调整代码风格
adjust_code_style() {
    local code="$1"
    local target_file="$2"
    
    local lang=$(get_file_language "$target_file")
    local indent=$(analyze_indentation "$target_file")
    local quote=$(analyze_quote_style "$target_file")
    local semicolon=$(analyze_semicolon "$target_file")
    
    APKS_DEBUG "调整代码风格: lang=$lang, indent=$indent, quote=$quote, semicolon=$semicolon"
    
    # 根据语言调整
    case "$lang" in
        javascript|typescript)
            # 调整引号
            if [[ "$quote" == "single" ]]; then
                code=$(echo "$code" | sed "s/\"\([^\"]*\)\"/'\1'/g")
            fi
            
            # 调整分号
            if [[ "$semicolon" == "false" ]]; then
                code=$(echo "$code" | sed 's/;$//')
            elif [[ "$semicolon" == "true" ]]; then
                # 确保语句以分号结尾
                code=$(echo "$code" | sed 's/[^;]$/&;/')
            fi
            ;;
        python)
            # Python 通常使用单引号
            if [[ "$quote" == "double" ]]; then
                # 保持双引号，Python 两者都支持
                true
            fi
            ;;
    esac
    
    echo "$code"
}

# 在文件中查找最佳插入位置
find_insert_position() {
    local file="$1"
    local code_type="$2"
    local lang=$(get_file_language "$file")
    
    APKS_DEBUG "查找插入位置: type=$code_type, lang=$lang"
    
    local line_num=0
    
    case "$code_type" in
        import)
            # 在现有导入之后插入
            case "$lang" in
                javascript|typescript)
                    line_num=$(grep -n "^import\|^const.*require" "$file" 2>/dev/null | tail -1 | cut -d: -f1)
                    ;;
                python)
                    line_num=$(grep -n "^import\|^from" "$file" 2>/dev/null | tail -1 | cut -d: -f1)
                    ;;
                go)
                    line_num=$(grep -n "^import" "$file" 2>/dev/null | tail -1 | cut -d: -f1)
                    ;;
            esac
            ;;
        function)
            # 在最后一个函数之后插入
            case "$lang" in
                javascript|typescript)
                    line_num=$(grep -n "^function\|^export.*function\|^const.*=" "$file" 2>/dev/null | tail -1 | cut -d: -f1)
                    ;;
                python)
                    line_num=$(grep -n "^def\|^class" "$file" 2>/dev/null | tail -1 | cut -d: -f1)
                    ;;
            esac
            ;;
        *)
            # 默认在文件末尾
            line_num=$(wc -l < "$file")
            ;;
    esac
    
    echo "${line_num:-0}"
}

# 插入代码到文件
insert_code() {
    local target_file="$1"
    local code="$2"
    local position="${3:-end}"
    local dry_run="${4:-false}"
    
    APKS_DEBUG "插入代码到: $target_file (位置: $position, 干运行: $dry_run)"
    
    if [[ ! -f "$target_file" ]]; then
        apks_error "目标文件不存在: $target_file"
        return 1
    fi
    
    # 调整代码风格
    local adjusted_code=$(adjust_code_style "$code" "$target_file")
    
    # 确定插入行号
    local line_num=0
    if [[ "$position" == "end" ]]; then
        line_num=$(wc -l < "$target_file")
    elif [[ "$position" =~ ^[0-9]+$ ]]; then
        line_num=$position
    else
        line_num=$(find_insert_position "$target_file" "$position")
    fi
    
    APKS_DEBUG "插入位置: 第 $line_num 行"
    
    if [[ "$dry_run" == "true" ]]; then
        apks_info "[干运行模式] 将在第 $line_num 行后插入以下代码:"
        echo "---"
        echo "$adjusted_code"
        echo "---"
        return 0
    fi
    
    # 创建临时文件
    local temp_file=$(mktemp)
    
    # 分割文件并插入代码
    head -n "$line_num" "$target_file" > "$temp_file"
    echo "" >> "$temp_file"
    echo "$adjusted_code" >> "$temp_file"
    tail -n +$((line_num + 1)) "$target_file" >> "$temp_file"
    
    # 替换原文件
    mv "$temp_file" "$target_file"
    
    apks_success "代码已插入到 $target_file (第 $line_num 行后)"
}

# 显示帮助信息
show_help() {
    cat << 'HELPTEXT'
使用方法: context-aware-insert.sh [选项] <目标文件> [代码片段]

选项:
  --file, -f <文件>      从文件读取代码片段
  --target, -t <文件>    目标文件 (必需)
  --position, -p <位置>  插入位置 (import|function|end|行号)
  --dry-run, -n          干运行模式，显示但不执行
  --debug, -d            启用调试模式
  --help, -h             显示帮助信息

示例:
  # 从文件插入代码
  ./context-aware-insert.sh -f snippet.ts -t src/app.ts

  # 直接插入代码字符串
  ./context-aware-insert.sh -t src/app.ts "console.log('hello');"

  # 在导入部分插入
  ./context-aware-insert.sh -f utils.ts -t app.ts -p import

  # 干运行模式
  ./context-aware-insert.sh -f snippet.py -t main.py --dry-run

环境变量:
  APKS_PROJECT_ROOT   项目根目录
  DEBUG               启用调试输出
HELPTEXT
}

# 主函数
main() {
    local snippet_file=""
    local target_file=""
    local code=""
    local position="end"
    local dry_run="false"

    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            --file|-f)
                snippet_file="$2"
                shift 2
                ;;
            --target|-t)
                target_file="$2"
                shift 2
                ;;
            --position|-p)
                position="$2"
                shift 2
                ;;
            --dry-run|-n)
                dry_run="true"
                shift
                ;;
            --debug|-d)
                DEBUG=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            -*)
                apks_error "未知选项: $1"
                show_help
                exit 1
                ;;
            *)
                if [[ -z "$code" ]]; then
                    code="$1"
                fi
                shift
                ;;
        esac
    done

    # 验证参数
    if [[ -z "$target_file" ]]; then
        apks_error "请指定目标文件 (--target)"
        show_help
        exit 1
    fi

    # 读取代码片段
    if [[ -n "$snippet_file" ]]; then
        if [[ ! -f "$snippet_file" ]]; then
            apks_error "代码片段文件不存在: $snippet_file"
            exit 1
        fi
        code=$(cat "$snippet_file")
    fi

    if [[ -z "$code" ]]; then
        apks_error "请提供代码片段 (--file 或直接传入)"
        show_help
        exit 1
    fi

    # 显示分析信息
    apks_info "目标文件: $(apks_highlight "$target_file")"
    apks_info "插入位置: $(apks_highlight "$position")"
    apks_info "文件语言: $(apks_highlight "$(get_file_language "$target_file")")"
    
    local indent=$(analyze_indentation "$target_file")
    apks_info "缩进风格: $(apks_highlight "$indent")"
    
    # 执行插入
    insert_code "$target_file" "$code" "$position" "$dry_run"
}

# 执行主函数
main "$@"
