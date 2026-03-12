# model-failover

自动检测模型失败并切换到备用模型

## 描述

监控 OpenClaw 模型健康状态，当检测到模型失败时自动切换到 fallback 列表中的下一个模型，无需重启整个 Gateway

## 核心功能

- 检测模型失败（timeout/ratelimit/api error）
- 自动切换 fallback 模型
- 平滑重载配置（不重启 Gateway）
- 记录切换日志

## 使用方法

```bash
# 手动执行
~/.openclaw/workspace/skills/model-failover/scripts/check-model-health.sh

# 如果检测失败，自动执行
~/.openclaw/workspace/skills/model-failover/scripts/switch-model.sh
```

## 工作原理

1. 调用 `openclaw doctor` 检查模型健康
2. 如果检测到失败，读取 openclaw.json 的 fallbacks 列表
3. 当前模型 + 失败原因 记录到 log
4. 切换到下一个 fallback 模型
5. 执行 `openclaw config set` 更新配置
6. 执行 `openclaw gateway reload` 平滑重载

## 配置

无需额外配置

## 依赖

- openclaw CLI
- jq（JSON处理）

## 作者

小琳

## 版本

1.0.0
