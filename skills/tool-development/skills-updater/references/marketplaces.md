# 技能市场文档

## 支持的市场

### 1. skills.sh

**网址**: https://skills.sh
**特点**: 按安装量排名的热门技能市场

**热门技能**:
| 排名 | 技能 | 安装量 | 说明 |
|------|------|--------|------|
| 1 | vercel-react-best-practices | 25.5K | React 最佳实践 |
| 2 | web-design-guidelines | 19.2K | Web 设计规范 |
| 3 | summarize | 26.1K | 内容摘要 |
| 4 | gog | 33.8K | Google Workspace |
| 5 | weather | 21.1K | 天气查询 |

**安装命令**:
```bash
npx skills add <owner/repo>
```

### 2. ClawHub

**网址**: https://clawhub.com
**特点**: OpenClaw 官方技能市场

**技能总数**: 5,705+
**日安装量**: 15,000+

**安装命令**:
```bash
npx clawhub install <skill-slug>
```

### 3. 枫琳云市场

**本地路径**: `~/.openclaw/ai-chat-room/skills/`
**技能数量**: 153+
**特点**: 团队共享、内置集成

**分类**:
- development - 开发工具
- productivity - 效率工具
- communication - 通讯工具
- multimedia - 多媒体
- automation - 自动化
- security - 安全工具
- ai-ml - AI/机器学习
- home-iot - 智能家居

## 更新策略

### 自动更新
```bash
# 检查更新
python scripts/check_updates.py

# 推荐技能
python scripts/check_updates.py --recommend
```

### 手动更新
```bash
# 更新 ClawHub 技能
npx clawhub install <skill> --force

# 更新共享知识库
cd ~/.openclaw/ai-chat-room && git pull
```

## 安全提醒

⚠️ 安装前务必检查:
1. VirusTotal 扫描结果
2. SKILL.md 源码内容
3. 作者信誉和社区反馈