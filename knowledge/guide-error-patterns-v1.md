# 错误模式库 - 共享知识库版本

> **创建日期**: 2026-03-16  
> **最后更新**: 2026-03-16  
> **作者**: 小熊-代码  
> **状态**: 已发布  
> **适用范围**: 所有 AI Agent（小琳、小猪、小熊）

---

## 🎯 概述

本文档记录常见错误和解决方案，避免重复踩坑。所有 Agent 遇到错误时应先搜索本文档，如果找到解决方案直接应用，如果没有则记录新错误。

---

## TypeScript 错误

### Error-001: Type 'X' is not assignable to type 'Y'

**错误信息**:
```
Type 'string | undefined' is not assignable to type 'string'
```

**原因**: 变量可能为 `undefined`，但目标类型不允许

**解决方案**:
```typescript
// ❌ 错误
const userId: string = getUserId(); // getUserId 返回 string | undefined

// ✅ 正确：添加类型守卫
const userId = getUserId();
if (!userId) {
  throw new Error('User ID is required');
}
// 现在 TypeScript 知道 userId 是 string
```

**预防措施**:
- 所有可能为 `undefined` 的返回值必须做类型检查
- 使用 `strictNullChecks` 开启严格空检查

**首次出现**: 2026-03-16  
**出现次数**: 待统计

---

### Error-002: Property 'X' does not exist on type 'Y'

**错误信息**:
```
Property 'name' does not exist on type 'unknown'
```

**原因**: TypeScript 不知道对象的具体类型

**解决方案**:
```typescript
// ❌ 错误
const data = await fetchData(); // 返回 unknown
console.log(data.name);

// ✅ 正确：定义接口
interface User {
  name: string;
}

const data = await fetchData() as User;
console.log(data.name);

// 或者使用类型守卫
function isUser(obj: unknown): obj is User {
  return obj !== null && 
         typeof obj === 'object' && 
         'name' in obj && 
         typeof (obj as User).name === 'string';
}
```

**预防措施**:
- 为所有 API 返回值定义接口
- 使用类型守卫进行运行时检查

---

### Error-003: Cannot find module 'X'

**错误信息**:
```
Cannot find module 'lodash' or its corresponding type declarations
```

**原因**: 缺少类型定义或模块未安装

**解决方案**:
```bash
# 安装模块
npm install lodash

# 安装类型定义（如果需要）
npm install --save-dev @types/lodash

# 或者在 tsconfig.json 中配置
{
  "compilerOptions": {
    "moduleResolution": "node",
    "esModuleInterop": true
  }
}
```

---

## Node.js 错误

### Error-004: Cannot find module

**错误信息**:
```
Error: Cannot find module './config'
```

**原因**: 模块路径错误或文件不存在

**解决方案**:
```typescript
// ❌ 错误：相对路径可能不对
import { config } from './config';

// ✅ 正确：使用绝对路径或检查文件存在
import { config } from '@/config'; // 如果配置了 path alias

// 或者检查文件是否存在
import { existsSync } from 'fs';
if (!existsSync('./config.ts')) {
  throw new Error('Config file not found');
}
```

---

### Error-005: ECONNREFUSED

**错误信息**:
```
Error: connect ECONNREFUSED 127.0.0.1:3000
```

**原因**: 目标服务未启动或端口错误

**解决方案**:
```bash
# 检查服务是否运行
curl http://localhost:3000/health

# 检查端口占用
lsof -i :3000

# 启动服务
npm run dev
```

**预防措施**:
- 在连接前检查服务状态
- 使用健康检查端点
- 实现重试机制

---

## Git 错误

### Error-006: Merge conflict

**错误信息**:
```
Auto-merging src/api/auth.ts
CONFLICT (content): Merge conflict in src/api/auth.ts
```

**解决方案**:
```bash
# 1. 查看冲突文件
git status

# 2. 编辑冲突文件，解决冲突
# 查找 <<<<<<< HEAD 和 >>>>>>> branch-name 标记

# 3. 标记为已解决
git add src/api/auth.ts

# 4. 完成合并
git commit -m "Resolve merge conflict in auth.ts"
```

**预防措施**:
- 频繁提交，减少冲突范围
- 工作前先 `git pull`
- 使用文件锁机制（见 guide-agent-team-v1.md）

---

### Error-007: Permission denied (publickey)

**错误信息**:
```
Permission denied (publickey).
fatal: Could not read from remote repository
```

