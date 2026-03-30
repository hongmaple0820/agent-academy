---
id: "snippet-008"
language: "typescript"
category: "utility"
tags: ["date", "format", "time", "intl"]
author: "ChessVerse"
description: "日期格式化工具函数，支持相对时间和多种格式"
complexity: "medium"
---

# 日期格式化工具

## 代码内容

```typescript
/**
 * 格式化日期为相对时间
 * @param date 日期字符串或 Date 对象
 * @returns 相对时间描述（如：刚刚、5分钟前、昨天等）
 */
export function formatRelativeTime(date: string | Date): string {
  const now = new Date();
  const target = new Date(date);
  const diffMs = now.getTime() - target.getTime();
  const diffSecs = Math.floor(diffMs / 1000);
  const diffMins = Math.floor(diffSecs / 60);
  const diffHours = Math.floor(diffMins / 60);
  const diffDays = Math.floor(diffHours / 24);

  if (diffSecs < 60) return '刚刚';
  if (diffMins < 60) return `${diffMins}分钟前`;
  if (diffHours < 24) return `${diffHours}小时前`;
  if (diffDays === 1) return '昨天';
  if (diffDays < 7) return `${diffDays}天前`;
  if (diffDays < 30) return `${Math.floor(diffDays / 7)}周前`;
  
  return formatDate(date, 'yyyy-MM-dd');
}

/**
 * 格式化日期
 * @param date 日期字符串或 Date 对象
 * @param format 格式模板
 */
export function formatDate(
  date: string | Date,
  format: string = 'yyyy-MM-dd HH:mm'
): string {
  const d = new Date(date);
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  const hours = String(d.getHours()).padStart(2, '0');
  const minutes = String(d.getMinutes()).padStart(2, '0');
  const seconds = String(d.getSeconds()).padStart(2, '0');

  return format
    .replace('yyyy', String(year))
    .replace('MM', month)
    .replace('dd', day)
    .replace('HH', hours)
    .replace('mm', minutes)
    .replace('ss', seconds);
}

/**
 * 格式化时长
 * @param seconds 秒数
 * @returns 格式化的时长（如：1:30、2:45:30）
 */
export function formatDuration(seconds: number): string {
  const hours = Math.floor(seconds / 3600);
  const mins = Math.floor((seconds % 3600) / 60);
  const secs = seconds % 60;

  if (hours > 0) {
    return `${hours}:${String(mins).padStart(2, '0')}:${String(secs).padStart(2, '0')}`;
  }
  return `${mins}:${String(secs).padStart(2, '0')}`;
}

/**
 * 检查日期是否在今天
 */
export function isToday(date: string | Date): boolean {
  const d = new Date(date);
  const now = new Date();
  return d.toDateString() === now.toDateString();
}

/**
 * 获取日期范围的开始和结束
 */
export function getDateRange(range: 'today' | 'week' | 'month'): { start: Date; end: Date } {
  const now = new Date();
  const start = new Date(now);
  const end = new Date(now);

  switch (range) {
    case 'today':
      start.setHours(0, 0, 0, 0);
      end.setHours(23, 59, 59, 999);
      break;
    case 'week':
      start.setDate(now.getDate() - now.getDay());
      start.setHours(0, 0, 0, 0);
      end.setHours(23, 59, 59, 999);
      break;
    case 'month':
      start.setDate(1);
      start.setHours(0, 0, 0, 0);
      end.setHours(23, 59, 59, 999);
      break;
  }

  return { start, end };
}
```

## 使用示例

```typescript
import { formatRelativeTime, formatDate, formatDuration } from "@/lib/date-utils"

// 相对时间
formatRelativeTime(new Date()) // "刚刚"
formatRelativeTime("2024-01-01") // "3个月前"

// 格式化日期
formatDate(new Date(), "yyyy-MM-dd") // "2024-03-27"
formatDate(new Date(), "HH:mm") // "14:30"

// 格式化时长
formatDuration(90) // "1:30"
formatDuration(3665) // "1:01:05"
```
