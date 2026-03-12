# Remotion Video Skill - AI 视频生成指南

让 AI 用自然语言生成专业视频代码。

## 快速开始

### 1. 创建新项目
```bash
npx create-video@latest --template hello-world
```

### 2. 项目结构
```
my-video/
├── src/
│   ├── Root.tsx          # 注册所有 Composition
│   ├── Composition.tsx   # 视频组件
│   └── index.ts          # 入口
├── remotion.config.ts    # 配置文件
└── package.json
```

### 3. 运行开发服务器
```bash
npx remotion studio
```

### 4. 渲染视频
```bash
npx remotion render MyComposition out/video.mp4
```

---

## 核心 API 速查

### `<AbsoluteFill>` - 全屏容器
最基础的布局组件，相当于一个全屏的 `position: absolute` div。

```tsx
import { AbsoluteFill } from 'remotion';

// 基础用法
<AbsoluteFill style={{
  backgroundColor: 'white',
  justifyContent: 'center',
  alignItems: 'center',
}}>
  {/* 内容 */}
</AbsoluteFill>

// 分层叠加 - 后渲染的在上面
<AbsoluteFill>
  <AbsoluteFill>
    <Video src="background.mp4" />  {/* 底层 */}
  </AbsoluteFill>
  <AbsoluteFill>
    <h1>标题文字</h1>  {/* 顶层 */}
  </AbsoluteFill>
</AbsoluteFill>
```

**样式默认值**：
- `position: absolute`
- `top/left/right/bottom: 0`
- `width/height: 100%`
- `display: flex`
- `flexDirection: column`

---

### `useCurrentFrame()` - 获取当前帧
返回当前播放到的帧号（从 0 开始）。

```tsx
import { useCurrentFrame } from 'remotion';

const MyComponent = () => {
  const frame = useCurrentFrame();
  
  return <div>当前帧: {frame}</div>;
};

// 配合 Sequence 使用 - 获取相对帧
import { Sequence, useCurrentFrame } from 'remotion';

const MyVideo = () => {
  return (
    <Sequence from={10}>
      <Subtitle />  {/* 这里 frame 从 0 开始，而非 10 */}
    </Sequence>
  );
};
```

---

### `useVideoConfig()` - 获取视频配置
返回视频的元数据。

```tsx
import { useVideoConfig } from 'remotion';

const { fps, durationInFrames, width, height } = useVideoConfig();

// 计算时长（秒）
const durationInSeconds = durationInFrames / fps;
```

**返回值**：
- `fps` - 帧率（通常 30）
- `durationInFrames` - 总帧数
- `width` - 宽度（像素）
- `height` - 高度（像素）

---

### `interpolate()` - 值映射
核心动画函数：把帧号映射到任意范围。

```tsx
import { interpolate, useCurrentFrame } from 'remotion';

const frame = useCurrentFrame();

// 基础用法：帧 0-20 映射到透明度 0-1
const opacity = interpolate(frame, [0, 20], [0, 1]);

// 多点映射：淡入 → 保持 → 淡出
const opacity = interpolate(
  frame,
  [0, 20, durationInFrames - 20, durationInFrames],
  [0, 1, 1, 0]
);

// 限制范围（防止超出）
const scale = interpolate(frame, [0, 20], [0, 1], {
  extrapolateRight: 'clamp',  // 超过 20 帧后保持 1
  extrapolateLeft: 'clamp',   // 小于 0 帧时保持 0
});

// 缓动函数
import { Easing } from 'remotion';

const progress = interpolate(frame, [0, 100], [0, 1], {
  easing: Easing.bezier(0.8, 0.22, 0.96, 0.65),
  extrapolateRight: 'clamp',
});
```

**常用映射**：
```tsx
// 帧号 → 透明度（淡入）
opacity = interpolate(frame, [0, 30], [0, 1], { extrapolateRight: 'clamp' })

// 帧号 → 缩放（从小到大）
scale = interpolate(frame, [0, 20], [0.5, 1], { extrapolateRight: 'clamp' })

// 帧号 → 位置（从左滑入）
x = interpolate(frame, [0, 30], [-100, 0], { extrapolateRight: 'clamp' })

// 帧号 → 旋转（转一圈）
rotation = interpolate(frame, [0, 60], [0, 360], { extrapolateRight: 'clamp' })
```

---

### `spring()` - 物理动画
创建自然弹跳效果的动画。

```tsx
import { spring, useCurrentFrame, useVideoConfig } from 'remotion';

const frame = useCurrentFrame();
const { fps } = useVideoConfig();

// 基础用法
const value = spring({ frame, fps });

// 自定义参数
const bounce = spring({
  frame,
  fps,
  config: {
    stiffness: 100,   // 弹性（越大越弹）
    damping: 10,      // 阻尼（越大越不弹）
    mass: 1,          // 质量（越大越慢）
  },
});

// 固定动画时长
const progress = spring({
  frame,
  fps,
  durationInFrames: 40,  // 动画正好 40 帧
});

// 结合 interpolate 使用
const scale = interpolate(value, [0, 1], [0.5, 1.2]);
```

