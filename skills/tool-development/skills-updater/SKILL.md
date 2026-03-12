---
name: skills-updater
description: 检查和更新已安装的 Claude Code 技能，支持多种来源。扫描可用更新，支持批量或单独更新，推荐热门技能。触发词：检查更新、更新技能、推荐技能、热门技能。
version: 1.0.0
author: yizhiyanhua-ai
---

# Skills Updater

管理、更新和发现 Claude Code 技能。

## 支持的来源

**Claude Code Plugins** (`~/.claude/plugins/`):
- `installed_plugins.json` - 跟踪已安装的技能版本
- `known_marketplaces.json` - 注册的市场源
- `cache/` - 已安装的技能文件

**npx skills** (`~/.skills/`):
- 通过 `npx skills add <owner/repo>` 安装
- 由 skills.sh 基础设施管理

**枫琳云市场** (`~/.openclaw/ai-chat-room/skills/`):
- 共享知识库中的技能
- 支持团队协作和共享

## 更新检查工作流

### 检查更新

```bash
python scripts/check_updates.py
```

输出格式：
```
📦 已安装技能状态
━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ 已是最新 (12):
   • skill-creator@daymade-skills (1.2.2)
   • github-ops@daymade-skills (1.0.0)
   ...

⬆️ 有可用更新 (3):
   • planning-with-files@planning-with-files
     本地: 2.5.0 → 远程: 2.6.1
   ...
```

### 更新市场

```bash
python scripts/update_marketplace.py anthropic-agent-skills --auto-install
```

### 推荐技能

```bash
python scripts/recommend_skills.py --source all
```

## 技能市场

### skills.sh

热门技能市场，按安装量排名：
- https://skills.sh

### skillsmp.com

精选市场（如可访问）：
- https://skillsmp.com

### 枫琳云市场

内置技能库：
- 本地路径: `~/.openclaw/ai-chat-room/skills/`
- 技能数量: 153+

## 使用方法

### 检查更新

用户说："检查 skills 更新" / "/skills-updater"

→ 运行 `scripts/check_updates.py` 并显示结果

### 更新指定市场

用户说："更新 anthropic-agent-skills 市场"

→ 运行 `scripts/update_marketplace.py` 并自动重新安装受影响的技能

### 发现新技能

用户说："推荐一些好用的 skills" / "有什么热门技能推荐？"

→ 运行 `scripts/recommend_skills.py` 并显示精选列表

### 更新全部

用户说："更新所有 skills"

→ 扫描 → 确认 → 处理合并 → 更新 → 报告结果

## 资源

### scripts/
- `check_updates.py` - 扫描并比较本地与远程版本
- `recommend_skills.py` - 从市场获取热门技能
- `update_marketplace.py` - 更新市场仓库并自动重装技能
- `i18n.py` - 国际化模块

### references/
- `marketplaces.md` - 支持的市场文档