# 智能搜索技能使用示例

> 使用 `smart-search` 技能快速找到需要的信息

## 📋 场景说明

**场景**: 在大量文档、代码或数据中快速定位信息
**技能**: smart-search
**触发**: 说"搜索 XXX"、"查找 XXX"、"帮我找 XXX"

---

## 💬 完整对话示例

### 示例 1: 搜索知识库文档

```
用户：帮我找一下 Redis Pub/Sub 的配置文档。

小熊：好的！让我用 `smart-search` 技能搜索。🐻

🔍 **搜索关键词**: Redis Pub/Sub 配置

**搜索结果**:
1. `knowledge/guides/redis-pubsub-setup.md` - Redis Pub/Sub 配置指南
   匹配度：95%
   摘要："配置 Redis Pub/Sub 需要同时监听多个频道..."

2. `memory/core/lessons.md` - 经验教训
   匹配度：85%
   摘要："Redis Pub/Sub 消息丢失问题 - 只监听了一个频道"

3. `projects/chat-hub/docs/redis-config.md` - chat-hub Redis 配置
   匹配度：80%
   摘要："Redis 连接配置和频道订阅设置"

需要我打开哪个文档？
```

### 示例 2: 搜索代码片段

```
用户：我记得之前写过 SQLite FTS5 的搜索代码，在哪里？

小熊：让我搜索代码库。🐻

🔍 **搜索关键词**: SQLite FTS5 搜索

**搜索结果**:
1. `chat-hub/src/database/messages.js` (第 45-68 行)
   ```javascript
   // 创建 FTS5 虚拟表
   CREATE VIRTUAL TABLE messages_fts USING fts5(
     content,
     sender,
     timestamp
   );
   
   // 全文搜索
   SELECT * FROM messages_fts 
   WHERE messages_fts MATCH ?;
   ```
   匹配度：92%

2. `chat-hub/src/services/search.js` (第 12-30 行)
   ```javascript
   async function searchMessages(query) {
     const sql = `
       SELECT m.* FROM messages m
       JOIN messages_fts fts ON m.id = fts.rowid
       WHERE fts.messages_fts MATCH ?
     `;
     return await db.all(sql, [query]);
   }
   ```
   匹配度：90%

需要我详细解释这段代码吗？
```

### 示例 3: 搜索命令历史

```
用户：我之前用过一个 docker 命令，是清理所有停止的容器。

小熊：搜索命令历史。🐻

🔍 **搜索关键词**: docker 清理 容器

**搜索结果**:
1. `~/.bash_history` (3 天前)
   ```bash
   docker container prune -f
   ```
   说明：清理所有停止的容器

2. `~/.zsh_history` (1 周前)
   ```bash
   docker system prune -a --volumes
   ```
   说明：清理所有未使用的资源（包括镜像、网络、卷）

3. `memory/daily/2026-03-10.md` (日志记录)
   ```bash
   # Docker 清理命令总结
   docker container prune -f      # 停止的容器
   docker image prune -a          # 未使用的镜像
   docker volume prune            # 未使用的卷
   docker system prune -a         # 全部清理
   ```

推荐使用第三个，最完整！需要我执行清理吗？
```

### 示例 4: 搜索 Git 提交

```
用户：谁修复了 Redis 连接的那个 bug？

小熊：搜索 Git 提交历史。🐻

🔍 **搜索关键词**: Redis 连接 bug fix

**搜索结果**:
1. `commit 8a7f3d2` (2026-03-10)
   ```
   fix(chat-hub): 修复 Redis 连接频道订阅问题
   
   - 同时监听 chat:messages 和 chat:replies
   - 添加重连机制
   - 增加错误日志
   
   Fixes: #123
   ```
   作者：小琳
   文件：chat-hub/src/services/redis.js

2. `commit 5b2e1f9` (2026-03-11)
   ```
   test(chat-hub): 添加 Redis 连接测试
   
   - 单元测试覆盖重连逻辑
   - 集成测试验证频道订阅
   ```
   作者：小琳
   文件：chat-hub/tests/redis.test.js

是小琳修复的！需要我查看详细的代码变更吗？
```

---

## 🔧 搜索技巧

### 技巧 1: 精确搜索
```
# 使用引号精确匹配
"Redis Pub/Sub"  # 只匹配完整短语

# 不加引号模糊匹配
Redis PubSub     # 匹配 Redis、PubSub 分别出现
```

### 技巧 2: 组合关键词
```
# 多个关键词 AND 逻辑
Redis 配置 频道    # 同时包含三个词

# 排除关键词
docker 清理 -volume  # 排除 volume
```

### 技巧 3: 指定文件类型
```
# 只搜索代码文件
*.js Redis 搜索

# 只搜索文档
*.md Redis 配置
```

### 技巧 4: 使用正则
```
# 搜索函数定义
function search\w+\(

# 搜索 import 语句
^import.*from.*redis
```

---

## 📁 搜索范围

### 默认搜索范围
- `~/.openclaw/workspace/` - 工作区
- `~/.openclaw/ai-chat-room/` - 知识库
- `~/.agents/skills/` - 技能目录

### 可配置范围
```json
{
  "searchPaths": [
    "~/.openclaw/workspace",
    "~/.openclaw/ai-chat-room",
    "~/.agents/skills",
    "~/projects"
  ],
  "excludePatterns": [
    "node_modules",
    ".git",
    "*.log",
    "*.tmp"
  ]
}
```

---

## 💡 最佳实践

### 1. 搜索前明确目标
- 要找什么类型的信息？（文档、代码、命令）
- 关键特征是什么？（关键词、文件名、时间）

### 2. 逐步缩小范围
```
第一次：宽泛搜索 → 了解概况
第二次：添加关键词 → 缩小范围
第三次：精确匹配 → 定位目标
```

### 3. 记录搜索结果
- 重要的搜索结果保存到 `memory/core/`
- 常用命令记录到 `TOOLS.md`
- 代码片段保存为 snippets

### 4. 组合使用技能
- `smart-search` + `reading-assistant` - 搜索并总结
- `smart-search` + `code-explainer` - 搜索并解释代码
- `smart-search` + `memory-search` - 跨记忆搜索

---

## 🔗 相关技能

- `memory-search` - 搜索记忆系统
- `code-explainer` - 解释代码
- `reading-assistant` - 阅读和总结文档
- `grep-master` - 高级 grep 搜索

---

*示例版本：v1.0*
*更新时间：2026-03-14*
