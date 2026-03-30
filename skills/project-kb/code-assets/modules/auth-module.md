---
id: "module-auth"
type: "authentication"
complexity: "high"
title: "认证模块"
description: "完整的用户认证系统，支持 Cookie-based 会话管理和 OAuth2 集成"
author: "ChessVerse"
---

# 认证模块

## 概述

本模块提供完整的用户认证解决方案，包括：
- 基于 Cookie 的会话管理
- 用户名/密码登录
- OAuth2 第三方登录集成
- Token 刷新机制

## 接口定义

### 类型定义

```typescript
// 用户类型
interface User {
  id: string;
  username: string;
  email?: string;
  avatar?: string;
  playerType: 'human' | 'agent';
  isOnline: boolean;
}

// 登录凭证
interface LoginCredentials {
  username: string;
  password: string;
}

// 登录响应
interface LoginResponse {
  success: boolean;
  player: User;
  error?: string;
}

// OAuth2 Token
interface TokenData {
  accessToken: string;
  refreshToken: string;
  expiresIn: number;
  expiresAt: Date;
}

// 认证状态
interface AuthState {
  user: User | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  error: string | null;
}
```

### API 接口

```typescript
// 认证服务接口
interface IAuthService {
  // 登录
  login(credentials: LoginCredentials): Promise<LoginResponse>;
  
  // 登出
  logout(): Promise<void>;
  
  // 获取当前用户
  getCurrentUser(): Promise<User | null>;
  
  // 检查认证状态
  checkAuth(): Promise<boolean>;
  
  // OAuth2 相关
  getOAuthUrl(provider: string): string;
  handleOAuthCallback(code: string, provider: string): Promise<LoginResponse>;
  refreshToken(): Promise<boolean>;
}
```

## 核心实现

### 1. 服务端登录 API

```typescript
// app/api/auth/login/route.ts
import { NextRequest, NextResponse } from 'next/server';
import bcrypt from 'bcryptjs';

export async function POST(request: NextRequest) {
  try {
    const { username, password } = await request.json();

    if (!username || !password) {
      return NextResponse.json(
        { error: '用户名和密码不能为空' },
        { status: 400 }
      );
    }

    // 查找用户
    const user = await prisma.user.findUnique({ where: { username } });

    if (!user || !user.password) {
      return NextResponse.json(
        { error: '用户名或密码错误' },
        { status: 401 }
      );
    }

    // 验证密码
    const isValid = await bcrypt.compare(password, user.password);
    if (!isValid) {
      return NextResponse.json(
        { error: '用户名或密码错误' },
        { status: 401 }
      );
    }

    // 创建响应
    const response = NextResponse.json({
      success: true,
      user: { id: user.id, username: user.username }
    });

    // 设置 Cookie
    response.cookies.set('sessionId', user.id, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'lax',
      maxAge: 60 * 60 * 24 * 7 // 7天
    });

    return response;
  } catch (error) {
    return NextResponse.json(
      { error: '登录失败' },
      { status: 500 }
    );
  }
}
```

### 2. 获取当前用户 API

```typescript
// app/api/auth/me/route.ts
export async function GET(request: NextRequest) {
  const sessionId = request.cookies.get('sessionId')?.value;

  if (!sessionId) {
    return NextResponse.json(
      { error: '未登录' },
      { status: 401 }
    );
  }

  const user = await prisma.user.findUnique({
    where: { id: sessionId }
  });

  if (!user) {
    return NextResponse.json(
      { error: '用户不存在' },
      { status: 404 }
    );
  }

  return NextResponse.json({ user });
}
```

### 3. React Hook

```typescript
// hooks/use-auth.ts
import { useState, useEffect, createContext, useContext } from 'react';

const AuthContext = createContext<{
  user: User | null;
  login: (creds: LoginCredentials) => Promise<void>;
  logout: () => Promise<void>;
  isLoading: boolean;
} | null>(null);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    // 检查当前登录状态
    fetch('/api/auth/me')
      .then(res => res.ok ? res.json() : null)
      .then(data => setUser(data?.user || null))
      .finally(() => setIsLoading(false));
  }, []);

  const login = async (credentials: LoginCredentials) => {
    const res = await fetch('/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(credentials)
    });
    
    if (!res.ok) throw new Error('Login failed');
    
    const data = await res.json();
    setUser(data.user);
  };

  const logout = async () => {
    await fetch('/api/auth/logout', { method: 'POST' });
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, login, logout, isLoading }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth must be used within AuthProvider');
  return ctx;
};
```

## 使用示例

```tsx
// 登录表单
function LoginForm() {
  const { login } = useAuth();
  const [error, setError] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await login({ username, password });
      router.push('/dashboard');
    } catch (err) {
      setError('登录失败');
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <input name="username" required />
      <input name="password" type="password" required />
      <button type="submit">登录</button>
      {error && <p>{error}</p>}
    </form>
  );
}

// 受保护路由
function ProtectedPage() {
  const { user, isLoading } = useAuth();
  
  if (isLoading) return <Loading />;
  if (!user) return <Redirect to="/login" />;
  
  return <div>Welcome, {user.username}</div>;
}
```

## 测试用例

```typescript
// __tests__/auth.test.ts
import { describe, it, expect, vi } from 'vitest';

describe('Auth Module', () => {
  it('should login with valid credentials', async () => {
    const mockUser = { id: '1', username: 'test' };
    global.fetch = vi.fn().mockResolvedValue({
      ok: true,
      json: () => Promise.resolve({ user: mockUser })
    });

    const result = await login({ username: 'test', password: 'pass' });
    expect(result.user).toEqual(mockUser);
  });

  it('should reject invalid credentials', async () => {
    global.fetch = vi.fn().mockResolvedValue({
      ok: false,
      status: 401
    });

    await expect(login({ username: 'test', password: 'wrong' }))
      .rejects.toThrow('Login failed');
  });

  it('should clear user on logout', async () => {
    global.fetch = vi.fn().mockResolvedValue({ ok: true });
    await logout();
    expect(user).toBeNull();
  });
});
```

## 设计思路

1. **安全性**: 使用 httpOnly Cookie 存储会话，防止 XSS 攻击
2. **用户体验**: 自动检查登录状态，无感刷新
3. **可扩展性**: 预留 OAuth2 接口，支持第三方登录
4. **类型安全**: 完整的 TypeScript 类型定义
