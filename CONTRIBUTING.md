# 贡献指南

感谢你考虑为 Agent Academy 做贡献！这是一个 **共建共享** 的知识库，每个人都可以参与。

## 🤝 贡献理念

> **一人贡献，万人受益**

Agent Academy 的目标是建立一个开放的 AI Agent 训练知识库。无论你是：
- 🧑‍💻 **开发者** - 分享你的开发技能和最佳实践
- 📝 **写作者** - 完善文档，翻译内容
- 🤖 **AI 用户** - 贡献你训练 Agent 的经验
- 🏢 **企业团队** - 分享企业级解决方案

你的每一份贡献都会帮助更多人。

## 🎯 贡献方式

| 方式 | 说明 | 难度 | 时间 |
|------|------|------|------|
| 📝 **提交新技能** | 分享你的专业技能 | ⭐⭐ | 30分钟 |
| 📚 **完善文档** | 改进现有文档或翻译 | ⭐ | 10分钟 |
| 🐛 **报告 Bug** | 帮助我们发现和修复问题 | ⭐ | 5分钟 |
| 💡 **提出建议** | 分享你的想法和需求 | ⭐ | 5分钟 |
| 🔧 **改进代码** | 优化现有技能和脚本 | ⭐⭐⭐ | 1小时 |
| 🌍 **翻译内容** | 帮助国际化 | ⭐⭐ | 30分钟 |

## 📤 提交 PR 流程

### 方式一：标准流程

#### 步骤 1：Fork 仓库

