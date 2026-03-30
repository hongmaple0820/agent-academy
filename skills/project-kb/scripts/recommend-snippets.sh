#!/bin/bash
#
# recommend-snippets.sh - 智能代码片段推荐系统
#
# 功能:
# - 根据当前任务类型推荐代码片段
# - 根据文件类型推荐相关代码
# - 显示推荐理由
#
# 使用方法:
#   ./recommend-snippets.sh [任务类型] [文件路径]
#   ./recommend-snippets.sh --context [文件路径]
#   ./recommend-snippets.sh --task "创建 API 端点"
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

# 代码片段库目录
APKS_SNIPPETS_DIR="${APKS_SNIPPETS_DIR:-$HOME/.openclaw/workspace/skills/project-kb/snippets}"
APKS_PROFILES_DIR="${APKS_PROFILES_DIR:-$HOME/.openclaw/workspace/skills/project-kb/profiles}"

# 输出函数
apks_info() { echo -e "${APKS_COLOR_INFO}[APKS INFO]${APKS_COLOR_RESET} $*"; }
apks_success() { echo -e "${APKS_COLOR_SUCCESS}[APKS SUCCESS]${APKS_COLOR_RESET} $*"; }
apks_warn() { echo -e "${APKS_COLOR_WARN}[APKS WARN]${APKS_COLOR_RESET} $*"; }
apks_error() { echo -e "${APKS_COLOR_ERROR}[APKS ERROR]${APKS_COLOR_RESET} $*"; }
apks_highlight() { echo -e "${APKS_COLOR_HIGHLIGHT}$*${APKS_COLOR_RESET}"; }

# 任务类型到代码片段类别的映射
get_task_category() {
    local task="$1"
    local task_lower=$(echo "$task" | tr '[:upper:]' '[:lower:]')
    APKS_DEBUG "分析任务类型: $task"

    if [[ "$task_lower" == *"api"* ]] || [[ "$task_lower" == *"接口"* ]] || [[ "$task_lower" == *"endpoint"* ]]; then echo "api"; return; fi
    if [[ "$task_lower" == *"数据库"* ]] || [[ "$task_lower" == *"db"* ]] || [[ "$task_lower" == *"sql"* ]]; then echo "database"; return; fi
    if [[ "$task_lower" == *"认证"* ]] || [[ "$task_lower" == *"授权"* ]] || [[ "$task_lower" == *"auth"* ]] || [[ "$task_lower" == *"jwt"* ]]; then echo "auth"; return; fi
    if [[ "$task_lower" == *"错误"* ]] || [[ "$task_lower" == *"异常"* ]] || [[ "$task_lower" == *"error"* ]]; then echo "error-handling"; return; fi
    if [[ "$task_lower" == *"日志"* ]] || [[ "$task_lower" == *"log"* ]]; then echo "logging"; return; fi
    if [[ "$task_lower" == *"测试"* ]] || [[ "$task_lower" == *"test"* ]]; then echo "testing"; return; fi
    if [[ "$task_lower" == *"配置"* ]] || [[ "$task_lower" == *"config"* ]]; then echo "config"; return; fi
    if [[ "$task_lower" == *"工具"* ]] || [[ "$task_lower" == *"util"* ]]; then echo "utils"; return; fi
    echo "general"
}

# 根据文件扩展名获取语言类型
get_language_from_file() {
    local file="$1"
    local ext="${file##*.}"
    APKS_DEBUG "从文件扩展名获取语言: .$ext"
    case "$ext" in
        js|jsx) echo "javascript" ;;
        ts|tsx) echo "typescript" ;;
        py) echo "python" ;;
        go) echo "go" ;;
        rs) echo "rust" ;;
        java) echo "java" ;;
        rb) echo "ruby" ;;
        php) echo "php" ;;
        cs) echo "csharp" ;;
        swift) echo "swift" ;;
        kt|kts) echo "kotlin" ;;
        sh|bash) echo "bash" ;;
        json) echo "json" ;;
        yml|yaml) echo "yaml" ;;
        md|markdown) echo "markdown" ;;
        css|scss|sass|less) echo "css" ;;
        html|htm) echo "html" ;;
        sql) echo "sql" ;;
        *) echo "unknown" ;;
    esac
}

