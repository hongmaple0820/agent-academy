---
id: "module-notification"
type: "notification"
complexity: "medium"
title: "消息通知模块"
description: "全局消息通知系统，支持多种类型、位置配置和队列管理"
author: "ChessVerse"
---

# 消息通知模块

## 概述

提供全局消息通知解决方案：
- 多种通知类型（成功、错误、警告、信息）
- 多位置支持
- 自动消失和手动关闭
- 队列管理和优先级
- i18n 集成

## 接口定义

### 核心类型

```typescript
// 通知类型
type NotificationType = 'default' | 'success' | 'error' | 'warning' | 'info';

// 通知位置
type NotificationPosition = 
  | 'top-left' | 'top-center' | 'top-right'
  | 'bottom-left' | 'bottom-center' | 'bottom-right';

// 通知选项
interface NotificationOptions {
  id?: string;
  title?: string;
  description?: string;
  type?: NotificationType;
  duration?: number; // 毫秒，0 表示不自动关闭
  position?: NotificationPosition;
  closable?: boolean;
  action?: {
    label: string;
    onClick: () => void;
  };
  onClose?: () => void;
}

// 通知对象
interface Notification extends NotificationOptions {
  id: string;
  createdAt: number;
}

// 通知状态
type NotificationState = {
  notifications: Notification[];
};

// 通知服务接口
interface INotificationService {
  show(options: NotificationOptions): string;
  success(title: string, options?: Omit<NotificationOptions, 'type' | 'title'>): string;
  error(title: string, options?: Omit<NotificationOptions, 'type' | 'title'>): string;
  warning(title: string, options?: Omit<NotificationOptions, 'type' | 'title'>): string;
  info(title: string, options?: Omit<NotificationOptions, 'type' | 'title'>): string;
  dismiss(id: string): void;
  dismissAll(): void;
}
```

## 核心实现

### 1. 通知状态管理

```typescript
// lib/notifications/store.ts
import { create } from 'zustand';

interface NotificationStore {
  notifications: Notification[];
  show: (options: NotificationOptions) => string;
  dismiss: (id: string) => void;
  dismissAll: () => void;
}

let notificationId = 0;

export const useNotificationStore = create<NotificationStore>((set, get) => ({
  notifications: [],

  show: (options) => {
    const id = options.id || `notification-${++notificationId}`;
    const notification: Notification = {
      ...options,
      id,
      type: options.type || 'default',
      duration: options.duration ?? 5000,
      position: options.position || 'top-right',
      closable: options.closable ?? true,
      createdAt: Date.now(),
    };

    set((state) => ({
      notifications: [...state.notifications, notification],
    }));

    // 自动关闭
    if (notification.duration > 0) {
      setTimeout(() => {
        get().dismiss(id);
      }, notification.duration);
    }

    return id;
  },

  dismiss: (id) => {
    set((state) => {
      const notification = state.notifications.find(n => n.id === id);
      notification?.onClose?.();
      return {
        notifications: state.notifications.filter(n => n.id !== id),
      };
    });
  },

  dismissAll: () => {
    set((state) => {
      state.notifications.forEach(n => n.onClose?.());
      return { notifications: [] };
    });
  },
}));
```

### 2. 通知服务

```typescript
// lib/notifications/service.ts
import { useNotificationStore } from './store';

export const notificationService: INotificationService = {
  show: (options) => {
    return useNotificationStore.getState().show(options);
  },

  success: (title, options = {}) => {
    return useNotificationStore.getState().show({
      ...options,
      title,
      type: 'success',
    });
  },

  error: (title, options = {}) => {
    return useNotificationStore.getState().show({
      ...options,
      title,
      type: 'error',
      duration: options.duration ?? 8000, // 错误默认显示更久
    });
  },

  warning: (title, options = {}) => {
    return useNotificationStore.getState().show({
      ...options,
      title,
      type: 'warning',
    });
  },

  info: (title, options = {}) => {
    return useNotificationStore.getState().show({
      ...options,
      title,
      type: 'info',
    });
  },

  dismiss: (id) => {
    useNotificationStore.getState().dismiss(id);
  },

  dismissAll: () => {
    useNotificationStore.getState().dismissAll();
  },
};
```

### 3. 通知组件

```typescript
// components/notifications/NotificationContainer.tsx
import { useNotificationStore } from '@/lib/notifications/store';
import { NotificationItem } from './NotificationItem';

const positionClasses: Record<NotificationPosition, string> = {
  'top-left': 'top-4 left-4',
  'top-center': 'top-4 left-1/2 -translate-x-1/2',
  'top-right': 'top-4 right-4',
  'bottom-left': 'bottom-4 left-4',
  'bottom-center': 'bottom-4 left-1/2 -translate-x-1/2',
  'bottom-right': 'bottom-4 right-4',
};

export function NotificationContainer() {
  const notifications = useNotificationStore((state) => state.notifications);

  // 按位置分组
  const groupedByPosition = notifications.reduce((acc, notification) => {
    const pos = notification.position || 'top-right';
    if (!acc[pos]) acc[pos] = [];
    acc[pos].push(notification);
    return acc;
  }, {} as Record<NotificationPosition, Notification[]>);

  return (
    <>
      {Object.entries(groupedByPosition).map(([position, items]) => (
        <div
          key={position}
          className={`fixed z-50 flex flex-col gap-2 ${positionClasses[position as NotificationPosition]}`}
        >
          {items.map((notification) => (
            <NotificationItem key={notification.id} notification={notification} />
          ))}
        </div>
      ))}
    </>
  );
}
```

