#!/bin/bash
#
# load-project-profile.sh - 项目画像加载器
#
# 功能:
# - 检测当前项目类型
# - 自动加载对应的项目画像
# - 设置环境变量
#
# 使用方法:
#   source load-project-profile.sh [项目路径]
#   或
#   ./load-project-profile.sh --auto
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

# 颜色定义（用于输出）
APKS_COLOR_INFO="\033[36m"    # 青色
APKS_COLOR_SUCCESS="\033[32m" # 绿色
APKS_COLOR_WARN="\033[33m"    # 黄色
APKS_COLOR_ERROR="\033[31m"   # 红色
APKS_COLOR_RESET="\033[0m"

# 项目画像目录
APKS_PROFILES_DIR="${APKS_PROFILES_DIR:-$HOME/.openclaw/workspace/skills/project-kb/profiles}"
APKS_CURRENT_PROFILE=""
APKS_PROJECT_TYPE=""
APKS_PROJECT_ROOT=""

# 打印信息
apks_info() {
    echo -e "${APKS_COLOR_INFO}[APKS INFO]${APKS_COLOR_RESET} $*"
}

apks_success() {
    echo -e "${APKS_COLOR_SUCCESS}[APKS SUCCESS]${APKS_COLOR_RESET} $*"
}

apks_warn() {
    echo -e "${APKS_COLOR_WARN}[APKS WARN]${APKS_COLOR_RESET} $*"
}

apks_error() {
    echo -e "${APKS_COLOR_ERROR}[APKS ERROR]${APKS_COLOR_RESET} $*"
}

