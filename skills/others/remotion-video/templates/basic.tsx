import {
  AbsoluteFill,
  useCurrentFrame,
  useVideoConfig,
  interpolate,
  spring,
} from 'remotion';

/**
 * 基础视频模板
 * 
 * 使用方法：
 * 1. 复制此文件到 src/compositions/
 * 2. 在 src/Root.tsx 中注册
 * 3. 运行 npx remotion studio 预览
 */

export const BasicVideo = () => {
  const frame = useCurrentFrame();
  const { fps, durationInFrames } = useVideoConfig();

  // 淡入淡出效果
  const opacity = interpolate(
    frame,
    [0, 20, durationInFrames - 20, durationInFrames],
    [0, 1, 1, 0],
    { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' }
  );

  // 弹跳进入效果
  const scale = spring({
    frame,
    fps,
    config: {
      stiffness: 200,
      damping: 15,
    },
  });

  // 背景颜色渐变
  const bgHue = interpolate(frame, [0, durationInFrames], [220, 260]);

  return (
    <AbsoluteFill
      style={{
        backgroundColor: `hsl(${bgHue}, 70%, 15%)`,
        justifyContent: 'center',
        alignItems: 'center',
      }}
    >
      {/* 主标题 */}
      <h1
        style={{
          fontSize: 120,
          fontWeight: 'bold',
          color: 'white',
          opacity,
          transform: `scale(${scale})`,
          margin: 0,
        }}
      >
        Welcome
      </h1>

      {/* 副标题 - 延迟出现 */}
      <p
        style={{
          fontSize: 48,
          color: 'rgba(255, 255, 255, 0.8)',
          opacity: interpolate(
            frame,
            [20, 40],
            [0, 1],
            { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' }
          ),
          transform: `translateY(${interpolate(
            frame,
            [20, 40],
            [20, 0],
            { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' }
          )}px)`,
        }}
      >
        Create videos with code
      </p>
    </AbsoluteFill>
  );
};