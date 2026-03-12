---
name: mcporter
description: MCPorter CLI - 管理、调用和生成 MCP 服务器/工具。支持 HTTP 和 stdio 传输，OAuth 认证，类型生成，CLI 生成。触发词：MCP、mcporter、MCP服务器、MCP工具。
version: 1.0.0
author: steipete
---

# MCPorter 🧳

TypeScript 运行时、CLI 和代码生成工具包，用于 Model Context Protocol。

## 安装

```bash
# npm
npm install mcporter

# pnpm
pnpm add mcporter

# Homebrew
brew tap steipete/tap
brew install steipete/tap/mcporter

# 或直接使用 npx（无需安装）
npx mcporter list
```

## 快速开始

### 列出 MCP 服务器

```bash
# 列出所有已配置的 MCP 服务器
npx mcporter list

# 列出特定服务器的工具
npx mcporter list linear
npx mcporter list context7 --schema

# 列出 URL 服务器
npx mcporter list https://mcp.linear.app/mcp
```

### 调用 MCP 工具

```bash
# 函数调用语法
npx mcporter call 'linear.create_comment(issueId: "ENG-123", body: "Looks good!")'

# 标志语法
npx mcporter call linear.create_comment issueId:ENG-123 body:'Looks good!'

# URL + 工具后缀
npx mcporter call shadcn.io/api/mcp.getComponent component=vortex
```

### 无需配置即可尝试 MCP

```bash
# 直接指向 HTTPS MCP 服务器
npx mcporter list --http-url https://mcp.linear.app/mcp --name linear

# 通过 Bun 运行本地 stdio MCP 服务器
npx mcporter call --stdio "bun run ./local-server.ts" --name local-tools

# 保存配置以便后续使用
npx mcporter list --http-url https://mcp.example.com/mcp --persist config/mcporter.local.json
```

## 常用 MCP 服务器

### Context7（无需认证）

```bash
npx mcporter call context7.resolve-library-id libraryName=react
npx mcporter call context7.get-library-docs context7CompatibleLibraryID=/websites/react_dev topic=hooks
```

### Linear（需要 LINEAR_API_KEY）

```bash
LINEAR_API_KEY=sk_linear_example npx mcporter call linear.search_documentation query="automations"
```

### Chrome DevTools

```bash
# 快照当前标签页
npx mcporter call chrome-devtools.take_snapshot
```

### Vercel（需要 OAuth）

```bash
# 首次认证
npx mcporter auth vercel

# 搜索文档
npx mcporter call vercel.search_vercel_documentation topic=routing
```

## 代码中使用

### 一次性调用

```ts
import { callOnce } from "mcporter";

const result = await callOnce({
  server: "firecrawl",
  toolName: "crawl",
  args: { url: "https://anthropic.com" },
});

console.log(result);
```

### 使用运行时

```ts
import { createRuntime, createServerProxy } from "mcporter";

const runtime = await createRuntime();
const chrome = createServerProxy(runtime, "chrome-devtools");

const snapshot = await chrome.takeSnapshot();
console.log(snapshot.text());

await runtime.close();
```

## 生成 CLI

将任何服务器定义转换为可共享的 CLI 工具：

```bash
# 生成 TypeScript CLI
npx mcporter generate-cli --command https://mcp.context7.com/mcp

# 生成编译后的二进制文件
npx mcporter generate-cli linear --compile

# 从配置中的服务器生成
npx mcporter generate-cli firecrawl --bundle dist/firecrawl.js
```

## 生成类型

```bash
# 仅生成类型
npx mcporter emit-ts linear --out types/linear-tools.d.ts

# 生成客户端包装器
npx mcporter emit-ts linear --mode client --out clients/linear.ts
```

## 配置

配置文件 `config/mcporter.json`：

```json
{
  "mcpServers": {
    "context7": {
      "baseUrl": "https://mcp.context7.com/mcp",
      "headers": {
        "Authorization": "$env:CONTEXT7_API_KEY"
      }
    },
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest"]
    }
  },
  "imports": ["cursor", "claude-code", "claude-desktop", "codex", "windsurf", "opencode", "vscode"]
}
```

### 管理配置

```bash
# 列出配置
npx mcporter config list

# 添加服务器
npx mcporter config add my-server https://api.example.com/mcp

# 移除服务器
npx mcporter config remove my-server

# 导入编辑器配置
npx mcporter config import cursor --copy
```

## Daemon 管理

```bash
# 检查状态
npx mcporter daemon status

# 启动
npx mcporter daemon start

# 停止
npx mcporter daemon stop

# 重启
npx mcporter daemon restart
```

## 常用标志

| 标志 | 说明 |
|------|------|
| `--config <path>` | 自定义配置文件 |
| `--root <path>` | stdio 命令的工作目录 |
| `--log-level <level>` | 日志级别 (debug/info/warn/error) |
| `--oauth-timeout <ms>` | OAuth 浏览器等待时间 |
| `--tail-log` | 流式输出日志文件的最后 20 行 |
| `--output <format>` | 输出格式 (json/raw) |
| `--json` | JSON 格式输出 |
| `--http-url <url>` | 直接指定 HTTP MCP 服务器 |
| `--stdio <cmd>` | 直接指定 stdio 命令 |

## 相关资源

- **GitHub**: https://github.com/steipete/mcporter
- **npm**: https://www.npmjs.com/package/mcporter
- **MCP 规范**: https://github.com/modelcontextprotocol/specification