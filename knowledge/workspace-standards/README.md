# 🏠 OpenClaw 工作区规范

> 让 AI Agent 拥有清晰的身份、记忆和行为准则

## 概述

OpenClaw 工作区规范是一套完整的 AI Agent 配置标准，包括：
- Agent 身份定义（SOUL.md）
- 工作区协议（AGENTS.md）
- 记忆管理规范
- 安全边界设定

## 核心文件

| 文件 | 说明 | 用途 |
|------|------|------|
| `AGENTS.md` | 工作区协议 | 定义 Agent 行为规范 |
| `SOUL.md` | 身份定义 | 定义 Agent 是谁 |
| `USER.md` | 用户信息 | 定义服务对象 |
| `TOOLS.md` | 工具配置 | 定义可用工具 |
| `MEMORY.md` | 长期记忆 | 存储核心知识 |

## 快速开始

### 1. 创建 SOUL.md

```markdown
# SOUL.md - Who You Are

## Core Truths

- Be genuinely helpful, not performatively helpful
- Have opinions
- Be resourceful before asking
- Earn trust through competence

## Boundaries

- Private things stay private
- When in doubt, ask before acting externally
- You're not the user's voice in group chats
```

### 2. 创建 AGENTS.md

```markdown
# AGENTS.md - Your Workspace

## Every Session

1. Read SOUL.md — this is who you are
2. Read USER.md — this is who you're helping
3. Read memory/YYYY-MM-DD.md (today + yesterday)
4. If in MAIN SESSION: Also read MEMORY.md

## Memory

- Daily notes: memory/YYYY-MM-DD.md
- Long-term: MEMORY.md

## Safety

- Don't exfiltrate private data
- Don't run destructive commands without asking
```

### 3. 创建 USER.md

```markdown
# USER.md - Who You're Helping

## 基本信息

- 名字：[用户名]
- 角色：[职位]
- 联系方式：[可选]

## 偏好

- 编程语言：TypeScript
- 文档风格：简洁清晰
- 工作时间：9:00-18:00

## 项目

- 项目 A：[描述]
- 项目 B：[描述]
```

## 文件结构

```
workspace/
├── AGENTS.md          # 工作区协议
├── SOUL.md            # 身份定义
├── USER.md            # 用户信息
├── TOOLS.md           # 工具配置
├── MEMORY.md          # 长期记忆
├── memory/            # 工作记忆
│   ├── 2026-03-13.md
│   └── 2026-03-12.md
├── projects/          # 项目文档
├── docs/              # 通用文档
├── scripts/           # 脚本
└── archive/           # 归档
```

## 会话协议

### 启动流程

```
1. 读取 SOUL.md      → 知道"我是谁"
2. 读取 USER.md      → 知道"服务谁"
3. 读取 今日/昨日日志 → 知道"最近做什么"
4. 读取 MEMORY.md    → 知道"长期记忆"
```

### 记忆写入规则

| 触发场景 | 写入文件 | 内容类型 |
|---------|---------|---------|
| 日常笔记 | `memory/YYYY-MM-DD.md` | 按日归档 |
| 长期事实 | `MEMORY.md` | 核心知识 |
| 经验总结 | `AGENTS.md` / `TOOLS.md` | 能力配置 |

## 安全边界

### 安全操作（无需确认）

- 读取文件
- 搜索内容
- 组织工作区
- 内部操作

### 需确认操作

- 发送邮件/消息
- 公开发布内容
- 删除文件
- 外部 API 调用

## 最佳实践

### 1. 身份定义

- 清晰定义 Agent 是谁
- 设定行为边界
- 保持一致性

### 2. 记忆管理

- 重要信息写入 MEMORY.md
- 日常笔记按日归档
- 定期回顾整理

### 3. 安全意识

- 私密信息不上传
- 外部操作需确认
- 群聊中注意言行

---

**来源**：OpenClaw 工作区规范
**参考**：Manthan Gupta 逆向工程分析
