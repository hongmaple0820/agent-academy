---
id: "snippet-001"
language: "typescript"
category: "ui-component"
tags: ["react", "button", "tailwind", "radix-ui"]
author: "ChessVerse"
description: "基于 Radix UI 和 Tailwind CSS 的可复用按钮组件，支持多种变体和尺寸"
complexity: "medium"
---

# Button 组件

## 代码内容

```typescript
import * as React from "react"
import { Slot } from "@radix-ui/react-slot"
import { cva, type VariantProps } from "class-variance-authority"
import { cn } from "@/lib/utils"

const buttonVariants = cva(
  "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-all disabled:pointer-events-none disabled:opacity-50",
  {
    variants: {
      variant: {
        default:
          "bg-primary text-primary-foreground shadow-xs hover:bg-primary/90",
        destructive:
          "bg-destructive text-white shadow-xs hover:bg-destructive/90",
        outline:
          "border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground",
        secondary:
          "bg-secondary text-secondary-foreground shadow-xs hover:bg-secondary/80",
        ghost:
          "hover:bg-accent hover:text-accent-foreground",
        link: "text-primary underline-offset-4 hover:underline",
      },
      size: {
        default: "h-9 px-4 py-2",
        sm: "h-8 rounded-md gap-1.5 px-3",
        lg: "h-10 rounded-md px-6",
        icon: "size-9",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  }
)

function Button({
  className,
  variant,
  size,
  asChild = false,
  ...props
}: React.ComponentProps<"button"> &
  VariantProps<typeof buttonVariants> & {
    asChild?: boolean
  }) {
  const Comp = asChild ? Slot : "button"

  return (
    <Comp
      data-slot="button"
      className={cn(buttonVariants({ variant, size, className }))}
      {...props}
    />
  )
}

export { Button, buttonVariants }
```

## 使用说明

1. 依赖安装:
   ```bash
   npm install @radix-ui/react-slot class-variance-authority clsx tailwind-merge
   ```

2. 工具函数 `cn`:
   ```typescript
   import { clsx, type ClassValue } from "clsx"
   import { twMerge } from "tailwind-merge"
   
   export function cn(...inputs: ClassValue[]) {
     return twMerge(clsx(inputs))
   }
   ```

## 使用示例

```tsx
import { Button } from "@/components/ui/button"

// 默认按钮
<Button>Click me</Button>

// 变体按钮
<Button variant="destructive">Delete</Button>
<Button variant="outline">Outline</Button>
<Button variant="ghost">Ghost</Button>

// 尺寸
<Button size="sm">Small</Button>
<Button size="lg">Large</Button>
<Button size="icon"><Icon /></Button>

// 作为子元素
<Button asChild>
  <a href="/link">Link Button</a>
</Button>
```

## 特性

- 6 种变体: default, destructive, outline, secondary, ghost, link
- 4 种尺寸: default, sm, lg, icon
- 支持 `asChild` 模式，可渲染为其他元素
- 完整的 TypeScript 类型支持
- 无障碍友好
