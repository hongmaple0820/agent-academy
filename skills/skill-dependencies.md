# 技能依赖关系图

> 技能之间的依赖关系和使用顺序

## 📊 依赖关系总览

```mermaid
graph TD
    A[brainstorming] --> B[planning-with-files]
    A --> C[/write-prd]
    B --> D[programming-workflow]
    C --> D
    D --> E[test-driven-development]
    D --> F[requesting-code-review]
    E --> F
    F --> G[deploying-applications]
    D --> H[project-standards]
    
    C --> I[/strategy]
    C --> J[/plan-launch]
    
    K[daily-review] --> B
    K --> L[MEMORY.md]
    
    M[frontend-design] --> D
    N[statistical-analysis] --> K
```

## 🔗 核心依赖链

### 链 1: 新产品开发流程

```
brainstorming
    ↓ (需求明确后)
planning-with-files
    ↓ (创建计划后)
/write-prd
    ↓ (PRD 完成后)
programming-workflow
    ├─→ test-driven-development (开发阶段)
    ├─→ requesting-code-review (代码审查)
    └─→ deploying-applications (部署上线)
```

**使用场景**: 从 0 到 1 开发新功能

---

### 链 2: 产品规划流程

```
brainstorming
    ↓ (想法验证后)
/strategy
    ↓ (战略明确后)
/write-prd
    ↓ (PRD 完成后)
/plan-launch
    ↓ (发布计划后)
planning-with-files
```

**使用场景**: 产品战略规划和发布

---

### 链 3: 日常复盘流程

```
daily-review
    ├─→ MEMORY.md (更新长期记忆)
    ├─→ planning-with-files (规划明天)
    └─→ statistical-analysis (数据分析)
```

**使用场景**: 每日总结和规划

---

### 链 4: 项目开发流程

```
programming-workflow
    ├─→ project-standards (遵循规范)
    ├─→ frontend-design (UI 设计)
    ├─→ test-driven-development (TDD)
    ├─→ requesting-code-review (代码审查)
    └─→ deploying-applications (部署)
```

**使用场景**: 标准软件开发项目

---

## 📋 技能依赖详情

### brainstorming (头脑风暴)

**依赖**: 无
**被依赖**: planning-with-files, /write-prd, /strategy

**推荐组合**:
- → planning-with-files: 探索后制定计划
- → /write-prd: 探索后写需求文档

---

### planning-with-files (任务计划)

**依赖**: brainstorming (可选)
**被依赖**: daily-review, /plan-launch

**推荐组合**:
- → programming-workflow: 计划后开始开发
- → executing-plans: 创建计划后执行

---

### /write-prd (PRD 写作)

**依赖**: brainstorming
**被依赖**: programming-workflow, /plan-launch

**推荐组合**:
- → /strategy: 先战略后 PRD
- → programming-workflow: PRD 后开发

---

### programming-workflow (编程工作流)

**依赖**: planning-with-files 或 /write-prd
**被依赖**: test-driven-development, requesting-code-review

**推荐组合**:
- → project-standards: 遵循项目规范
- → frontend-design: UI 设计
- → test-driven-development: TDD 开发

---

### test-driven-development (测试驱动开发)

**依赖**: programming-workflow
**被依赖**: requesting-code-review

**推荐组合**:
- → requesting-code-review: 测试后审查
- → deploying-applications: 测试后部署

---

### requesting-code-review (代码审查)

**依赖**: test-driven-development 或 programming-workflow
**被依赖**: deploying-applications

**推荐组合**:
- → deploying-applications: 审查后部署
- → receiving-code-review: 发送审查后接收反馈

---

### deploying-applications (应用部署)

**依赖**: requesting-code-review
**被依赖**: 无 (流程终点)

**推荐组合**:
- → finishing-a-development-branch: 部署后完成分支
- → daily-review: 部署后复盘

---

### daily-review (每日复盘)

**依赖**: 无
**被依赖**: planning-with-files

**推荐组合**:
- → planning-with-files: 复盘后规划明天
- → MEMORY.md: 复盘后更新长期记忆

---

### frontend-design (前端设计)

**依赖**: 无
**被依赖**: programming-workflow

**推荐组合**:
- → programming-workflow: 设计后实现
- → designing-layouts: 布局设计

---

## 🎯 使用建议

### 新手推荐路径

```
Day 1:
  brainstorming → planning-with-files → daily-review

Day 2-3:
  /write-prd → programming-workflow → test-driven-development

Day 4:
  requesting-code-review → deploying-applications → daily-review
```

### 进阶组合

**复杂项目**:
```
brainstorming → /strategy → /write-prd → planning-with-files 
→ programming-workflow → frontend-design → test-driven-development 
→ requesting-code-review → deploying-applications → daily-review
```

**快速迭代**:
```
planning-with-files → programming-workflow → test-driven-development 
→ deploying-applications
```

---

## 📊 依赖矩阵

| 技能 | 前置依赖 | 后置依赖 | 推荐组合 |
|------|---------|---------|---------|
| brainstorming | 无 | planning-with-files, /write-prd | 需求探索 |
| planning-with-files | brainstorming(可选) | programming-workflow | 任务规划 |
| /write-prd | brainstorming | programming-workflow | 需求文档 |
| programming-workflow | planning-with-files 或 /write-prd | test-driven-development | 项目开发 |
| test-driven-development | programming-workflow | requesting-code-review | TDD 开发 |
| requesting-code-review | test-driven-development | deploying-applications | 代码审查 |
| deploying-applications | requesting-code-review | 无 | 部署上线 |
| daily-review | 无 | planning-with-files | 每日复盘 |
| frontend-design | 无 | programming-workflow | UI 设计 |
| /strategy | brainstorming | /write-prd | 产品战略 |
| /plan-launch | /write-prd | planning-with-files | 发布计划 |

---

## 🔧 维护说明

### 更新依赖关系

当发现新的技能组合模式时：
1. 更新本文件的依赖图
2. 更新依赖矩阵
3. 添加使用示例

### 验证依赖

定期检查：
- [ ] 依赖关系是否合理
- [ ] 是否有循环依赖
- [ ] 是否有缺失的依赖

---

*版本：v1.0*
*更新时间：2026-03-14*
*维护者：小熊 🐻*
