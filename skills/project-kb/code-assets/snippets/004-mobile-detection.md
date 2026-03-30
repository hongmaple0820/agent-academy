---
id: "snippet-004"
language: "typescript"
category: "ui-component"
tags: ["react", "responsive", "hooks", "mobile"]
author: "ChessVerse"
description: "React Hook 用于检测当前是否为移动设备，基于窗口宽度"
complexity: "low"
---

# 移动端检测 Hook

## 代码内容

```typescript
import * as React from "react"

const MOBILE_BREAKPOINT = 768

export function useIsMobile() {
  const [isMobile, setIsMobile] = React.useState<boolean | undefined>(undefined)

  React.useEffect(() => {
    const mql = window.matchMedia(`(max-width: ${MOBILE_BREAKPOINT - 1}px)`)
    const onChange = () => {
      setIsMobile(window.innerWidth < MOBILE_BREAKPOINT)
    }
    mql.addEventListener("change", onChange)
    setIsMobile(window.innerWidth < MOBILE_BREAKPOINT)
    return () => mql.removeEventListener("change", onChange)
  }, [])

  return !!isMobile
}
```

## 使用示例

```tsx
import { useIsMobile } from "@/hooks/use-mobile"

function ResponsiveComponent() {
  const isMobile = useIsMobile()

  return (
    <div>
      {isMobile ? (
        <MobileView />
      ) : (
        <DesktopView />
      )}
    </div>
  )
}
```

## 变体：使用自定义断点

```typescript
export function useBreakpoint(breakpoint: number = 768) {
  const [isBelow, setIsBelow] = React.useState(false)

  React.useEffect(() => {
    const mql = window.matchMedia(`(max-width: ${breakpoint - 1}px)`)
    const onChange = () => setIsBelow(window.innerWidth < breakpoint)
    mql.addEventListener("change", onChange)
    setIsBelow(window.innerWidth < breakpoint)
    return () => mql.removeEventListener("change", onChange)
  }, [breakpoint])

  return isBelow
}
```