```typescript
// components/notifications/NotificationItem.tsx
import { useNotificationStore } from '@/lib/notifications/store';
import { X, CheckCircle, AlertCircle, AlertTriangle, Info } from 'lucide-react';

const typeIcons = {
  default: Info,
  success: CheckCircle,
  error: AlertCircle,
  warning: AlertTriangle,
  info: Info,
};

const typeStyles = {
  default: 'bg-white border-gray-200 text-gray-800',
  success: 'bg-emerald-50 border-emerald-200 text-emerald-800',
  error: 'bg-red-50 border-red-200 text-red-800',
  warning: 'bg-amber-50 border-amber-200 text-amber-800',
  info: 'bg-blue-50 border-blue-200 text-blue-800',
};

interface NotificationItemProps {
  notification: Notification;
}

export function NotificationItem({ notification }: NotificationItemProps) {
  const dismiss = useNotificationStore((state) => state.dismiss);
  const Icon = typeIcons[notification.type || 'default'];

  return (
    <div
      className={`relative flex w-80 items-start gap-3 rounded-lg border p-4 shadow-lg animate-in slide-in-from-right ${typeStyles[notification.type || 'default']}`}
      role="alert"
    >
      <Icon className="h-5 w-5 shrink-0" />
      
      <div className="flex-1 min-w-0">
        {notification.title && (
          <h4 className="font-medium text-sm">{notification.title}</h4>
        )}
        {notification.description && (
          <p className="mt-1 text-sm opacity-90">{notification.description}</p>
        )}
        {notification.action && (
          <button
            onClick={notification.action.onClick}
            className="mt-2 text-sm font-medium underline hover:no-underline"
          >
            {notification.action.label}
          </button>
        )}
      </div>

      {notification.closable && (
        <button
          onClick={() => dismiss(notification.id)}
          className="shrink-0 opacity-50 hover:opacity-100 transition-opacity"
        >
          <X className="h-4 w-4" />
        </button>
      )}
    </div>
  );
}
```

### 4. Hook 封装

```typescript
// hooks/use-notification.ts
import { notificationService } from '@/lib/notifications/service';
import { useTranslations } from 'next-intl';

export function useNotification() {
  const t = useTranslations();

  return {
    show: notificationService.show,
    
    success: (messageKey: string, options?: any) => {
      notificationService.success(t(messageKey), {
        ...options,
        translate: true,
      });
    },
    
    error: (messageKey: string, options?: any) => {
      notificationService.error(t(messageKey), {
        ...options,
        translate: true,
      });
    },
    
    warning: (messageKey: string, options?: any) => {
      notificationService.warning(t(messageKey), {
        ...options,
        translate: true,
      });
    },
    
    info: (messageKey: string, options?: any) => {
      notificationService.info(t(messageKey), {
        ...options,
        translate: true,
      });
    },
    
    dismiss: notificationService.dismiss,
    dismissAll: notificationService.dismissAll,
  };
}
```

## 使用示例

```tsx
// 基础用法
import { notificationService } from '@/lib/notifications/service';

notificationService.success('操作成功');
notificationService.error('操作失败', { duration: 10000 });
notificationService.warning('请注意', { 
  description: '这是一条警告信息',
  position: 'top-center'
});

// 带操作的提示
notificationService.info('新消息', {
  action: {
    label: '查看',
    onClick: () => router.push('/messages'),
  },
});

// React Hook 用法
function UserProfile() {
  const notify = useNotification();

  const handleUpdate = async () => {
    try {
      await updateProfile(data);
      notify.success('profile.updateSuccess');
    } catch (error) {
      notify.error('profile.updateError');
    }
  };
}

// 在 App 中使用
function App() {
  return (
    <>
      <NotificationContainer />
      <main>{children}</main>
    </>
  );
}
```

## 测试用例

```typescript
// __tests__/notifications.test.ts
import { notificationService } from '@/lib/notifications/service';
import { useNotificationStore } from '@/lib/notifications/store';

describe('Notification Module', () => {
  beforeEach(() => {
    useNotificationStore.setState({ notifications: [] });
  });

  it('should show notification', () => {
    const id = notificationService.success('Test message');
    const state = useNotificationStore.getState();
    expect(state.notifications).toHaveLength(1);
    expect(state.notifications[0].title).toBe('Test message');
  });

  it('should dismiss notification', () => {
    const id = notificationService.info('Test');
    notificationService.dismiss(id);
    const state = useNotificationStore.getState();
    expect(state.notifications).toHaveLength(0);
  });

  it('should dismiss all notifications', () => {
    notificationService.success('1');
    notificationService.error('2');
    notificationService.dismissAll();
    const state = useNotificationStore.getState();
    expect(state.notifications).toHaveLength(0);
  });

  it('should auto-dismiss after duration', async () => {
    jest.useFakeTimers();
    notificationService.success('Test', { duration: 1000 });
    expect(useNotificationStore.getState().notifications).toHaveLength(1);
    jest.advanceTimersByTime(1000);
    expect(useNotificationStore.getState().notifications).toHaveLength(0);
    jest.useRealTimers();
  });
});
```

## 设计思路

1. **全局状态**: 使用 Zustand 管理通知状态，支持跨组件访问
2. **位置灵活**: 支持 6 个不同位置，自动分组显示
3. **类型丰富**: 5 种通知类型，每种有不同的视觉样式
4. **自动管理**: 自动关闭、队列管理，无需手动清理
5. **i18n 支持**: 内置国际化支持，方便多语言应用
