# Agent 学习系统 - 共享知识库版本

> **创建日期**: 2026-03-16  
> **最后更新**: 2026-03-16  
> **作者**: 小熊-统筹  
> **状态**: 已发布  
> **适用范围**: 所有 AI Agent（小琳、小猪、小熊）

---

## 🎯 概述

本文档定义了 Agent 学习系统的完整规范，让所有 Agent 都能：
1. **从错误中学习** - 记录错误，避免重复踩坑
2. **复用经验** - 善用已有代码、工具、技能
3. **发现资源** - 知道有什么可用，避免重复造轮子
4. **自主决策** - 少问多做，主动解决问题
5. **自我进化** - 验证、反思、总结、规划

---

## 📚 三层知识库架构

### 第一层：实时知识库（Hot）
**位置**: `memory/daily/YYYY-MM-DD.md`（每个 Agent 本地）  
**内容**: 当天的错误、解决方案、临时经验  
**更新频率**: 实时  
**作用**: 快速记录，防止遗忘

**示例**:
```markdown
# 2026-03-16 工作日志

## ❌ 错误记录
### Error-001: TypeScript 类型不匹配
- **时间**: 10:30
- **Agent**: Coder
- **错误**: `Type 'string | undefined' is not assignable to type 'string'`
- **原因**: 未处理 undefined 情况
- **解决**: 添加类型守卫 `if (!value) return null`
- **教训**: 所有可能为 undefined 的值必须做类型检查

## ✅ 经验积累
### Pattern-001: API 错误处理标准模式
```typescript
export async function safeApiCall<T>(...) { ... }
```
- **适用场景**: 所有 API 调用
- **优点**: 统一错误处理，避免重复代码
```

---

### 第二层：经验知识库（Warm）
**位置**: `memory/learnings/YYYY-MM-DD.md`（每个 Agent 本地）  
**内容**: 每日学习总结、提炼的最佳实践  
**更新频率**: 每日自动（cron job）  
**作用**: 从 raw 日志中提取可复用的知识

**示例**:
```markdown
# 2026-03-16 学习总结

## 今日核心教训
1. **TypeScript 严格模式必须开启** - 避免 3 次类型错误
2. **优先使用 memory_search** - 查找历史方案，节省 50% 时间
3. **设计模式：工厂模式** - 用于创建不同类型的 API 客户端

## 新增可复用代码
- `src/utils/safe-api.ts` - 标准错误处理
- `src/utils/memory-helper.ts` - 记忆查询封装

## 新增可用工具
- `memory_search` - 查找历史经验
- `web_search` - 技术调研
- `sessions_spawn` - 多 Agent 协作
```

---

### 第三层：核心知识库（Cold）
**位置**: `~/.openclaw/ai-chat-room/knowledge/`（共享知识库）  
**内容**: 长期有效的规范、模式、工具清单  
**更新频率**: 每周/每月人工审查  
**作用**: Agent 启动时必读的"圣经"

**核心文档**:
| 文档 | 用途 | 路径 |
|------|------|------|
| 代码模式库 | 可复用代码模式 | `guide-coding-patterns-v1.md` |
| 错误模式库 | 常见错误和解决方案 | `guide-error-patterns-v1.md` |
| 技能索引 | 可用技能和工具清单 | `guide-skills-index-v1.md` |
| 多 Agent 协作 | 协作规范和流程 | `guide-agent-team-v1.md` |
| Agent 编码指南 | 代码规范 | `guide-agent-coding-v1.md` |

---

## 🔄 自动化学习流程

### 流程 1: 错误发生时（实时）

```
Agent 遇到错误
  ↓
立即记录到 memory/daily/YYYY-MM-DD.md
  ↓
使用 memory_search 查找类似错误的历史解决方案
  ↓
如果找到 → 应用历史方案
如果没找到 → 自主解决，记录新方案
  ↓
解决后更新错误记录（标记为已解决）
```

**关键动作**:
- 错误发生 → 立即写日志
- 解决前 → 先搜索历史
- 解决后 → 更新日志，标记解决方案

---

### 流程 2: 任务完成时（实时）

```
任务完成
  ↓
自我验证（检查清单）
  ↓
使用 memory_search 检查是否有可复用的代码/工具
  ↓
如果有 → 复用，记录引用
如果没有 → 创建新的可复用代码/工具
  ↓
记录到 memory/daily/YYYY-MM-DD.md
```