# 检测项目类型
# 通过分析项目中的特征文件来判断项目类型
detect_project_type() {
    local project_root="$1"
    local detected_type="unknown"
    local confidence=0

    APKS_DEBUG "检测项目类型: $project_root"

    # 检查各种项目类型的特征文件
    # 优先级从高到低

    # Node.js / TypeScript 项目
    if [[ -f "$project_root/package.json" ]]; then
        detected_type="nodejs"
        confidence=100
        APKS_DEBUG "发现 package.json，判断为 Node.js 项目"

        # 进一步判断子类型
        if [[ -f "$project_root/next.config.js" ]] || [[ -f "$project_root/next.config.ts" ]] || [[ -f "$project_root/next.config.mjs" ]]; then
            detected_type="nextjs"
            APKS_DEBUG "发现 Next.js 配置文件"
        elif [[ -f "$project_root/nuxt.config.js" ]] || [[ -f "$project_root/nuxt.config.ts" ]]; then
            detected_type="nuxtjs"
            APKS_DEBUG "发现 Nuxt.js 配置文件"
        elif [[ -f "$project_root/vue.config.js" ]] || [[ -f "$project_root/vite.config.ts" ]]; then
            if grep -q '"vue"' "$project_root/package.json" 2>/dev/null; then
                detected_type="vue"
                APKS_DEBUG "发现 Vue 项目配置"
            fi
        elif [[ -f "$project_root/angular.json" ]]; then
            detected_type="angular"
            APKS_DEBUG "发现 Angular 配置文件"
        elif [[ -f "$project_root/svelte.config.js" ]]; then
            detected_type="svelte"
            APKS_DEBUG "发现 Svelte 配置文件"
        elif grep -q '"react"' "$project_root/package.json" 2>/dev/null; then
            detected_type="react"
            APKS_DEBUG "发现 React 依赖"
        fi

        # 检查是否为 Express/Fastify 等后端框架
        if grep -q '"express"' "$project_root/package.json" 2>/dev/null; then
            detected_type="express"
            APKS_DEBUG "发现 Express 依赖"
        elif grep -q '"fastify"' "$project_root/package.json" 2>/dev/null; then
            detected_type="fastify"
            APKS_DEBUG "发现 Fastify 依赖"
        elif grep -q '"nestjs"' "$project_root/package.json" 2>/dev/null; then
            detected_type="nestjs"
            APKS_DEBUG "发现 NestJS 依赖"
        fi
    fi

    # Python 项目
    if [[ -f "$project_root/requirements.txt" ]] || [[ -f "$project_root/pyproject.toml" ]] || [[ -f "$project_root/setup.py" ]] || [[ -f "$project_root/Pipfile" ]]; then
        if [[ $confidence -lt 90 ]]; then
            detected_type="python"
            confidence=90
            APKS_DEBUG "发现 Python 项目特征文件"

            # 检查 Python 框架
            if [[ -f "$project_root/manage.py" ]] && grep -q "django" "$project_root/requirements.txt" 2>/dev/null; then
                detected_type="django"
                APKS_DEBUG "发现 Django 项目"
            elif [[ -f "$project_root/app.py" ]] || [[ -d "$project_root/flask" ]]; then
                if grep -q "flask" "$project_root/requirements.txt" 2>/dev/null; then
                    detected_type="flask"
                    APKS_DEBUG "发现 Flask 项目"
                fi
            elif [[ -f "$project_root/fastapi" ]] || grep -q "fastapi" "$project_root/requirements.txt" 2>/dev/null; then
                detected_type="fastapi"
                APKS_DEBUG "发现 FastAPI 项目"
            fi
        fi
    fi

    # Go 项目
    if [[ -f "$project_root/go.mod" ]]; then
        if [[ $confidence -lt 80 ]]; then
            detected_type="go"
            confidence=80
            APKS_DEBUG "发现 go.mod，判断为 Go 项目"
        fi
    fi

    # Rust 项目
    if [[ -f "$project_root/Cargo.toml" ]]; then
        if [[ $confidence -lt 80 ]]; then
            detected_type="rust"
            confidence=80
            APKS_DEBUG "发现 Cargo.toml，判断为 Rust 项目"
        fi
    fi

    # Java 项目
    if [[ -f "$project_root/pom.xml" ]] || [[ -f "$project_root/build.gradle" ]]; then
        if [[ $confidence -lt 80 ]]; then
            detected_type="java"
            confidence=80
            APKS_DEBUG "发现 Maven/Gradle 配置，判断为 Java 项目"

            if [[ -f "$project_root/build.gradle" ]] && grep -q "spring" "$project_root/build.gradle" 2>/dev/null; then
                detected_type="spring"
                APKS_DEBUG "发现 Spring Boot 项目"
            fi
        fi
    fi

    # Docker 项目
    if [[ -f "$project_root/Dockerfile" ]] || [[ -f "$project_root/docker-compose.yml" ]] || [[ -f "$project_root/docker-compose.yaml" ]]; then
        if [[ $confidence -lt 50 ]]; then
            detected_type="docker"
            confidence=50
            APKS_DEBUG "发现 Docker 配置文件"
        fi
    fi

    # 静态网站 / Jekyll / Hugo
    if [[ -f "$project_root/_config.yml" ]]; then
        if [[ $confidence -lt 70 ]]; then
            detected_type="jekyll"
            confidence=70
            APKS_DEBUG "发现 Jekyll 配置文件"
        fi
    fi

    if [[ -f "$project_root/config.toml" ]] && [[ -d "$project_root/content" ]]; then
        if [[ $confidence -lt 70 ]]; then
            detected_type="hugo"
            confidence=70
            APKS_DEBUG "发现 Hugo 项目特征"
        fi
    fi

    echo "$detected_type"
}

# 查找项目根目录
# 从当前目录向上查找，直到找到项目特征文件
find_project_root() {
    local start_dir="${1:-$(pwd)}"
    local current_dir="$start_dir"

    APKS_DEBUG "查找项目根目录，起始: $start_dir"

    while [[ "$current_dir" != "/" ]]; do
        # 检查项目特征文件
        if [[ -f "$current_dir/package.json" ]] || \
           [[ -f "$current_dir/requirements.txt" ]] || \
           [[ -f "$current_dir/pyproject.toml" ]] || \
           [[ -f "$current_dir/go.mod" ]] || \
           [[ -f "$current_dir/Cargo.toml" ]] || \
           [[ -f "$current_dir/pom.xml" ]] || \
           [[ -f "$current_dir/build.gradle" ]] || \
           [[ -f "$current_dir/.git" ]]; then
            APKS_DEBUG "找到项目根目录: $current_dir"
            echo "$current_dir"
            return 0
        fi

        # 向上移动一级
        current_dir="$(dirname "$current_dir")"
    done

    # 如果没找到，返回当前目录
    APKS_DEBUG "未找到项目根目录，返回起始目录"
    echo "$start_dir"
}