**参数说明**：
| 参数 | 默认值 | 说明 |
|------|--------|------|
| `stiffness` | 100 | 刚度，越大弹跳越快 |
| `damping` | 10 | 阻尼，越大越快停止 |
| `mass` | 1 | 质量，越大越慢 |
| `overshootClamping` | false | 是否禁止超调 |

---

### `<Sequence>` - 时间序列
控制组件的播放时间。

```tsx
import { Sequence } from 'remotion';

// 从第 10 帧开始播放
<Sequence from={10}>
  <Title />
</Sequence>

// 从第 10 帧开始，持续 30 帧
<Sequence from={10} durationInFrames={30}>
  <Subtitle />
</Sequence>

// 嵌套序列
<Sequence from={0} durationInFrames={60}>
  <Sequence from={20}>
    <DelayedContent />
  </Sequence>
</Sequence>
```

---

## Composition 注册

在 `src/Root.tsx` 中注册你的视频：

```tsx
import { Composition } from 'remotion';
import { MyVideo } from './MyVideo';

export const RemotionRoot = () => {
  return (
    <>
      <Composition
        id="MyVideo"
        component={MyVideo}
        durationInFrames={150}
        fps={30}
        width={1920}
        height={1080}
      />
    </>
  );
};
```

**参数说明**：
- `id` - 唯一标识符，用于渲染命令
- `component` - React 组件
- `durationInFrames` - 总帧数（fps=30 时，150帧=5秒）
- `fps` - 帧率（推荐 30）
- `width/height` - 分辨率（推荐 1920x1080）

---

## 常用动画模式

### 淡入淡出
```tsx
const opacity = interpolate(
  frame,
  [0, 20, durationInFrames - 20, durationInFrames],
  [0, 1, 1, 0],
  { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' }
);
```

### 弹跳缩放
```tsx
const spr = spring({ frame, fps, config: { stiffness: 200, damping: 15 } });
const scale = interpolate(spr, [0, 1], [0, 1]);
```

### 滑入效果
```tsx
const translateX = interpolate(
  spring({ frame, fps }),
  [0, 1],
  [-200, 0]
);
```

### 打字机效果
```tsx
const chars = "Hello World";
const visibleChars = Math.floor(interpolate(frame, [0, 30], [0, chars.length], {
  extrapolateRight: 'clamp'
}));
return <span>{chars.slice(0, visibleChars)}</span>;
```

---

## 完整示例

```tsx
import {
  AbsoluteFill,
  useCurrentFrame,
  useVideoConfig,
  interpolate,
  spring,
} from 'remotion';

export const MyVideo = () => {
  const frame = useCurrentFrame();
  const { fps, durationInFrames } = useVideoConfig();

  // 淡入淡出
  const opacity = interpolate(
    frame,
    [0, 20, durationInFrames - 20, durationInFrames],
    [0, 1, 1, 0],
    { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' }
  );

  // 弹跳缩放
  const scale = spring({
    frame,
    fps,
    config: { stiffness: 200, damping: 15 },
  });

  return (
    <AbsoluteFill
      style={{
        backgroundColor: '#1a1a2e',
        justifyContent: 'center',
        alignItems: 'center',
      }}
    >
      <h1
        style={{
          fontSize: 120,
          color: 'white',
          opacity,
          transform: `scale(${scale})`,
        }}
      >
        Hello Remotion!
      </h1>
    </AbsoluteFill>
  );
};
```

---

## 渲染命令

```bash
# 开发预览
npx remotion studio

# 渲染 MP4
npx remotion render MyVideo out/video.mp4

# 渲染 GIF
npx remotion render MyVideo out/video.gif

# 指定帧范围
npx remotion render MyVideo out/video.mp4 --frames=0-100

# 多线程渲染
npx remotion render MyVideo out/video.mp4 --concurrency=4
```

---

## 模板文件

本 Skill 包含以下模板：

1. **`templates/basic.tsx`** - 基础视频模板
2. **`templates/text-animation.tsx`** - 文字动画模板
3. **`templates/chart.tsx`** - 数据图表模板

使用方式：
```bash
cp templates/basic.tsx src/compositions/MyVideo.tsx
```

---

## 参考资源

- 官方文档：https://www.remotion.dev/docs/the-fundamentals
- API 参考：https://www.remotion.dev/docs/api
- 示例仓库：https://github.com/remotion-dev/remotion/tree/main/packages/docs/src/components
- 示例模板：https://remotion.dev/templates