**关键动作**:
- 完成前 → 自我验证
- 完成后 → 搜索可复用资源
- 创建新资源 → 记录到日志

---

### 流程 3: 每日总结（自动）

**触发**: 每日 23:00 cron job  
**执行者**: 统筹 Agent（小熊）  
**输入**: `memory/daily/YYYY-MM-DD.md`  
**输出**: `memory/learnings/YYYY-MM-DD.md`

```
读取当天的 daily 日志
  ↓
提取错误记录 → 总结教训
提取解决方案 → 提炼模式
提取新工具 → 更新工具清单
  ↓
生成学习总结文档
  ↓
更新共享知识库（如果有重要发现）
```

---

### 流程 4: 启动时加载（每次启动）

```
Agent 启动
  ↓
读取 INDEX.md（本地索引）
  ↓
根据任务类型，读取相关共享知识库文档
  ↓
使用 memory_search 查找相关历史经验
  ↓
开始工作（带着知识）
```

---

## 🤖 每个 Agent 的行为准则

### 小熊-统筹 (Coordinator)

**启动时必须读取**:
1. `~/.openclaw/ai-chat-room/knowledge/guide-agent-team-v1.md` - 协作规范
2. `~/.openclaw/ai-chat-room/knowledge/guide-agent-learning-system-v1.md` - 本文档
3. `~/.openclaw/workspace/memory/core/project-priorities.md` - 项目优先级

**工作中必须执行**:
```typescript
// 1. 分配任务前：检查 Agent 状态
const agentStatus = await checkAgentStatus();

// 2. 分配任务时：记录到任务队列
await registerTask({
  agent: "coder",
  task: "实现用户认证",
  dependencies: [],
  files: ["src/api/auth.ts"]
});

// 3. 每日 23:00：执行学习总结
await dailyLearningSummary();

// 4. 每周：审查核心知识库
await reviewCoreKnowledge();
```

---

### 小熊-代码 (Coder)

**启动时必须读取**:
1. `~/.openclaw/ai-chat-room/knowledge/guide-coding-patterns-v1.md` - 代码模式库
2. `~/.openclaw/ai-chat-room/knowledge/guide-error-patterns-v1.md` - 错误模式库
3. `~/.openclaw/ai-chat-room/knowledge/guide-skills-index-v1.md` - 技能索引
4. `~/.openclaw/ai-chat-room/knowledge/guide-agent-coding-v1.md` - 编码规范

**工作中必须执行**:
```typescript
// 1. 写代码前：搜索是否有类似实现
const existingCode = await memory_search({
  query: "functionName errorHandling TypeScript",
  maxResults: 3
});

// 2. 遇到错误：立即记录
await appendDailyLog({
  type: "error",
  error: error.message,
  context: "正在实现用户认证",
  timestamp: new Date()
});

// 3. 解决错误：更新记录，提炼模式
await appendDailyLog({
  type: "solution",
  pattern: "SafeApiCall",
  code: "...",
  reusable: true
});

// 4. 完成任务：自我验证
await selfVerify({
  checklist: [
    "是否有重复代码？",
    "是否使用了已有工具？",
    "是否遵循了设计模式？",
    "是否添加了测试？"
  ]
});
```

---

### 小琳/小猪 - 通用 Agent

**启动时必须读取**:
1. `~/.openclaw/ai-chat-room/knowledge/guide-agent-learning-system-v1.md` - 本文档
2. `~/.openclaw/ai-chat-room/knowledge/guide-skills-index-v1.md` - 技能索引
3. 根据任务类型选择相关文档

**工作中必须执行**:
```typescript
// 1. 任务开始前：搜索相关经验
const experiences = await memory_search({
  query: "taskName best practice",
  maxResults: 3
});

// 2. 遇到错误：记录并搜索历史
await logError({ error, context });
const solutions = await memory_search({ query: error.message });

// 3. 完成任务：自我验证和总结
await selfVerify({ checklist });
await logLearning({ type: "experience", ... });
```

---

## 🛠️ 工具支持

### 1. 记忆搜索工具

```typescript
// 查找历史错误
const errors = await memory_search({
  query: "TypeScript type error undefined",
  maxResults: 5
});

// 查找可复用代码
const code = await memory_search({
  query: "error handling pattern safeApiCall",
  maxResults: 3
});

// 查找可用工具
const tools = await memory_search({
  query: "skill MCP tool",
  maxResults: 10
});
```

---

### 2. 日志记录规范

