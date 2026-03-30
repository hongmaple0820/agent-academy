# 项目画像模板

> 使用此模板为新项目创建画像。复制到 `memory/projects/{project-name}/index.md` 并填写。

---

## 📋 基本信息

| 字段 | 内容 |
|------|------|
| **项目名称** | 项目英文名称 |
| **显示名称** | 项目中文/显示名称 |
| **项目类型** | Web应用 / API服务 / CLI工具 / 库 / 其他 |
| **主要语言** | TypeScript / Python / Go / Rust / 其他 |
| **技术栈** | 框架、运行时、数据库等 |
| **项目状态** | 开发中 / 维护中 / 已归档 |
| **负责人** | 主要负责人 |
| **创建时间** | YYYY-MM-DD |
| **最后更新** | YYYY-MM-DD |

## 🚀 快速导航

### 入口文件

| 类型 | 路径 | 说明 |
|------|------|------|
| 主入口 | `src/index.ts` | 应用程序入口 |
| CLI入口 | `src/cli.ts` | 命令行工具入口 |
| 配置入口 | `src/config/index.ts` | 配置文件汇总 |

### 核心模块

| 模块 | 路径 | 职责 |
|------|------|------|
| API路由 | `src/routes/` | HTTP 路由定义 |
| 服务层 | `src/services/` | 业务逻辑 |
| 数据层 | `src/repositories/` | 数据访问 |
| 工具函数 | `src/utils/` | 通用工具 |

### 配置文件

| 文件 | 用途 |
|------|------|
| `package.json` | 依赖和脚本 |
| `tsconfig.json` | TypeScript 配置 |
| `.env.example` | 环境变量模板 |
| `docker-compose.yml` | 本地开发环境 |

## 📐 代码规范

### 命名规范

| 类型 | 规范 | 示例 |
|------|------|------|
| 变量 | camelCase | `userName`, `totalCount` |
| 常量 | UPPER_SNAKE_CASE | `MAX_RETRY`, `API_BASE_URL` |
| 函数 | camelCase | `getUserById()`, `formatDate()` |
| 类 | PascalCase | `UserService`, `OrderController` |
| 接口 | PascalCase + I前缀 | `IUser`, `IOrderConfig` |
| 类型别名 | PascalCase | `UserType`, `ApiResponse` |
| 文件 | kebab-case | `user-service.ts`, `api-types.ts` |
| 目录 | kebab-case | `user-management/`, `api-client/` |

### 目录结构

```
src/
├── index.ts              # 入口
├── config/               # 配置
├── routes/               # 路由/API
├── services/             # 业务逻辑
├── repositories/         # 数据访问
├── models/               # 数据模型
├── utils/                # 工具函数
├── middleware/           # 中间件
├── types/                # 类型定义
└── tests/                # 测试文件
```

### 注释规范

- **文件头**: 文件用途说明
- **函数**: JSDoc 格式，说明参数和返回值
- **复杂逻辑**: 行内注释解释"为什么"
- **TODO**: `// TODO: 说明` 标记待办

```typescript
/**
 * 获取用户信息
 * @param userId - 用户唯一标识
 * @returns 用户对象，未找到返回 null
 */
async function getUser(userId: string): Promise<User | null> {
  // 缓存优先，减少数据库查询
  const cached = await cache.get(`user:${userId}`);
  if (cached) return cached;
  
  // TODO: 添加数据库查询逻辑
  return null;
}
```

## ⚡ 常用命令

### 开发

```bash
# 安装依赖
npm install

# 启动开发服务器
npm run dev

# 类型检查
npm run type-check

# 代码检查
npm run lint

# 自动修复
npm run lint:fix
```

### 测试

```bash
# 运行所有测试
npm test

# 运行单元测试
npm run test:unit

# 运行集成测试
npm run test:integration

# 生成覆盖率报告
npm run test:coverage
```

### 构建部署

```bash
# 构建生产版本
npm run build

# 启动生产服务器
npm start

# Docker 构建
docker build -t project-name .
```

## 📦 关键依赖

### 运行时

| 依赖 | 版本 | 用途 |
|------|------|------|
| express | ^4.x | Web 框架 |
| typescript | ^5.x | 类型系统 |

### 开发

| 依赖 | 版本 | 用途 |
|------|------|------|
| jest | ^29.x | 测试框架 |
| eslint | ^8.x | 代码检查 |
| prettier | ^3.x | 代码格式化 |

### 生产

| 依赖 | 版本 | 用途 |
|------|------|------|
| redis | ^4.x | 缓存 |
| pg | ^8.x | PostgreSQL |

## ⚠️ 注意事项

### 已知问题

- 问题1: 描述和解决方案
- 问题2: 描述和解决方案

### 开发陷阱

- 陷阱1: 描述和避免方法
- 陷阱2: 描述和避免方法

### 环境要求

- Node.js >= 18
- PostgreSQL >= 14
- Redis >= 6

### 特殊配置

- 需要配置环境变量 `DATABASE_URL`
- 开发模式需要本地 Redis

---

## 📝 变更记录

| 日期 | 变更内容 | 变更人 |
|------|----------|--------|
| YYYY-MM-DD | 创建项目画像 | 姓名 |

---

*模板版本: APKS v1.0*
