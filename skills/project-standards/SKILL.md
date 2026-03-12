---
name: project-standards
description: "AI 项目规范学习指南。提供目录结构、命名规则、代码风格的最佳实践，让 AI 学习如何规范化地组织项目。适用于所有编程项目，是 AI 自我提升的参考标准。触发词：项目规范、命名规则、目录结构、代码风格、最佳实践。"
version: "1.1.0"
author: 小琳
created: "2026-03-12"
keywords: [standards, conventions, best-practices, structure, naming, learning]
---

# AI 项目规范学习指南

> 本文档是 AI 学习和应用项目规范的指南，帮助 AI 在任何项目中遵循最佳实践。

---

## 🎯 学习目标

通过本指南，AI 应该学会：

1. **目录组织** - 如何合理组织项目文件
2. **命名规范** - 如何使用一致的命名风格
3. **代码风格** - 如何编写清晰、可维护的代码
4. **文档规范** - 如何编写标准化文档
5. **Git 规范** - 如何规范化地管理版本

---

## 📁 一、目录组织原则

### 核心原则

```
1. 按功能分类，不按文件类型
2. 临时文件与正式文件分离
3. 公开文档与内部文档分离
4. 构建产物不入库
```

### 标准目录模式

```
project/
├── src/              # 源代码（核心）
├── tests/            # 测试代码
├── scripts/          # 自动化脚本
├── docs/             # 文档
├── config/           # 配置
├── temp/             # 临时文件（不提交）
└── dist/             # 构建输出（不提交）
```

### 目录决策树

```
创建新文件时，问自己：

Q: 这是临时测试/调试用的吗？
├── 是 → temp/scripts/
└── 否 → 继续

Q: 这是用户需要看的文档吗？
├── 是 → docs/open/
└── 否 → 这是开发文档吗？
          ├── 是 → docs/internal/
          └── 否 → 这是设计思路吗？
                    ├── 是 → docs/dev/
                    └── 否 → docs/plans/

Q: 这是数据库脚本吗？
├── 是 → scripts/sql/
└── 否 → 这是构建/部署脚本吗？
          ├── 是 → scripts/build/ 或 scripts/deploy/
          └── 否 → scripts/

Q: 这是测试文件吗？
├── 是 → tests/
└── 否 → src/
```

### 重要规则

| 规则 | 说明 |
|------|------|
| temp/ 不提交 | 所有临时文件放在这里，.gitignore 排除 |
| docs 分类存放 | 用户文档 vs 开发文档要分开 |
| scripts 分类 | sql、build、deploy、test 分目录 |
| config 独立 | 配置文件单独管理 |

---

## 💻 二、命名规范原则

### 核心原则

```
1. 一致性 - 整个项目风格统一
2. 可读性 - 见名知义
3. 简洁性 - 不过度冗长
4. 语义化 - 名字表达意图
```

### 命名风格速查

| 类型 | 风格 | 示例 |
|------|------|------|
| 组件 | PascalCase | `GameBoard.tsx` |
| 函数 | camelCase | `makeMove()` |
| 变量 | camelCase | `currentPlayer` |
| 常量 | UPPER_SNAKE_CASE | `MAX_PLAYERS` |
| 类型/接口 | PascalCase | `GameConfig` |
| 文件名 | 与内容类型匹配 | 组件用 PascalCase，工具用 camelCase |

### 命名决策树

```
命名时，问自己：

Q: 这是一个 React 组件吗？
├── 是 → PascalCase（GameBoard）
└── 否 → 继续

Q: 这是一个常量（不会变的值）吗？
├── 是 → UPPER_SNAKE_CASE（MAX_PLAYERS）
└── 否 → 继续

Q: 这是一个类型/接口吗？
├── 是 → PascalCase（GameConfig）
└── 否 → camelCase（currentPlayer）

Q: 这是一个布尔值吗？
├── 是 → is/has/can 开头（isPlaying, hasWon）
└── 否 → 名词或动词（player, makeMove）
```

### 命名示例对比

```typescript
// ✅ 好的命名
const MAX_PLAYERS = 10
const currentPlayer = 'X'
const hasWon = false

function makeMove(gameId: string) {}
async function fetchGames() {}

interface GameConfig {
  maxPlayers: number
  boardSize: number
}

type PlayerRole = 'X' | 'O'

// ❌ 不好的命名
const max_players = 10      // 应该用 UPPER_SNAKE_CASE
const CurrentPlayer = 'X'   // 应该用 camelCase
const won = false           // 应该用 is/has 前缀

function MakeMove() {}      // 应该用 camelCase
function make_move() {}     // 应该用 camelCase
```

---

## 📝 三、代码风格原则

### 核心原则

```
1. 简洁明了 - 一眼看懂
2. 注释适度 - 解释"为什么"而非"是什么"
3. 一致的格式 - 遵循项目风格
4. 类型安全 - 使用 TypeScript
```

### 注释规范

