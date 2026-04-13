# 👥 多 Agent 协作知识库

> 让多个 AI Agent 协同工作，完成复杂任务

## 概述

本知识库包含多 Agent 协作的完整实现方案，包括：
- 团队组建模式
- 通信协议设计
- 任务协调策略
- 实战案例

## 核心价值

| 单 Agent | 多 Agent 协作 |
|---------|--------------|
| 能力有限 | 专业分工，各司其职 |
| 串行处理 | 并行执行，效率更高 |
| 质量依赖单点 | 多重审查，质量保障 |
| 难以扩展 | 灵活组建，按需扩展 |

## 文档目录

| 文档 | 说明 |
|------|------|
| [团队组建模式](team-patterns.md) | 5 种常用团队模式 |
| [通信协议](communication-protocol.md) | Agent 间通信设计 |
| [任务协调](task-coordination.md) | 任务分配与调度 |
| [案例研究](case-studies.md) | 实战案例详解 |

## 快速开始

### 1. 理解协作模式

```
Coordinator Agent（协调者）
├── Task Planner Agent（任务规划）
├── Research Agent（研究分析）
├── Developer Agent（开发执行）
└── Reviewer Agent（审核检查）
```

### 2. 选择团队模式

| 模式 | 适用场景 | 成员数量 |
|------|---------|---------|
| 代码审查团队 | PR 审查、代码质量 | 4 人 |
| 文档写作团队 | 技术文档、博客 | 4 人 |
| 数据分析团队 | 数据处理、报告 | 4 人 |
| 项目开发团队 | 软件开发 | 5 人 |
| 研究探索团队 | 问题调研、方案设计 | 3 人 |

### 3. 实现协作

```javascript
// 创建团队
const team = new AgentTeam({
  name: 'code-review',
  members: [
    { role: 'analyst', skill: 'code-analysis' },
    { role: 'security', skill: 'security-check' },
    { role: 'performance', skill: 'performance-review' },
    { role: 'reviewer', skill: 'final-review' }
  ],
  workflow: 'parallel' // 或 'sequential'
});

// 运行任务
const result = await team.run(codeToReview);
```

## 协作架构

### 并行模式

```
        ┌─────────────────┐
        │   Coordinator   │
        └────────┬────────┘
                 │ 分发任务
    ┌────────────┼────────────┐
    ▼            ▼            ▼
┌───────┐  ┌───────┐  ┌───────┐
│Agent 1│  │Agent 2│  │Agent 3│
│分析   │  │安全   │  │性能   │
└───┬───┘  └───┬───┘  └───┬───┘
    │          │          │
    └──────────┼──────────┘
               ▼
        ┌─────────────┐
        │   汇总结果   │
        └─────────────┘
```

### 串行模式

```
┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐
│ Research│ → │  Writer │ → │  Editor │ → │Reviewer │
└─────────┘    └─────────┘    └─────────┘    └─────────┘
   研究          写作          编辑          审核
```

## 适用场景

- 🤝 代码审查
- 📝 文档写作
- 📊 数据分析
- 🏗️ 项目开发
- 🔍 研究探索

---

**创建时间**：2026-03-13
**来源**：OpenClaw Agent Team + 实战经验
