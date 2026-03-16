# TDD 测试驱动开发使用示例

> 使用 `test-driven-development` 技能进行高质量开发

## 📋 场景说明

**场景**: 新功能开发、重构、Bug 修复
**技能**: test-driven-development
**流程**: 红 → 绿 → 重构

---

## 💬 完整对话示例

### 示例：开发用户认证功能

```
用户：帮我实现用户登录功能。

小熊：好的！使用 TDD 方法开发。🐻

🔄 **TDD 流程**
1. 🔴 先写失败的测试 (Red)
2. 🟢 实现最小功能通过测试 (Green)
3. 🔵 重构优化代码 (Refactor)

从哪个测试开始？
- [ ] 用户登录成功
- [ ] 密码错误处理
- [ ] JWT token 生成
- [ ] 登录失败限制
```

**用户选择后**:

```
小熊：好的！先写"用户登录成功"的测试。🐻

🔴 **Step 1: 写失败的测试**

`tests/auth.test.js`:
```javascript
const request = require('supertest');
const app = require('../src/app');

describe('用户认证', () => {
  describe('POST /api/auth/login', () => {
    it('应该成功登录并返回 token', async () => {
      // 准备测试数据
      const credentials = {
        username: 'testuser',
        password: 'password123'
      };
      
      // 执行请求
      const res = await request(app)
        .post('/api/auth/login')
        .send(credentials);
      
      // 验证响应
      expect(res.statusCode).toBe(200);
      expect(res.body.success).toBe(true);
      expect(res.body.token).toBeDefined();
      expect(res.body.token).toMatch(/^eyJ/); // JWT 格式
    });
  });
});
```

**运行测试**:
```bash
npm test -- auth.test.js
```

**结果**:
```
❌ 1 failing

1) 用户认证
   POST /api/auth/login
     应该成功登录并返回 token:
     
     Error: expected 200 "OK", got 404 "Not Found"
```

✅ 测试失败（符合预期）！

现在实现功能让测试通过。需要我写实现代码吗？
```

**用户确认后**:

```
小熊：🟢 **Step 2: 实现最小功能**

`src/routes/auth.js`:
```javascript
const express = require('express');
const jwt = require('jsonwebtoken');
const router = express.Router();

// 模拟用户数据（实际应该从数据库查询）
const users = [
  { id: 1, username: 'testuser', password: 'password123' }
];

router.post('/login', (req, res) => {
  const { username, password } = req.body;
  
  // 查找用户
  const user = users.find(u => 
    u.username === username && u.password === password
  );
  
  if (!user) {
    return res.status(401).json({
      success: false,
      message: '用户名或密码错误'
    });
  }
  
  // 生成 JWT token
  const token = jwt.sign(
    { userId: user.id, username: user.username },
    process.env.JWT_SECRET,
    { expiresIn: '24h' }
  );
  
  res.json({
    success: true,
    token: token
  });
});

module.exports = router;
```

`src/app.js`:
```javascript
const express = require('express');
const authRoutes = require('./routes/auth');

const app = express();

app.use(express.json());
app.use('/api/auth', authRoutes);

module.exports = app;
```

**运行测试**:
```bash
npm test -- auth.test.js
```

**结果**:
```
✅ 1 passing (45ms)
```

✅ 测试通过！

🔵 **Step 3: 重构优化**

现在代码可以工作，但可以改进：
- ❌ 硬编码用户数据
- ❌ 明文存储密码
- ❌ 缺少输入验证

需要我重构吗？
```

**用户确认后**:

```
小熊：✅ **重构后的代码**

`src/routes/auth.js`:
```javascript
const express = require('express');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const Joi = require('joi');
const db = require('../db');

const router = express.Router();

// 输入验证 schema
const loginSchema = Joi.object({
  username: Joi.string().required(),
  password: Joi.string().required()
});

router.post('/login', async (req, res) => {
  try {
    // 验证输入
    const { error, value } = loginSchema.validate(req.body);
    if (error) {
      return res.status(400).json({
        success: false,
        message: error.details[0].message
      });
    }
    
    // 查询用户
    const user = await db.query(
      'SELECT * FROM users WHERE username = ?',
      [value.username]
    );
    
    if (!user) {
      return res.status(401).json({
        success: false,
        message: '用户名或密码错误'
      });
    }
    
    // 验证密码
    const validPassword = await bcrypt.compare(
      value.password,
      user.passwordHash
    );
    
    if (!validPassword) {
      return res.status(401).json({
        success: false,
        message: '用户名或密码错误'
      });
    }
    
    // 生成 token
    const token = jwt.sign(
      { userId: user.id, username: user.username },
      process.env.JWT_SECRET,
      { expiresIn: '24h' }
    );
    
    res.json({
      success: true,
      token: token
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
});

module.exports = router;
```

**添加新测试验证重构**:
```javascript
it('应该拒绝无效的用户名', async () => {
  const res = await request(app)
    .post('/api/auth/login')
    .send({ username: '', password: 'test' });
  
  expect(res.statusCode).toBe(400);
});

it('应该拒绝错误的密码', async () => {
  const res = await request(app)
    .post('/api/auth/login')
    .send({ username: 'testuser', password: 'wrong' });
  
  expect(res.statusCode).toBe(401);
});
```

**运行所有测试**:
```bash
npm test
```

**结果**:
```
✅ 5 passing (89ms)
```

✅ 重构完成，所有测试通过！

**测试覆盖率**:
```
File               | Coverage
-------------------|----------
src/routes/auth.js | 95%
src/app.js        | 100%
```

需要继续开发其他功能吗？
```

---

## 🔧 TDD 循环

```
┌─────────────────┐
│   写测试 (Red)   │
│  预期会失败 ❌   │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│ 实现功能 (Green) │
│  让测试通过 ✅   │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│  重构 (Refactor) │
│  优化代码质量 🔵 │
└────────┬────────┘
         │
         ↓
    重复循环...
```

---

## 💡 最佳实践

### 1. 测试先行
```
❌ 先写代码再补测试
✅ 先写测试再实现功能
```

### 2. 小步快跑
```
❌ 一次写 10 个测试
✅ 一个测试一个功能点
```

### 3. 测试命名
```javascript
// ❌ 不清晰
it('应该工作', () => {});

// ✅ 清晰
it('应该成功登录并返回 JWT token', () => {});
```

### 4. AAA 模式
```javascript
it('测试用例', () => {
  // Arrange - 准备
  const input = {...};
  
  // Act - 执行
  const result = function(input);
  
  // Assert - 断言
  expect(result).toBe(expected);
});
```

---

## 🔗 相关技能

- `programming-workflow` - 编程工作流
- `requesting-code-review` - 代码审查
- `systematic-debugging` - 系统调试
- `git-workflow-management` - Git 工作流

---

*示例版本：v1.0*
*更新时间：2026-03-14*
