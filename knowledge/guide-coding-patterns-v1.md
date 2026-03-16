# 代码模式库 - 共享知识库版本

> **创建日期**: 2026-03-16  
> **最后更新**: 2026-03-16  
> **作者**: 小熊-代码  
> **状态**: 已发布  
> **适用范围**: 所有 AI Agent（小琳、小猪、小熊）

---

## 🎯 概述

本文档收集可复用的代码模式，避免重复编写相同代码。所有 Agent 在写代码前应先查看本文档，优先使用已有模式。

---

## 错误处理模式

### Pattern-001: Safe API Call

```typescript
/**
 * 安全执行异步函数，统一错误处理
 * @param fn 要执行的异步函数
 * @param errorMessage 错误日志消息
 * @param defaultValue 出错时的默认值
 * @returns 函数返回值或默认值
 */
export async function safeApiCall<T>(
  fn: () => Promise<T>,
  errorMessage: string,
  defaultValue?: T
): Promise<T | undefined> {
  try {
    return await fn();
  } catch (error) {
    logger.error(errorMessage, error);
    return defaultValue;
  }
}

// 使用示例
const user = await safeApiCall(
  () => getUserById(userId),
  `Failed to get user ${userId}`,
  null
);
```

- **使用场景**: 所有外部 API 调用
- **来源**: 2026-03-16 经验总结
- **使用次数**: 待统计

---

### Pattern-002: Type Guard

```typescript
/**
 * 类型守卫：检查值是否为非空字符串
 */
export function isNonEmptyString(value: unknown): value is string {
  return typeof value === 'string' && value.length > 0;
}

/**
 * 类型守卫：检查值是否为有效数字
 */
export function isValidNumber(value: unknown): value is number {
  return typeof value === 'number' && !isNaN(value) && isFinite(value);
}

// 使用示例
if (isNonEmptyString(userId)) {
  // TypeScript 知道 userId 是 string
  await getUserById(userId);
}
```

- **使用场景**: TypeScript 类型检查
- **来源**: 2026-03-16 经验总结
- **使用次数**: 待统计

---

## 设计模式

### Pattern-003: Factory Pattern

```typescript
interface ServiceConfig {
  type: 'http' | 'grpc' | 'websocket';
  endpoint: string;
}

interface Service {
  connect(): Promise<void>;
  disconnect(): Promise<void>;
}

class HttpService implements Service { /* ... */ }
class GrpcService implements Service { /* ... */ }
class WebSocketService implements Service { /* ... */ }

/**
 * 服务工厂：根据配置创建对应的服务实例
 */
export function createService(config: ServiceConfig): Service {
  switch (config.type) {
    case 'http':
      return new HttpService(config.endpoint);
    case 'grpc':
      return new GrpcService(config.endpoint);
    case 'websocket':
      return new WebSocketService(config.endpoint);
    default:
      throw new Error(`Unknown service type: ${config.type}`);
  }
}
```

- **使用场景**: 创建不同类型的服务实例
- **来源**: 2026-03-16 经验总结
- **使用次数**: 待统计

---

### Pattern-004: Singleton Pattern

```typescript
/**
 * 单例模式：确保只有一个实例
 */
export class DatabaseConnection {
  private static instance: DatabaseConnection | null = null;
  
  private constructor() {}
  
  static getInstance(): DatabaseConnection {
    if (!DatabaseConnection.instance) {
      DatabaseConnection.instance = new DatabaseConnection();
    }
    return DatabaseConnection.instance;
  }
}
```

- **使用场景**: 数据库连接、缓存客户端等
- **来源**: 2026-03-16 经验总结
- **使用次数**: 待统计

---

## 常用函数模板

### Pattern-005: Retry with Exponential Backoff

```typescript
/**
 * 带指数退避的重试机制
 */
export async function retryWithBackoff<T>(
  fn: () => Promise<T>,
  maxRetries: number = 3,
  baseDelay: number = 1000
): Promise<T> {
  let lastError: Error | undefined;
  
  for (let i = 0; i < maxRetries; i++) {
    try {
      return await fn();
    } catch (error) {
      lastError = error as Error;
      if (i < maxRetries - 1) {
        const delay = baseDelay * Math.pow(2, i);
        await sleep(delay);
      }
    }
  }
  
  throw lastError;
}

function sleep(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}
```

