# MCP (Model Context Protocol) 知识库

> 版本：v1.1
> 更新时间：2026-03-13
> 维护者：AI协作共享知识库
> 工具数量：20+ MCP 工具文档

---

## 一、MCP 概述

### 1.1 什么是 MCP？

**MCP (Model Context Protocol)** 是一种开放协议，允许 LLM (大语言模型) 通过标准化的接口与外部工具、数据源和服务进行交互。它提供了一种统一的方式，让 AI 模型能够：

- 执行外部工具和命令
- 访问数据库和文件系统
- 调用 API 和 Web 服务
- 与各种应用程序集成

### 1.2 核心价值

| 角色 | 价值 |
|------|------|
| **AI 应用开发者** | 快速集成各种工具，无需为每个服务编写适配器 |
| **工具开发者** | 一次开发，多处使用，遵循标准协议 |
| **最终用户** | 获得 AI 与各种服务的无缝集成体验 |
| **企业用户** | 标准化的集成方案，便于管理和审计 |

### 1.3 MCP 架构

```
┌────────────────────────────────────────────────────────┐
│                    AI 应用层                            │
│              (Chat-Hub / Claude / 等)                   │
└────────────────────────────────────────────────────────┘
                         │
                         ▼
┌────────────────────────────────────────────────────────┐
│                   MCP 协议层                            │
│         (标准化工具调用、资源访问、提示词管理)            │
└────────────────────────────────────────────────────────┘
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
    ┌──────────┐   ┌──────────┐   ┌──────────┐
    │ MCP 服务器 │   │ MCP 服务器 │   │ MCP 服务器 │
    │  (GitHub) │   │ (SQLite) │   │ (自定义)  │
    └──────────┘   └──────────┘   └──────────┘
```

---

## 二、知识库结构

```
knowledge/mcp/
├── README.md                    # 本文档 - MCP 知识库总览
├── mcp-quick-start.md           # 快速入门教程
├── mcp-best-practices.md        # 最佳实践指南
├── mcp-tools-configuration.md   # 工具配置手册
├── mcp-tools-reference.md       # MCP 工具完整参考（新增）
├── mcp-builtin-tools.md         # 内置工具快速配置指南（新增）
├── mcp-examples.md              # 实际案例集
└── mcp-troubleshooting.md       # 故障排除指南
```

### 文档说明

| 文档 | 说明 | 内容概要 |
|------|------|----------|
| **快速入门** | 5分钟上手 MCP | 环境准备、第一个工具、常用工具使用 |
| **最佳实践** | 开发和配置指南 | 设计原则、性能优化、安全建议 |
| **工具配置** | 详细配置手册 | 各工具配置示例、环境变量管理 |
| **工具参考** | 工具完整列表（新增） | 20+ 工具详细说明、对比表格、选择指南 |
| **内置工具** | 快速配置指南（新增） | 7个内置工具一键配置、验证脚本 |
| **实际案例** | 11个真实案例 | 数据分析、GitHub集成、文件操作等 |
| **故障排除** | 问题诊断解决 | 启动/连接/认证/性能问题处理 |

---

## 三、学习路径

### 3.1 初学者路径

1. **理解概念**：阅读 [MCP 快速入门](./mcp-quick-start.md)
2. **体验工具**：尝试使用内置 MCP 工具
3. **学习配置**：掌握 [工具配置方法](./mcp-tools-configuration.md)
4. **解决问题**：查阅 [故障排除指南](./mcp-troubleshooting.md)

### 3.2 开发者路径

1. **深入理解**：研究 MCP 协议规范
2. **学习开发**：阅读 [最佳实践指南](./mcp-best-practices.md)
3. **参考案例**：学习 [实际案例集](./mcp-examples.md)
4. **动手实践**：开发自己的 MCP 服务器

### 3.3 架构师路径

1. **系统设计**：理解 MCP 系统架构
2. **集成方案**：规划企业级 MCP 集成
3. **安全审计**：建立 MCP 安全管理体系
4. **性能优化**：优化 MCP 服务性能

---

## 四、核心概念

### 4.1 MCP 服务器

MCP 服务器是一个独立进程，通过标准化协议向 AI 应用提供工具能力。

**特性**：
- **独立性**：每个服务器独立运行，互不影响
- **可扩展**：支持动态加载和卸载
- **标准化**：遵循 MCP 协议规范