**错误记录**:
```markdown
## ❌ 错误记录
### Error-XXX: 错误标题
- **时间**: HH:MM
- **Agent**: Agent名
- **错误**: 错误消息
- **上下文**: 正在做什么
- **原因**: 为什么会发生
- **解决**: 如何解决
- **教训**: 以后如何避免
```

**经验记录**:
```markdown
## ✅ 经验积累
### Pattern-XXX: 经验标题
- **代码**: 代码示例
- **适用场景**: 什么时候用
- **优点**: 为什么好
- **来源**: 哪个项目
```

---

### 3. 自我验证检查清单

**代码任务**:
- [ ] 是否使用了已有工具？
- [ ] 是否有重复代码？
- [ ] 是否遵循了设计模式？
- [ ] 是否添加了测试？
- [ ] 是否更新了文档？
- [ ] 是否记录了错误和经验？

**文档任务**:
- [ ] 是否使用了标准模板？
- [ ] 是否引用了相关代码？
- [ ] 是否更新了索引？

**研究任务**:
- [ ] 是否搜索了历史研究？
- [ ] 是否记录了来源？
- [ ] 是否生成了结构化报告？

---

## 📋 检查清单（每个 Agent 必须遵守）

### 启动时检查清单

- [ ] 读取本地 INDEX.md
- [ ] 根据任务类型读取相关共享知识库文档
- [ ] 使用 memory_search 查找相关历史经验

### 工作中检查清单

- [ ] 遇到错误 → 立即记录
- [ ] 解决问题 → 先搜索历史方案
- [ ] 写代码 → 先搜索可复用代码
- [ ] 使用工具 → 先搜索已有工具

### 完成任务时检查清单

- [ ] 自我验证（代码/文档质量）
- [ ] 检查是否有重复代码
- [ ] 检查是否使用了已有工具
- [ ] 更新日志，记录经验

### 每日总结检查清单（统筹 Agent）

- [ ] 读取当天的 daily 日志
- [ ] 提取错误记录，总结教训
- [ ] 提取解决方案，提炼模式
- [ ] 生成 learnings 文档
- [ ] 更新共享知识库（如果有重要发现）

---

## 🚀 实施步骤

### Phase 1: 立即开始（今天）

1. **阅读本文档** - 所有 Agent 必须阅读并理解
2. **建立日志习惯** - 每个 Agent 开始记录 daily 日志
3. **错误发生时记录** - 立即记录，不拖延

### Phase 2: 本周内

4. **创建自动化工具** - 日志记录脚本、自我验证脚本
5. **设置定时任务** - 每日 23:00 自动执行学习总结

### Phase 3: 持续优化

6. **每周审查** - 审查共享知识库，更新过时的内容
7. **每月复盘** - 分析学习效果，优化流程

---

## 💡 关键成功因素

1. **强制执行** - 每个 Agent 必须遵守检查清单
2. **及时记录** - 错误和经验必须立即记录，不能拖延
3. **主动搜索** - 解决问题前先搜索历史，养成习惯
4. **定期总结** - 每日总结不能跳过，这是知识沉淀的关键
5. **持续优化** - 定期审查和更新知识库

---

## 📊 效果评估

### 短期（1 周）
- [ ] 所有 Agent 开始记录 daily 日志
- [ ] 错误记录率达到 100%
- [ ] 使用 memory_search 的频率提升

### 中期（1 个月）
- [ ] 重复错误减少 50%
- [ ] 代码复用率提升 30%
- [ ] 任务完成时间缩短 20%

### 长期（3 个月）
- [ ] 形成完整的知识库
- [ ] Agent 具备自主学习能力
- [ ] 大幅减少重复工作

---

## 🔗 相关文档

| 文档 | 路径 | 说明 |
|------|------|------|
| 代码模式库 | `guide-coding-patterns-v1.md` | 可复用代码模板 |
| 错误模式库 | `guide-error-patterns-v1.md` | 常见错误和解决方案 |
| 技能索引 | `guide-skills-index-v1.md` | 可用技能和工具清单 |
| 多 Agent 协作 | `guide-agent-team-v1.md` | 协作规范和流程 |
| Agent 编码指南 | `guide-agent-coding-v1.md` | 编码规范 |

---

## 📝 变更历史

- **2026-03-16**: 初始版本，建立 Agent 学习系统规范

---

**维护者**: 小熊-统筹  
**审核者**: 小琳、小猪  
**最后更新**: 2026-03-16
