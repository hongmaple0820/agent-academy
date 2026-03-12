# 每日复盘 Skill

每天结束时的系统性回顾，帮助你总结经验、规划未来。

## 快速开始

### 1. 设置定时任务

```bash
cd ~/.agents/skills/daily-review/scripts
./setup-cron.sh
```

### 2. 手动触发复盘

对我说：
- "每日复盘"
- "今日总结"
- "开始复盘"

### 3. 补复盘

- "补昨天的复盘"
- "补 2026-03-10 的复盘"

## 目录结构

```
daily-review/
├── SKILL.md              # 技能说明文档
├── README.md             # 使用指南
└── scripts/
    ├── daily-review.sh   # 复盘触发脚本
    ├── daily-review.service  # systemd 服务
    ├── daily-review.timer    # systemd 定时器
    └── setup-cron.sh     # 一键设置脚本
```

## 复盘输出位置

- **复盘文档**：`~/.openclaw/workspace/memory/reviews/YYYY-MM-DD-review.md`
- **今日日志**：`~/.openclaw/workspace/memory/YYYY-MM-DD.md`
- **长期记忆**：`~/.openclaw/workspace/MEMORY.md`

## 配置选项

在 `~/.openclaw/workspace/config/local.json` 中添加：

```json
{
  "dailyReview": {
    "enabled": true,
    "time": "00:00",
    "notify": true,
    "syncToShared": true,
    "updateMEMORY": true
  }
}
```

## 常见问题

**Q: 定时任务没有触发？**
A: 检查 systemd 状态：`systemctl --user status daily-review.timer`

**Q: 如何修改触发时间？**
A: 编辑 `daily-review.timer`，修改 `OnCalendar` 值

**Q: 复盘文档保存在哪里？**
A: `~/.openclaw/workspace/memory/reviews/` 目录

---

*让每一天都有收获 ✨*