---
name: knowledge-base-maintenance
description: 共享知识库维护规范 - 用于整理、分类和维护 AI 聊天室共享知识库。触发词：整理知识库、维护知识库、分类整理、清理知识库。
version: 1.0.0
author: 小琳
---

# 共享知识库维护规范

## 目录结构

```
ai-chat-room/
├── skills/              # 公共技能（所有人可用）
│   ├── development/     # 开发相关
│   ├── productivity/    # 效率工具
│   ├── communication/   # 通讯工具
│   ├── multimedia/      # 多媒体
│   ├── automation/      # 自动化
│   ├── security/        # 安全工具
│   ├── ai-ml/          # AI/机器学习
│   └── home-iot/       # 智能家居
├── skills-private/      # 私有技能（敏感信息）
├── knowledge/           # 知识文档
│   ├── tutorials/       # 教程
│   ├── references/      # 参考资料
│   └── standards/       # 规范标准
├── docs/                # 文档中心
├── memory/              # 记忆存储
├── learnings/           # 学习记录
├── members/             # 成员信息
└── archive/             # 归档（过时内容）
```

## 维护原则

### 1. 技能分类规则

| 分类 | 说明 | 示例 |
|------|------|------|
| development | 开发相关 | github, pr-reviewer, docker-essentials |
| productivity | 效率工具 | summarize, brainstorming, planning-with-files |
| communication | 通讯工具 | discord, slack, himalaya |
| multimedia | 多媒体 | openai-whisper, nano-banana-pro, remotion-video |
| automation | 自动化 | n8n-workflow-automation, github-action-gen |
| security | 安全工具 | 1password, healthcheck, security-sentinel |
| ai-ml | AI/机器学习 | gemini, model-usage, openai-image-gen |
| home-iot | 智能家居 | sonoscli, openhue, goplaces |

### 2. 私有技能处理

**必须放入 `skills-private/` 的内容**：
- 包含敏感信息的配置
- 团队内部专用技能
- 个人定制的技能

**禁止上传的内容**：
- API 密钥
- 密码
- 私人令牌
- 内网地址

### 3. 归档规则

以下内容应移入 `archive/`：
- 过时的文档
- 不再使用的技能
- 测试用的临时文件
- 重复的内容

### 4. 索引维护

每次更新后必须更新以下文件：
- `skills/README.md` - 技能索引
- `docs/OPENCLAW_SKILLS_GUIDE.md` - 完整指南
- `memory/YYYY-MM-DD.md` - 变更日志

## 安全检查

### 安装新技能前

```bash
# 1. 检查 VirusTotal 状态
npx clawhub install <skill-name>

# 2. 如果被标记可疑，检查源码
cat ~/.openclaw/workspace/skills/<skill-name>/SKILL.md

# 3. 检查脚本
grep -r "curl.*|.*sh\|wget.*|.*sh\|eval\|base64 -d" skills/<skill-name>/
```

### 定期检查

```bash
# 每周检查一次
cd ~/.openclaw/ai-chat-room
git pull

# 检查敏感信息
grep -r "password\|secret\|api_key\|token" skills/ --exclude-dir=.git
```

## 提交规范

```bash
# 提交变更
git add .
git commit -m "feat: 添加/更新/移除 <skill-name>"
git push origin master

# 同时推送到 GitHub
git push github master
```

## 团队协作

1. **使用前先拉取**：`git pull`
2. **避免冲突**：按功能分区使用
3. **及时同步**：每次工作结束后提交
4. **变更通知**：重要变更通知团队成员

---

*维护者：小琳*
*更新时间：2026-03-05*