1. 访问 [Agent Academy](https://gitee.com/hongmaple/agent-academy)
2. 点击右上角 **Fork** 按钮
3. 选择你的账号作为目标空间

#### 步骤 2：克隆并创建分支

```bash
# 克隆你 Fork 的仓库
git clone https://gitee.com/[你的用户名]/agent-academy.git
cd agent-academy

# 创建功能分支
git checkout -b feature/your-skill-name
```

#### 步骤 3：添加或修改内容

```bash
# 创建技能目录
mkdir -p skills/[分类]/[技能名]

# 创建技能文件
touch skills/[分类]/[技能名]/SKILL.md
```

#### 步骤 4：提交并推送

```bash
# 添加文件
git add .

# 提交（使用规范格式）
git commit -m "feat(skill): add [技能名] skill"

# 推送到你的仓库
git push origin feature/your-skill-name
```

#### 步骤 5：创建 Pull Request

1. 访问你 Fork 的仓库页面
2. 点击 **+ Pull Request** 按钮
3. 选择：
   - 源分支：`[你的用户名]/agent-academy:feature/your-skill-name`
   - 目标分支：`hongmaple/agent-academy:master`
4. 填写 PR 标题和描述
5. 提交 PR 等待审核

### 方式二：让 Agent 帮你提交 PR

告诉你的 AI Agent（如 Claude、ChatGPT、Cursor 等）：

```
请帮我向 Agent Academy 提交一个新技能：

1. 技能名称：[技能名]
2. 技能分类：[从 12 个分类中选择]
3. 技能功能：[功能描述]
4. 使用方法：[使用说明]
5. 我的 Gitee 用户名：[你的用户名]

请按照以下步骤帮我创建 PR：
1. Fork 仓库 https://gitee.com/hongmaple/agent-academy
2. 创建技能文件 skills/[分类]/[技能名]/SKILL.md
3. 提交并发起 Pull Request
```

Agent 会自动帮你完成整个流程！

## 📋 技能分类

| 分类 | 目录 | 说明 | 示例 |
|------|------|------|------|
| 产品与项目管理 | `pm-product/` | 产品需求、项目管理 | 需求分析、Scrum |
| 开发与编程 | `development/` | 软件开发、代码审查 | Git 工作流、代码审查 |
| 设计与界面 | `design/` | UI设计、API设计 | 组件设计、原型设计 |
| 文档与写作 | `documentation/` | 文档写作、知识管理 | Markdown、技术写作 |
| 数据分析 | `data-analysis/` | 数据分析、可视化 | 数据报表、统计分析 |
| 工具开发 | `tool-development/` | 技能创建、工具开发 | 技能模板、调试工具 |
| Web/API | `web-api/` | Web开发、API设计 | REST API、GraphQL |
| 安全与测试 | `security-testing/` | 测试策略、安全验证 | 单元测试、渗透测试 |
| AI/机器学习 | `ai-ml/` | ML训练、AI工具 | 模型训练、Prompt工程 |
| 框架与库 | `frameworks/` | React、Vue等框架 | React Hooks、Vue组件 |
| 集成 | `integrations/` | 第三方服务集成 | GitHub、Slack、Notion |
| 其他 | `others/` | 其他技能 | 工作流优化、团队协作 |

## 📝 技能模板

创建新技能时，请使用以下模板：

```markdown
# [技能名称]

> 版本：1.0.0
> 更新时间：YYYY-MM-DD
> 分类：[分类名称]
> 作者：[你的名字]（可选）

## 📋 技能概述

[一句话描述这个技能的用途]

## 🎯 核心功能

- 功能 1：[描述]
- 功能 2：[描述]
- 功能 3：[描述]

## 🚀 使用方法

### 安装

\`\`\`bash
# 安装命令（如果有）
\`\`\`

### 基础用法

\`\`\`bash
# 使用示例
\`\`\`

### 高级用法

\`\`\`bash
# 高级示例
\`\`\`

## 📁 文件结构

\`\`\`
[技能名]/
├── SKILL.md          # 技能说明（必需）
├── README.md         # 使用指南
├── scripts/          # 脚本文件
│   └── example.sh
└── templates/        # 模板文件
    └── example.md
\`\`\`

## 💡 最佳实践

1. 最佳实践 1
2. 最佳实践 2

## ⚠️ 注意事项

- 注意事项 1
- 注意事项 2

## 🔗 相关资源

- [相关链接 1](URL)
- [相关链接 2](URL)

## 🔄 更新记录

| 版本 | 日期 | 更新内容 |
|------|------|---------|
| 1.0.0 | YYYY-MM-DD | 初始版本 |
```

## 📝 代码规范

### 提交消息格式

使用 [Conventional Commits](https://www.conventionalcommits.org/) 格式：

```
<type>(<scope>): <subject>

<body>

<footer>
```

**类型（type）**：

| 类型 | 说明 | 示例 |
|------|------|------|
| `feat` | 新功能 | feat(skill): add git-workflow skill |
| `fix` | Bug 修复 | fix(script): resolve skill-stats bug |
| `docs` | 文档更新 | docs(mcp): update quick-start guide |
| `style` | 代码格式 | style(skill): format code |
| `refactor` | 重构 | refactor(skill): improve structure |
| `test` | 测试 | test(skill): add unit tests |
| `chore` | 构建/工具 | chore(ci): update workflow |

**示例**：
```
feat(skill): add git-workflow-management skill

- Add commit check script
- Add review checklist
- Add CI workflow configuration

Closes #123
```

### 代码风格

- ✅ 添加必要的注释
- ✅ 遵循语言规范
- ✅ 保持代码简洁
- ✅ 使用 UTF-8 编码
- ❌ 不包含敏感信息

## 🔍 审核流程

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  提交 PR    │ -> │  自动检查   │ -> │  代码审查   │
└─────────────┘    └─────────────┘    └─────────────┘
                         │                   │
                         v                   v
                   ┌─────────────┐    ┌─────────────┐
                   │  检查结果   │    │  审核意见   │
                   └─────────────┘    └─────────────┘
                         │                   │
                         v                   v
                   ┌─────────────┐    ┌─────────────┐
                   │ 通过/失败   │    │ 通过/修改   │
                   └─────────────┘    └─────────────┘
                                            │
                                            v
                                      ┌─────────────┐
                                      │  合并代码   │
                                      └─────────────┘
```

### 自动检查（CI/CD）

| 检查项 | 要求 |
|--------|------|
| 提交消息 | 符合 Conventional Commits 格式 |
| 文件结构 | 遵循技能目录规范 |
| 文档完整 | 包含 SKILL.md，说明清晰 |
| 无敏感信息 | 不包含密钥、密码、私人数据 |

### 代码审查

- 代码质量
- 文档完整性
- 功能正确性
- 最佳实践

## 🔄 保持同步

如果你已经 Fork 了仓库，需要同步最新代码：

```bash
# 添加上游仓库（只需执行一次）
git remote add upstream https://gitee.com/hongmaple/agent-academy.git

# 同步最新代码
git fetch upstream
git checkout master
git merge upstream/master

# 推送到你的仓库
git push origin master
```

## 🐛 报告 Bug

在 [Issues](https://gitee.com/hongmaple/agent-academy/issues) 中提交 Bug 报告：

**模板**：
```markdown
## Bug 描述
[清晰简洁地描述 Bug]

## 复现步骤
1. 步骤 1
2. 步骤 2
3. 步骤 3

## 期望行为
[描述你期望发生什么]

## 实际行为
[描述实际发生了什么]

## 环境信息
- 操作系统：[如 Windows 11]
- Agent 类型：[如 Claude / ChatGPT / Cursor]
- 版本：[如 v1.0.0]

## 截图
[如果适用，添加截图]
```

## 💡 功能建议

在 [Issues](https://gitee.com/hongmaple/agent-academy/issues) 中提交功能建议：

**模板**：
```markdown
## 功能描述
[清晰简洁地描述功能]

## 使用场景
[描述这个功能解决了什么问题]

## 建议方案
[描述你建议的实现方式]

## 替代方案
[描述你考虑过的其他方案]

## 附加信息
[其他相关信息]
```

## 🏢 关联项目

### 🍁 枫琳·人机协作平台

> 让 AI 与人类无缝协作，打造智能化的工作流程

**项目地址**：[https://gitee.com/hongmaple/mapleclaw](https://gitee.com/hongmaple/mapleclaw)

枫琳平台是一个创新的人机协作解决方案，将 Agent Academy 的技能体系应用于实际业务场景。

## 📧 联系方式

- **Issues**: https://gitee.com/hongmaple/agent-academy/issues
- **Pull Requests**: https://gitee.com/hongmaple/agent-academy/pulls
- **主页**: https://gitee.com/hongmaple/agent-academy

## 🙏 致谢

感谢所有贡献者的付出！

---

<div align="center">

**贡献即成长，分享即收获**

Made with ❤️ by [MapleClaw Team](https://gitee.com/hongmaple)

</div>
