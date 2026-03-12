# 编程项目工作流最佳实践

> 基于实战经验总结的工作流最佳实践

---

## 一、阶段执行原则

### 1. 智能灵活协调

**阶段并行**:
- 需求整理 + 技术调研 → 同时进行
- UI 设计 + API 设计 → 并行开发
- 前端开发 + 后端开发 → 并行实现

**阶段跳过**:
- 小改动: 需求 → 开发 → 测试 → 上线
- Bug 修复: 开发 → 测试 → 发布

**阶段回溯**:
- 需求变更 → 回到需求整理阶段
- 设计问题 → 回到 UI 设计阶段

### 2. 质量门禁

**提交门禁**:
```bash
npm run lint      # ESLint 检查
npm run typecheck # TypeScript 检查
npm test          # 单元测试
```

**发布门禁**:
- 测试覆盖率 > 80%
- API 响应 < 200ms
- 无高危安全漏洞

---

## 二、多 Agent 协同

### 角色分工

| Agent | 技能 | 负责模块 |
|-------|------|----------|
| 小琳 | 前端/UI | Vue/React 组件、样式、交互 |
| 小猪 | 后端/运维 | API、数据库、部署 |
| 小熊 | 全栈/测试 | 全栈功能、测试框架 |

### 协作通信

**Git 工作流**:
```
master ← dev ← feat-<agent>-<feature>-<version>
```

**消息格式**:
```
@<Agent> <任务描述>

示例:
@小琳 请完成登录页面 UI
@小猪 需要新增用户 API
```

### 冲突避免

- 文件名区分: `xiaolin-xxx.ts`, `xiaozhu-xxx.ts`
- 模块目录区分: `modules/frontend/`, `modules/backend/`
- 及时同步: 每日下班前提交代码

---

## 三、进度同步机制

### 任务看板规范

```markdown
# 任务看板

## 📋 待办
- [ ] 任务1 (P0) - 负责人 - 截止日期

## 🔄 进行中
- [ ] 任务2 (P0) - 小琳 - 预计: 2026-03-15

## ✅ 完成
- [x] 任务3 (P1) - 小猪 - 完成于: 2026-03-12

## ❌ 阻塞
- [ ] 任务4 (P2) - 小琳 - 原因: 等待设计确认
```

### 每日日志规范

```markdown
# 2026-03-12 今日记录

## 完成任务
- [x] TypeScript 迁移完成
- [x] API 接口开发

## 进行中
- [ ] 前端页面开发 (进度 60%)

## 问题与阻塞
- Redis 连接不稳定

## 明日计划
- 完成前端页面
- 开始集成测试
```

---

## 四、版本迭代管理

### 版本号规范

- MAJOR: 重大更新，不兼容变更
- MINOR: 功能新增，向后兼容
- PATCH: Bug 修复，向后兼容

### Git 分支策略

```
master (生产)
  ↑
dev (开发)
  ↑
feat-<agent>-<feature>-<version>
```

### 提交信息规范

```
<type>(<scope>): <subject>

type: feat | fix | docs | style | refactor | test | chore
scope: 模块名
subject: 简短描述
```

---

## 五、测试与发布

### 测试清单

- [ ] 单元测试通过
- [ ] 集成测试通过
- [ ] E2E 测试通过
- [ ] 性能测试达标
- [ ] 安全测试通过

### 发布清单

- [ ] 版本号更新
- [ ] CHANGELOG 更新
- [ ] 文档更新
- [ ] 部署配置确认
- [ ] 回滚方案准备

---

## 六、常用 Skills 组合

### 新功能开发
```
brainstorming → create-prd → ui-ux-pro-max → planning-with-files → coding-agent
```

### Bug 修复
```
问题确认 → coding-agent 修复 → 测试 → 发布
```

### 快速原型
```
brainstorming → coding-agent 快速开发 → 内部测试 → 迭代
```

---

## 七、参考资源

### 官方文档
- [Claude Skill 完全构建指南](https://github.com/anthropics/skills)
- [OpenClaw 官方 Skills](https://github.com/openclaw/openclaw/tree/main/skills)

### 社区资源
- [awesome-agent-skills](https://github.com/libukai/awesome-agent-skills)
- [ClawHub 商店](https://clawhub.com/)
- [skillsmp 商店](https://skillsmp.com/)

---

*持续更新中...*