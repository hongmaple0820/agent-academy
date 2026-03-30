# 代码规范

> 统一代码风格，提升可读性和维护性。

---

## 🏷️ 命名规范

### 变量命名

| 类型 | 规范 | 示例 | 说明 |
|------|------|------|------|
| 普通变量 | camelCase | `userName`, `totalCount` | 首字母小写，驼峰式 |
| 私有变量 | _camelCase | `_privateVar` | 下划线前缀（类成员） |
| 布尔变量 | is/has/should + 名词 | `isActive`, `hasPermission` | 语义明确 |
| 常量 | UPPER_SNAKE_CASE | `MAX_RETRY`, `API_BASE_URL` | 全大写下划线分隔 |
| 枚举 | PascalCase | `UserStatus`, `OrderType` | 首字母大写 |
| 枚举值 | UPPER_SNAKE_CASE | `ACTIVE`, `PENDING` | 与常量一致 |

```typescript
// ✅ 正确
const MAX_RETRY_COUNT = 3;
let userName = '张三';
const isValid = true;

// ❌ 错误
const maxretry = 3;      // 应为大写下划线
let user_name = '张三';  // 应为驼峰式
const valid = true;      // 布尔变量语义不明确
```

### 函数命名

| 类型 | 规范 | 示例 | 说明 |
|------|------|------|------|
| 普通函数 | camelCase + 动词 | `getUser()`, `formatDate()` | 动词开头 |
| 私有函数 | _camelCase | `_validateInput()` | 下划线前缀 |
| 异步函数 | 动词 + Async | `fetchDataAsync()` | 明确异步 |
| 回调函数 | on/handle + 事件 | `onClick()`, `handleSubmit()` | 事件处理 |
| 工厂函数 | create + 名词 | `createUser()`, `createService()` | 创建实例 |
| 判断函数 | is/has/can + 名词 | `isEmpty()`, `hasValue()` | 返回布尔 |

```typescript
// ✅ 正确
function getUserById(id: string): User {}
async function fetchDataAsync(): Promise<Data> {}
function isValidEmail(email: string): boolean {}

// ❌ 错误
function user() {}           // 缺少动词
function get_user() {}       // 使用下划线
async function fetchData() {} // 未标明 Async
```

### 类命名

| 类型 | 规范 | 示例 | 说明 |
|------|------|------|------|
| 类 | PascalCase + 名词 | `UserService`, `OrderController` | 首字母大写 |
| 抽象类 | PascalCase + Base | `BaseController`, `BaseService` | Base 后缀 |
| 接口 | PascalCase + I前缀 | `IUser`, `IRepository` | I 前缀 |
| 类型别名 | PascalCase | `UserType`, `ApiResponse` | 描述性 |
| 泛型参数 | T/K/V + 描述 | `TData`, `KKey` | 单字母大写 |

```typescript
// ✅ 正确
class UserService {}
interface IUserRepository {}
type ApiResponse<T> = { data: T };

// ❌ 错误
class userService {}     // 应为 PascalCase
interface userRepo {}    // 缺少 I 前缀
type apiResponse = {};  // 应为 PascalCase
```

### 文件命名

| 类型 | 规范 | 示例 | 说明 |
|------|------|------|------|
| 普通文件 | kebab-case | `user-service.ts` | 小写连字符 |
| 类文件 | PascalCase | `User.ts` | 与类名一致 |
| 类型文件 | kebab-case + .types | `user.types.ts` | 类型定义 |
| 测试文件 | .test.ts | `user.test.ts` | 测试后缀 |
| 配置文件 | 原名 | `tsconfig.json` | 保持原名 |

```
✅ 正确
src/
├── user-service.ts
├── user.types.ts
├── user.test.ts
├── User.ts

❌ 错误
src/
├── userService.ts      // 应为 kebab-case
├── user_types.ts       // 应为连字符
├── user.spec.ts        // 应为 .test.ts
```

---

## 📁 目录结构规范

### 标准项目结构

```
project-root/
├── src/                    # 源代码
│   ├── index.ts           # 入口文件
│   ├── config/            # 配置相关
│   ├── routes/            # 路由/API 端点
│   ├── services/          # 业务逻辑层
│   ├── repositories/      # 数据访问层
│   ├── models/            # 数据模型
│   ├── utils/             # 工具函数
│   ├── middleware/        # 中间件
│   ├── types/             # 类型定义
│   └── tests/             # 测试文件
├── docs/                  # 文档
├── scripts/               # 脚本工具
├── .github/               # GitHub 配置
├── package.json
├── tsconfig.json
├── .eslintrc.js
├── .prettierrc
├── .gitignore
└── README.md
```

