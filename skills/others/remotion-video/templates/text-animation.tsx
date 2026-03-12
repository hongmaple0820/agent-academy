import {
  AbsoluteFill,
  useCurrentFrame,
  useVideoConfig,
  interpolate,
  spring,
} from 'remotion';

/**
 * 文字动画模板
 * 
 * 包含多种文字效果：
 * - 逐字显示（打字机效果）
 * - 逐词淡入
 * - 字符弹跳
 * - 波浪效果
 */

// 逐字显示效果
const TypewriterText: React.FC<{
  text: string;
  startFrame: number;
  speed?: number;
}> = ({ text, startFrame, speed = 2 }) => {
  const frame = useCurrentFrame();
  const chars = text.split('');
  
  const visibleChars = Math.floor(
    interpolate(frame, [startFrame, startFrame + chars.length * speed], [0, chars.length], {
      extrapolateLeft: 'clamp',
      extrapolateRight: 'clamp',
    })
  );

  return (
    <span>
      {chars.slice(0, visibleChars).map((char, i) => (
        <span key={i}>{char === ' ' ? '\u00A0' : char}</span>
      ))}
      {/* 光标闪烁 */}
      {frame % 30 < 15 && visibleChars < chars.length && (
        <span style={{ borderLeft: '2px solid white' }}>&nbsp;</span>
      )}
    </span>
  );
};

// 逐词淡入效果
const WordFadeIn: React.FC<{
  text: string;
  startFrame: number;
  wordDelay?: number;
}> = ({ text, startFrame, wordDelay = 10 }) => {
  const frame = useCurrentFrame();
  const words = text.split(' ');

  return (
    <span>
      {words.map((word, i) => {
        const opacity = interpolate(
          frame,
          [startFrame + i * wordDelay, startFrame + i * wordDelay + 10],
          [0, 1],
          { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' }
        );
        const translateY = interpolate(
          frame,
          [startFrame + i * wordDelay, startFrame + i * wordDelay + 10],
          [20, 0],
          { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' }
        );
        return (
          <span
            key={i}
            style={{
              opacity,
              display: 'inline-block',
              transform: `translateY(${translateY}px)`,
              marginRight: '0.3em',
            }}
          >
            {word}
          </span>
        );
      })}
    </span>
  );
};

// 字符弹跳效果
const BouncingText: React.FC<{
  text: string;
  startFrame: number;
}> = ({ text, startFrame }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();
  const chars = text.split('');

  return (
    <span>
      {chars.map((char, i) => {
        const charFrame = frame - startFrame - i * 2;
        const spr = spring({
          frame: charFrame,
          fps,
          config: { stiffness: 300, damping: 20 },
        });
        const scale = interpolate(spr, [0, 1], [0, 1]);
        const translateY = interpolate(spr, [0, 1], [50, 0]);

        return (
          <span
            key={i}
            style={{
              display: 'inline-block',
              transform: `scale(${scale}) translateY(${translateY}px)`,
              transformOrigin: 'bottom',
            }}
          >
            {char === ' ' ? '\u00A0' : char}
          </span>
        );
      })}
    </span>
  );
};

// 波浪效果
const WaveText: React.FC<{
  text: string;
}> = ({ text }) => {
  const frame = useCurrentFrame();
  const chars = text.split('');

  return (
    <span>
      {chars.map((char, i) => {
        const offset = Math.sin(frame * 0.1 + i * 0.5) * 10;
        return (
          <span
            key={i}
            style={{
              display: 'inline-block',
              transform: `translateY(${offset}px)`,
            }}
          >
            {char === ' ' ? '\u00A0' : char}
          </span>
        );
      })}
    </span>
  );
};

// 主组件
export const TextAnimationVideo = () => {
  const frame = useCurrentFrame();
  const { durationInFrames } = useVideoConfig();

  // 背景颜色
  const bgProgress = frame / durationInFrames;
  const bgColor = `hsl(${200 + bgProgress * 60}, 60%, 15%)`;

  return (
    <AbsoluteFill
      style={{
        backgroundColor: bgColor,
        justifyContent: 'center',
        alignItems: 'center',
        gap: 60,
        padding: 80,
      }}
    >
      {/* 打字机效果 */}
      <div style={{ fontSize: 60, color: 'white', height: 80 }}>
        <TypewriterText
          text="Hello, Remotion!"
          startFrame={0}
          speed={3}
        />
      </div>

      {/* 逐词淡入 */}
      <div style={{ fontSize: 48, color: 'rgba(255, 255, 255, 0.9)', height: 60 }}>
        <WordFadeIn
          text="Create stunning videos with code"
          startFrame={60}
        />
      </div>

      {/* 弹跳文字 */}
      <div style={{ fontSize: 72, color: '#ff6b6b', height: 90, marginTop: 20 }}>
        <BouncingText text="Animation Magic" startFrame={120} />
      </div>

      {/* 波浪效果 */}
      <div style={{ fontSize: 56, color: '#4ecdc4', height: 70 }}>
        <WaveText text="Wave Effect Demo" />
      </div>
    </AbsoluteFill>
  );
};