# 🤝 Agent Academy — AI Agent 训练知识库

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Skills](https://img.shields.io/badge/skills-800+-green.svg)](skills/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Stars](https://img.shields.io/badge/dynamic/json?url=https://gitee.com/api/v5/repos/hongmaple/agent-academy&query=stargazers_count&label=stars&color=yellow)](https://gitee.com/hongmaple/agent-academy)

> **给你的 AI 助手办一张"终身学习卡"**  
> 800+ 精选技能 · 四层记忆系统 · 多 Agent 协作 · MCP 全家桶 · 开箱即用

[English](README_EN.md) | 简体中文

---

## ✨ 为什么需要 Agent Academy？

AI 助手本身很聪明，但它们需要"专业训练"才能真正发挥价值。

就像一个高材生刚毕业，没有经过专业培训，很难快速上手业务工作。

**Agent Academy 解决的就是这个问题**——提供系统化的知识、技能和规范，让 AI 助手真正能用、好用。

---

## 🚀 快速开始

### 方式一：一键安装（推荐）

```bash
# Linux / macOS
curl -fsSL https://gitee.com/hongmaple/agent-academy/raw/master/scripts/install.sh | bash

# Windows (PowerShell)
Invoke-WebRequest -Uri "https://gitee.com/hongmaple/agent-academy/raw/master/scripts/install.ps1" -OutFile "install.ps1"; .\install.ps1
```

### 方式二：手动安装

```bash
# 1. 克隆仓库
git clone https://gitee.com/hongmaple/agent-academy.git

# 2. 复制技能库到你的 AI 助手目录
cp -r agent-academy/skills/* ~/.agents/skills/

# 3. 复制工作区配置模板（可选）
cp agent-academy/templates/AGENTS.md ~/your-workspace/AGENTS.md
```

### 激活使用

告诉你的 AI 助手：
```
我已安装 Agent Academy，工作区：~/.agents/
请加载技能库，确认可用的专业技能。
```

---

## 📦 包含什么？

### 🎯 800+ 精选技能

覆盖 12 个专业领域，每个技能都有完整文档和使用示例：

| 领域 | 技能数 | 代表技能 |
|------|--------|---------|
| 开发与编程 | 21+ | Git 工作流、代码审查、部署自动化 |
| AI / 机器学习 | 21+ | 模型训练、Prompt 工程、评估工具 |
| 集成服务 | 28+ | GitHub、Slack、Notion、Figma |
| 设计 | 14+ | UI 规范、API 设计、原型图 |
| 数据分析 | 8+ | 可视化、统计报表、数据清洗 |
| 文档处理 | 4+ | PDF / Word / PPT / Excel |
| 产品管理 | 5+ | PRD、需求分析、迭代规划 |
| 工具开发 | 16+ | 技能创建、脚本自动化 |
| Web / API | 12+ | 接口设计、前端规范 |
| 安全测试 | 10+ | 漏洞扫描、测试策略 |
| 框架与库 | 15+ | React、Vue、Node.js |
| 其他专项 | 20+ | 更多专业场景 |

### 🧠 四层记忆系统

| 层级 | 说明 | 效果 |
|------|------|------|
| 上下文记忆 | 当前对话 | 即时响应 |
| 会话记忆 | 单次会话 | 连贯对话 |
| 工作记忆 | 项目相关 | 理解你的项目 |
| 长期记忆 | 核心知识 | 越用越懂你 |

**QMD 本地语义搜索**：Token 消耗降低 90%，搜索准确率 93%

### 👥 多 Agent 协作

5 种团队模式，效率提升 3-8x：

- **并行模式**：多任务同时处理
- **串行模式**：有依赖的工作流
- **主从模式**：统一调度执行
- **专家模式**：专业角色分工
- **混合模式**：复杂项目组合

### 📡 MCP 完整知识体系

| 文档 | 内容 |
|------|------|
| [快速入门](knowledge/mcp/) | 5 分钟上手 MCP 协议 |
| [工具配置](knowledge/mcp/) | 20+ 工具详细配置 |
| [最佳实践](knowledge/mcp/) | 踩坑总结和避坑指南 |
| [实战案例](knowledge/mcp/) | 11 个真实使用场景 |

### 🌐 浏览器自动化

- Puppeteer（Node.js 环境）
- Playwright（多浏览器支持）
- 自动化测试 / 数据抓取 / 截图 / 表单填写

---

## 📁 目录结构

```
agent-academy/
├── README.md                    # 你正在读的这个文件
├── LICENSE                      # MIT 开源协议
│
├── skills/                      # 🎯 800+ 技能库
│   ├── README.md                # 技能索引与导航
│   ├── development/             # 开发与编程
│   ├── ai-ml/                   # AI 与机器学习
│   ├── integrations/            # 集成服务
│   ├── design/                  # 设计
│   ├── data-analysis/           # 数据分析
│   ├── documentation/           # 文档处理
│   ├── pm-product/              # 产品管理
│   ├── tool-development/        # 工具开发
│   ├── web-api/                 # Web / API
│   ├── security-testing/        # 安全测试
│   ├── frameworks/              # 框架与库
│   ├── others/                  # 其他专项
│   ├── daily-review/            # ⭐ 每日复盘（独立核心技能）
│   ├── programming-workflow/    # ⭐ 编程项目工作流（独立核心技能）
│   ├── project-standards/       # ⭐ 项目规范指南（独立核心技能）
│   └── pm-skills/               # ⭐ 产品经理技能包（65个，自成体系）
│
├── knowledge/                   # 📚 知识库
│   ├── INDEX.md                 # 知识库导航入口
│   ├── mcp/                     # MCP 知识体系（8篇核心文档）
│   ├── guides/                  # 使用指南
│   └── workflow/                # 工作流文档
│
├── templates/                   # 📋 模板文件
│   ├── AGENTS.md                # 工作区配置模板（必备）
│   ├── SOUL.md                  # AI 身份定义模板
│   └── MEMORY.md                # 长期记忆模板
│
├── scripts/                     # 🔧 自动化脚本
│   ├── install.sh               # 一键安装（Linux/macOS）
│   ├── install.ps1              # 一键安装（Windows）
│   └── skill-stats.py           # 技能统计工具
│
└── docs/                        # 📖 文档中心
    ├── push-guide.md            # 推送指南
    └── articles/                # 推广文章
```

---

## 📖 必读文档

| 文档 | 说明 | 重要性 |
|------|------|--------|
| [知识库导航](knowledge/INDEX.md) | 知识库核心导航入口 | ⭐⭐⭐⭐⭐ |
| [MCP 快速入门](knowledge/mcp/) | 5 分钟上手 MCP 协议 | ⭐⭐⭐⭐⭐ |
| [贡献指南](CONTRIBUTING.md) | 如何向社区贡献技能 | ⭐⭐⭐⭐ |
| [英文版说明](README_EN.md) | English documentation | ⭐⭐⭐ |

---

## 🤝 如何贡献？

Agent Academy 是一个社区共建项目，欢迎所有人参与！

### 贡献方式

| 方式 | 难度 | 说明 |
|------|------|------|
| 📝 提交新技能 | ⭐⭐ | Fork → 创建技能目录 → 提交 PR |
| 📚 完善文档 | ⭐ | 改进说明、补充示例、翻译 |
| 🐛 报告问题 | ⭐ | 在 Issues 中描述问题 |
| 💡 提出建议 | ⭐ | 分享你的想法和需求 |

### 技能提交规范

```
skills/[分类]/[技能名]/
├── SKILL.md      # 技能说明（必需）
├── README.md     # 使用指南（推荐）
├── scripts/      # 脚本文件（可选）
└── templates/    # 模板文件（可选）
```

详细说明：[贡献指南](CONTRIBUTING.md)

---

## 📊 当前状态

| 指标 | 数量 | 趋势 |
|------|------|------|
| 技能总数 | **800+** | 持续增长 |
| 覆盖领域 | **12 个** | 稳定 |
| 知识文档 | **70+ 篇** | 持续完善 |
| 贡献者 | **3+** | 招募中 |
| 代码行数 | **430,000+** | 持续增长 |

---

## 🌐 多平台地址

| 平台 | 地址 |
|------|------|
| **Gitee**（推荐国内） | https://gitee.com/hongmaple/agent-academy |
| **GitHub**（国际） | https://github.com/hongmaple0820/agent-academy |
| **GitCode** | https://gitcode.com/maple168/agent-academy |

---

## 🔗 关联项目

**🍁 枫琳·人机协作平台**  
一个真实运行的多 AI 协作系统，Agent Academy 从这个项目的实战中提炼而来。  
地址：https://gitee.com/hongmaple/mapleclaw

---

## 📄 开源协议

[MIT License](LICENSE) — 自由使用、修改、分发。

---

<div align="center">

**如果这个项目对你有帮助，请给一个 Star ⭐**

它是对开源最好的鼓励。

Made with ❤️ by [MapleClaw Team](https://gitee.com/hongmaple)

</div>
