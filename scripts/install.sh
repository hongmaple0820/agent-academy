#!/bin/bash
# ==============================================
# OpenClaw 公开安装脚本 v3.1 (开源版)
# 
# 适用：外部用户、新用户
# 特点：只使用开源知识库 agent-academy，不含私密信息
#
# 项目地址：
#   - Gitee: https://gitee.com/hongmaple/agent-academy
#   - GitHub: https://github.com/hongmaple0820/agent-academy
#   - GitCode: https://gitcode.com/maple168/agent-academy
#
# 作者：maple (hongmaple)
# 团队：枫林 AI 协作团队
# 
# 更新时间：2026-03-14
# ==============================================

set -e

# --- 颜色定义 ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# --- 配置 ---
VERSION="3.1.0"
SCRIPT_URL="https://gitee.com/hongmaple/agent-academy/raw/master/scripts/install.sh"

# 开源知识库地址 - Agent Academy
PUBLIC_KB_REPO="https://gitee.com/hongmaple/agent-academy.git"
PUBLIC_KB_BRANCH="master"
PUBLIC_KB_NAME="agent-academy"

# --- 打印横幅 ---
print_banner() {
    echo -e "${BLUE}=============================================="
    echo -e "🎓 OpenClaw 安装脚本 v${VERSION} (开源版)"
    echo -e "   搭配 Agent Academy 知识库"
    echo -e "==============================================${NC}"
    echo -e "📦 项目: ${GREEN}Agent Academy${NC} - AI Agent 训练学院"
    echo -e "👨‍💻 作者: ${YELLOW}maple (hongmaple)${NC}"
    echo -e "🏠 主页: https://gitee.com/hongmaple/agent-academy"
    echo -e "🤝 团队: 枫林 AI 协作团队"
    echo -e "📅 更新时间: 2026-03-14"
    echo ""
    echo -e "${GREEN}✨ 特性:${NC}"
    echo -e "   📦 800+ 精选技能"
    echo -e "   📚 MCP 知识体系"
    echo -e "   🧠 记忆系统方案"
    echo -e "   👥 多 Agent 协作"
    echo -e "   🌐 浏览器自动化"
    echo ""
}

# --- 辅助函数 ---
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_ok() { echo -e "${GREEN}[✓]${NC} $1"; }
log_step() { echo -e "${BLUE}>>>${NC} $1"; }

# 统计
SUCCESS=0; WARNINGS=0; SKIPPED=0

# ==============================================
# 阶段 1: 彻底卸载旧版 Node.js
# ==============================================
uninstall_old_node() {
    log_step "阶段 1/8: 检查并清理 Node.js 环境"
    
    if command -v node &> /dev/null; then
        OLD_VER=$(node -v 2>/dev/null || echo "unknown")
        log_info "检测到当前 Node.js: $OLD_VER"
        
        # 检查是否需要升级到 Node.js 24
        MAJOR_VER=$(echo "$OLD_VER" | sed 's/v//; s/\..*//' 2>/dev/null || echo "0")
        
        if [ "$MAJOR_VER" -ge 22 ]; then
            log_ok "Node.js 版本满足要求 (>= 22)，跳过重装"
            return 0
        fi
        
        log_info "Node.js 版本过低，准备升级..."
        
        # 卸载 apt 安装的 nodejs
        sudo apt-get remove --purge -y nodejs npm 2>/dev/null || true
        sudo apt-get autoremove -y 2>/dev/null || true
        sudo apt-get autoclean -y 2>/dev/null || true
        
        # 清理残留
        sudo rm -rf /usr/local/lib/node_modules 2>/dev/null || true
        sudo rm -rf /usr/lib/node_modules 2>/dev/null || true
        
        # 清理 npm 缓存
        npm cache clean --force 2>/dev/null || true
        rm -rf ~/.npm 2>/dev/null || true
        
        log_ok "旧版 Node.js 已清理"
    else
        log_info "未检测到 Node.js，将进行全新安装"
    fi
    echo ""
}

# ==============================================
# 阶段 2: 网络检测与源选择
# ==============================================
NODE_SOURCE_URL=""
NPM_REGISTRY="https://registry.npmmirror.com"

