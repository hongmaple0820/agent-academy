# QMD 本地语义搜索

> Token 消耗降低 90%，混合搜索准确率 93%

## 什么是 QMD

QMD 是 Shopify 创始人 Tobi 用 Rust 编写的本地语义搜索引擎，专为 AI Agent 设计。

### 核心特性

| 特性 | 说明 |
|------|------|
| 混合搜索 | BM25 全文 + 向量语义 + LLM 重排序 |
| 本地运行 | 完全本地，零 API 成本 |
| MCP 集成 | 原生支持 MCP 协议 |
| 多格式支持 | Markdown、文本、PDF 等 |

### 自动下载的模型

| 模型 | 用途 | 大小 |
|------|------|------|
| jina-embeddings-v3 | Embedding | ~330MB |
| jina-reranker-v2-base-multilingual | Reranker | ~640MB |

## 安装

### Linux/macOS

```bash
# 安装 bun
curl -fsSL https://bun.sh/install | bash
source ~/.bashrc

# 安装 qmd
bun install -g https://github.com/tobi/qmd

# 验证
qmd --version
```

### Windows

```powershell
# 安装 bun
powershell -c "irm bun.sh/install.ps1 | iex"

# 安装 qmd
bun install -g https://github.com/tobi/qmd
```

## 快速开始

### 1. 创建记忆库

```bash
# 进入工作区
cd ~/workspace

# 创建集合
qmd collection add memory/*.md --name daily-logs

# 生成 embedding
qmd embed daily-logs memory/*.md
```

### 2. 搜索记忆

```bash
# 混合搜索（推荐，准确率最高）
qmd search daily-logs "用户偏好" --hybrid

# 纯语义搜索
qmd search daily-logs "如何处理 API 错误"

# 关键词搜索
qmd search daily-logs "chat-hub"
```

### 3. 查看状态

```bash
# 列出所有集合
qmd list

# 查看集合详情
qmd info daily-logs
```

## MCP 集成

### 配置

在 MCP 配置文件中添加：

```json
{
  "mcpServers": {
    "qmd": {
      "command": "/path/to/qmd",
      "args": ["mcp"]
    }
  }
}
```

### 可用工具

| 工具 | 说明 | 用途 |
|------|------|------|
| `query` | 混合搜索 | 精度最高，推荐使用 |
| `vsearch` | 语义检索 | 匹配抽象内容 |
| `search` | 关键词检索 | 精准匹配 |
| `get` | 获取文档 | 根据 ID 读取 |
| `multi_get` | 批量获取 | 批量读取文档 |
| `status` | 健康检查 | 检查服务状态 |

### 使用示例

```
用户：我们之前讨论过 API 架构吗？

Agent 调用 qmd.query("API 架构讨论")
返回：memory/2026-01-20.md 第 45-52 行
内容："## API 讨论\n为追求简洁性，决定采用 REST..."
```

## 工作流程

```
用户提问
    │
    ▼
┌─────────────────┐
│ Agent 调用 qmd  │  ← MCP: query "关键词"
│ 检索相关记忆    │
└────────┬────────┘
         │ 返回相关片段（~200 Token）
         ▼
┌─────────────────┐
│ 拼接到上下文    │
│ 发送给大模型    │
└────────┬────────┘
         │
         ▼
     准确回答
```

### Token 消耗对比

| 方案 | Token 消耗 |
|------|-----------|
| 传统（全量加载） | 2000 Token |
| QMD（检索片段） | 200 Token |
| **节省** | **90%** |

## 自动更新

### 方式一：Heartbeat 任务

```markdown
### qmd 记忆库更新

检查 memory/ 目录是否有新文件，如有则更新：

```bash
cd ~/workspace
qmd embed daily-logs memory/*.md
```
```

### 方式二：Cron 任务

```bash
# 每 6 小时更新一次
0 */6 * * * cd ~/workspace && qmd embed daily-logs memory/*.md
```

### 方式三：文件监控

```bash
# 使用 inotifywait 监控文件变化
inotifywait -m -r -e modify,create ~/workspace/memory/ |
  while read path action file; do
    qmd embed daily-logs "$path$file"
  done
```

## 适用场景

| 场景 | 效果 |
|------|------|
| 用户偏好回忆 | Token 减少 90% |
| 历史决策查询 | 准确率 93% |
| 跨文件知识检索 | 无需手动指定文件 |
| 项目知识库 | 精准定位相关文档 |

## 最佳实践

### 1. 集合划分

```bash
# 按类型划分
qmd collection add memory/*.md --name daily-logs
qmd collection add docs/*.md --name documents
qmd collection add learnings/*.md --name learnings

# 按项目划分
qmd collection add projects/a/*.md --name project-a
qmd collection add projects/b/*.md --name project-b
```

### 2. 检索策略

- **精准匹配** → 使用 `search`（关键词）
- **语义匹配** → 使用 `vsearch`（语义）
- **综合匹配** → 使用 `query`（混合，推荐）

### 3. 结果处理

```bash
# 限制返回数量
qmd search daily-logs "关键词" --limit 5

# 设置最小相似度
qmd search daily-logs "关键词" --min-score 0.5
```

## 故障排除

### 问题：模型下载失败

```bash
# 手动下载模型
# Embedding 模型
wget https://huggingface.co/jinaai/jina-embeddings-v3/resolve/main/model.gguf

# Reranker 模型
wget https://huggingface.co/jinaai/jina-reranker-v2-base-multilingual/resolve/main/model.gguf
```

### 问题：搜索结果不准确

```bash
# 重新生成 embedding
qmd reindex daily-logs

# 调整搜索参数
qmd search daily-logs "关键词" --rerank --top-k 10
```

### 问题：MCP 连接失败

```bash
# 检查 qmd 路径
which qmd

# 测试 MCP 模式
qmd mcp --test
```

---

**来源**：QMD 官方文档 + OpenClaw 集成实践
**实测效果**：混合搜索准确率 93%，Token 消耗降低 90%
