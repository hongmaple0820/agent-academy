# 🎓 Agent Academy - AI Agent 训练学院

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Skills](https://img.shields.io/badge/skills-800+-green.svg)](skills/)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

> **训练、培养、共享** - 一个用于训练和培养 AI Agent 的共享知识库

## 📖 项目简介

**Agent Academy** 是一个开源的 AI Agent 训练知识库，致力于为 AI 助手（如 OpenClaw、Claude、ChatGPT 等）提供结构化的技能体系和知识资源。

就像人类需要在学校学习各种技能一样，AI Agent 也需要一个"学院"来获取知识、提升能力。Agent Academy 正是这样一个知识宝库，包含了软件开发、产品设计、数据分析、AI/ML 等 12 个领域的 800+ 精选技能，以及完整的 MCP（Model Context Protocol）知识体系。

### 🎯 核心价值

| 价值 | 说明 |
|------|------|
| **训练** | 提供结构化的技能和知识，让 Agent 快速学习特定领域的能力 |
| **培养** | 持续的知识更新和最佳实践，帮助 Agent 不断成长进化 |
| **共享** | 开源社区协作，知识互通，让每个人都能贡献和受益 |

### 💡 使用场景

- **个人开发者**：为你的 AI 助手配置专业技能，提升工作效率
- **团队协作**：建立团队共享知识库，保持 AI 助手能力一致
- **企业用户**：私有部署，定制化训练企业专属 AI 助手
- **开源社区**：贡献技能，分享知识，共同建设 AI 生态

## ✨ 特性

- 📦 **800+ 精选技能** - 覆盖开发、设计、数据分析等 12 个领域
- 📚 **MCP 知识体系** - 完整的 Model Context Protocol 文档和最佳实践
- 🔄 **CI/CD 集成** - 自动化统计、验证、发布流程
- 🚀 **快速开始** - 一键安装，开箱即用
- 🤝 **社区驱动** - 开源协作，持续更新

## 📦 安装

### 方式一：克隆仓库

```bash
# 克隆仓库
git clone https://gitee.com/hongmaple/agent-academy.git

# 安装技能到你的 AI 助手
cp -r agent-academy/skills/* ~/.agents/skills/
```

### 方式二：选择性安装

```bash
# 只安装特定分类的技能
cp -r agent-academy/skills/development ~/.agents/skills/
cp -r agent-academy/skills/ai-ml ~/.agents/skills/
```

## 🚀 快速开始

1. **浏览技能**：查看 [技能索引](skills/README.md) 了解可用技能
2. **学习 MCP**：阅读 [MCP 知识库](knowledge/mcp/README.md) 掌握工具集成
3. **配置使用**：参考 [使用指南](docs/usage.md) 配置你的 AI 助手
4. **贡献技能**：参考 [贡献指南](CONTRIBUTING.md) 参与社区建设

## 📚 文档

| 文档 | 说明 |
|------|------|
| [技能索引](skills/README.md) | 800+ 技能完整列表和分类 |
| [MCP 快速入门](knowledge/mcp/mcp-quick-start.md) | 5 分钟上手 MCP 工具 |
| [MCP 最佳实践](knowledge/mcp/mcp-best-practices.md) | MCP 开发和使用指南 |
| [MCP 工具配置](knowledge/mcp/mcp-tools-configuration.md) | 20+ 工具配置手册 |
| [贡献指南](CONTRIBUTING.md) | 如何参与项目贡献 |

## 📂 目录结构

```
agent-academy/
├── skills/              # 技能库（800+ 技能）
│   ├── pm-product/      # 产品与项目管理类（5个）
│   ├── development/     # 开发与编程类（21个）
│   ├── design/          # 设计与界面类（14个）
│   ├── documentation/   # 文档与写作类（5个）
│   ├── data-analysis/   # 数据分析类（8个）
│   ├── tool-development/# 工具开发类（16个）
│   ├── web-api/         # Web/API 开发类
│   ├── security-testing/# 安全与测试类（3个）
│   ├── ai-ml/           # AI/机器学习类（21个）
│   ├── frameworks/      # 框架与库类（4个）
│   ├── integrations/    # 集成类（28个）
│   └── others/          # 其他技能（29个）
├── knowledge/           # 知识库
│   ├── mcp/            # MCP 知识体系（8个文档）
│   └── guides/         # 使用指南
├── templates/          # 模板文件
├── scripts/            # 自动化脚本
├── .github/            # CI/CD 配置
└── docs/               # 文档站点
```

## 🤝 贡献

我们欢迎所有形式的贡献！

### 贡献方式

- 📝 **提交新技能** - 分享你的专业技能
- 📚 **完善文档** - 改进现有文档或翻译
- 🐛 **报告 Bug** - 帮助我们发现和修复问题
- 💡 **提出建议** - 分享你的想法和需求
- 🔧 **改进代码** - 优化现有技能和脚本

详见 [贡献指南](CONTRIBUTING.md)

## 📊 统计

| 指标 | 数量 |
|------|------|
| 技能总数 | 800+ |
| 分类数量 | 12 |
| MCP 文档 | 8 |
| CI/CD 工作流 | 4 |
| 代码行数 | 430,000+ |

## 🏢 关联项目

### 🍁 枫琳·人机协作平台

> 让 AI 与人类无缝协作，打造智能化的工作流程

**项目地址**：[https://gitee.com/hongmaple/mapleclaw](https://gitee.com/hongmaple/mapleclaw)

枫琳平台是一个创新的人机协作解决方案，将 Agent Academy 的技能体系应用于实际业务场景，实现：
- 🤖 智能任务分配与执行
- 📊 自动化工作流程
- 🔄 人机协同决策
- 📈 持续学习与优化

---

## 👥 作者

| 角色 | 信息 |
|------|------|
| **组织** | MapleClaw Team |
| **维护者** | 小琳、小猪、小熊 |
| **联系方式** | [Gitee Issues](https://gitee.com/hongmaple/agent-academy/issues) |

## 📄 许可证

[MIT License](LICENSE) - 可自由使用、修改和分发

---

<div align="center">

**⭐ 如果这个项目对你有帮助，请给一个 Star ⭐**

Made with ❤️ by [MapleClaw Team](https://gitee.com/hongmaple)

[🏠 主页](https://gitee.com/hongmaple/agent-academy) · [📖 文档](docs/) · [🐛 反馈](https://gitee.com/hongmaple/agent-academy/issues) · [🤝 贡献](CONTRIBUTING.md)

</div>
