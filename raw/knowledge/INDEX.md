# 📚 Agent Academy — 知识库导航中心

> **最后更新：2026-03-23**  
> **文档总数：70+ 篇 | 技能总数：800+ | 代码行数：430,000+**

---

## 🚀 新成员快速入门路径

按顺序阅读，循序渐进：

| 天数 | 必读文档 | 核心收获 |
|------|---------|---------|
| Day 1 | [技能使用示例](../skills/examples/README.md) | 了解如何智能灵活地加载和使用技能 |
| Day 2 | [Agent 学习系统](guide-agent-learning-system-v1.md) | 理解错误学习、经验复用的方法论 |
| Day 3 | [MCP 快速入门](mcp/) | 学会让 AI 连接数据库、文件系统、API |
| Day 4 | [代码模式库](guide-coding-patterns-v1.md) | 掌握可复用的代码模板和最佳实践 |
| Day 5+ | 按任务需求 | 根据工作场景选择对应技能 |

---

## 📁 目录结构

```
knowledge/
├── INDEX.md              ← 你在这里
├── mcp/                  # MCP 知识体系（8篇核心文档）
├── guides/               # 操作指南
├── workflow/             # 工作流文档
├── browser-automation/   # 浏览器自动化
├── memory-systems/       # 记忆系统
├── multi-agent/          # 多 Agent 协作
└── workspace-standards/  # 工作区规范
```

---

## 🗂️ 核心文档索引

### 📡 MCP 知识体系

> MCP（Model Context Protocol）让 AI 能够连接数据库、操作文件、调用 API

| 文档 | 说明 |
|------|------|
| [README](mcp/) | MCP 知识体系总览 |
| [快速入门](mcp/) | 5 分钟上手 MCP，从零到运行 |
| [内置工具参考](mcp/) | 所有内置 MCP 工具的使用手册 |
| [工具配置指南](mcp/) | 20+ 第三方工具的详细配置 |
| [最佳实践](mcp/) | 踩坑总结和架构设计建议 |
| [实战案例](mcp/) | 11 个真实场景案例 |
| [故障排查](mcp/) | 常见问题和解决方案 |

---

### 🧠 AI 能力提升

| 文档 | 说明 |
|------|------|
| [Agent 学习系统](guide-agent-learning-system-v1.md) | 错误学习、经验复用、自主决策方法论 |
| [代码模式库](guide-coding-patterns-v1.md) | 可复用的代码模板和最佳实践 |
| [错误模式库](guide-error-patterns-v1.md) | 常见错误类型和解决方案汇总 |
| [技能索引指南](guide-skills-index-v1.md) | 所有可用技能和工具清单 |
| [复合工程指南](guide-compound-engineering-v1.md) | 复杂工程问题的分解策略 |
| [**开发工作流规范**](guide-development-workflow-v1.md) | Zero-Bug Delivery 四阶段工作流、契约先行、禁止行为清单 |

---

### 🏗️ 工作流

| 文档 | 说明 |
|------|------|
| [通用项目工作流](workflow/SKILL.md) | 标准项目工作流程 |
| [对比测试方案](workflow/comparison-test.md) | A/B 测试和方案对比方法 |
| [自动化沉淀脚本](workflow/scripts/compound.sh) | 知识自动化提炼工具 |

---

### 🌐 浏览器自动化

| 文档 | 说明 |
|------|------|
| [browser-automation/](browser-automation/) | Puppeteer / Playwright 使用指南 |

---

### 🧩 记忆系统

| 文档 | 说明 |
|------|------|
| [memory-systems/](memory-systems/) | 四层记忆架构设计与实现 |

---

### 👥 多 Agent 协作

| 文档 | 说明 |
|------|------|
| [multi-agent/](multi-agent/) | 多 Agent 协作模式和规范 |

---

### 📋 工作区规范

| 文档 | 说明 |
|------|------|
| [workspace-standards/](workspace-standards/) | AGENTS.md / SOUL.md / MEMORY.md 配置规范 |

---

## 📦 技能使用示例

| 示例 | 说明 |
|------|------|
| [示例库说明](../skills/examples/README.md) | 所有示例概览 |
| [每日复盘示例](../skills/examples/daily-review/example-session.md) | 完整复盘对话示例 |
| [Git 分支管理示例](../skills/examples/git-workflow/branch-management.md) | 分支管理最佳实践 |
| [Playwright 自动化示例](../skills/examples/playwright-skill/automation-examples.md) | 浏览器自动化案例 |
| [PRD 写作示例](../skills/examples/pm-skills/prd-writing-example.md) | 产品需求文档范例 |
| [项目初始化示例](../skills/examples/programming-workflow/project-init-example.md) | 新项目启动流程 |
| [TDD 流程示例](../skills/examples/tdd/tdd-flow-example.md) | 测试驱动开发示例 |
| [写作技能示例](../skills/examples/writing-skills/writing-examples.md) | 各类写作场景示例 |

---

## 🔍 搜索文档

### 命令行搜索

```bash
# 按关键词全文搜索
rg "关键词" ./knowledge/

# 只显示文件名
rg -l "关键词" ./

# 搜索特定文件类型
rg "关键词" --type md ./
```

### 文档命名规范

格式：`<类型>-<主题>-<版本>.md`

| 前缀 | 含义 |
|------|------|
| `guide-` | 操作指南，step-by-step |
| `architecture-` | 架构设计文档 |
| `reference-` | 参考文档，快速查阅 |
| `plan-` | 规划和计划 |

---

## 🔄 知识库更新流程

### 添加新文档

1. 按命名规范创建文件
2. 在本 INDEX.md 对应分类中添加索引
3. 提交到 Git

```bash
git add .
git commit -m "docs: 添加 XXX 指南"
git push origin master
```

### 更新现有文档

1. 修改文件内容
2. 更新文件头部的"最后更新"日期
3. 提交到 Git

---

*索引版本：v4.1*  
*最后更新：2026-03-23*  
*维护者：MapleClaw Team*
