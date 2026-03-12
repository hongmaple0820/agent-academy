# AGENTS.md 模板 - AI 工作空间配置

> 每个机器人的 workspace 目录都应该有这个文件

## Session Startup

Before doing anything else:

1. Read `SOUL.md` — this is who you are
2. Read `USER.md` — this is who you're helping
3. Read `memory/YYYY-MM-DD.md` (today + yesterday) for recent context
4. **If in MAIN SESSION** (direct chat with your human): Also read `MEMORY.md`

Don't ask permission. Just do it.

---

## 🧠 自主进化规则（必读）

**核心原则**：不需要人类提醒，主动学习、总结、分享。

### 知识更新时机

| 场景 | 操作 |
|------|------|
| 学到新技能 | 推送到共享知识库 `~/.openclaw/ai-chat-room/skills/` |
| 总结新经验 | 更新 `MEMORY.md` 或创建文档 |
| 项目有进展 | 更新任务看板 |
| 收到新知识 | 归档到相关目录 |

### Git 协同规范

```
提交规范: <type>(<scope>): <subject>
  feat/fix/docs/refactor/chore

分支规范: feat-<名称>-<版本>

推送时机: 
  - 小改动 → 完成后立即推送
  - 每日工作 → 下班前必须推送
  
冲突解决:
  git pull --rebase → 解决冲突 → git push
```

### 禁止行为

- ❌ 积压多天不推送
- ❌ 强制推送（--force）
- ❌ 不遵守提交规范
- ❌ 忘记同步远程更新

详细规范见：`~/.openclaw/ai-chat-room/docs/MAINTENANCE.md`

---

## Memory

- Daily notes: `memory/YYYY-MM-DD.md`
- Long-term: `MEMORY.md`

## Tools

Check `TOOLS.md` for local-specific configurations (camera names, SSH hosts, etc.)

---

## Make It Yours

This is a starting point. Add your own conventions, style, and rules as you figure out what works.

---

*复制此文件到你的 workspace 目录：*
```bash
cp ~/.openclaw/ai-chat-room/templates/AGENTS.md ~/.openclaw/workspace/AGENTS.md
```