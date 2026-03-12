import {
  AbsoluteFill,
  useCurrentFrame,
  useVideoConfig,
  interpolate,
  spring,
} from 'remotion';

/**
 * 数据图表模板
 * 
 * 包含：
 * - 柱状图动画
 * - 进度条动画
 * - 数值计数器
 */

// 柱状图组件
const BarChart: React.FC<{
  data: { label: string; value: number; color: string }[];
  maxValue: number;
  startFrame: number;
}> = ({ data, maxValue, startFrame }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'flex-end',
        gap: 30,
        height: 400,
      }}
    >
      {data.map((item, i) => {
        const barFrame = frame - startFrame - i * 5;
        const spr = spring({
          frame: barFrame,
          fps,
          config: { stiffness: 100, damping: 15 },
        });
        const height = interpolate(spr, [0, 1], [0, (item.value / maxValue) * 400]);

        return (
          <div
            key={i}
            style={{
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              gap: 10,
            }}
          >
            <div
              style={{
                width: 80,
                height,
                backgroundColor: item.color,
                borderRadius: '8px 8px 0 0',
                transformOrigin: 'bottom',
              }}
            />
            <span style={{ color: 'white', fontSize: 24 }}>{item.label}</span>
            <span style={{ color: 'rgba(255,255,255,0.7)', fontSize: 18 }}>
              {Math.round(interpolate(spr, [0, 1], [0, item.value]))}
            </span>
          </div>
        );
      })}
    </div>
  );
};

// 进度条组件
const ProgressBar: React.FC<{
  progress: number;
  label: string;
  color: string;
  startFrame: number;
}> = ({ progress, label, color, startFrame }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const spr = spring({
    frame: frame - startFrame,
    fps,
    config: { stiffness: 50, damping: 15 },
  });
  const currentProgress = interpolate(spr, [0, 1], [0, progress]);
  const percentage = Math.round(currentProgress * 100);

  return (
    <div style={{ width: '100%', marginBottom: 30 }}>
      <div
        style={{
          display: 'flex',
          justifyContent: 'space-between',
          marginBottom: 10,
        }}
      >
        <span style={{ color: 'white', fontSize: 28 }}>{label}</span>
        <span style={{ color: 'white', fontSize: 28 }}>{percentage}%</span>
      </div>
      <div
        style={{
          width: '100%',
          height: 20,
          backgroundColor: 'rgba(255,255,255,0.1)',
          borderRadius: 10,
          overflow: 'hidden',
        }}
      >
        <div
          style={{
            width: `${percentage}%`,
            height: '100%',
            backgroundColor: color,
            borderRadius: 10,
          }}
        />
      </div>
    </div>
  );
};

// 数值计数器
const NumberCounter: React.FC<{
  targetValue: number;
  duration: number;
  startFrame: number;
  prefix?: string;
  suffix?: string;
}> = ({ targetValue, duration, startFrame, prefix = '', suffix = '' }) => {
  const frame = useCurrentFrame();

  const currentValue = Math.floor(
    interpolate(
      frame,
      [startFrame, startFrame + duration],
      [0, targetValue],
      { extrapolateLeft: 'clamp', extrapolateRight: 'clamp' }
    )
  );

  return (
    <span>
      {prefix}
      {currentValue.toLocaleString()}
      {suffix}
    </span>
  );
};

// 主组件
export const ChartVideo = () => {
  const frame = useCurrentFrame();
  const { durationInFrames } = useVideoConfig();

  // 示例数据
  const chartData = [
    { label: 'Jan', value: 65, color: '#ff6b6b' },
    { label: 'Feb', value: 85, color: '#feca57' },
    { label: 'Mar', value: 45, color: '#48dbfb' },
    { label: 'Apr', value: 92, color: '#1dd1a1' },
    { label: 'May', value: 78, color: '#5f27cd' },
  ];

  const progressBars = [
    { progress: 0.85, label: 'React', color: '#61dafb' },
    { progress: 0.72, label: 'TypeScript', color: '#3178c6' },
    { progress: 0.68, label: 'Node.js', color: '#68a063' },
  ];

  // 标题动画
  const titleOpacity = interpolate(
    frame,
    [0, 20],
    [0, 1],
    { extrapolateRight: 'clamp' }
  );

  return (
    <AbsoluteFill
      style={{
        backgroundColor: '#1a1a2e',
        padding: 80,
        flexDirection: 'column',
      }}
    >
      {/* 标题 */}
      <h1
        style={{
          fontSize: 80,
          color: 'white',
          opacity: titleOpacity,
          marginBottom: 60,
          textAlign: 'center',
        }}
      >
        Data Visualization
      </h1>

      {/* 柱状图区域 */}
      <div
        style={{
          display: 'flex',
          justifyContent: 'center',
          marginBottom: 80,
        }}
      >
        <BarChart data={chartData} maxValue={100} startFrame={30} />
      </div>

      {/* 进度条区域 */}
      <div style={{ width: '80%', alignSelf: 'center' }}>
        {progressBars.map((bar, i) => (
          <ProgressBar
            key={i}
            {...bar}
            startFrame={60 + i * 15}
          />
        ))}
      </div>

      {/* 数值计数器 */}
      <div
        style={{
          display: 'flex',
          justifyContent: 'center',
          gap: 60,
          marginTop: 60,
        }}
      >
        <div style={{ textAlign: 'center', color: 'white' }}>
          <div style={{ fontSize: 64, fontWeight: 'bold', color: '#ff6b6b' }}>
            <NumberCounter targetValue={12500} duration={60} startFrame={90} />
          </div>
          <div style={{ fontSize: 28, opacity: 0.7 }}>Users</div>
        </div>
        <div style={{ textAlign: 'center', color: 'white' }}>
          <div style={{ fontSize: 64, fontWeight: 'bold', color: '#1dd1a1' }}>
            <NumberCounter
              targetValue={98}
              duration={60}
              startFrame={100}
              suffix="%"
            />
          </div>
          <div style={{ fontSize: 28, opacity: 0.7 }}>Satisfaction</div>
        </div>
        <div style={{ textAlign: 'center', color: 'white' }}>
          <div style={{ fontSize: 64, fontWeight: 'bold', color: '#48dbfb' }}>
            <NumberCounter
              targetValue={2.5}
              duration={60}
              startFrame={110}
              prefix="$"
              suffix="M"
            />
          </div>
          <div style={{ fontSize: 28, opacity: 0.7 }}>Revenue</div>
        </div>
      </div>
    </AbsoluteFill>
  );
};