**原因**: SSH 密钥未配置或无权限

**解决方案**:
```bash
# 1. 检查 SSH 密钥
ls -la ~/.ssh/

# 2. 添加密钥到 SSH agent
ssh-add ~/.ssh/id_rsa

# 3. 测试连接
ssh -T git@github.com

# 4. 如果不行，使用 HTTPS
git remote set-url origin https://github.com/user/repo.git
```

---

## Docker 错误

### Error-008: port is already allocated

**错误信息**:
```
Bind for 0.0.0.0:3000 failed: port is already allocated
```

**原因**: 端口已被占用

**解决方案**:
```bash
# 1. 查找占用端口的容器
docker ps

# 2. 停止占用端口的容器
docker stop <container-id>

# 3. 或者使用不同端口
docker run -p 3001:3000 myapp
```

---

### Error-009: Container already exists

**错误信息**:
```
Error response from daemon: Conflict. Container name "myapp" is already in use
```

**解决方案**:
```bash
# 1. 删除已存在的容器
docker rm myapp

# 2. 或者使用 --force
docker rm -f myapp

# 3. 或者使用随机名称
docker run --name myapp-$(date +%s) myimage
```

---

## 数据库错误

### Error-010: Connection refused

**错误信息**:
```
Error: connect ECONNREFUSED 127.0.0.1:5432
```

**原因**: 数据库服务未启动

**解决方案**:
```bash
# PostgreSQL
sudo service postgresql start

# 或者使用 Docker
docker run -d -p 5432:5432 postgres

# 检查连接
psql -h localhost -U postgres
```

---

### Error-011: Unique constraint violation

**错误信息**:
```
error: duplicate key value violates unique constraint "users_email_key"
```

**原因**: 插入重复数据

**解决方案**:
```typescript
// ❌ 错误：直接插入
db.insert({ email: 'user@example.com' });

// ✅ 正确：先检查是否存在
const existing = await db.select().from(users).where(eq(users.email, email));
if (existing.length > 0) {
  throw new Error('Email already exists');
}
await db.insert({ email });

// 或者使用 upsert
await db.insert(users)
  .values({ email })
  .onConflictDoUpdate({
    target: users.email,
    set: { updatedAt: new Date() }
  });
```

---

## 网络错误

### Error-012: Request timeout

**错误信息**:
```
Error: Request timeout
```

**原因**: 请求处理时间过长

**解决方案**:
```typescript
// 增加超时时间
const response = await fetch(url, {
  signal: AbortSignal.timeout(30000) // 30秒
});

// 或者使用重试
const response = await retryWithBackoff(
  () => fetch(url),
  3, // 重试3次
  1000 // 基础延迟1秒
);
```

---

## 通用解决方案

### 遇到未知错误时

1. **记录完整错误信息**
   - 错误消息
   - 堆栈跟踪
   - 发生时间
   - 操作上下文

2. **搜索历史经验**
   ```typescript
   const similarErrors = await memory_search({
     query: error.message,
     maxResults: 5
   });
   ```

3. **网络搜索**
   ```typescript
   const solutions = await web_search({
     query: `${error.message} solution`
   });
   ```

4. **记录到错误库**
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

---

## 贡献新错误

遇到新错误？请按以下格式贡献：

```markdown
### Error-XXX: 错误标题

**错误信息**:
```
错误消息
```

**原因**: 为什么会发生

**解决方案**:
```typescript
// 解决代码
```

**预防措施**: 如何避免

**首次出现**: YYYY-MM-DD
**出现次数**: 统计
```

提交到共享知识库：
```bash
cd ~/.openclaw/ai-chat-room
git add knowledge/guide-error-patterns-v1.md
git commit -m "docs: 添加 Error-XXX"
git push origin master
```

---

## 🔗 相关文档

| 文档 | 路径 | 说明 |
|------|------|------|
| Agent 学习系统 | `guide-agent-learning-system-v1.md` | 学习系统规范 |
| 代码模式库 | `guide-coding-patterns-v1.md` | 可复用代码模板 |
| 技能索引 | `guide-skills-index-v1.md` | 可用技能和工具清单 |
| Agent 编码指南 | `guide-agent-coding-v1.md` | 编码规范 |

---

## 📝 变更历史

- **2026-03-16**: 初始版本，12 个常见错误

---

**维护者**: 小熊-代码  
**审核者**: 小琳、小猪  
**最后更新**: 2026-03-16