check_network() {
    log_step "阶段 2/8: 检测网络连接"
    
    if timeout 5 curl -s --head https://deb.nodesource.com &>/dev/null; then
        NODE_SOURCE_URL="https://deb.nodesource.com/setup_24.x"
        log_ok "使用官方 NodeSource 源 (Node.js 24)"
    else
        NODE_SOURCE_URL="https://mirrors.tuna.tsinghua.edu.cn/nodesource/deb/setup_24.x"
        log_warn "官方源超时，切换至 [清华大学镜像源]"
    fi
    echo ""
}

# ==============================================
# 阶段 3: 安装 Node.js 24 LTS
# ==============================================
install_node24() {
    log_step "阶段 3/8: 安装 Node.js 24 LTS"
    
    if command -v node &> /dev/null; then
        CURRENT_VER=$(node -v 2>/dev/null)
        MAJOR_VER=$(echo "$CURRENT_VER" | sed 's/v//; s/\..*//' 2>/dev/null || echo "0")
        
        if [ "$MAJOR_VER" -ge 22 ]; then
            log_ok "Node.js $CURRENT_VER 已满足要求，跳过安装"
            npm config set registry "$NPM_REGISTRY" 2>/dev/null || true
            echo ""
            return 0
        fi
    fi
    
    log_info "添加 NodeSource 源..."
    if curl -fsSL "$NODE_SOURCE_URL" | sudo -E bash -; then
        log_ok "NodeSource 源添加成功"
    else
        log_error "NodeSource 源添加失败"
        return 1
    fi
    
    log_info "安装 Node.js..."
    if sudo apt-get install -y nodejs; then
        log_ok "Node.js 安装成功"
        node -v
        npm -v
    else
        log_error "Node.js 安装失败"
        return 1
    fi
    
    # 配置 npm 镜像
    log_info "配置 npm 淘宝镜像..."
    npm config set registry "$NPM_REGISTRY"
    log_ok "npm 镜像已设置为: $(npm config get registry)"
    echo ""
}

# ==============================================
# 阶段 4: 安装系统依赖
# ==============================================
install_dependencies() {
    log_step "阶段 4/8: 安装系统依赖"
    
    # Git
    if ! command -v git &> /dev/null; then
        log_info "安装 Git..."
        sudo apt-get install -y git && log_ok "Git ✓" || log_warn "Git 安装失败"
    else
        log_ok "Git 已存在 ✓"
    fi
    
    # Python (用于搜索工具)
    if ! command -v python3 &> /dev/null; then
        log_info "安装 Python3..."
        sudo apt-get install -y python3 python3-pip && log_ok "Python3 ✓" || log_warn "Python3 安装失败"
    else
        log_ok "Python3 已存在 ✓"
    fi
    
    echo ""
}

# ==============================================
# 阶段 5: 安装 OpenClaw 核心
# ==============================================
install_openclaw() {
    log_step "阶段 5/8: 安装 OpenClaw 核心"
    
    log_info "更新 npm..."
    sudo npm install -g npm@latest 2>/dev/null || true
    
    if ! command -v openclaw &> /dev/null; then
        log_info "安装 OpenClaw (这可能需要几分钟)..."
        if sudo npm install -g openclaw; then
            log_ok "OpenClaw 安装成功"
        else
            log_error "OpenClaw 安装失败"
            log_warn "请检查上方错误信息"
            return 1
        fi
    else
        log_ok "OpenClaw 已存在 ✓"
    fi
    
    OPENCLAW_VER=$(openclaw --version 2>/dev/null || echo "installed")
    log_ok "OpenClaw 版本: $OPENCLAW_VER"
    echo ""
}

