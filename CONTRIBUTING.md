# 贡献指南

感谢你考虑为 AI Skill Hub 做贡献！

## 🎯 贡献方式

- 📝 提交新技能
- 📚 完善文档
- 🐛 报告 Bug
- 💡 提出新功能建议
- 🔧 改进现有代码

## 📋 提交技能

### 1. Fork 本仓库

点击右上角 `Fork` 按钮

### 2. 创建技能目录

```
skills/[分类]/[技能名]/
├── SKILL.md          # 技能说明（必需）
├── README.md         # 使用指南
├── scripts/          # 脚本文件
└── templates/        # 模板文件
```

### 3. 技能分类

| 分类 | 目录 | 说明 |
|------|------|------|
| 产品与项目管理 | `pm-product/` | 产品需求、项目管理 |
| 开发与编程 | `development/` | 软件开发、代码审查 |
| 设计与界面 | `design/` | UI设计、API设计 |
| 文档与写作 | `documentation/` | 文档写作、知识管理 |
| 数据分析 | `data-analysis/` | 数据分析、可视化 |
| 工具开发 | `tool-development/` | 技能创建、工具开发 |
| Web/API | `web-api/` | Web开发、API设计 |
| 安全与测试 | `security-testing/` | 测试策略、安全验证 |
| AI/机器学习 | `ai-ml/` | ML训练、AI工具 |
| 框架与库 | `frameworks/` | React、Vue等框架 |
| 集成 | `integrations/` | 第三方服务集成 |
| 其他 | `others/` | 其他技能 |

### 4. 提交 Pull Request

1. 提交代码
2. 创建 Pull Request
3. 等待审核

## 📝 代码规范

### 提交消息格式

使用 [Conventional Commits](https://www.conventionalcommits.org/) 格式：

```
<type>(<scope>): <subject>

<body>

<footer>
```

**类型（type）**：
- `feat` - 新功能
- `fix` - Bug 修复
- `docs` - 文档更新
- `style` - 代码格式
- `refactor` - 重构
- `test` - 测试
- `chore` - 构建/工具

**示例**：
```
feat(skill): add git-workflow-management skill
fix(script): resolve skill-stats.py bug
docs(mcp): update mcp-quick-start.md
```

### 代码风格

- 添加必要的注释
- 遵循语言规范
- 保持代码简洁

## 🔍 审核流程

1. **自动检查**（CI/CD）
   - 提交消息格式
   - 文件结构
   - 敏感信息

2. **代码审查**
   - 代码质量
   - 文档完整性
   - 功能正确性

3. **合并到主分支**

## 📚 文档规范

### SKILL.md 模板

```markdown
# 技能名称

> 版本：x.x.x
> 更新时间：YYYY-MM-DD
> 分类：[分类名称]

## 📋 技能概述

[技能简介]

## 🎯 核心功能

- 功能 1
- 功能 2

## 🚀 使用方法

### 安装

\`\`\`bash
# 安装命令
\`\`\`

### 使用

\`\`\`bash
# 使用示例
\`\`\`

## 📁 文件结构

\`\`\`
[技能名]/
├── SKILL.md
├── README.md
├── scripts/
└── templates/
\`\`\`

## 🔄 更新记录

| 版本 | 日期 | 更新内容 |
|------|------|---------|
| x.x.x | YYYY-MM-DD | 初始版本 |
```

## 🐛 报告 Bug

在 [Issues](https://gitee.com/openclaw/ai-skill-hub/issues) 中提交 Bug 报告：

- 描述 Bug
- 复现步骤
- 期望行为
- 环境信息

## 💡 功能建议

在 [Issues](https://gitee.com/openclaw/ai-skill-hub/issues) 中提交功能建议：

- 描述功能
- 使用场景
- 建议方案

## 📧 联系方式

- Issues: https://gitee.com/openclaw/ai-skill-hub/issues
- Pull Requests: https://gitee.com/openclaw/ai-skill-hub/pulls

---

感谢你的贡献！🎉