# 加载项目画像
load_profile() {
    local project_type="$1"
    local profile_file="$APKS_PROFILES_DIR/${project_type}.json"

    APKS_DEBUG "尝试加载画像: $profile_file"

    if [[ ! -f "$profile_file" ]]; then
        apks_warn "未找到项目画像: $profile_file"
        apks_info "使用默认画像..."
        profile_file="$APKS_PROFILES_DIR/default.json"

        if [[ ! -f "$profile_file" ]]; then
            apks_error "默认画像也不存在"
            return 1
        fi
    fi

    # 读取并解析画像
    if command -v jq &> /dev/null; then
        APKS_CURRENT_PROFILE=$(cat "$profile_file")
        apks_success "成功加载项目画像: $project_type"

        # 设置环境变量
        export APKS_PROJECT_TYPE="$project_type"
        export APKS_PROFILE_PATH="$profile_file"
        export APKS_PROFILE_LOADED="true"

        # 从画像中提取关键信息设置环境变量
        local project_name=$(echo "$APKS_CURRENT_PROFILE" | jq -r '.name // "unknown"')
        local language=$(echo "$APKS_CURRENT_PROFILE" | jq -r '.language // "unknown"')
        local framework=$(echo "$APKS_CURRENT_PROFILE" | jq -r '.framework // "none"')

        export APKS_PROJECT_NAME="$project_name"
        export APKS_PROJECT_LANGUAGE="$language"
        export APKS_PROJECT_FRAMEWORK="$framework"

        APKS_DEBUG "项目名: $project_name, 语言: $language, 框架: $framework"

        return 0
    else
        apks_error "需要 jq 工具来解析 JSON 画像"
        apks_info "请安装 jq: apt-get install jq 或 brew install jq"
        return 1
    fi
}

# 显示项目信息
show_project_info() {
    if [[ "$APKS_PROFILE_LOADED" != "true" ]]; then
        apks_warn "尚未加载项目画像"
        return 1
    fi

    echo ""
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║              APKS 项目画像加载成功                     ║"
    echo "╠════════════════════════════════════════════════════════╣"
    printf "║ 项目类型: %-45s ║\n" "$APKS_PROJECT_TYPE"
    printf "║ 项目名称: %-45s ║\n" "$APKS_PROJECT_NAME"
    printf "║ 编程语言: %-45s ║\n" "$APKS_PROJECT_LANGUAGE"
    printf "║ 主要框架: %-45s ║\n" "$APKS_PROJECT_FRAMEWORK"
    printf "║ 项目根目录: %-43s ║\n" "$APKS_PROJECT_ROOT"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
}

# 主函数
main() {
    local project_path=""
    local auto_mode=false

    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            --auto|-a)
                auto_mode=true
                shift
                ;;
            --debug|-d)
                DEBUG=true
                shift
                ;;
            --help|-h)
                echo "使用方法: source load-project-profile.sh [选项] [项目路径]"
                echo ""
                echo "选项:"
                echo "  --auto, -a      自动检测当前目录项目"
                echo "  --debug, -d     启用调试模式"
                echo "  --help, -h      显示帮助信息"
                echo ""
                echo "示例:"
                echo "  source load-project-profile.sh"
                echo "  source load-project-profile.sh /path/to/project"
                echo "  source load-project-profile.sh --auto"
                return 0
                ;;
            -*)
                apks_error "未知选项: $1"
                return 1
                ;;
            *)
                project_path="$1"
                shift
                ;;
        esac
    done

    # 确定项目路径
    if [[ -z "$project_path" ]]; then
        project_path=$(pwd)
    fi

    # 转换为绝对路径
    project_path="$(cd "$project_path" && pwd)"

    apks_info "正在分析项目: $project_path"

    # 查找项目根目录
    APKS_PROJECT_ROOT=$(find_project_root "$project_path")
    export APKS_PROJECT_ROOT

    # 检测项目类型
    APKS_PROJECT_TYPE=$(detect_project_type "$APKS_PROJECT_ROOT")
    export APKS_PROJECT_TYPE

    apks_info "检测到项目类型: $APKS_PROJECT_TYPE"

    # 加载对应画像
    if load_profile "$APKS_PROJECT_TYPE"; then
        show_project_info

        # 如果指定了自动模式，输出环境变量供其他脚本使用
        if [[ "$auto_mode" == true ]]; then
            echo "export APKS_PROJECT_TYPE=$APKS_PROJECT_TYPE"
            echo "export APKS_PROJECT_ROOT=$APKS_PROJECT_ROOT"
            echo "export APKS_PROFILE_LOADED=true"
        fi

        return 0
    else
        apks_error "加载项目画像失败"
        return 1
    fi
}

# 如果直接执行（非 source），运行主函数
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
