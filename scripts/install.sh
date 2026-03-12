#!/bin/bash

# Agent Academy 安装脚本
# 用途：自动安装技能库到 AI Agent 环境
# 使用：curl -fsSL https://gitee.com/hongmaple/agent-academy/raw/master/scripts/install.sh | bash

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印函数
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# 版本信息
VERSION="1.0.0"
REPO_URL="https://gitee.com/hongmaple/agent-academy.git"
TEMP_DIR="/tmp/agent-academy-$$"

echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║       🎓 Agent Academy - AI Agent 训练学院               ║"
echo "║              自动安装脚本 v${VERSION}                        ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# 检查依赖
check_dependencies() {
    info "检查依赖..."
    
    if ! command -v git &> /dev/null; then
        error "未找到 git，请先安装 git"
    fi
    
    success "依赖检查通过"
}

# 确定安装目录
detect_install_dir() {
    info "检测安装目录..."
    
    # 优先级：自定义 > 环境变量 > 默认位置
    if [ -n "$AGENT_ACADEMY_DIR" ]; then
        INSTALL_DIR="$AGENT_ACADEMY_DIR"
    elif [ -n "$HOME" ]; then
        # 常见的 Agent 配置目录
        if [ -d "$HOME/.agents" ]; then
            INSTALL_DIR="$HOME/.agents"
        elif [ -d "$HOME/.config/agents" ]; then
            INSTALL_DIR="$HOME/.config/agents"
        elif [ -d "$HOME/.claude" ]; then
            INSTALL_DIR="$HOME/.claude"
        elif [ -d "$HOME/.cursor" ]; then
            INSTALL_DIR="$HOME/.cursor"
        else
            INSTALL_DIR="$HOME/.agents"
        fi
    else
        INSTALL_DIR="/opt/agent-academy"
    fi
    
    info "安装目录: $INSTALL_DIR"
}

# 克隆仓库
clone_repo() {
    info "克隆 Agent Academy 仓库..."
    
    if [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
    
    git clone --depth 1 "$REPO_URL" "$TEMP_DIR" || error "克隆失败"
    
    success "仓库克隆完成"
}

# 安装技能
install_skills() {
    info "安装技能库..."
    
    # 创建目标目录
    mkdir -p "$INSTALL_DIR/skills"
    
    # 复制技能
    cp -r "$TEMP_DIR/skills/"* "$INSTALL_DIR/skills/" || error "技能复制失败"
    
    # 统计
    SKILL_COUNT=$(find "$INSTALL_DIR/skills" -name "SKILL.md" | wc -l)
    
    success "已安装 $SKILL_COUNT 个技能"
}

# 安装知识库
install_knowledge() {
    info "安装知识库..."
    
    mkdir -p "$INSTALL_DIR/knowledge"
    
    if [ -d "$TEMP_DIR/knowledge" ]; then
        cp -r "$TEMP_DIR/knowledge/"* "$INSTALL_DIR/knowledge/" || warn "知识库复制部分失败"
        success "知识库安装完成"
    else
        warn "未找到知识库目录"
    fi
}

# 安装模板
install_templates() {
    info "安装模板文件..."
    
    mkdir -p "$INSTALL_DIR/templates"
    
    if [ -d "$TEMP_DIR/templates" ]; then
        cp -r "$TEMP_DIR/templates/"* "$INSTALL_DIR/templates/" 2>/dev/null || true
        success "模板安装完成"
    fi
}

# 安装脚本
install_scripts() {
    info "安装自动化脚本..."
    
    mkdir -p "$INSTALL_DIR/scripts"
    
    if [ -d "$TEMP_DIR/scripts" ]; then
        cp -r "$TEMP_DIR/scripts/"*.py "$INSTALL_DIR/scripts/" 2>/dev/null || true
        cp -r "$TEMP_DIR/scripts/"*.sh "$INSTALL_DIR/scripts/" 2>/dev/null || true
        success "脚本安装完成"
    fi
}

# 创建配置文件
create_config() {
    info "创建配置文件..."
    
    cat > "$INSTALL_DIR/AGENTS.md" << 'EOF'
# Agent Academy 配置

## 技能目录
技能库位于 `skills/` 目录，共 12 个分类：

- `pm-product/` - 产品与项目管理
- `development/` - 开发与编程
- `design/` - 设计与界面
- `documentation/` - 文档与写作
- `data-analysis/` - 数据分析
- `tool-development/` - 工具开发
- `web-api/` - Web/API 开发
- `security-testing/` - 安全与测试
- `ai-ml/` - AI/机器学习
- `frameworks/` - 框架与库
- `integrations/` - 集成服务
- `others/` - 其他技能

## MCP 知识库
MCP 知识位于 `knowledge/mcp/` 目录：

- `mcp-quick-start.md` - 快速入门
- `mcp-best-practices.md` - 最佳实践
- `mcp-tools-configuration.md` - 工具配置

## 更新
运行以下命令更新技能库：
```bash
curl -fsSL https://gitee.com/hongmaple/agent-academy/raw/master/scripts/install.sh | bash
```
EOF
    
    success "配置文件创建完成"
}

# 清理
cleanup() {
    info "清理临时文件..."
    rm -rf "$TEMP_DIR"
}

# 显示结果
show_result() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                  ✅ 安装完成！                           ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""
    echo "📂 安装目录: $INSTALL_DIR"
    echo ""
    echo "📊 安装内容:"
    echo "   ├── skills/        # 技能库"
    echo "   ├── knowledge/     # 知识库"
    echo "   ├── templates/     # 模板文件"
    echo "   ├── scripts/       # 自动化脚本"
    echo "   └── AGENTS.md      # 配置文件"
    echo ""
    echo "🚀 快速开始:"
    echo "   1. 查看技能索引: cat $INSTALL_DIR/skills/README.md"
    echo "   2. 学习 MCP: cat $INSTALL_DIR/knowledge/mcp/mcp-quick-start.md"
    echo "   3. 配置 Agent: 编辑 $INSTALL_DIR/AGENTS.md"
    echo ""
    echo "📚 文档: https://gitee.com/hongmaple/agent-academy"
    echo ""
}

# 主流程
main() {
    check_dependencies
    detect_install_dir
    clone_repo
    install_skills
    install_knowledge
    install_templates
    install_scripts
    create_config
    cleanup
    show_result
}

# 执行安装
main "$@"
