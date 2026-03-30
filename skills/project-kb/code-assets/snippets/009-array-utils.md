---
id: "snippet-009"
language: "typescript"
category: "utility"
tags: ["array", "utils", "grouping", "pagination"]
author: "ChessVerse"
description: "数组处理工具函数，包含分组、分页、去重等常用操作"
complexity: "low"
---

# 数组工具函数

## 代码内容

```typescript
/**
 * 按指定键对数组进行分组
 * @param array 要分组的数组
 * @param key 分组键
 */
export function groupBy<T>(array: T[], key: keyof T): Record<string, T[]> {
  return array.reduce((result, item) => {
    const groupKey = String(item[key]);
    if (!result[groupKey]) {
      result[groupKey] = [];
    }
    result[groupKey].push(item);
    return result;
  }, {} as Record<string, T[]>);
}

/**
 * 数组分页
 * @param array 要分页的数组
 * @param page 当前页码（从1开始）
 * @param pageSize 每页大小
 */
export function paginate<T>(array: T[], page: number, pageSize: number): T[] {
  const start = (page - 1) * pageSize;
  return array.slice(start, start + pageSize);
}

/**
 * 根据指定键去重
 * @param array 要去重的数组
 * @param key 唯一键
 */
export function uniqueBy<T>(array: T[], key: keyof T): T[] {
  const seen = new Set();
  return array.filter((item) => {
    const value = item[key];
    if (seen.has(value)) return false;
    seen.add(value);
    return true;
  });
}

/**
 * 数组去重
 */
export function unique<T>(array: T[]): T[] {
  return [...new Set(array)];
}

/**
 * 按多个条件排序
 * @param array 要排序的数组
 * @param comparers 比较函数数组
 */
export function sortBy<T>(
  array: T[],
  ...comparers: ((a: T, b: T) => number)[]
): T[] {
  return [...array].sort((a, b) => {
    for (const comparer of comparers) {
      const result = comparer(a, b);
      if (result !== 0) return result;
    }
    return 0;
  });
}

/**
 * 创建比较器（升序）
 */
export function ascending<T>(key: keyof T): (a: T, b: T) => number {
  return (a, b) => {
    if (a[key] < b[key]) return -1;
    if (a[key] > b[key]) return 1;
    return 0;
  };
}

/**
 * 创建比较器（降序）
 */
export function descending<T>(key: keyof T): (a: T, b: T) => number {
  return (a, b) => {
    if (a[key] > b[key]) return -1;
    if (a[key] < b[key]) return 1;
    return 0;
  };
}

/**
 * 将数组分块
 * @param array 要分块的数组
 * @param size 每块大小
 */
export function chunk<T>(array: T[], size: number): T[][] {
  const result: T[][] = [];
  for (let i = 0; i < array.length; i += size) {
    result.push(array.slice(i, i + size));
  }
  return result;
}

/**
 * 随机打乱数组（Fisher-Yates 算法）
 */
export function shuffle<T>(array: T[]): T[] {
  const result = [...array];
  for (let i = result.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [result[i], result[j]] = [result[j], result[i]];
  }
  return result;
}

/**
 * 计算数组中某键值的总和
 */
export function sumBy<T>(array: T[], key: keyof T): number {
  return array.reduce((sum, item) => sum + (Number(item[key]) || 0), 0);
}

/**
 * 查找数组中的最大项
 */
export function maxBy<T>(array: T[], key: keyof T): T | undefined {
  if (array.length === 0) return undefined;
  return array.reduce((max, item) =>
    (item[key] as number) > (max[key] as number) ? item : max
  );
}

/**
 * 查找数组中的最小项
 */
export function minBy<T>(array: T[], key: keyof T): T | undefined {
  if (array.length === 0) return undefined;
  return array.reduce((min, item) =>
    (item[key] as number) < (min[key] as number) ? item : min
  );
}
```

## 使用示例

```typescript
import { groupBy, paginate, uniqueBy, sortBy, ascending, descending, chunk } from "@/lib/array-utils"

const users = [
  { id: 1, name: "Alice", role: "admin", age: 30 },
  { id: 2, name: "Bob", role: "user", age: 25 },
  { id: 3, name: "Charlie", role: "admin", age: 35 },
]

// 分组
groupBy(users, "role")
// { admin: [...], user: [...] }

// 分页
paginate(users, 1, 10) // 第1页，每页10条

// 去重
uniqueBy(users, "id")

// 排序
sortBy(users, ascending("age"), descending("name"))

// 分块
chunk(users, 2) // [[user1, user2], [user3]]
```
