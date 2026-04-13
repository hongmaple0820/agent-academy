# MCP 快速入门教程

> 版本：v1.0
> 更新时间：2026-03-13
> 适用人群：初学者、工具使用者

---

## 一、什么是 MCP？

### 1.1 简单理解

想象一下，你的 AI 助手就像一个聪明但"手很短"的人——它知道很多，但无法直接操作你的电脑、访问数据库、或调用外部服务。

**MCP 就是给 AI 装上"手"的技术**。

通过 MCP，你的 AI 助手可以：
- 操作数据库
- 读写文件
- 调用 API
- 执行各种工具

### 1.2 工作原理

```
用户提问："帮我查询数据库中的用户数量"
         ↓
AI 理解意图，选择合适的 MCP 工具
         ↓
MCP 工具执行 SQL 查询
         ↓
返回结果给 AI
         ↓
AI 整理结果并回复用户
```

---

## 二、5 分钟上手 MCP

### 2.1 环境准备

**前置条件**：
- 已安装 Node.js (v18+) 或 Python (3.10+)
- 已安装 OpenClaw 或其他支持 MCP 的应用

**检查环境**：
```bash
# 检查 Node.js
node --version

# 检查 Python
python --version

# 检查 npm
npm --version
```

### 2.2 安装第一个 MCP 工具

**方式一：使用内置安装脚本**
```bash
# Linux/macOS
./scripts/configure-mcp.sh

# Windows
scripts\configure-mcp.bat
```

**方式二：手动配置**

编辑配置文件 `~/.openclaw/openclaw.json`：

```json
{
  "mcpServers": {
    "sqlite": {
      "command": "uvx",
      "args": ["mcp-server-sqlite", "--db-path", "~/data/test.db"]
    }
  }
}
```

### 2.3 验证安装

重启应用后，在对话中尝试：

```
请列出可用的 MCP 工具
```

AI 应该会返回类似：

```
可用的 MCP 工具：
- sqlite_query: 执行 SQL 查询
- sqlite_schema: 查看数据库结构
```

---

## 三、常用 MCP 工具使用

### 3.1 SQLite 工具

**功能**：操作 SQLite 数据库

**安装**：
```json
{
  "mcpServers": {
    "sqlite": {
      "command": "uvx",
      "args": ["mcp-server-sqlite", "--db-path", "/path/to/your.db"]
    }
  }
}
```

**使用示例**：

```
# 创建表
请帮我创建一个 notes 表，包含 id、title、content、created_at 字段

# 插入数据
向 notes 表插入一条记录：title="第一条笔记", content="这是内容"

# 查询数据
查询 notes 表中的所有记录

# 查看结构
显示数据库中所有的表
```

### 3.2 GitHub 工具

**功能**：与 GitHub API 交互

**安装**：
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_your_personal_access_token"
      }
    }
  }
}
```

**获取 Token**：
1. 访问 GitHub Settings > Developer settings > Personal access tokens
2. 创建新 Token，选择所需权限
3. 复制 Token 并填入配置

**使用示例**：

```
# 搜索项目
搜索 GitHub 上 star 最多的 Python 项目

# 查看仓库信息
获取 modelcontextprotocol/typescript-sdk 仓库的详情

# 列出 Issues
列出某个仓库的最近 10 个 Issues
```

### 3.3 文件系统工具

**功能**：安全地读写文件

**安装**：
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/path/to/allowed/directory"
      ]
    }
  }
}
```

**安全说明**：
- 只能访问配置中指定的目录
- 防止 AI 访问敏感文件

**使用示例**：

```
# 列出文件
列出当前目录下的所有文件

# 读取文件
读取 config.json 文件的内容

# 写入文件
创建一个 test.txt 文件，内容为"Hello MCP"

# 搜索文件
搜索包含 "TODO" 的所有文件
```

### 3.4 思维链工具

**功能**：结构化推理，分步思考

**安装**：
```json
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
  }
}
```

**使用示例**：

```
# 复杂问题分析
请使用思维链工具分析：如何设计一个高可用的微服务架构？

# 逐步推理
用分步思考的方式，计算 1+2+3+...+100 的和
```

---

## 四、实际应用场景

### 4.1 数据分析场景

**需求**：分析 SQLite 数据库中的销售数据

**对话示例**：
```
用户：我有一个 sales.db 数据库，请帮我分析 2024 年的销售趋势

AI：我来帮你分析销售数据。

[调用 sqlite_query 工具]
SELECT strftime('%Y-%m', sale_date) as month, 
       SUM(amount) as total_sales 
FROM sales 
WHERE sale_date >= '2024-01-01' 
GROUP BY month 
ORDER BY month;

[返回结果]
2024-01: ¥120,000
2024-02: ¥150,000
2024-03: ¥180,000
...

根据数据分析，2024 年销售呈稳步增长趋势...
```

