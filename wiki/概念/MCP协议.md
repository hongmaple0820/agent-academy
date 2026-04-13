# MCP（模型上下文协议）

Model Context Protocol — 开放协议，让 LLM 通过标准化接口与外部工具、数据源和服务交互。

## 核心架构

```
AI 应用层 (Chat-Hub / Claude)
    │
    ▼
MCP 协议层 (标准化工具调用、资源访问、提示词管理)
    │
┌───┼───┐
▼   ▼   ▼
MCP MCP MCP
服务器 服务器 服务器
```

## 关键概念

- **MCP 服务器**：独立进程，通过 stdio 或 HTTP/SSE 提供工具能力
- **工具 (Tools)**：AI 可执行的操作单元（如 `sqlite_query`、`github_search`）
- **资源 (Resources)**：数据访问接口（文件、数据库、API）
- **提示词 (Prompts)**：预定义模板，快速构建 AI 交互

## 工具生态（20+ 工具）

| 类别 | 示例 |
|------|------|
| 内置 | chrome-devtools, context7, fetch, memory, sequential-thinking, time, mem0 |
| 官方 | SQLite, GitHub, Filesystem, Brave Search, Puppeteer |
| 社区 | Figma, Redis, PostgreSQL, MongoDB, Slack, Notion, Google Drive, Docker, AWS, Stripe |

## 学习路径

- **初学者**：快速入门 → 体验工具 → 配置方法 → 故障排除
- **开发者**：协议规范 → 最佳实践 → 实际案例 → 开发自己的 MCP 服务器
- **架构师**：系统设计 → 企业级集成 → 安全体系 → 性能优化

## Related

- [[Agent技能体系]] — MCP 本身也是一种技能类别
- [[Agent学习系统]] — Agent 如何学习和使用 MCP 工具

---
- **Source**: `raw/knowledge/mcp/README.md` + 7 篇配套文档
- **Updated**: 2026-04-13
