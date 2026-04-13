# Wiki Schema — 知识库行为配置

> 这是 Claude 的行为配置文件（Schema）。它定义了这个开源知识库的结构、约定和工作流。
> 每次会话开始时，Claude 应先阅读此文件，再阅读 `wiki/index.md`，再开始工作。

---

## 仓库结构

```
agent-academy/
├── CLAUDE.md              ← 本文件：Schema 配置
├── README.md / README_EN.md
├── CONTRIBUTING.md / CONTRIBUTING_EN.md
├── raw/                   ← 原始资料层（只读，不可修改）
│   └── knowledge/         ← 历史知识文档（23 篇）
├── wiki/                  ← 知识库层（Claude 全权维护）
│   ├── index.md           ← 内容索引（每次 ingest 后更新）
│   ├── 实体/              ← 实体页：人、组织、工具
│   ├── 概念/              ← 概念页：原理、方法论
│   ├── 主题/              ← 主题页：领域概览
│   └── 综合/              ← 综合页：交叉分析
├── skills/                ← 800+ 技能库（核心价值）
├── docs/                  ← 文档中心
├── templates/             ← 配置模板
├── scripts/               ← 安装脚本
└── logs/
    └── log.md             ← 操作日志（仅追加）
```

### 层级规则

| 层级 | 目录 | 谁可以修改 |
|------|------|-----------|
| 原始资料 | `raw/` | **只有用户**，Claude 只读 |
| 知识库 | `wiki/` | **只有 Claude**，用户可读 |
| 技能库 | `skills/` | 用户和 Claude 共同维护 |
| Schema | `CLAUDE.md` | 用户和 Claude 共同演进 |

---

## Wiki 页面约定

### Frontmatter（YAML）

```yaml
---
created: YYYY-MM-DD
updated: YYYY-MM-DD
sources: [raw/来源路径]
tags: [标签1, 标签2]
status: active | draft | superseded
---
```

### 页面格式

- 使用 **Obsidian 风格 Markdown**：`[[wikilinks]]`、callouts、tags
- 每个页面以**一句话摘要**开头
- 行内引用来源：`[来源 1](raw/路径)`
- 页面底部必须有 **Related** 区

### 交叉引用

- 页面间用 Wiki-link：`[[wiki/实体/页面名]]`
- 提到的每个实体/概念都应链接到对应页面
- 如果对应页面不存在，先创建再引用

---

## 工作流

### Ingest（摄取新资料）
1. 放置来源到 `raw/` → 2. 提取要点创建 wiki 页面 → 3. 更新 `wiki/index.md` → 4. 追加 `logs/log.md`

### Query（查询）
1. 读 `wiki/index.md` → 2. 读相关页面 → 3. 综合回答 → 4. 有价值则归档到 `wiki/综合/`

### Lint（健康检查）
检查：矛盾、孤儿页面、缺页概念、过时信息、index 同步

---

## 重要说明

- **这不是代码项目** — 没有构建、测试命令（skills/ 下有独立项目除外）
- **`raw/` 中的原始来源不可变** — LLM 只读不写
- **`wiki/` 由 LLM 全权拥有**
- **`skills/` 是核心价值** — 800+ 技能，按领域组织
- 使用 `trash` 而非 `rm`
- 绝不泄露 `.env` 中的敏感信息

---

*Schema 版本：v1.0 — 2026-04-13*
*基于 Karpathy LLM Wiki 方法论*