### 4.2 代码管理场景

**需求**：查看和管理 GitHub Issues

**对话示例**：
```
用户：帮我查看 openclaw/ai-collab-space 仓库中标记为 bug 的 Issues

AI：我来查询相关的 Issues。

[调用 github 工具]
列出 openclaw/ai-collab-space 仓库中标签为 bug 的 Issues

[返回结果]
#456 - 登录页面加载缓慢
#452 - 移动端布局错位
#448 - 搜索功能不工作

共找到 3 个 bug 类型的 Issues。你希望我查看哪个 Issue 的详情？
```

### 4.3 自动化任务场景

**需求**：自动整理和归档文件

**对话示例**：
```
用户：请帮我将 downloads 目录下所有 PDF 文件移动到 documents/pdfs/ 目录

AI：我来帮你整理文件。

[调用 filesystem 工具]
1. 列出 downloads 目录下的 PDF 文件
2. 创建目标目录（如果不存在）
3. 移动文件

已完成！共移动了 15 个 PDF 文件到 documents/pdfs/ 目录。
```

---

## 五、进阶技巧

### 5.1 组合使用多个工具

MCP 的强大之处在于可以组合使用多个工具：

```
用户：分析这个 GitHub 项目的代码质量，并将报告保存到本地文件

AI 会：
1. 使用 GitHub 工具获取项目信息
2. 分析代码结构
3. 使用文件系统工具保存报告
```

### 5.2 创建自定义工具

如果你有特定需求，可以创建自己的 MCP 工具：

1. **确定需求**：明确工具要解决的问题
2. **选择技术栈**：TypeScript 或 Python
3. **开发工具**：参考 [mcp-builder 技能](../../skills/tool-development/mcp-builder/SKILL.md)
4. **测试验证**：使用 MCP Inspector 测试
5. **部署使用**：配置到 MCP 服务器

### 5.3 安全最佳实践

1. **最小权限原则**：只授予必要的权限
2. **限制访问范围**：文件系统工具指定允许的目录
3. **保护敏感信息**：使用环境变量存储 Token
4. **定期审查**：检查已安装的 MCP 工具

---

## 六、常见问题

### Q1: MCP 工具无法启动？

**检查清单**：
- [ ] Node.js/Python 版本是否满足要求
- [ ] 命令路径是否正确
- [ ] 环境变量是否设置
- [ ] 配置文件 JSON 格式是否正确

### Q2: GitHub Token 无效？

**解决方案**：
- 确认 Token 未过期
- 检查 Token 权限是否足够
- 确认 Token 格式正确（以 `ghp_` 开头）

### Q3: 文件系统工具无法访问文件？

**可能原因**：
- 路径不在允许的目录范围内
- 文件权限不足
- 路径格式错误（Windows 使用反斜杠或正斜杠）

### Q4: 如何调试 MCP 工具？

**调试方法**：
```bash
# 使用 MCP Inspector
npx @modelcontextprotocol/inspector

# 查看日志
# 检查应用的日志输出
```

---

## 七、下一步学习

### 7.1 深入学习

- [MCP 最佳实践指南](./mcp-best-practices.md)
- [MCP 工具配置详解](./mcp-tools-configuration.md)
- [MCP 实际案例集](./mcp-examples.md)

### 7.2 动手实践

- 尝试安装和使用不同的 MCP 工具
- 分析现有 MCP 服务器的代码
- 开发自己的第一个 MCP 工具

### 7.3 参与社区

- 加入 MCP 中文社区
- 分享你的使用经验
- 贡献新的 MCP 工具

---

## 八、快速参考卡片

### 常用配置模板

```json
{
  "mcpServers": {
    "sqlite": {
      "command": "uvx",
      "args": ["mcp-server-sqlite", "--db-path", "/path/to/db"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_TOKEN": "ghp_xxx" }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/allowed/path"]
    },
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": { "BRAVE_API_KEY": "xxx" }
    }
  }
}
```

### 常用命令

```bash
# 安装 MCP 工具
npx -y @modelcontextprotocol/server-xxx

# 使用 uvx 安装 Python 工具
uvx mcp-server-xxx

# 调试工具
npx @modelcontextprotocol/inspector
```

---

**恭喜你完成了 MCP 快速入门！**
接下来可以探索更多高级功能，或开发自己的 MCP 工具。