**传输方式**：
- `stdio`：通过标准输入输出通信（本地）
- `HTTP/SSE`：通过 HTTP 协议通信（远程）

### 4.2 工具 (Tools)

工具是 MCP 服务器提供的核心能力单元，允许 AI 执行特定操作。

**工具定义**：
```json
{
  "name": "sqlite_query",
  "description": "执行 SQL 查询语句",
  "inputSchema": {
    "type": "object",
    "properties": {
      "query": {
        "type": "string",
        "description": "SQL 查询语句"
      }
    },
    "required": ["query"]
  }
}
```

### 4.3 资源 (Resources)

资源是 MCP 服务器提供的数据访问接口，允许 AI 读取文件、数据库等内容。

**资源类型**：
- 文件资源：读取本地文件
- 数据库资源：查询数据库
- API 资源：访问外部 API

### 4.4 提示词 (Prompts)

提示词是 MCP 服务器提供的预定义模板，帮助用户快速构建 AI 交互。

---

## 五、MCP 技能目录

本知识库中的 MCP 相关技能位于 `skills/tool-development/mcp-builder/`，包含：

### 5.1 核心技能

| 技能名称 | 描述 | 路径 |
|---------|------|------|
| **mcp-builder** | MCP 服务器开发指南 | `skills/tool-development/mcp-builder/` |

### 5.2 参考文档

| 文档 | 描述 | 路径 |
|------|------|------|
| **MCP 最佳实践** | 通用开发指南 | `skills/tool-development/mcp-builder/reference/mcp_best_practices.md` |
| **TypeScript 指南** | TypeScript 开发模式 | `skills/tool-development/mcp-builder/reference/node_mcp_server.md` |
| **Python 指南** | Python 开发模式 | `skills/tool-development/mcp-builder/reference/python_mcp_server.md` |
| **评估指南** | MCP 服务器评估方法 | `skills/tool-development/mcp-builder/reference/evaluation.md` |

---

## 六、快速开始

### 6.1 安装 MCP 工具

```bash
# 使用内置安装脚本
./scripts/configure-mcp.sh

# 或手动配置
# 编辑 ~/.openclaw/openclaw.json
```

### 6.2 配置示例

```json
{
  "mcpServers": {
    "sqlite": {
      "command": "uvx",
      "args": ["mcp-server-sqlite", "--db-path", "/path/to/database.db"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_your_token"
      }
    }
  }
}
```

### 6.3 使用示例

```
# 使用 SQLite 工具
请帮我查询 users 表中所有记录

# 使用 GitHub 工具
搜索 OpenClaw 组织下的热门项目

# 使用思维链工具
请使用 think 工具分析这个问题的解决方案
```

---

## 七、常见 MCP 工具

### 7.1 内置工具（开箱即用）

