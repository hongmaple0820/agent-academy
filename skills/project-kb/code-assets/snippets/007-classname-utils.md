---
id: "snippet-007"
language: "typescript"
category: "utility"
tags: ["tailwind", "css", "classname", "utility"]
author: "ChessVerse"
description: "Tailwind CSS 类名合并工具，解决类名冲突问题"
complexity: "low"
---

# ClassName 工具函数

## 代码内容

```typescript
import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

/**
 * 合并 Tailwind CSS 类名
 * 1. 使用 clsx 处理条件类名
 * 2. 使用 tailwind-merge 解决类名冲突
 */
export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
```

## 依赖安装

```bash
npm install clsx tailwind-merge
```

## 使用示例

```tsx
import { cn } from "@/lib/utils"

// 基础用法
<button className={cn("px-4 py-2", "bg-blue-500")}>
  Button
</button>

// 条件类名
<button className={cn(
  "px-4 py-2 rounded",
  isActive && "bg-blue-500",
  !isActive && "bg-gray-300",
  isDisabled && "opacity-50 cursor-not-allowed"
)}>
  {label}
</button>

// 合并外部传入的 className
function Card({ className, children }: { className?: string; children: React.ReactNode }) {
  return (
    <div className={cn(
      "rounded-lg border bg-white p-4 shadow-sm",
      className
    )}>
      {children}
    </div>
  )
}

// 处理数组
<div className={cn([
  "base-class",
  condition1 && "conditional-1",
  condition2 && "conditional-2"
])} />

// 处理对象
<div className={cn({
  "base-class": true,
  "conditional-1": condition1,
  "conditional-2": condition2
})} />
```

## 解决的问题

```tsx
// ❌ 不使用 cn：类名冲突，后面的覆盖前面的
<div className="p-4 p-2">  // 最终只有 p-2 生效

// ✅ 使用 cn：tailwind-merge 智能合并
<div className={cn("p-4", "p-2")}>  // 最终 p-2 生效（后面的优先级高）

// ✅ 条件类名
<div className={cn("p-4", isCompact && "p-2")}>  // 根据条件决定
```