```typescript
/**
 * 文件头注释（重要文件使用）
 * @file GameEngine.ts
 * @description 游戏核心逻辑
 */

/**
 * 函数注释（复杂函数使用）
 * @param board - 棋盘状态
 * @returns 胜者或 null
 */
function checkWinner(board: Board): Player | null {
  // 检查行
  for (const row of board) {
    if (row[0] && row.every(cell => cell === row[0])) {
      return row[0]
    }
  }
  
  // TODO: 添加对角线检查
  // FIXME: 这里有边界情况
  return null
}

// 简单的行内注释用中文
const result = checkWinner(board)  // 检查是否有胜者
```

### 代码组织

```typescript
// 文件结构顺序
// 1. 导入
import { useState } from 'react'
import type { GameConfig } from './types'

// 2. 类型定义
interface Props {
  gameId: string
}

// 3. 常量
const MAX_MOVES = 100

// 4. 组件/函数
export function GameBoard({ gameId }: Props) {
  // 4.1 Hooks
  const [board, setBoard] = useState<Board>([])
  
  // 4.2 派生状态
  const isGameOver = board.length >= MAX_MOVES
  
  // 4.3 事件处理
  const handleClick = () => {}
  
  // 4.4 渲染
  return <div>...</div>
}
```

---

## 📄 四、文档规范原则

### 核心原则

```
1. 版本号必须标注
2. 更新日期必须标注
3. 状态必须明确
4. 结构清晰易读
```

### 文档头部模板

```markdown
# 文档标题

**版本号**: v1.0.0
**最后更新**: YYYY-MM-DD
**状态**: 已发布 | 草稿 | 废弃
**作者**: AI Assistant

---

## 概述

<!-- 正文 -->
```

### 文档分类决策

```
Q: 谁会看这个文档？

用户/外部人员 → docs/open/
├── README.md
├── 使用指南
└── API 文档

开发团队 → docs/internal/
├── 架构设计
├── 开发规范
└── 部署手册

个人笔记 → docs/dev/
├── 设计思路
├── 问题记录
└── 技术调研

计划文档 → docs/plans/
├── 路线图
├── 任务计划
└── 版本规划
```

### 版本号规则

```
v主版本.次版本.修订号

主版本 - 破坏性变更（不兼容）
次版本 - 新功能（向后兼容）
修订号 - Bug 修复

示例：
v1.0.0 → 初始发布
v1.0.1 → 修复 Bug
v1.1.0 → 新增功能
v2.0.0 → 重大更新
```

---

## 🔧 五、Git 规范原则

### 提交信息格式

```
<type>(<scope>): <subject>

type 类型：
- feat     新功能
- fix      Bug 修复
- docs     文档
- style    格式
- refactor 重构
- test     测试
- chore    构建/工具

示例：
feat(chat): add message search
fix(api): resolve timeout issue
docs(readme): update guide
```

### 分支命名

```
feature/<name>    新功能
bugfix/<name>     Bug 修复
hotfix/<name>     紧急修复
release/<version> 发布分支

示例：
feature/chat-search
bugfix/login-timeout
release/v1.0.0
```

### .gitignore 标准

```gitignore
# 必须排除
node_modules/
dist/
.env
.env.local
*.log
temp/

# IDE 配置
.vscode/
.idea/

# 系统文件
.DS_Store
```

---

## ✅ 六、检查清单

### 创建文件前

- [ ] 目录位置是否正确？
- [ ] 文件命名是否规范？
- [ ] 扩展名是否正确？

### 编写代码前

- [ ] 变量/函数命名是否清晰？
- [ ] 是否需要添加注释？
- [ ] 类型定义是否完整？

### 提交代码前

- [ ] 提交信息格式是否正确？
- [ ] 是否有不该提交的文件？
- [ ] 文档是否需要更新？

---

## 🚫 七、禁止行为

```
❌ 在根目录乱放临时文件
❌ 提交 temp/ 目录内容
❌ 提交敏感信息（密钥、密码）
❌ 使用不一致的命名风格
❌ 提交未经测试的代码
❌ 文档缺失版本号和日期
```

---

## 📚 八、学习资源

### 官方指南

- [语义化版本](https://semver.org/)
- [约定式提交](https://www.conventionalcommits.org/)
- [Google TypeScript 风格](https://google.github.io/styleguide/tsguide.html)

### 最佳实践

- React: [React 风格指南](https://github.com/airbnb/javascript/tree/master/react)
- TypeScript: [TypeScript 最佳实践](https://www.typescriptlang.org/docs/handbook/declaration-files/do-s-and-don-ts.html)
- Git: [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/)

---

## 🔄 九、持续改进

本规范是活的文档，应该：

1. **定期回顾** - 每季度检查是否需要更新
2. **团队共识** - 团队成员共同维护
3. **实践驱动** - 根据实际项目调整
4. **版本控制** - 记录每次变更

---

*AI 在每次编码时都应该参考本规范，确保输出符合标准。*