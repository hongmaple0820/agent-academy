---
id: "config-env"
title: "环境变量配置"
description: "项目环境变量配置模板，包含开发、测试、生产环境"
---

# 环境变量配置

## 文件结构

```
.env              # 默认环境变量（不提交到 Git）
.env.local        # 本地环境变量（不提交到 Git）
.env.development  # 开发环境
.env.test         # 测试环境
.env.production   # 生产环境
.env.example      # 示例文件（提交到 Git）
```

## .env.example 模板

```bash
# ============================================
# 应用配置
# ============================================
# 应用名称
NEXT_PUBLIC_APP_NAME=MyApp

# 应用 URL
NEXT_PUBLIC_APP_URL=http://localhost:3000

# 环境模式: development | test | production
NODE_ENV=development

# ============================================
# 数据库配置
# ============================================
# 数据库类型: sqlite | postgresql | mysql
DATABASE_PROVIDER=sqlite

# 数据库连接字符串
# SQLite 示例
DATABASE_URL="file:./dev.db"

# PostgreSQL 示例
# DATABASE_URL="postgresql://user:password@localhost:5432/mydb"

# ============================================
# 认证配置
# ============================================
# JWT 密钥（生成命令: openssl rand -base64 32）
JWT_SECRET=your-jwt-secret-key

# Session 密钥
SESSION_SECRET=your-session-secret-key

# Cookie 安全（生产环境设为 true）
COOKIE_SECURE=false

# ============================================
# OAuth2 配置
# ============================================
# GitHub OAuth
GITHUB_CLIENT_ID=
GITHUB_CLIENT_SECRET=

# Google OAuth
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=

# OAuth 回调地址
OAUTH_REDIRECT_URI=http://localhost:3000/api/auth/callback

# ============================================
# 邮件服务配置
# ============================================
# SMTP 配置
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USER=
SMTP_PASSWORD=
SMTP_FROM=noreply@example.com

# ============================================
# 存储配置
# ============================================
# 文件上传路径
UPLOAD_DIR=./uploads

# 最大文件大小（MB）
MAX_FILE_SIZE=10

# 允许的文件类型
ALLOWED_FILE_TYPES=image/jpeg,image/png,image/gif

# ============================================
# 缓存配置
# ============================================
# Redis 配置（可选）
REDIS_URL=redis://localhost:6379
REDIS_PASSWORD=

# ============================================
# 外部 API 配置
# ============================================
# OpenAI API
OPENAI_API_KEY=
OPENAI_BASE_URL=https://api.openai.com/v1

# 其他 API 密钥
API_KEY=

# ============================================
# 监控和日志
# ============================================
# 日志级别: debug | info | warn | error
LOG_LEVEL=info

# Sentry 配置（错误追踪）
SENTRY_DSN=
SENTRY_ENVIRONMENT=development

# ============================================
# 功能开关
# ============================================
# 是否启用注册
ENABLE_REGISTRATION=true

# 是否启用邮件验证
ENABLE_EMAIL_VERIFICATION=false

# 是否启用 2FA
ENABLE_2FA=false
```

## Next.js 环境变量规范

```typescript
// lib/env.ts
import { z } from 'zod';

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
  DATABASE_URL: z.string(),
  JWT_SECRET: z.string().min(32),
  NEXT_PUBLIC_APP_URL: z.string().url(),
  NEXT_PUBLIC_APP_NAME: z.string().default('MyApp'),
});

export const env = envSchema.parse(process.env);
```

## 环境变量类型定义

```typescript
// types/env.d.ts
declare global {
  namespace NodeJS {
    interface ProcessEnv {
      NODE_ENV: 'development' | 'test' | 'production';
      
      // Database
      DATABASE_URL: string;
      
      // Auth
      JWT_SECRET: string;
      SESSION