# 获取项目类型
get_project_type() {
    if [[ -n "$APKS_PROJECT_TYPE" ]]; then echo "$APKS_PROJECT_TYPE"; return; fi
    local project_root="${APKS_PROJECT_ROOT:-$(pwd)}"
    if [[ -f "$project_root/package.json" ]]; then echo "nodejs"
    elif [[ -f "$project_root/requirements.txt" ]] || [[ -f "$project_root/pyproject.toml" ]]; then echo "python"
    elif [[ -f "$project_root/go.mod" ]]; then echo "go"
    elif [[ -f "$project_root/Cargo.toml" ]]; then echo "rust"
    elif [[ -f "$project_root/pom.xml" ]] || [[ -f "$project_root/build.gradle" ]]; then echo "java"
    else echo "unknown"; fi
}

# 获取代码片段文件路径
get_snippet_file() {
    local project_type="$1"
    local category="$2"
    local language="$3"
    local snippet_file="$APKS_SNIPPETS_DIR/${project_type}/${category}.${language}.md"
    if [[ ! -f "$snippet_file" ]]; then snippet_file="$APKS_SNIPPETS_DIR/${project_type}/${category}.md"; fi
    if [[ ! -f "$snippet_file" ]]; then snippet_file="$APKS_SNIPPETS_DIR/default/${category}.${language}.md"; fi
    if [[ ! -f "$snippet_file" ]]; then snippet_file="$APKS_SNIPPETS_DIR/default/${category}.md"; fi
    echo "$snippet_file"
}

# 显示代码片段
show_snippet() {
    local snippet_file="$1"
    local max_lines=${2:-50}
    if [[ ! -f "$snippet_file" ]]; then apks_warn "代码片段文件不存在: $snippet_file"; return 1; fi
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    local line_count=0
    while IFS= read -r line && [[ $line_count -lt $max_lines ]]; do
        echo "$line"
        ((line_count++))
    done < "$snippet_file"
    if [[ $line_count -ge $max_lines ]]; then echo "... (内容已截断)"; fi
    echo "═══════════════════════════════════════════════════════════"
    echo ""
}

# 推荐代码片段
recommend_snippets() {
    local task="$1"
    local file_path="$2"
    local project_type=$(get_project_type)
    local category=$(get_task_category "$task")
    local language="unknown"
    
    if [[ -n "$file_path" ]]; then
        language=$(get_language_from_file "$file_path")
    fi
    
    apks_info "任务类型: $(apks_highlight "$task")"
    apks_info "项目类型: $(apks_highlight "$project_type")"
    apks_info "代码类别: $(apks_highlight "$category")"
    if [[ "$language" != "unknown" ]]; then
        apks_info "编程语言: $(apks_highlight "$language")"
    fi
    
    # 获取代码片段文件
    local snippet_file=$(get_snippet_file "$project_type" "$category" "$language")
    
    if [[ -f "$snippet_file" ]]; then
        apks_success "找到匹配的代码片段:"
        show_snippet "$snippet_file"
        
        # 显示推荐理由
        echo ""
        echo "推荐理由:"
        echo "  1. 基于项目类型 '$project_type' 筛选"
        echo "  2. 基于任务类别 '$category' 匹配"
        [[ "$language" != "unknown" ]] && echo "  3. 基于编程语言 '$language' 定制"
        echo ""
    else
        apks_warn "未找到匹配的代码片段"
        apks_info "建议:"
        echo "  - 检查 snippets 目录是否存在: $APKS_SNIPPETS_DIR"
        echo "  - 创建默认代码片段: $APKS_SNIPPETS_DIR/default/$category.md"
        echo "  - 或使用 --init 初始化示例代码片段库"
    fi
}

# 显示帮助信息
show_help() {
    cat << 'HELPTEXT'
使用方法: recommend-snippets.sh [选项] [参数]

选项:
  --task, -t <描述>     根据任务描述推荐代码片段
  --context, -c <文件>   根据文件上下文推荐相关代码
  --list, -l            列出所有可用的代码片段类别
  --init                初始化示例代码片段库
  --debug, -d           启用调试模式
  --help, -h            显示帮助信息

示例:
  # 根据任务推荐
  ./recommend-snippets.sh --task "创建 API 端点"
  ./recommend-snippets.sh -t "数据库查询"

  # 根据文件上下文推荐
  ./recommend-snippets.sh --context src/app.ts
  ./recommend-snippets.sh -c main.py

  # 列出可用类别
  ./recommend-snippets.sh --list

环境变量:
  APKS_SNIPPETS_DIR     代码片段库目录
  APKS_PROJECT_TYPE     项目类型
  DEBUG                 启用调试输出
HELPTEXT
}