# ==============================================
# 阶段 6: 创建配置模板
# ==============================================
create_configs() {
    log_step "阶段 6/8: 创建配置模板"
    
    mkdir -p ~/.openclaw/workspace/{memory,skills,knowledge,templates}
    mkdir -p ~/.openclaw/logs
    
    safe_create() {
        local file=$1
        local content=$2
        if [ ! -f "$file" ]; then
            echo -e "$content" > "$file"
            log_ok "创建: $file"
        else
            echo -e "${BLUE}[-]${NC} 已存在: $file"
        fi
    }
    
    safe_create ~/.openclaw/workspace/IDENTITY.md "# IDENTITY.md - Who Am I?\n\n- **Name:** AI Assistant\n- **Creature:** AI 助手\n- **Vibe:** 可靠、高效、专注\n- **Emoji:** ✨\n\n---\n\n## 我的故事\n\n在这里写下你的 AI 助手故事..."
    safe_create ~/.openclaw/workspace/USER.md "# USER.md - About Your Human\n\n- **Name:** 用户名\n- **What to call them:** 昵称\n- **Timezone:** Asia/Shanghai (GMT+8)\n- **Location:** 位置\n\n## Context\n\n记录用户偏好、项目、兴趣等..."
    safe_create ~/.openclaw/workspace/SOUL.md "# SOUL.md - Who You Are\n\n## Core Truths\n\n- Be genuinely helpful, not performatively helpful\n- Have opinions — an assistant with no personality is just a search engine\n- Be resourceful before asking\n- Earn trust through competence\n\n## Boundaries\n\n- Private things stay private\n- When in doubt, ask before acting externally\n\n## Vibe\n\nBe the assistant you'd actually want to talk to."
    safe_create ~/.openclaw/workspace/AGENTS.md "# AGENTS.md - Your Workspace\n\n## Session Startup\n\n1. Read \`SOUL.md\` — who you are\n2. Read \`USER.md\` — who you're helping\n3. Read \`memory/YYYY-MM-DD.md\` — recent context\n\n## Memory\n\n- Daily notes: \`memory/YYYY-MM-DD.md\`\n- Long-term: \`MEMORY.md\`\n\n## Tools\n\n- Check \`TOOLS.md\` for local-specific configurations"
    safe_create ~/.openclaw/workspace/HEARTBEAT.md "# HEARTBEAT.md\n\n# Keep this file empty to skip heartbeat API calls.\n# Add tasks below when you want the agent to check something periodically."
    safe_create ~/.openclaw/workspace/TOOLS.md "# TOOLS.md - Local Notes\n\nSkills define _how_ tools work. This file is for _your_ specifics.\n\n## What Goes Here\n\n- Camera names and locations\n- SSH hosts and aliases\n- Preferred voices for TTS\n- Device nicknames"
    safe_create ~/.openclaw/workspace/MEMORY.md "# MEMORY.md - Long-term Memory\n\nThis file stores important information, decisions, and lessons learned.\n\n## Guidelines\n\n- Keep it concise and actionable\n- Update regularly with significant events\n- Remove outdated information\n- Review daily notes and distill key insights here"
    
    if [ ! -f ~/.openclaw/openclaw.json ]; then
        cat > ~/.openclaw/openclaw.json << 'EOF'
{
  "model": "bailian/qwen-turbo",
  "channels": {},
  "browser": { "enabled": true },
  "tts": { "enabled": true }
}
EOF
        log_ok "创建: ~/.openclaw/openclaw.json"
    else
        echo -e "${BLUE}[-]${NC} 配置文件已存在"
    fi
    echo ""
}

