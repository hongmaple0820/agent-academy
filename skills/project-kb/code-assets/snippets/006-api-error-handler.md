---
id: "snippet-006"
language: "typescript"
category: "network"
tags: ["api", "error-handling", "fetch", "typescript"]
author: "ChessVerse"
description: "统一的 API 错误处理和通知集成，支持 i18n 翻译"
complexity: "medium"
---

# API 错误处理工具

## 代码内容

```typescript
'use client';

import { useTranslations } from 'next-intl';

type ToastVariant = 'default' | 'success' | 'error' | 'warning' | 'info';

interface ToastOptions {
  title?: string;
  description?: string;
  variant?: ToastVariant;
  translate?: boolean;
  values?: Record<string, string | number>;
  duration?: number;
}

interface NotifyFunctions {
  success: (message: string, options?: any) => void;
  error: (message: string, options?: any) => void;
  warning: (message: string, options?: any) => void;
  info: (message: string, options?: any) => void;
}

/**
 * 增强版通知 Hook，集成 i18n 支持
 */
export function useNotify() {
  const t = useTranslations();

  const notify = (options: ToastOptions) => {
    const {
      title,
      description,
      variant = 'default',
      translate = true,
      values = {},
      duration = 5000,
    } = options;

    const translatedTitle = title
      ? translate ? t(title, values) : title
      : undefined;

    const translatedDescription = description
      ? translate ? t(description, values) : description
      : undefined;

    // 调用你的 toast 方法
    console.log({ title: translatedTitle, description: translatedDescription, variant, duration });
  };

  return {
    success: (message: string, options?: any) =>
      notify({ title: message, variant: 'success', ...options }),
    error: (message: string, options?: any) =>
      notify({ title: message, variant: 'error', ...options }),
    warning: (message: string, options?: any) =>
      notify({ title: message, variant: 'warning', ...options }),
    info: (message: string, options?: any) =>
      notify({ title: message, variant: 'info', ...options }),
    notify,
  };
}

/**
 * API 错误处理辅助函数
 */
export async function handleApiError(
  response: Response,
  notify: NotifyFunctions,
  fallbackKey: string = 'toast.common.unknownError'
) {
  try {
    const data = await response.json();
    const errorMessage = data.error || data.message || fallbackKey;
    notify.error(errorMessage, { translate: true });
  } catch {
    notify.error(fallbackKey, { translate: true });
  }
}

/**
 * 网络错误处理辅助函数
 */
export function handleNetworkError(
  notify: NotifyFunctions,
  error?: Error
) {
  console.error('Network error:', error);
  notify.error('toast.common.networkError', { translate: true });
}

/**
 * 通用 API 请求封装
 */
export async function apiRequest<T>(
  url: string,
  options?: RequestInit
): Promise<T> {
  const response = await fetch(url, {
    headers: {
      'Content-Type': 'application/json',
    },
    ...options,
  });

  if (!response.ok) {
    const error = await response.json().catch(() => ({}));
    throw new Error(error.error || `HTTP ${response.status}`);
  }

  return response.json();
}
```

## 使用示例

```tsx
import { useNotify, handleApiError, apiRequest } from "@/hooks/use-notify"

function UserProfile() {
  const notify = useNotify()

  const updateProfile = async (data: any) => {
    try {
      const result = await apiRequest('/api/profile', {
        method: 'POST',
        body: JSON.stringify(data),
      })
      notify.success('Profile updated!')
    } catch (error) {
      notify.error(error.message)
    }
  }

  const fetchData = async () => {
    const response = await fetch('/api/data')
    if (!response.ok) {
      await handleApiError(response, notify)
      return
    }
    const data = await response.json()
  }

  return <button onClick={fetchData}>Fetch Data</button>
}
```