### 目录命名

- 使用 **kebab-case**（短横线连接）
- 复数形式表示集合：`services/`, `utils/`
- 单数形式表示单个：`config/`, `middleware/`

```
✅ 正确
src/
├── user-management/
├── api-client/
├── error-handling/

❌ 错误
src/
├── userManagement/      // 应为 kebab-case
├── api_client/          // 应使用连字符
├── errorHandling/       // 应为 kebab-case
```

### 文件组织原则

1. **单一职责** - 一个文件只做一件事
2. **就近原则** - 相关文件放在一起
3. **扁平优先** - 避免过深的嵌套（最多 3 层）

```
✅ 推荐
src/
├── services/
│   ├── user-service.ts
│   ├── user-service.test.ts
│   └── user-types.ts

❌ 避免
src/
├── services/
│   └── user/
│       ├── index.ts
│       ├── service.ts
│       ├── types.ts
│       └── tests/
│           └── service.test.ts
```

---

## 📝 注释规范

### 文件头注释

每个文件开头应有简要说明：

```typescript
/**
 * 用户服务模块
 * 处理用户相关的业务逻辑，包括注册、登录、信息管理等
 * @module services/user-service
 */
```

### 函数/方法注释

使用 JSDoc 格式：

```typescript
/**
 * 根据 ID 获取用户信息
 * @param userId - 用户唯一标识符
 * @param options - 查询选项
 * @returns 用户对象，未找到返回 null
 * @throws {NotFoundError} 当用户不存在时
 * @example
 * const user = await getUserById('123', { includeProfile: true });
 */
async function getUserById(
  userId: string,
  options?: GetUserOptions
): Promise<User | null> {
  // 实现
}
```

### 行内注释

解释"为什么"而不是"做什么"：

```typescript
// ✅ 正确 - 解释原因
// 缓存 5 分钟，因为用户数据变化不频繁
await cache.set(key, data, { ttl: 300 });

// ❌ 错误 - 重复代码
// 设置缓存，TTL 为 300 秒
await cache.set(key, data, { ttl: 300 });
```

### TODO/FIXME 标记

```typescript
// TODO: 添加邮箱验证逻辑
// FIXME: 这里存在性能问题，需要优化
// HACK: 临时解决方案，后续需要重构
// NOTE: 这个逻辑依赖于外部 API 的行为
```

---

## ✅ 代码审查清单

### 提交前自检

#### 基础检查

- [ ] 代码可以正常编译/运行
- [ ] 没有未使用的变量和导入
- [ ] 没有遗留的调试代码（console.log, debugger）
- [ ] 没有硬编码的敏感信息（密码、密钥）

#### 命名检查

- [ ] 变量名清晰表达用途
- [ ] 函数名以动词开头
- [ ] 类名使用 PascalCase
- [ ] 常量使用 UPPER_SNAKE_CASE

#### 代码质量

- [ ] 函数长度不超过 50 行
- [ ] 嵌套层级不超过 3 层
- [ ] 没有重复代码（DRY 原则）
- [ ] 错误处理完善
- [ ] 边界条件已考虑

#### 注释检查

- [ ] 复杂逻辑有注释说明
- [ ] 公共 API 有 JSDoc 注释
- [ ] 没有无意义的注释
- [ ] TODO 有明确的后续计划

### 审查他人代码

#### 功能性

- [ ] 代码实现了需求
- [ ] 处理了边界情况
- [ ] 错误处理合理
- [ ] 没有明显的 bug

#### 可读性

- [ ] 代码易于理解
- [ ] 命名清晰一致
- [ ] 结构合理
- [ ] 注释充分

#### 可维护性

- [ ] 遵循单一职责原则
- [ ] 没有过度设计
- [ ] 测试覆盖充分
- [ ] 没有技术债务

#### 性能

- [ ] 没有明显的性能问题
- [ ] 资源使用合理
- [ ] 异步处理正确

---

## 🎨 代码风格

### 缩进与空格

- 使用 **2 个空格** 缩进
- 行尾 **无空格**
- 文件末尾 **空一行**

### 括号与换行

```typescript
// ✅ 正确
if (condition) {
  doSomething();
}

function example() {
  return value;
}

// ❌ 错误
if (condition)
{
  doSomething();
}

function example()
{
  return value;
}
```

### 引号与分号

- 字符串使用 **单引号**（除非需要模板字符串）
- 语句末尾 **必须加分号**

```typescript
// ✅ 正确
const name = 'Alice';
const message = `Hello, ${name}`;

// ❌ 错误
const name = "Alice"
const message = 'Hello, ' + name
```

---

*规范版本: v1.0*
*最后更新: 2026-03-27*