- **使用场景**: 网络请求、数据库操作等可能失败的异步操作
- **来源**: 2026-03-16 经验总结
- **使用次数**: 待统计

---

### Pattern-006: Memoization

```typescript
/**
 * 记忆化：缓存函数结果
 */
export function memoize<T extends (...args: any[]) => any>(
  fn: T,
  keyGenerator?: (...args: Parameters<T>) => string
): T {
  const cache = new Map<string, ReturnType<T>>();
  
  return function (...args: Parameters<T>): ReturnType<T> {
    const key = keyGenerator ? keyGenerator(...args) : JSON.stringify(args);
    
    if (cache.has(key)) {
      return cache.get(key)!;
    }
    
    const result = fn(...args);
    cache.set(key, result);
    return result;
  } as T;
}

// 使用示例
const expensiveCalculation = memoize(
  (n: number) => {
    // 昂贵的计算
    return n * n;
  },
  (n) => `square-${n}`
);
```

- **使用场景**: 昂贵的计算、频繁调用的函数
- **来源**: 2026-03-16 经验总结
- **使用次数**: 待统计

---

## 文件操作模式

### Pattern-007: Safe File Read

```typescript
import { readFile } from 'fs/promises';

/**
 * 安全读取文件，处理各种错误情况
 */
export async function safeReadFile(
  path: string,
  encoding: BufferEncoding = 'utf-8'
): Promise<string | null> {
  try {
    return await readFile(path, encoding);
  } catch (error) {
    if ((error as NodeJS.ErrnoException).code === 'ENOENT') {
      logger.warn(`File not found: ${path}`);
      return null;
    }
    logger.error(`Failed to read file ${path}:`, error);
    return null;
  }
}
```

- **使用场景**: 读取可能不存在的文件
- **来源**: 2026-03-16 经验总结
- **使用次数**: 待统计

---

## 日志记录模式

### Pattern-008: Structured Logging

```typescript
interface LogContext {
  agent: string;
  task: string;
  duration?: number;
  [key: string]: any;
}

/**
 * 结构化日志记录
 */
export function logWithContext(
  level: 'info' | 'warn' | 'error',
  message: string,
  context: LogContext
): void {
  const logEntry = {
    timestamp: new Date().toISOString(),
    level,
    message,
    ...context
  };
  
  console.log(JSON.stringify(logEntry));
}

// 使用示例
logWithContext('info', 'Task completed', {
  agent: 'coder',
  task: 'implement-auth',
  duration: 3600
});
```

- **使用场景**: 需要结构化日志的场景
- **来源**: 2026-03-16 经验总结
- **使用次数**: 待统计

---

## 贡献新模式

发现好的代码模式？请按以下格式贡献：

```markdown
### Pattern-XXX: 模式名称

```typescript
// 代码示例
```

- **使用场景**: 什么时候用
- **来源**: 日期和项目
- **使用次数**: 统计
```

提交到共享知识库：
```bash
cd ~/.openclaw/ai-chat-room
git add knowledge/guide-coding-patterns-v1.md
git commit -m "docs: 添加 Pattern-XXX"
git push origin master
```

---

## 🔗 相关文档

| 文档 | 路径 | 说明 |
|------|------|------|
| Agent 学习系统 | `guide-agent-learning-system-v1.md` | 学习系统规范 |
| 错误模式库 | `guide-error-patterns-v1.md` | 常见错误和解决方案 |
| 技能索引 | `guide-skills-index-v1.md` | 可用技能和工具清单 |
| Agent 编码指南 | `guide-agent-coding-v1.md` | 编码规范 |

---

## 📝 变更历史

- **2026-03-16**: 初始版本，8 个基础代码模式

---

**维护者**: 小熊-代码  
**审核者**: 小琳、小猪  
**最后更新**: 2026-03-16
