---
id: "config-database"
title: "数据库配置"
description: "Prisma + SQLite/PostgreSQL 数据库配置模板"
---

# 数据库配置

## Prisma Schema 模板

```prisma
// prisma/schema.prisma

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "sqlite" // 或 "postgresql"
  url      = env("DATABASE_URL")
}

// ============================================
// 用户模型
// ============================================
model User {
  id        String   @id @default(cuid())
  email     String   @unique
  username  String   @unique
  password  String?  // 密码哈希
  name      String?
  avatar    String?
  role      Role     @default(USER)
  status    UserStatus @default(ACTIVE)
  
  // 时间戳
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  
  // 关系
  sessions  Session[]
  posts     Post[]
  
  @@map("users")
}

enum Role {
  USER
  ADMIN
  MODERATOR
}

enum UserStatus {
  ACTIVE
  INACTIVE
  SUSPENDED
}

// ============================================
// 会话模型
// ============================================
model Session {
  id           String   @id @default(cuid())
  userId       String
  token        String   @unique
  expiresAt    DateTime
  
  // 元数据
  ipAddress    String?
  userAgent    String?
  
  createdAt    DateTime @default(now())
  
  // 关系
  user         User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  
  @@index([userId])
  @@index([token])
  @@map("sessions")
}

// ============================================
// 文章模型
// ============================================
model Post {
  id          String    @id @default(cuid())
  title       String
  slug        String    @unique
  content     String
  excerpt     String?
  coverImage  String?
  published   Boolean   @default(false)
  publishedAt DateTime?
  
  // 统计
  viewCount   Int       @default(0)
  likeCount   Int       @default(0)
  
  // 时间戳
  createdAt   DateTime  @default(now())
  updatedAt   DateTime  @updatedAt
  
  // 关系
  authorId    String
  author      User      @relation(fields: [authorId], references: [id], onDelete: Cascade)
  tags        Tag[]
  
  @@index([authorId])
  @@index([published])
  @@index([slug])
  @@map("posts")
}

// ============================================
// 标签模型
// ============================================
model Tag {
  id        String   @id @default(cuid())
  name      String   @unique
  slug      String   @unique
  
  // 关系
  posts     Post[]
  
  @@map("tags")
}

// ============================================
// 审计日志
// ============================================
model AuditLog {
  id          String   @id @default(cuid())
  userId      String?
  action      String   // CREATE, UPDATE, DELETE, LOGIN, etc.
  entityType  String   // User, Post, etc.
  entityId    String?
  oldValue    String?  // JSON
  newValue    String?  // JSON
  metadata    String?  // JSON
  ipAddress   String?
  
  createdAt   DateTime @default(now())
  
  @@index([userId])
  @@index([action])
  @@index([entityType])
  @@index([createdAt])
  @@map("audit_logs")
}
```

## 数据库客户端

```typescript
// lib/db.ts
import { PrismaClient } from '@prisma/client';

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined;
};

export const prisma = globalForPrisma.prisma ?? new PrismaClient();

if (process.env.NODE_ENV !== 'production') {
  globalForPrisma.prisma = prisma;
}

// 类型导出
export * from '@prisma/client';
```

## 数据库工具函数

```typescript
// lib/db-utils.ts
import { prisma } from './db';

/**
 * 事务包装器
 */
export async function withTransaction<T>(
  fn: (tx: typeof prisma) => Promise<T>
): Promise<T> {
  return await prisma.$transaction(async (tx) => {
    return await fn(tx as typeof prisma);
  });
}

/**
 * 分页查询
 */
export async function paginate<T>(
  model: any,
  where: any = {},
  options: {
    page?: number;
    pageSize?: number;
    orderBy?: any;
    include?: any;
  } = {}
) {
  const { page = 1, pageSize = 20, orderBy, include } = options;
  const skip = (page - 1) * pageSize;

  const [data, total] = await Promise.all([
    model.findMany({
      where,
      skip,
      take: pageSize,
      orderBy,
      include,
    }),
    model.count({ where }),
  ]);

  return {
    data,
    pagination: {
      page,
      pageSize,
      total,
      totalPages: Math.ceil(total / pageSize),
      hasNextPage: page * pageSize < total,
      hasPrevPage: page > 1,
    },
  };
}

/**
 * 软删除
 */
export async function softDelete(
  model: any,
  id: string,
  userId?: string
) {
  return await model.update({
    where: { id },
    data: {
      deletedAt: new Date(),
      deletedBy: userId,
    },
  });
}

/**
 * 批量操作
 */
export async function batchCreate<T>(
  model: any,
  data: T[],
  batchSize = 100
) {
  const results = [];
  for (let i = 0; i < data.length; i += batchSize) {
    const batch = data.slice(i, i + batchSize);
    const result = await model.createMany({ data: batch });
    results.push(result);
  }
  return results;
}
```

## 种子数据

```typescript
// prisma/seed.ts
import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  // 创建管理员用户
  const adminPassword = await bcrypt.hash('admin123', 10);
  
  const admin = await prisma.user.upsert({
    where: { email: 'admin@example.com' },
    update: {},
    create: {
      email: 'admin@example.com',
      username: 'admin',
      password: adminPassword,
      name: 'Administrator',
      role: 'ADMIN',
    },
  });

  console.log('Created admin user:', admin.id);

  // 创建示例标签
  const tags = await prisma.tag.createMany({
    data: [
      { name: '技术', slug: 'tech' },
      { name: '生活', slug: 'life' },
      { name: '随笔', slug: 'essay' },
    ],
    skipDuplicates: true,
  });

  console.log('Created tags:', tags.count);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
```

## 常用命令

```bash
# 生成 Prisma 客户端
npx prisma generate

# 创建迁移
npx prisma migrate dev --name init

# 应用迁移（生产环境）
npx prisma migrate deploy

# 重置数据库
npx prisma migrate reset

# 打开 Prisma Studio
npx prisma studio

# 运行种子
npx prisma db seed

# 验证 schema
npx prisma validate

# 格式化 schema
npx prisma format
```

## package.json 配置

```json
{
  "prisma": {
    "seed": "tsx prisma/seed.ts"
  },
  "scripts": {
    "db:generate": "prisma generate",
    "db:migrate": "prisma migrate dev",
    "db:deploy": "prisma migrate deploy",
    "db:reset": "prisma migrate reset",
    "db:studio": "prisma studio",
    "db:seed": "prisma db seed"
  }
}
```

## 环境变量

```bash
# SQLite
DATABASE_URL="file:./dev.db"

# PostgreSQL
DATABASE_URL="postgresql://user:password@localhost:5432/mydb"

# 连接池（生产环境）
DATABASE_URL="postgresql://user:password@localhost:5432/mydb?connection_limit=10"
```
