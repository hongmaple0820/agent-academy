# Claude 项目指令

**项目**: 中国象棋 Agent 接入系统
**版本**: v1.0.0

---

## 📁 目录规范（必须遵守）

### 临时文件
- **临时脚本** → `temp/scripts/`
- **临时输出** → `temp/output/`
- **临时日志** → `temp/logs/`

⚠️ `temp/` 目录已被 .gitignore 忽略，不要将生产代码放在这里

### 生产脚本
- **SQL 脚本** → `scripts/sql/`
- **构建脚本** → `scripts/build/`
- **部署脚本** → `scripts/deploy/`
- **测试脚本** → `scripts/test/`
- **数据脚本** → `scripts/data/`
- **工具脚本** → `scripts/utils/`

### 文档
- **对外文档** → `docs/open/`（用户可见）
- **内部文档** → `docs/internal/`（开发团队）
- **开发文档** → `docs/dev/`（设计思路）
- **计划文档** → `docs/plans/`（路线图）

---

## 💬 回复规范

1. **全程使用中文回复**
2. **代码注释使用中文**
3. **变量名、函数名使用英文**
4. **组件名使用 PascalCase**
5. **函数名使用 camelCase**

---

## 📝 文档规范

所有文档开头必须包含：

```markdown
# 标题

**版本号**: v1.0.0
**最后更新**: 2026-03-09
**状态**: 已发布 | 草稿
```

---

## 🔧 代码生成规范

### React 组件

```typescript
/**
 * @file ComponentName.tsx
 * @description 组件描述
 * @version v1.0.0
 */
'use client';

import ...

export default function ComponentName() {
  return ...
}
```

### API 路由

```typescript
/**
 * @file route.ts
 * @description API 描述
 */
import { NextRequest, NextResponse } from 'next/server';

export async function GET(request: NextRequest) {
  ...
}
```

### 数据库脚本

```sql
-- V{版本}__{描述}.sql
-- 例如：V1__add_user_index.sql
-- 日期：2026-03-09

CREATE INDEX ...
```

---

## ✅ 检查清单

生成代码前检查：
- [ ] 目录是否正确
- [ ] 命名是否规范
- [ ] 是否有中文注释
- [ ] 是否标注版本号

---

## 🚫 禁止行为

- ❌ 在根目录创建临时文件
- ❌ 把测试脚本放在 `scripts/` 根目录
- ❌ 把内部文档放在 `docs/open/`
- ❌ 使用中文变量名
- ❌ 提交 `.next/` 或 `node_modules/`

---

## 记忆持久化

重要信息请保存到 `memory/` 目录：
- 项目架构决策
- 用户偏好设置
- 常见问题解决方案
- 代码模式和最佳实践
