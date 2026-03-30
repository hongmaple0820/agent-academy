# APKS CLI 使用指南

APKS (AI Project Knowledge Store) - 项目知识库命令行工具

## 目录

- [安装](#安装)
- [快速开始](#快速开始)
- [命令参考](#命令参考)
- [使用示例](#使用示例)
- [快捷键](#快捷键)
- [故障排除](#故障排除)

---

## 安装

### 自动安装

```bash
# 克隆或下载项目
cd skills/project-kb

# 运行安装脚本
./install.sh
```

### 手动安装

```bash
# 复制主程序
sudo cp apks.sh /usr/local/bin/apks
sudo chmod +x /usr/local/bin/apks

# 创建配置目录
mkdir -p ~/.config/apks

# 复制辅助脚本
cp -r scripts ~/.config/apks/
```

### 卸载

```bash
./install.sh --uninstall
```

---

## 快速开始

### 1. 初始化项目

```bash
cd your-project
apks init
```

这将启动交互式向导，收集项目信息并生成配置文件。

### 2. 查看可用代码

```bash
# 列出所有代码片段
apks list

# 搜索代码
apks search react
```

### 3. 插入代码

```bash
# 交互式选择
apks insert

# 直接指定 ID
apks insert snippet-001
```

---

## 命令参考

### `apks init`

初始化项目知识库。

```bash
apks init
```

启动交互式向导，配置：
- 项目名称
- 项目类型（前端/后端/全栈等）
- 技术栈
- 自动加载设置

### `apks search <keyword>`

搜索代码片段。

```bash
# 搜索 React 相关代码
apks search react

# 搜索 hooks
apks search "useEffect"
```

### `apks list`

列出所有可用的代码片段。

```bash
apks list
```

输出格式：
```
ID          名称                    标签                    大小
────────────────────────────────────────────────────────────
snippet-001  React useState Hook     react,hooks,state       2KB
snippet-002  API Error Handling      api,error,fetch         3KB
```

### `apks show <id>`

显示代码片段详情。

```bash
apks show snippet-001
```

### `apks insert [id]`

插入代码到项目。

```bash
# 交互式选择（推荐）
apks insert

# 直接指定 ID
apks insert snippet-001
```

交互式模式支持：
- 上下箭头选择
- 实时预览代码
- 确认后插入或复制到剪贴板

### `apks update`

更新知识库。

```bash
apks update
```

### `apks stats`

显示项目统计信息。

```bash
apks stats
```

输出示例：
```
项目信息:
  项目名称: my-project
  项目类型: frontend

代码片段统计:
  总数: 15
  总大小: 45KB
  标签数: 23

语言分布:
  TypeScript: 8
  JavaScript: 5
  CSS: 2
```

### `apks config`

配置管理。

```bash
apks config
```

### `apks version`

显示版本信息。

```bash
apks version
```

### `apks help`

显示帮助信息。

```bash
apks help
```

---

## 使用示例

### 示例 1: 初始化前端项目

```bash
# 进入项目目录
cd my-react-app

# 初始化
apks init
# 回答向导问题:
# - 项目名称: my-react-app
# - 项目类型: Web 前端项目
# - 编程语言: TypeScript
# - 框架: React
# - 自动加载: yes

# 更新知识库
apks update

# 搜索 React hooks
apks search "useState"

# 交互式插入代码
apks insert
# 选择 useState hook，复制到剪贴板
```

### 示例 2: 快速查找代码

```bash
# 使用别名快速搜索
aps error handling    # 等同于: apks search "error handling"

# 列出所有代码
apl                   # 等同于: apks list

# 快速插入
api                   # 等同于: apks insert
```

### 示例 3: 查看项目统计

```bash
# 查看项目使用了多少代码片段
apks stats
```

---

## 快捷键

### 交互式选择器 (`apks insert`)

| 按键 | 功能 |
|------|------|
| `↑` / `k` | 向上移动 |
| `↓` / `j` | 向下移动 |
| `Enter` | 插入选中代码 |
| `p` | 切换预览 |
| `g` | 跳到开头 |
| `G` | 跳到结尾 |
| `?` | 显示帮助 |
| `q` / `Esc` | 退出 |

### Tab 补全

APKS 支持命令和代码片段 ID 的 Tab 补全：

```bash
# 命令补全
apks in<Tab>      # 自动补全为: apks init
apks sea<Tab>     # 自动补全为: apks search

# 代码片段 ID 补全
apks show snip<Tab>   # 列出所有 snippet-*
apks insert use<Tab>  # 列出所有 use* 片段
```

---

## 故障排除

### 问题: 命令未找到 (command not found)

**原因**: `apks` 不在 PATH 中

**解决**:
```bash
# 重新加载 shell 配置
source ~/.bashrc    # 或 ~/.zshrc

# 或手动添加
export PATH="/usr/local/bin:$PATH"
```

### 问题: 权限被拒绝 (Permission denied)

**原因**: 安装目录需要管理员权限

**解决**:
```bash
# 使用 sudo 安装
sudo ./install.sh

# 或安装到用户目录
INSTALL_DIR="$HOME/.local/bin" ./install.sh
```

### 问题: 交互式选择器显示异常

**原因**: 终端不支持某些控制字符

**解决**:
1. 确保使用支持 ANSI 的终端
2. 尝试设置 TERM 变量:
   ```bash
   export TERM=xterm-256color
   ```
3. 或使用非交互式模式:
   ```bash
   apks insert snippet-id
   ```

### 问题: 代码片段未找到

**原因**: 项目未初始化或知识库为空

**解决**:
```bash
# 检查项目是否初始化
ls -la .apks/

# 重新初始化
apks init

# 更新知识库
apks update
```

### 问题: 剪贴板复制失败

**原因**: 缺少剪贴板工具

**解决**:
```bash
# Linux 安装 xclip
sudo apt-get install xclip    # Debian/Ubuntu
sudo yum install xclip        # RHEL/CentOS

# macOS 自带 pbcopy，无需安装

# WSL 使用 clip.exe，无需安装
```

### 问题: Tab 补全不工作

**原因**: 补全脚本未正确加载

**解决**:
```bash
# 手动加载补全脚本
source ~/.bash_completion.d/apks

# 或重新安装
./install.sh
```

---

## 配置文件

### 全局配置

位置: `~/.config/apks/config`

```bash
# APKS 全局配置

# 知识库路径
APKS_KB_DIR="${HOME}/.config/apks/knowledge"

# 默认编辑器
APKS_EDITOR="${EDITOR:-vi}"

# 自动更新检查
APKS_AUTO_CHECK_UPDATE=true

# 主题设置 (auto|light|dark)
APKS_THEME="auto"
```

### 项目配置

位置: `.apks/config`

```bash
# 项目基本信息
project_name="my-project"
project_type="frontend"
project_description="A React application"

# 技术栈
programming_language="TypeScript"
framework="React"

# 功能设置
auto_load=true

# 统计信息
last_update="2024-01-15 10:30:00"
snippet_count=15
```

---

## 环境变量

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `INSTALL_DIR` | 安装目录 | `/usr/local/bin` |
| `APKS_KB_DIR` | 知识库路径 | `~/.config/apks/knowledge` |
| `APKS_EDITOR` | 默认编辑器 | `$EDITOR` 或 `vi` |
| `APKS_THEME` | 主题设置 | `auto` |

---

## 获取帮助

- 查看帮助: `apks help`
- 查看版本: `apks version`
- 查看命令帮助: `apks <command> --help`

---

**Happy Coding!** 🚀
