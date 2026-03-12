# Agent Academy 安装脚本 (Windows PowerShell)
# 用途：自动安装技能库到 AI Agent 环境
# 使用：Invoke-WebRequest -Uri "https://gitee.com/hongmaple/agent-academy/raw/master/scripts/install.ps1" -OutFile "install.ps1"; ./install.ps1

param(
    [string]$InstallDir = "",
    [switch]$Help
)

$VERSION = "1.0.0"
$REPO_URL = "https://gitee.com/hongmaple/agent-academy.git"
$TEMP_DIR = Join-Path $env:TEMP "agent-academy-$(Get-Random)"

function Write-Info { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Blue }
function Write-Success { param($msg) Write-Host "[SUCCESS] $msg" -ForegroundColor Green }
function Write-Warn { param($msg) Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Error { param($msg) Write-Host "[ERROR] $msg" -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════╗"
Write-Host "║       🎓 Agent Academy - AI Agent 训练学院               ║"
Write-Host "║              自动安装脚本 v$VERSION                        ║"
Write-Host "╚══════════════════════════════════════════════════════════╝"
Write-Host ""

if ($Help) {
    Write-Host "用法: .\install.ps1 [-InstallDir <路径>]"
    Write-Host ""
    Write-Host "参数:"
    Write-Host "  -InstallDir  指定安装目录（可选）"
    Write-Host "  -Help        显示帮助信息"
    Write-Host ""
    Write-Host "示例:"
    Write-Host "  .\install.ps1"
    Write-Host "  .\install.ps1 -InstallDir 'C:\Users\YourName\.agents'"
    exit 0
}

# 检查依赖
function Check-Dependencies {
    Write-Info "检查依赖..."
    
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Error "未找到 git，请先安装 git"
    }
    
    Write-Success "依赖检查通过"
}

# 确定安装目录
function Get-InstallDir {
    Write-Info "检测安装目录..."
    
    if ($InstallDir -ne "") {
        $script:InstallPath = $InstallDir
    }
    elseif ($env:AGENT_ACADEMY_DIR) {
        $script:InstallPath = $env:AGENT_ACADEMY_DIR
    }
    else {
        # 常见的 Agent 配置目录
        $homeDir = $env:USERPROFILE
        $possibleDirs = @(
            "$homeDir\.agents",
            "$homeDir\.config\agents",
            "$homeDir\.claude",
            "$homeDir\.cursor",
            "$homeDir\Documents\agent-academy"
        )
        
        $script:InstallPath = $possibleDirs | Where-Object { Test-Path $_ } | Select-Object -First 1
        
        if (-not $script:InstallPath) {
            $script:InstallPath = "$homeDir\.agents"
        }
    }
    
    Write-Info "安装目录: $script:InstallPath"
}

# 克隆仓库
function Clone-Repo {
    Write-Info "克隆 Agent Academy 仓库..."
    
    if (Test-Path $TEMP_DIR) {
        Remove-Item -Recurse -Force $TEMP_DIR
    }
    
    git clone --depth 1 $REPO_URL $TEMP_DIR
    
    if (-not $?) {
        Write-Error "克隆失败"
    }
    
    Write-Success "仓库克隆完成"
}

# 安装技能
function Install-Skills {
    Write-Info "安装技能库..."
    
    $targetDir = Join-Path $script:InstallPath "skills"
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    
    Copy-Item -Recurse -Force "$TEMP_DIR\skills\*" $targetDir
    
    $skillCount = (Get-ChildItem -Path $targetDir -Filter "SKILL.md" -Recurse).Count
    Write-Success "已安装 $skillCount 个技能"
}

# 安装知识库
function Install-Knowledge {
    Write-Info "安装知识库..."
    
    $targetDir = Join-Path $script:InstallPath "knowledge"
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    
    if (Test-Path "$TEMP_DIR\knowledge") {
        Copy-Item -Recurse -Force "$TEMP_DIR\knowledge\*" $targetDir
        Write-Success "知识库安装完成"
    }
    else {
        Write-Warn "未找到知识库目录"
    }
}

# 安装模板
function Install-Templates {
    Write-Info "安装模板文件..."
    
    $targetDir = Join-Path $script:InstallPath "templates"
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    
    if (Test-Path "$TEMP_DIR\templates") {
        Copy-Item -Recurse -Force "$TEMP_DIR\templates\*" $targetDir -ErrorAction SilentlyContinue
        Write-Success "模板安装完成"
    }
}

# 安装脚本
function Install-Scripts {
    Write-Info "安装自动化脚本..."
    
    $targetDir = Join-Path $script:InstallPath "scripts"
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    
    if (Test-Path "$TEMP_DIR\scripts") {
        Get-ChildItem "$TEMP_DIR\scripts\*.py" -ErrorAction SilentlyContinue | Copy-Item -Destination $targetDir
        Get-ChildItem "$TEMP_DIR\scripts\*.sh" -ErrorAction SilentlyContinue | Copy-Item -Destination $targetDir
        Get-ChildItem "$TEMP_DIR\scripts\*.ps1" -ErrorAction SilentlyContinue | Copy-Item -Destination $targetDir
        Write-Success "脚本安装完成"
    }
}

# 创建配置文件
function New-Config {
    Write-Info "创建配置文件..."
    
    $configPath = Join-Path $script:InstallPath "AGENTS.md"
    
    $configContent = @"
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
``````powershell
Invoke-WebRequest -Uri "https://gitee.com/hongmaple/agent-academy/raw/master/scripts/install.ps1" -OutFile "install.ps1"
.\install.ps1
``````
"@
    
    Set-Content -Path $configPath -Value $configContent -Encoding UTF8
    Write-Success "配置文件创建完成"
}

# 清理
function Clear-Temp {
    Write-Info "清理临时文件..."
    if (Test-Path $TEMP_DIR) {
        Remove-Item -Recurse -Force $TEMP_DIR
    }
}

# 显示结果
function Show-Result {
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════════════════╗"
    Write-Host "║                  ✅ 安装完成！                           ║"
    Write-Host "╚══════════════════════════════════════════════════════════╝"
    Write-Host ""
    Write-Host "📂 安装目录: $script:InstallPath"
    Write-Host ""
    Write-Host "📊 安装内容:"
    Write-Host "   ├── skills/        # 技能库"
    Write-Host "   ├── knowledge/     # 知识库"
    Write-Host "   ├── templates/     # 模板文件"
    Write-Host "   ├── scripts/       # 自动化脚本"
    Write-Host "   └── AGENTS.md      # 配置文件"
    Write-Host ""
    Write-Host "🚀 快速开始:"
    Write-Host "   1. 查看技能索引: Get-Content $script:InstallPath\skills\README.md"
    Write-Host "   2. 学习 MCP: Get-Content $script:InstallPath\knowledge\mcp\mcp-quick-start.md"
    Write-Host "   3. 配置 Agent: 编辑 $script:InstallPath\AGENTS.md"
    Write-Host ""
    Write-Host "📚 文档: https://gitee.com/hongmaple/agent-academy"
    Write-Host ""
}

# 主流程
Check-Dependencies
Get-InstallDir
Clone-Repo
Install-Skills
Install-Knowledge
Install-Templates
Install-Scripts
New-Config
Clear-Temp
Show-Result
