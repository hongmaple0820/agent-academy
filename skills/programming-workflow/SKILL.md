---
name: programming-workflow
description: "编程项目全生命周期管理。9阶段流程：需求→产品→UI→架构→开发→测试→验证→部署→运营。支持多Agent协同、进度同步、版本管理。触发词：新项目、项目计划、开发流程、工作流、版本迭代。"
version: "1.1.0"
author: 小琳
created: "2026-03-12"
updated: "2026-03-12"
keywords: [workflow, project-management, development, agile, multi-agent]
---

# 编程项目工作流

> 软件开发项目全生命周期管理，让开发更高效、更规范

## 快速开始

### 新项目启动
```
1. brainstorming      → 探索需求
2. create-prd         → 编写 PRD
3. ui-ux-pro-max      → 设计 UI
4. planning-with-files → 规划开发
5. coding-agent       → 开始开发
```

### 功能迭代
```
分析反馈 → 更新 PRD → 开发 → 测试 → 发布
```

---

## 9 阶段流程

```
需求发掘 → 产品设计 → UI设计 → 架构规划 → 开发部署 → 测试 → 产品验证 → 上线部署 → 运营推广
```

| 阶段 | Skills | 输出物 |
|------|--------|--------|
| 需求 | `brainstorming`, `analyze-feature-requests` | 需求清单 |
| 产品 | `create-prd` | PRD 文档 |
| UI | `ui-ux-pro-max`, `ckm-design` | 设计系统 |
| 架构 | `planning-with-files` | 技术方案 |
| 开发 | `coding-agent` | 功能代码 |
| 测试 | `audit-website` | 测试报告 |
| 验证 | 产品验收 | 验收报告 |
| 部署 | `deploy-to-vercel` | 上线服务 |
| 推广 | `baoyu-post-to-*` | 营销内容 |

---

## 多 Agent 协同

| Agent | 专长 | 职责 |
|-------|------|------|
| 小琳 | 前端/UI | 前端开发、界面设计 |
| 小猪 | 后端/运维 | 后端开发、API设计 |
| 小熊 | 全栈/测试 | 全栈开发、测试 |

---

## 进度同步

- **任务看板**: `tasks/<项目名>.md`
- **每日日志**: `memory/YYYY-MM-DD.md`
- **版本管理**: Git + Tag + CHANGELOG

---

## 质量门禁

### 提交门禁
- ESLint 通过
- TypeScript 无错误

### 发布门禁
- 测试覆盖率 > 80%
- 性能达标 (< 200ms)
- 安全通过

---

## 智能灵活协调

- **阶段并行**: 需求+调研、UI+API、前端+后端
- **阶段跳过**: 小改动简化流程
- **阶段回溯**: 需求变更可回退

---

## 文件结构

```
programming-workflow/
├── SKILL.md              # 本文件
├── WORKFLOW_GUIDE.md     # 完整指南
├── scripts/              # 自动化脚本
│   ├── init-project.sh   # 项目初始化
│   └── sync-progress.sh  # 进度同步
├── templates/            # 文档模板
│   ├── task_plan.md
│   ├── prd-template.md
│   └── test-report.md
├── references/           # 参考资源
│   └── best-practices.md
└── examples/             # 使用示例
    └── mapleclaw-workflow.md
```

## 使用示例

```bash
# 初始化新项目
./scripts/init-project.sh my-project

# 同步进度
./scripts/sync-progress.sh
```

---

## 参考资源

- [Claude Skill 完全构建指南](https://github.com/anthropics/skills)
- [awesome-agent-skills](https://github.com/libukai/awesome-agent-skills)
- [superpowers](https://github.com/obra/superpowers)