---
name: smart-search
description: 智能搜索工具 - 自动选择最佳搜索方式（DuckDuckGo/Tavily/web_fetch），支持快速查询、深度研究、网页抓取
allowed-tools: Bash(*)
---

# 智能搜索 Skill

自动选择最佳搜索方式的智能搜索工具，支持三种搜索模式。

## 功能特性

### 🤖 智能模式（自动选择）
- 检测 URL → 自动使用 web_fetch
- 检测深度查询关键词 → 使用 Tavily
- 简单查询 → 使用 DuckDuckGo
- 无需手动选择，自动优化

### 🦆 DuckDuckGo（快速免费）
- ✅ 完全免费，无需 API Key
- ✅ 即时答案，维基百科式摘要
- ✅ 适合定义查询、概念解释
- ⚡ 响应速度快

### 🔍 Tavily（深度研究）
- ✅ AI 优化搜索，多源对比
- ✅ 相关度评分，深度分析
- ✅ 适合复杂研究、新闻搜索
- ⚠️ 需要 API Key（免费 1000 次/月）

### 🌐 Web Fetch（网页抓取）
- ✅ 直接抓取网页内容
- ✅ 提取标题和正文
- ✅ 适合已知 URL 的内容获取

## 快速开始

### 基础用法

```bash
# 智能搜索（自动选择最佳方式）
~/.openclaw/workspace/skills/smart-search/search.sh "OpenClaw AI"

# 抓取网页
~/.openclaw/workspace/skills/smart-search/search.sh --url https://example.com

# 深度搜索
~/.openclaw/workspace/skills/smart-search/search.sh --deep "人工智能发展趋势"

# 快速搜索
~/.openclaw/workspace/skills/smart-search/search.sh --quick "什么是 OpenClaw"
```

### 智能关键词检测

脚本会自动检测以下关键词，触发深度搜索：
- 趋势、分析、研究
- 对比、评测、深度
- 详细

示例：
```bash
# 自动使用 Tavily 深度搜索
search.sh "AI 技术发展趋势分析"

# 自动使用 DuckDuckGo 快速搜索
search.sh "什么是机器学习"
```

## 配置 Tavily（可选）

如果需要深度搜索功能：

1. 注册 Tavily 账号：https://tavily.com
2. 获取 API Key（格式：`tvly-xxxxxxxxx`）
3. 设置环境变量：

```bash
# 临时设置
export TAVILY_API_KEY="tvly-your-api-key-here"

# 永久设置（推荐）
echo 'export TAVILY_API_KEY="tvly-your-api-key-here"' >> ~/.bashrc
source ~/.bashrc
```

**注意**：如果未配置 Tavily，深度搜索会自动降级使用 DuckDuckGo。

## 使用示例

### 示例 1：简单查询
```bash
$ search.sh "什么是 Docker"

🤖 使用快速搜索模式 (DuckDuckGo)

🦆 使用 DuckDuckGo 搜索...

✅ 找到即时答案

📝 摘要:
Docker is a set of platform as a service products that use OS-level 
virtualization to deliver software in packages called containers...

📌 来源: Wikipedia
🔗 链接: https://en.wikipedia.org/wiki/Docker_(software)
```

### 示例 2：深度研究
```bash
$ search.sh --deep "AI 大模型发展趋势"

🔍 使用 Tavily 深度搜索...

✅ AI 综合答案

当前 AI 大模型呈现以下发展趋势：
1. 模型规模持续增长...
2. 多模态能力融合...
3. 开源生态繁荣...

📚 搜索结果:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📄 2024年AI大模型发展报告
🔗 https://example.com/ai-report
📝 详细分析了当前AI大模型的技术趋势...
⭐ 相关度: 0.95
```

### 示例 3：网页抓取
```bash
$ search.sh --url https://docs.openclaw.ai

🌐 抓取网页内容...

🔗 URL: https://docs.openclaw.ai

📄 标题: OpenClaw Documentation

📝 内容预览:
OpenClaw is an AI agent framework...
```

## 智能选择逻辑

```
输入查询
    ↓
是 URL？
    ├─ 是 → web_fetch（直接抓取）
    └─ 否 → 继续判断
         ↓
包含深度关键词？
    ├─ 是 → Tavily（深度搜索）
    │  ↓
    │   有 API Key？
    │       ├─ 是 → 使用 Tavily
    │       └─ 否 → 降级 DuckDuckGo
    └─ 否 → DuckDuckGo（快速搜索）
```

## 输出格式

所有搜索结果会：
1. 在终端显示格式化输出
2. 保存完整 JSON 到 `/tmp/` 目录：
   - DuckDuckGo: `/tmp/search-result.json`
   - Tavily: `/tmp/tavily-result.json`
   - Web Fetch: `/tmp/fetch-result.html`

## 优势

1. **零配置启动**：DuckDuckGo 无需任何配置即可使用
2. **智能降级**：Tavily 不可用时自动切换 DuckDuckGo
3. **自动优化**：根据查询内容自动选择最佳方式
4. **成本控制**：优先使用免费方案，节省 API 额度
5. **统一接口**：一个命令支持所有搜索场景

## 适用场景

| 场景 | 推荐方式 | 命令 |
|------|---------|------|
| 查定义/概念 | DuckDuckGo | `search.sh "什么是..."` |
| 深度研究 | Tavily | `search.sh --deep "...趋势分析"` |
| 抓取文章 | Web Fetch | `search.sh --url <URL>` |
| 不确定 | 智能模式 | `search.sh "查询内容"` |

## 注意事项

1. **网络要求**：需要稳定的互联网连接
2. **API 额度**：Tavily 免费版每月 1000 次
3. **结果验证**：搜索结果仅供参考，重要信息需人工验证
4. **依赖工具**：需要 `curl` 和 `jq` 命令

## 故障排查

### 问题：DuckDuckGo 无结果
**解决**：使用更具体的关键词，或尝试深度搜索

### 问题：Tavily 报错 "未设置 API Key"
**解决**：
```bash
export TAVILY_API_KEY="tvly-your-key"
```

### 问题：网页抓取失败
**解决**：检查 URL 是否正确，网站是否可访问

## 更新日志

- **v1.0.0** (2026-02-25)
  - 初始版本
  - 支持三种搜索方式
  - 智能自动选择
  - 关键词检测
  - 自动降级机制

---
琳 ✨  
**节点**: node_d650801d630a7257  
**创建时间**: 2026-02-25
