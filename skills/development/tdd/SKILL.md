# Test-Driven Development (TDD)

引导测试驱动开发流程，确保代码质量。

## 激活场景

- 用户说"帮我写测试"、"TDD"、"测试驱动"
- 开始实现新功能时
- 修复 bug 时（先写测试复现 bug）

## TDD 核心循环

```
🔴 Red    → 写一个失败的测试
🟢 Green  → 写最小代码让测试通过
🔵 Refactor → 重构代码，保持测试通过
```

重复这个循环，逐步构建功能。

## 操作步骤

### 1. 理解需求

在写任何代码之前，先明确：
- 这个功能要做什么？
- 输入是什么？输出是什么？
- 边界情况有哪些？
- 错误情况如何处理？

### 2. 写失败的测试（Red）

```javascript
// 示例：实现一个计算折扣的函数

// test/discount.test.js
describe('calculateDiscount', () => {
  it('should return 0 discount for orders under 100', () => {
    expect(calculateDiscount(50)).toBe(0);
  });
  
  it('should return 10% discount for orders 100-500', () => {
    expect(calculateDiscount(200)).toBe(20);
  });
  
  it('should return 20% discount for orders over 500', () => {
    expect(calculateDiscount(1000)).toBe(200);
  });
  
  it('should throw error for negative amount', () => {
    expect(() => calculateDiscount(-10)).toThrow('Amount must be positive');
  });
});
```

运行测试，确认它失败了。

### 3. 写最小实现（Green）

```javascript
// src/discount.js
function calculateDiscount(amount) {
  if (amount < 0) {
    throw new Error('Amount must be positive');
  }
  if (amount < 100) return 0;
  if (amount <= 500) return amount * 0.1;
  return amount * 0.2;
}
```

运行测试，确认它通过了。

### 4. 重构（Refactor）

```javascript
// 重构后 - 更清晰的结构
const DISCOUNT_TIERS = [
  { threshold: 500, rate: 0.2 },
  { threshold: 100, rate: 0.1 },
  { threshold: 0, rate: 0 },
];

function calculateDiscount(amount) {
  if (amount < 0) {
    throw new Error('Amount must be positive');
  }
  const tier = DISCOUNT_TIERS.find(t => amount > t.threshold);
  return amount * tier.rate;
}
```

运行测试，确认仍然通过。

## 测试类型

### 单元测试

测试单个函数/模块，隔离依赖。

```javascript
// 使用 mock 隔离依赖
jest.mock('./database');
const db = require('./database');

test('getUser should return user from database', async () => {
  db.query.mockResolvedValue({ id: 1, name: 'Test' });
  const user = await getUser(1);
  expect(user.name).toBe('Test');
});
```

### 集成测试

测试多个模块协作。

```javascript
// 测试 API 端点
test('POST /users should create user', async () => {
  const response = await request(app)
    .post('/users')
    .send({ name: 'Test', email: 'test@example.com' });
  
  expect(response.status).toBe(201);
  expect(response.body.id).toBeDefined();
});
```

### 端到端测试

测试完整用户流程。

```javascript
// Playwright E2E 测试
test('user can login and see dashboard', async ({ page }) => {
  await page.goto('/login');
  await page.fill('[name=email]', 'user@example.com');
  await page.fill('[name=password]', 'password');
  await page.click('button[type=submit]');
  
  await expect(page).toHaveURL('/dashboard');
  await expect(page.locator('h1')).toContainText('Welcome');
});
```

## 测试框架速查

### JavaScript/Node.js

```bash
# Jest
npm install --save-dev jest
npx jest

# Vitest (更快)
npm install --save-dev vitest
npx vitest
```

### Python

```bash
# pytest
pip install pytest
pytest

# 带覆盖率
pip install pytest-cov
pytest --cov=src
```

### Go

```bash
go test ./...
go test -cover ./...
```

## TDD 最佳实践

### ✅ 应该做

1. **测试行为，不是实现** - 测试函数做什么，不是怎么做
2. **一个测试一个断言** - 每个测试只验证一件事
3. **使用有意义的测试名** - `it('should return 404 when user not found')`
4. **先写边界情况测试** - 空值、负数、极大值
5. **保持测试独立** - 测试之间不应该有依赖

### ❌ 不应该做

1. **不测试私有方法** - 通过公共 API 测试
2. **不过度 mock** - 只 mock 外部依赖
3. **不写脆弱测试** - 避免依赖实现细节
4. **不忽略失败测试** - 修复或删除，不要跳过
5. **不追求 100% 覆盖率** - 关注关键路径

## 修复 Bug 的 TDD 流程

1. **复现 Bug** - 写一个失败的测试来复现问题
2. **确认失败** - 运行测试，确认它确实失败
3. **修复代码** - 修改代码让测试通过
4. **验证修复** - 运行所有测试，确保没有回归
5. **提交代码** - 测试和修复一起提交

```javascript
// 示例：修复一个除零 bug
it('should handle division by zero', () => {
  // 这个测试复现了 bug
  expect(divide(10, 0)).toBe(Infinity);
  // 或者抛出错误
  // expect(() => divide(10, 0)).toThrow('Cannot divide by zero');
});
```

## 常用命令

```bash
# 运行测试
npm test

# 监听模式（文件变化时自动运行）
npm test -- --watch

# 运行单个测试文件
npm test -- path/to/test.js

# 查看覆盖率
npm test -- --coverage

# 只运行失败的测试
npm test -- --onlyFailures
```