| 工具名称 | 功能 | 配置难度 | 文档链接 |
|---------|------|---------|---------|
| **chrome-devtools** | Chrome 浏览器自动化 | ⭐ | [详细说明](./mcp-builtin-tools.md#31-chrome-devtools) |
| **context7** | 官方文档搜索（50+ 库） | ⭐ | [详细说明](./mcp-builtin-tools.md#32-context7) |
| **fetch** | 网页内容抓取 | ⭐ | [详细说明](./mcp-builtin-tools.md#33-fetch) |
| **memory** | 短期记忆存储 | ⭐ | [详细说明](./mcp-builtin-tools.md#34-memory) |
| **sequential-thinking** | 顺序思考工具 | ⭐ | [详细说明](./mcp-builtin-tools.md#35-sequential-thinking) |
| **time** | 时间工具 | ⭐ | [详细说明](./mcp-builtin-tools.md#36-time) |
| **mem0** | 长期记忆层 | ⭐⭐ | [详细说明](./mcp-builtin-tools.md#37-mem0) |

**一键配置**：参见 [内置工具快速配置指南](./mcp-builtin-tools.md#21-完整配置模板)

### 7.2 官方工具

| 工具名称 | 功能 | 配置要求 | 文档链接 |
|---------|------|---------|---------|
| **SQLite** | 数据库操作 | Python + uvx | [详细说明](./mcp-tools-reference.md#31-sqlite) |
| **GitHub** | GitHub API 集成 | GitHub Token | [详细说明](./mcp-tools-reference.md#32-github) |
| **Filesystem** | 文件系统操作 | Node.js | [详细说明](./mcp-tools-reference.md#33-filesystem) |
| **Brave Search** | 搜索引擎集成 | API Key | [详细说明](./mcp-tools-reference.md#34-brave-search) |
| **Puppeteer** | 浏览器自动化 | Node.js | [详细说明](./mcp-tools-reference.md#35-puppeteer) |

### 7.3 社区工具

| 工具名称 | 功能 | 配置要求 | 文档链接 |
|---------|------|---------|---------|
| **Figma** | 设计工具集成 | Figma Token | [详细说明](./mcp-tools-reference.md#41-figma) |
| **Redis** | 缓存数据库操作 | Redis 服务器 | [详细说明](./mcp-tools-reference.md#42-redis) |
| **PostgreSQL** | 关系型数据库 | 数据库连接 | [详细说明](./mcp-tools-reference.md#43-postgresql) |
| **MongoDB** | 文档数据库操作 | MongoDB 连接 | [详细说明](./mcp-tools-reference.md#44-mongodb) |
| **Slack** | 团队协作集成 | Slack Bot Token | [详细说明](./mcp-tools-reference.md#45-slack) |
| **Notion** | 知识管理集成 | Notion API Key | [详细说明](./mcp-tools-reference.md#46-notion) |
| **Google Drive** | 云存储集成 | OAuth 凭据 | [详细说明](./mcp-tools-reference.md#47-google-drive) |
| **Docker** | 容器管理 | Docker 环境 | [详细说明](./mcp-tools-reference.md#48-docker) |
| **AWS** | 云服务集成 | AWS 凭据 | [详细说明](./mcp-tools-reference.md#49-aws) |
| **Stripe** | 支付集成 | Stripe API Key | [详细说明](./mcp-tools-reference.md#410-stripe) |

**完整列表**：参见 [MCP 工具完整参考](./mcp-tools-reference.md)

---

## 八、学习资源

### 8.1 官方文档

- [MCP 官方网站](https://modelcontextprotocol.io/)
- [MCP 规范文档](https://modelcontextprotocol.io/specification)
- [TypeScript SDK](https://github.com/modelcontextprotocol/typescript-sdk)
- [Python SDK](https://github.com/modelcontextprotocol/python-sdk)

### 8.2 本知识库资源

#### 入门必读
- [MCP 快速入门](./mcp-quick-start.md) - 5分钟上手教程
- [MCP 内置工具](./mcp-builtin-tools.md) - 一键配置指南
- [MCP 工具配置](./mcp-tools-configuration.md) - 详细配置方法

#### 进阶学习
- [MCP 最佳实践](./mcp-best-practices.md) - 开发和优化指南
- [MCP 工具参考](./mcp-tools-reference.md) - 20+ 工具完整列表
- [MCP 实际案例](./mcp-examples.md) - 11个真实应用场景

#### 故障排除
- [MCP 故障排除](./mcp-troubleshooting.md) - 问题诊断和解决

### 8.3 社区资源

- [MCP 中文社区](https://mcp-cn.com)
- [ClawHub 市场](https://clawhub.com)
- [GitHub MCP 讨论](https://github.com/modelcontextprotocol)

---

## 九、贡献指南

### 9.1 贡献方式

1. **文档贡献**：完善 MCP 文档和教程
2. **工具开发**：开发新的 MCP 工具并分享
3. **问题反馈**：报告问题和改进建议
4. **案例分享**：分享实际使用案例

### 9.2 文档规范

- 使用 Markdown 格式
- 包含清晰的代码示例
- 提供实际应用场景
- 注明版本和更新日期

---

## 十、更新日志

### v1.1 (2026-03-13)
- 新增 MCP 工具完整参考文档
- 新增内置工具快速配置指南
- 添加 20+ MCP 工具详细说明
- 添加工具对比表和选择指南
- 更新知识库索引和学习路径

### v1.0 (2026-03-13)
- 创建 MCP 知识库结构
- 添加核心概念说明
- 整合已有 MCP 技能资源
- 创建学习路径指南

---

**维护者**：AI协作共享知识库团队
**联系方式**：通过 GitHub Issues 反馈问题
**许可协议**：参见 LICENSE.txt
