# AI 助手通用指令

**版本号**: v1.0.0
**适用范围**: Claude、OpenCode、Trae、Codex 等所有 AI 助手

---

## 📁 目录规范

### 文件存放位置

| 目录 | 用途 | 是否 Git 跟踪 |
|------|------|--------------|
| `temp/scripts/` | 临时测试脚本、调试脚本 | ❌ 否 |
| `scripts/` | 生产环境脚本 | ✅ 是 |
| `docs/open/` | 对外公开文档（用户可见） | ✅ 是 |
| `docs/internal/` | 内部开发文档 | ✅ 是 |
| `docs/dev/` | 开发笔记、设计思路 | ✅ 是 |
| `docs/plans/` | 计划文档、路线图 | ✅ 是 |
| `scripts/sql/` | 数据库 SQL 脚本 | ✅ 是 |
| `scripts/build/` | 构建脚本 | ✅ 是 |
| `scripts/deploy/` | 部署脚本 | ✅ 是 |
| `scripts/test/` | 测试脚本 | ✅ 是 |

### 重要规则

1. **临时脚本必须放在 `temp/scripts/`**
   - 测试用代码
   - 一次性迁移脚本
   - 调试工具
   - 临时数据处理

2. **生产脚本必须放在 `scripts/`**
   - 正式数据库迁移
   - 构建脚本
   - 部署脚本
   - 数据备份/恢复

3. **文档分类存放**
   - 给用户看的 → `docs/open/`
   - 给开发看的 → `docs/internal/`
   - 设计思路 → `docs/dev/`
   - 计划路线 → `docs/plans/`

---

## 💻 代码规范

### 命名规则

```typescript
// ✅ 组件名 - PascalCase
GameBoard.tsx
AgentList.tsx

// ✅ 函数名 - camelCase
const makeMove = () => {}
const fetchGames = () => {}

// ✅ 变量名 - camelCase
const currentPlayer = ...
const gameHistory = ...

// ✅ 常量 - UPPER_SNAKE_CASE
const MAX_PLAYERS = 10
const API_BASE_URL = '...'

// ❌ 避免使用
game-board.tsx     // 不要用连字符
GAMEBOARD.tsx      // 不要全大写（常量除外）
```

### 文件扩展名

```
.tsx    - React 组件
.ts     - TypeScript 源码/工具函数
.test.ts - 测试文件
.module.css - CSS 模块
```

### 注释规范

```typescript
/**
 * 文件头注释
 * @file GameResultReport.tsx
 * @description 游戏结算报告组件
 * @version v1.0.0
 */

/**
 * 函数注释
 * @param gameId - 对局 ID
 * @returns 走棋结果
 */
async function makeMove(gameId: string): Promise<MoveResult> {
  // 行内注释使用中文
}
```

---

## 📝 文档规范

### 文档头部格式

每个文档开头必须包含：

```markdown
# 文档标题

**版本号**: v1.0.0
**最后更新**: 2026-03-09
**状态**: 已发布 | 草稿 | 废弃
**作者**: AI Assistant
```

### 版本号规则

遵循语义化版本 (SemVer)：

```
v1.0.0  →  初始发布
v1.0.1  →  Bug 修复
v1.1.0  →  新功能（向后兼容）
v2.0.0  →  破坏性变更
```

---

## 🤖 AI 特定配置

### Claude

在 `.claude/instructions.md` 中配置：

```markdown
# 项目指令

1. 临时脚本放在 temp/scripts/
2. 生产脚本放在 scripts/
3. 文档放在 docs/ 并分类
4. 全程使用中文回复
5. 代码注释使用中文
```

### OpenCode / Trae / Codex

将此文件 (`AI_INSTRUCTIONS.md`) 放在项目根目录，AI 会自动读取。

---

## 🚫 禁止行为

```
❌ 不要在根目录创建临时文件
❌ 不要把测试脚本放在 scripts/ 根目录
❌ 不要把内部文档放在 docs/open/
❌ 不要提交 .next/ 或 node_modules/
❌ 不要使用中文变量名（注释用中文）
```

---

## ✅ 推荐做法

```
✅ 使用 TypeScript
✅ 组件使用 .tsx 扩展名
✅ 工具函数使用 .ts 扩展名
✅ 遵循 ESLint 配置
✅ 添加适当的注释
✅ 更新相关文档
```

---

## 📋 检查清单

创建文件前检查：

- [ ] 目录是否正确
- [ ] 命名是否规范
- [ ] 是否需要添加注释
- [ ] 是否需要更新文档
- [ ] 版本号是否标注

---

## 其他 AI 助手

如果你不是 Claude，请：

1. 读取此文件并遵守规范
2. 在你的系统提示中添加类似配置
3. 确保输出符合本规范要求

**目标**: 确保不同 AI 助手生成的代码和文档保持一致性。
