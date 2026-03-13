# 🧠 记忆系统知识库

> 让 AI Agent 拥有持久记忆，降低 90% Token 消耗

## 概述

本知识库包含 AI Agent 记忆系统的完整实现方案，包括：
- 四层记忆架构
- QMD 本地语义搜索
- OpenClaw 工作区规范
- 记忆模板和最佳实践

## 核心价值

| 传统方案 | 记忆系统方案 |
|---------|-------------|
| 每次把所有记忆塞进 context | Agent 先检索，只取相关片段 |
| 2000 Token 消耗 | 200 Token 消耗（降低 90%） |
| 大量无关内容干扰 | 精准内容提升准确度 |
| 依赖云端 API | 完全本地运行，零成本 |

## 文档目录

| 文档 | 说明 |
|------|------|
| [四层记忆架构](four-layer-memory.md) | 上下文/会话/工作/长期记忆 |
| [QMD 记忆搜索](qmd-memory-search.md) | 本地语义搜索，Token 降低 90% |
| [OpenClaw 记忆架构](openclaw-memory-architecture.md) | OpenClaw 完整记忆系统 |
| [记忆模板](memory-templates.md) | 可复用的记忆文件模板 |
| [最佳实践](best-practices.md) | 记忆管理最佳实践 |

## 快速开始

### 1. 理解记忆概念

```
Context（上下文）  →  临时、有限、费钱
Memory（记忆）     →  持久、无限、免费
```

### 2. 建立四层架构

```
Layer 1: 上下文记忆 - 当前对话
Layer 2: 会话记忆 - 本次会话
Layer 3: 工作记忆 - 近期记录
Layer 4: 长期记忆 - 核心知识
```

### 3. 使用 QMD 检索

```bash
# 安装 qmd
bun install -g https://github.com/tobi/qmd

# 创建记忆库
qmd collection add memory/*.md --name my-memory
qmd embed my-memory memory/*.md

# 检索
qmd search my-memory "用户偏好" --hybrid
```

## 适用场景

- 🤖 AI Agent 开发
- 📚 知识库建设
- 💬 对话历史管理
- 🔍 语义搜索
- 🧠 记忆持久化

---

**创建时间**：2026-03-13
**来源**：OpenClaw + QMD + 实战经验