# ==============================================
# 阶段 7: 克隆开源知识库 Agent Academy
# ==============================================
clone_public_knowledge() {
    log_step "阶段 7/8: 克隆 Agent Academy 开源知识库"
    
    log_info "开源知识库: $PUBLIC_KB_NAME"
    log_info "地址: $PUBLIC_KB_REPO"
    log_info "说明: 800+ 技能 | MCP 知识体系 | 记忆系统 | 多 Agent 协作"
    
    # 创建知识库目录
    mkdir -p ~/.openclaw/knowledge
    
    # 克隆开源知识库
    if [ ! -d ~/.openclaw/knowledge/$PUBLIC_KB_NAME ]; then
        log_info "克隆 Agent Academy 知识库..."
        if git clone --depth 1 -b "$PUBLIC_KB_BRANCH" "$PUBLIC_KB_REPO" ~/.openclaw/knowledge/$PUBLIC_KB_NAME; then
            log_ok "Agent Academy 知识库克隆成功"
        else
            log_warn "Agent Academy 知识库克隆失败，跳过"
        fi
    else
        log_ok "Agent Academy 知识库已存在，尝试更新..."
        cd ~/.openclaw/knowledge/$PUBLIC_KB_NAME && git pull 2>/dev/null && log_ok "知识库已更新" || log_warn "知识库更新失败"
    fi
    
    KB_PATH=~/.openclaw/knowledge/$PUBLIC_KB_NAME
    
    # === 1. 复制 skills 到工作区 ===
    if [ -d "$KB_PATH/skills" ]; then
        log_info "复制技能到工作区 (800+ 技能)..."
        cp -r "$KB_PATH/skills"/* ~/.openclaw/workspace/skills/ 2>/dev/null || true
        SKILL_COUNT=$(find ~/.openclaw/workspace/skills -maxdepth 2 -name "SKILL.md" 2>/dev/null | wc -l)
        log_ok "技能复制完成，共 $SKILL_COUNT 个技能"
    fi
    
    # === 2. 复制知识文档 ===
    if [ -d "$KB_PATH/knowledge" ]; then
        log_info "复制知识文档 (MCP、记忆系统、多Agent协作等)..."
        mkdir -p ~/.openclaw/workspace/knowledge
        cp -r "$KB_PATH/knowledge"/* ~/.openclaw/workspace/knowledge/ 2>/dev/null || true
        log_ok "知识文档复制完成"
    fi
    
    # === 3. 复制模板文件 ===
    if [ -d "$KB_PATH/templates" ]; then
        log_info "复制模板文件..."
        cp -r "$KB_PATH/templates"/* ~/.openclaw/workspace/templates/ 2>/dev/null || true
        log_ok "模板文件复制完成"
    fi
    
    # === 4. 复制项目文档 ===
    log_info "复制项目文档..."
    [ -f "$KB_PATH/README.md" ] && cp "$KB_PATH/README.md" ~/.openclaw/workspace/ && log_ok "README.md ✓"
    [ -f "$KB_PATH/README_EN.md" ] && cp "$KB_PATH/README_EN.md" ~/.openclaw/workspace/ && log_ok "README_EN.md ✓"
    [ -f "$KB_PATH/CONTRIBUTING.md" ] && cp "$KB_PATH/CONTRIBUTING.md" ~/.openclaw/workspace/ && log_ok "CONTRIBUTING.md ✓"
    [ -f "$KB_PATH/CONTRIBUTING_EN.md" ] && cp "$KB_PATH/CONTRIBUTING_EN.md" ~/.openclaw/workspace/ && log_ok "CONTRIBUTING_EN.md ✓"
    [ -f "$KB_PATH/LICENSE" ] && cp "$KB_PATH/LICENSE" ~/.openclaw/workspace/ && log_ok "LICENSE ✓"
    
    # === 5. 复制技能统计 ===
    log_info "复制技能统计..."
    [ -f "$KB_PATH/skills-stats.md" ] && cp "$KB_PATH/skills-stats.md" ~/.openclaw/workspace/ && log_ok "skills-stats.md ✓"
    [ -f "$KB_PATH/skills-stats.json" ] && cp "$KB_PATH/skills-stats.json" ~/.openclaw/workspace/ && log_ok "skills-stats.json ✓"
    
    # === 6. 复制 docs 目录 ===
    if [ -d "$KB_PATH/docs" ]; then
        log_info "复制文档目录..."
        cp -r "$KB_PATH/docs" ~/.openclaw/workspace/ 2>/dev/null || true
        log_ok "docs 目录复制完成"
    fi
    
    # === 7. 复制 scripts 目录 ===
    if [ -d "$KB_PATH/scripts" ]; then
        log_info "复制脚本目录..."
        cp -r "$KB_PATH/scripts" ~/.openclaw/workspace/ 2>/dev/null || true
        log_ok "scripts 目录复制完成"
    fi
    
    log_ok "知识库完整复制！Agent 可以学习和使用所有知识"
    echo ""
}

# ==============================================
# 阶段 8: 安装基础 Skills
# ==============================================
install_skills() {
    log_step "阶段 8/8: 安装基础 Skills"
    
    log_info "安装核心技能..."
    
    # 基础技能列表
    CORE_SKILLS=(
        "weather"
        "healthcheck"
        "skill-creator"
        "find-skills"
        "browser-use"
    )
    
    INSTALLED=0; FAILED=0
    
    for skill in "${CORE_SKILLS[@]}"; do
        if npx clawhub@latest install "$skill" 2>/dev/null; then
            log_ok "$skill ✓"
            ((INSTALLED++))
        else
            log_warn "$skill 安装跳过"
            ((FAILED++))
        fi
    done
    
    log_info "核心技能安装完成: 成功 $INSTALLED, 跳过 $FAILED"
    log_info "更多技能: npx clawhub@latest install <技能名>"
    echo ""
}

# ==============================================
# 完成
# ==============================================
finish() {
    echo -e "${BLUE}=============================================="
    echo -e "✅ 安装完成! (开源版 v${VERSION})"
    echo -e "==============================================${NC}"
    echo ""
    echo "📊 环境信息:"
    echo "   Node.js: $(node -v 2>/dev/null || echo '未安装')"
    echo "   npm: $(npm -v 2>/dev/null || echo '未安装')"
    echo "   OpenClaw: $(openclaw --version 2>/dev/null || echo '待验证')"
    echo ""
    echo -e "${GREEN}📚 Agent Academy 知识库:${NC}"
    echo "   源码位置: ~/.openclaw/knowledge/agent-academy"
    echo "   工作区位置: ~/.openclaw/workspace/"
    echo ""
    echo -e "${GREEN}📂 已安装内容 (完整覆盖):${NC}"
    echo "   ├── skills/              (800+ 技能库)"
    echo "   ├── knowledge/           (MCP、记忆系统、多Agent协作)"
    echo "   ├── templates/           (AGENTS.md、MEMORY.md 模板)"
    echo "   ├── docs/                (项目文档、推广文章)"
    echo "   ├── scripts/             (安装脚本、工具脚本)"
    echo "   ├── README.md            (项目说明)"
    echo "   ├── README_EN.md         (项目说明 - 英文)"
    echo "   ├── CONTRIBUTING.md      (贡献指南)"
    echo "   ├── CONTRIBUTING_EN.md   (贡献指南 - 英文)"
    echo "   ├── LICENSE              (开源许可证)"
    echo "   ├── skills-stats.md      (技能统计)"
    echo "   └── skills-stats.json    (技能统计数据)"
    echo ""
    echo -e "${GREEN}📖 知识模块 (Agent 可学习):${NC}"
    echo "   📦 Skills - 800+ 技能库 (可直接安装使用)"
    echo "   📚 MCP - Model Context Protocol 完整文档"
    echo "   🧠 记忆系统 - 四层架构、QMD 搜索方案"
    echo "   👥 多 Agent 协作 - 团队模式、通信协议"
    echo "   🌐 浏览器自动化 - Puppeteer、Playwright 指南"
    echo "   🏠 工作区规范 - SOUL、AGENTS、记忆管理"
    echo ""
    echo "📝 下一步操作:"
    echo "   1. 刷新环境: source ~/.bashrc"
    echo "   2. 编辑身份: nano ~/.openclaw/workspace/IDENTITY.md"
    echo "   3. 配置密钥: nano ~/.openclaw/openclaw.json"
    echo "   4. 启动服务: openclaw gateway start"
    echo ""
    echo -e "${YELLOW}💡 提示:${NC}"
    echo "   知识库已完整安装，Agent 可以学习和使用所有内容"
    echo "   项目地址: https://gitee.com/hongmaple/agent-academy"
    echo ""
    echo -e "🏠 项目: ${BLUE}https://gitee.com/hongmaple/agent-academy${NC}"
    echo -e "👨‍💻 感谢作者: ${YELLOW}maple (hongmaple)${NC} 及 枫林 AI 协作团队"
    echo "=============================================="
}

# ==============================================
# 主执行流
# ==============================================
print_banner

# 确认安装
log_warn "即将安装 OpenClaw 及 Agent Academy 开源知识库"
read -p "是否继续? (y/n): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    log_info "已取消"
    exit 0
fi

uninstall_old_node
check_network
install_node24
install_dependencies
install_openclaw
create_configs
clone_public_knowledge
install_skills
finish
