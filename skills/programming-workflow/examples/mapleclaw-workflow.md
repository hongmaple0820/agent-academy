# MapleClaw 项目工作流实例

> 本文档展示如何在 MapleClaw 项目中应用 programming-workflow 技能

---

## 项目信息

| 项目 | 信息 |
|------|------|
| 名称 | MapleClaw (枫琳) |
| 类型 | 多 Agent 协同办公平台 |
| 开始日期 | 2026-02-09 |
| 参与者 | maple、小琳、小猪 |

---

## 工作流应用

### Phase 1: 需求发掘与整理 ✅

**使用 Skills**: `brainstorming`, `analyze-feature-requests`

**输出物**:
- 需求清单 (12 个核心模块)
- 用户画像 (开发者、产品经理、普通用户)
- 优先级排序 (P0/P1/P2)

### Phase 2: 产品设计 ✅

**使用 Skills**: `create-prd`

**输出物**:
- PRD v1.0 (`docs/product/PRD-v1.0.md`)
- 功能架构图
- 版本规划路线图

### Phase 3: UI/UX 设计 ✅

**使用 Skills**: `ui-ux-pro-max`, `ckm-design`

**输出物**:
- UI 设计规范 v1.0 (`docs/design/UI-design-v1.0.md`)
- 色彩系统、字体系统
- 页面布局设计

### Phase 4: 架构规划 ✅

**使用 Skills**: `planning-with-files`

**输出物**:
- 技术架构设计 (`docs/architecture/technical-design-v1.0.md`)
- 数据库设计
- API 接口设计

### Phase 5: 开发部署 🔄

**使用 Skills**: `coding-agent`, `deploy-to-vercel`

**当前状态**:
- chat-hub 后端: ✅ 可用 (端口 8273)
- chat-web 前端: ⚠️ TypeScript 迁移中
- chat-mobile: 📋 规划中

**任务看板**: `~/.openclaw/ai-chat-room/tasks/枫林项目.md`

### Phase 6-9: 待执行

- 测试阶段
- 产品验证
- 上线部署
- 运营推广

---

## 多 Agent 协同示例

### 开发分工

```
maple (产品决策)
   │
   ├── 小琳 (前端)
   │     ├── Vue 组件开发
   │     ├── UI 样式实现
   │     └── 用户体验优化
   │
   └── 小猪 (后端)
         ├── API 接口开发
         ├── 数据库设计
         └── 性能优化
```

### 协作通信

```
钉钉群消息 → chat-hub 存储 → AI 同步 → 任务分配
```

---

## 进度同步

### 每日日志
- 位置: `memory/YYYY-MM-DD.md`
- 更新频率: 每日

### 任务看板
- 位置: `tasks/枫林项目.md`
- 更新频率: 完成任务时

### Git 提交
- 提交规范: `feat(chat-hub): add xxx feature`
- 推送频率: 每日下班前

---

## 经验总结

### 成功实践
- 使用 `planning-with-files` 进行任务规划
- Git 分支规范避免冲突
- 每日日志保持上下文

### 待改进
- 测试覆盖率不足
- 文档同步滞后
- Beta 测试流程待完善

---

*本文档将随项目进展持续更新*