# 列出可用类别
list_categories() {
    apks_info "可用的代码片段类别:"
    echo ""
    echo "通用类别:"
    echo "  - api           API 开发相关"
    echo "  - database      数据库操作"
    echo "  - auth          认证授权"
    echo "  - error-handling 错误处理"
    echo "  - logging       日志记录"
    echo "  - testing       测试代码"
    echo "  - config        配置文件"
    echo "  - utils         工具函数"
    echo "  - general       通用代码"
    echo ""
    
    if [[ -d "$APKS_SNIPPETS_DIR" ]]; then
        apks_info "已安装的代码片段:"
        find "$APKS_SNIPPETS_DIR" -name "*.md" -type f 2>/dev/null | while read -r file; do
            local rel_path="${file#$APKS_SNIPPETS_DIR/}"
            echo "  - $rel_path"
        done
    fi
}

# 初始化示例代码片段库
init_snippets() {
    apks_info "初始化代码片段库..."
    
    mkdir -p "$APKS_SNIPPETS_DIR/default"
    mkdir -p "$APKS_SNIPPETS_DIR/nodejs"
    mkdir -p "$APKS_SNIPPETS_DIR/python"
    
    # 创建示例 API 代码片段
    cat > "$APKS_SNIPPETS_DIR/default/api.md" << 'SNIPPET'
## API 端点模板

### Express.js
```javascript
app.get('/api/resource', async (req, res) => {
  try {
    const data = await getResource();
    res.json({ success: true, data });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});
```

### FastAPI
```python
@app.get("/api/resource")
async def get_resource():
    try:
        data = await get_resource()
        return {"success": True, "data": data}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
```
SNIPPET

    # 创建示例错误处理代码片段
    cat > "$APKS_SNIPPETS_DIR/default/error-handling.md" << 'SNIPPET'
## 错误处理模板

### JavaScript/TypeScript
```javascript
class AppError extends Error {
  constructor(message, statusCode) {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = true;
    Error.captureStackTrace(this, this.constructor);
  }
}

const asyncHandler = (fn) => (req, res, next) => {
  Promise.resolve(fn(req, res, next)).catch(next);
};
```

### Python
```python
class AppError(Exception):
    def __init__(self, message, status_code=500):
        super().__init__(message)
        self.status_code = status_code
        self.is_operational = True

def async_handler(func):
    async def wrapper(*args, **kwargs):
        try:
            return await func(*args, **kwargs)
        except Exception as e:
            # 处理错误
            raise
    return wrapper
```
SNIPPET

    apks_success "代码片段库初始化完成!"
    apks_info "位置: $APKS_SNIPPETS_DIR"
}

# 主函数
main() {
    local task=""
    local file_path=""
    local context_mode=false
    local list_mode=false
    local init_mode=false

    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            --task|-t)
                task="$2"
                shift 2
                ;;
            --context|-c)
                file_path="$2"
                context_mode=true
                shift 2
                ;;
            --list|-l)
                list_mode=true
                shift
                ;;
            --init)
                init_mode=true
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
                if [[ -z "$task" ]]; then
                    task="$1"
                elif [[ -z "$file_path" ]]; then
                    file_path="$1"
                fi
                shift
                ;;
        esac
    done

    # 执行对应操作
    if [[ "$list_mode" == true ]]; then
        list_categories
    elif [[ "$init_mode" == true ]]; then
        init_snippets
    elif [[ "$context_mode" == true ]]; then
        if [[ -z "$file_path" ]]; then
            apks_error "请提供文件路径"
            exit 1
        fi
        recommend_snippets "context-analysis" "$file_path"
    elif [[ -n "$task" ]]; then
        recommend_snippets "$task" "$file_path"
    else
        apks_info "请提供任务描述或使用 --help 查看帮助"
        show_help
    fi
}

# 执行主函数
main "$@"