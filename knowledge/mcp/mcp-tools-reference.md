# MCP 工具完整参考手册

> 版本：v1.1
> 更新时间：2026-03-13
> 维护者：AI协作共享知识库

---

## 一、工具分类概览

MCP 工具按照来源和用途可分为以下几类：

| 分类 | 说明 | 数量 |
|------|------|------|
| **内置工具** | 随 MCP 协议默认提供，开箱即用 | 7+ |
| **官方工具** | Model Context Protocol 官方维护 | 10+ |
| **社区工具** | 社区开发者贡献 | 50+ |
| **企业工具** | 企业内部开发的定制工具 | 按需 |

---

## 二、内置工具（Built-in Tools）

这些工具随 MCP 协议默认提供，无需额外安装。

### 2.1 chrome-devtools - Chrome DevTools 浏览器自动化

**功能描述**：通过 Chrome DevTools Protocol 实现浏览器自动化操作。

**主要能力**：
- 网页截图和 PDF 导出
- 页面元素交互（点击、输入、滚动）
- 网络请求监控
- 性能分析
- JavaScript 执行

**配置示例**：

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-chromium-devtools"]
    }
  }
}
```

**使用场景**：

```
用户：帮我访问 https://example.com 并截图

AI：
[调用 chrome-devtools 工具]
1. 启动浏览器
2. 导航到目标页面
3. 等待页面加载完成
4. 截取屏幕快照

✅ 截图已保存为 screenshot.png
```

**典型应用**：
- 自动化测试
- 网页数据抓取
- UI 验证
- 性能监控

---

### 2.2 context7 - 官方文档搜索

**功能描述**：搜索 50+ 主流库和框架的官方文档。

**支持的文档**：
- React, Vue, Angular
- Next.js, Nuxt.js, SvelteKit
- Node.js, Express, Fastify
- TypeScript, JavaScript
- Tailwind CSS, Bootstrap
- MongoDB, PostgreSQL
- 等等...

**配置示例**：

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/mcp-server"]
    }
  }
}
```

**使用场景**：

```
用户：查找 React useEffect 的使用方法

AI：
[调用 context7 工具]
搜索 React 官方文档中关于 useEffect 的内容

📄 useEffect - React 官方文档

useEffect 是一个 React Hook，用于在组件中执行副作用操作...

基本用法：
useEffect(() => {
  // 副作用代码
  return () => {
    // 清理函数
  };
}, [dependencies]);
```

**典型应用**：
- 快速查阅 API 文档
- 学习新技术栈
- 代码示例查找

---

### 2.3 fetch - 网页内容抓取

**功能描述**：抓取网页内容并转换为 Markdown 格式。

**主要能力**：
- 抓取网页 HTML
- 转换为 Markdown
- 提取文本内容
- 处理 JavaScript 渲染页面

**配置示例**：

```json
{
  "mcpServers": {
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    }
  }
}
```

**使用场景**：

```
用户：抓取 https://example.com/article 的内容

AI：
[调用 fetch 工具]
获取网页内容并转换为 Markdown

📄 文章标题：示例文章

## 摘要
这是一个示例文章的内容...

## 正文
文章的详细内容...
```

**典型应用**：
- 文章内容提取
- 新闻聚合
- 文档收集

---

### 2.4 memory - 短期记忆存储

**功能描述**：为 AI 提供短期记忆存储能力，支持键值对存储。

**主要能力**：
- 存储键值对数据
- 检索存储的内容
- 列出所有记忆
- 清除记忆

**配置示例**：

```json
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    }
  }
}
```

**使用场景**：

```
用户：记住我的项目名称是 "ai-collab-space"

AI：
[调用 memory 工具]
存储：project_name = "ai-collab-space"

✅ 已记住：项目名称是 ai-collab-space

---

用户：我之前说的项目名称是什么？

AI：
[调用 memory 工具]
检索存储的记忆

📌 根据记忆，您的项目名称是：ai-collab-space
```

**典型应用**：
- 会话上下文保存
- 用户偏好记忆
- 临时数据存储

---

### 2.5 sequential-thinking - 顺序思考工具

**功能描述**：提供结构化的思维链推理能力。

**主要能力**：
- 分步骤推理
- 逻辑验证
- 复杂问题分解
- 思维过程可视化

**配置示例**：

```json
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
  }
}
```

**使用场景**：

```
用户：用思维链分析：如何优化数据库查询性能？

AI：
[调用 sequential-thinking 工具]

📌 步骤 1：分析问题
- 数据库查询慢的可能原因
- 常见的优化方向

📌 步骤 2：识别瓶颈
- 检查慢查询日志
- 分析执行计划
- 评估索引使用情况

📌 步骤 3：制定方案
- 添加合适的索引
- 优化查询语句
- 考虑缓存策略

📌 步骤 4：实施优化
- 创建索引
- 重写查询
- 配置缓存

📌 步骤 5：验证效果
- 对比优化前后性能
- 监控查询时间

✅ 完成分析
```

**典型应用**：
- 复杂问题求解
- 算法设计
- 架构决策

---

### 2.6 time - 时间工具

**功能描述**：提供时间相关的操作和转换。

**主要能力**：
- 获取当前时间
- 时间格式转换
- 时区转换
- 时间计算

**配置示例**：

```json
{
  "mcpServers": {
    "time": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-time"]
    }
  }
}
```

**使用场景**：

```
用户：现在北京时间几点？

AI：
[调用 time 工具]
获取北京时间

📅 当前时间：2026-03-13 14:30:25 (UTC+8)

---

用户：将时间戳 1703275200 转换为日期

AI：
[调用 time 工具]
转换时间戳

📅 时间戳 1703275200 对应的日期：2023-12-22 20:00:00 (UTC)
```

**典型应用**：
- 时间计算
- 跨时区协调
- 日程安排

---

### 2.7 mem0 - 长期记忆层

**功能描述**：提供持久化的长期记忆存储，支持语义搜索。

**主要能力**：
- 长期记忆存储
- 语义搜索
- 记忆分类
- 记忆遗忘

**配置示例**：

```json
{
  "mcpServers": {
    "mem0": {
      "command": "npx",
      "args": ["-y", "@mem0/mcp-server"],
      "env": {
        "MEM0_API_KEY": "your_api_key"
      }
    }
  }
}
```

**使用场景**：

```
用户：记住我喜欢使用 VS Code 编辑器

AI：
[调用 mem0 工具]
存储长期记忆

✅ 已长期记忆：用户偏好使用 VS Code 编辑器

---

用户：我之前说过喜欢用什么编辑器？

AI：
[调用 mem0 工具]
语义搜索相关记忆

📌 根据长期记忆，您偏好使用 VS Code 编辑器
```

**典型应用**：
- 用户偏好学习
- 项目知识积累
- 长期上下文保持

---

## 三、官方工具（Official Tools）

### 3.1 SQLite - 数据库操作

**功能描述**：操作 SQLite 数据库，支持查询、创建、修改等操作。

**配置示例**：

```json
{
  "mcpServers": {
    "sqlite": {
      "command": "uvx",
      "args": ["mcp-server-sqlite", "--db-path", "/path/to/database.db"]
    }
  }
}
```

**主要工具**：
- `sqlite_query` - 执行 SQL 查询
- `sqlite_schema` - 查看数据库结构

**详细文档**：参见 [mcp-quick-start.md](./mcp-quick-start.md#31-sqlite-工具)

---

### 3.2 GitHub - GitHub API 集成

**功能描述**：与 GitHub API 交互，管理仓库、Issues、PRs 等。

**配置示例**：

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_your_token"
      }
    }
  }
}
```

**主要工具**：
- `github_search` - 搜索仓库、代码、Issues
- `github_repo_info` - 获取仓库详情
- `github_create_issue` - 创建 Issue
- `github_list_prs` - 列出 Pull Requests

**详细文档**：参见 [mcp-examples.md](./mcp-examples.md#案例-3项目概览分析)

---

### 3.3 Filesystem - 文件系统操作

**功能描述**：安全的文件系统操作，支持读写、搜索等。

**配置示例**：

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/allowed/directory"
      ]
    }
  }
}
```

**主要工具**：
- `read_file` - 读取文件
- `write_file` - 写入文件
- `list_directory` - 列出目录
- `search_files` - 搜索文件

**安全特性**：只能访问配置中指定的目录。

---

### 3.4 Brave Search - 搜索引擎集成

**功能描述**：使用 Brave 搜索引擎进行网络搜索。

**配置示例**：

```json
{
  "mcpServers": {
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "your_api_key"
      }
    }
  }
}
```

**主要工具**：
- `brave_web_search` - 网页搜索
- `brave_image_search` - 图片搜索

---

### 3.5 Puppeteer - 浏览器自动化

**功能描述**：基于 Puppeteer 的浏览器自动化操作。

**配置示例**：

```json
{
  "mcpServers": {
    "puppeteer": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-puppeteer"]
    }
  }
}
```

**主要能力**：
- 网页截图
- PDF 生成
- 表单自动填充
- 页面交互

---

## 四、社区工具（Community Tools）

### 4.1 Figma - 设计工具集成

**功能描述**：与 Figma 设计工具集成，获取设计数据和组件信息。

**主要能力**：
- 获取 Figma 文件数据
- 提取设计组件
- 导出设计规范
- 生成代码片段

**配置示例**：

```json
{
  "mcpServers": {
    "figma": {
      "command": "npx",
      "args": ["-y", "mcp-server-figma"],
      "env": {
        "FIGMA_ACCESS_TOKEN": "your_figma_token"
      }
    }
  }
}
```

**获取 Token**：
1. 登录 Figma 账户
2. 访问 Account Settings > Personal Access Tokens
3. 创建新的 Token

**使用场景**：

```
用户：获取这个 Figma 设计文件的主色调

AI：
[调用 figma 工具]
分析 Figma 文件的颜色变量

🎨 主色调分析：
- Primary: #3B82F6 (蓝色)
- Secondary: #10B981 (绿色)
- Accent: #F59E0B (橙色)
- Background: #F3F4F6 (浅灰)
```

**典型应用**：
- 设计稿转代码
- 设计规范提取
- 组件库同步

---

### 4.2 Redis - 缓存数据库操作

**功能描述**：操作 Redis 数据库，支持缓存、队列等场景。

**主要能力**：
- 键值对操作（SET, GET, DEL）
- 哈希表操作（HSET, HGET）
- 列表操作（LPUSH, RPUSH, LRANGE）
- 发布订阅
- 过期时间设置

**配置示例**：

```json
{
  "mcpServers": {
    "redis": {
      "command": "npx",
      "args": ["-y", "mcp-server-redis"],
      "env": {
        "REDIS_URL": "redis://localhost:6379"
      }
    }
  }
}
```

**使用场景**：

```
用户：检查 Redis 中 user:1001 的数据

AI：
[调用 redis 工具]
执行 HGETALL user:1001

📊 用户数据：
{
  "id": "1001",
  "name": "张三",
  "email": "zhang@example.com",
  "created_at": "2025-01-15"
}

---

用户：将 user:1001 的登录状态缓存 30 分钟

AI：
[调用 redis 工具]
执行 SETEX user:1001:session 1800 "active"

✅ 已设置登录状态缓存，30 分钟后过期
```

**典型应用**：
- 缓存管理
- 会话存储
- 消息队列
- 实时排行榜

---

### 4.3 PostgreSQL - 关系型数据库操作

**功能描述**：操作 PostgreSQL 数据库，支持复杂查询和事务。

**配置示例**：

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "postgresql://user:password@localhost:5432/dbname"
      }
    }
  }
}
```

**主要工具**：
- `postgres_query` - 执行 SQL 查询
- `postgres_schema` - 查看表结构
- `postgres_list_tables` - 列出所有表

---

### 4.4 MongoDB - 文档数据库操作

**功能描述**：操作 MongoDB 文档数据库。

**配置示例**：

```json
{
  "mcpServers": {
    "mongodb": {
      "command": "npx",
      "args": ["-y", "mcp-server-mongodb"],
      "env": {
        "MONGODB_URI": "mongodb://localhost:27017"
      }
    }
  }
}
```

**主要工具**：
- `mongo_find` - 查询文档
- `mongo_insert` - 插入文档
- `mongo_update` - 更新文档
- `mongo_aggregate` - 聚合查询

---

### 4.5 Slack - 团队协作集成

**功能描述**：与 Slack 集成，发送消息、管理频道等。

**配置示例**：

```json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "xoxb-your-token",
        "SLACK_TEAM_ID": "T0XXXXXXXX"
      }
    }
  }
}
```

**主要工具**：
- `slack_send_message` - 发送消息
- `slack_list_channels` - 列出频道
- `slack_get_channel_history` - 获取频道历史

---

### 4.6 Notion - 知识管理集成

**功能描述**：与 Notion 集成，管理页面和数据库。

**配置示例**：

```json
{
  "mcpServers": {
    "notion": {
      "command": "npx",
      "args": ["-y", "mcp-server-notion"],
      "env": {
        "NOTION_API_KEY": "secret_your_key"
      }
    }
  }
}
```

**主要工具**：
- `notion_search` - 搜索页面
- `notion_create_page` - 创建页面
- `notion_query_database` - 查询数据库

---

### 4.7 Google Drive - 云存储集成

**功能描述**：与 Google Drive 集成，管理文件和文件夹。

**配置示例**：

```json
{
  "mcpServers": {
    "google-drive": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-gdrive"],
      "env": {
        "GOOGLE_OAUTH_CLIENT_ID": "your_client_id",
        "GOOGLE_OAUTH_CLIENT_SECRET": "your_client_secret"
      }
    }
  }
}
```

**主要工具**：
- `drive_list_files` - 列出文件
- `drive_download` - 下载文件
- `drive_upload` - 上传文件

---

### 4.8 Docker - 容器管理

**功能描述**：管理 Docker 容器和镜像。

**配置示例**：

```json
{
  "mcpServers": {
    "docker": {
      "command": "npx",
      "args": ["-y", "mcp-server-docker"]
    }
  }
}
```

**主要工具**：
- `docker_list_containers` - 列出容器
- `docker_run` - 运行容器
- `docker_stop` - 停止容器
- `docker_logs` - 查看日志

---

### 4.9 AWS - 云服务集成

**功能描述**：与 AWS 服务集成，管理云资源。

**配置示例**：

```json
{
  "mcpServers": {
    "aws": {
      "command": "npx",
      "args": ["-y", "mcp-server-aws"],
      "env": {
        "AWS_ACCESS_KEY_ID": "your_key_id",
        "AWS_SECRET_ACCESS_KEY": "your_secret",
        "AWS_REGION": "us-east-1"
      }
    }
  }
}
```

**主要能力**：
- EC2 实例管理
- S3 存储操作
- Lambda 函数管理
- CloudWatch 监控

---

### 4.10 Stripe - 支付集成

**功能描述**：与 Stripe 支付平台集成。

**配置示例**：

```json
{
  "mcpServers": {
    "stripe": {
      "command": "npx",
      "args": ["-y", "mcp-server-stripe"],
      "env": {
        "STRIPE_API_KEY": "sk_test_your_key"
      }
    }
  }
}
```

**主要工具**：
- `stripe_create_customer` - 创建客户
- `stripe_create_payment` - 创建支付
- `stripe_list_invoices` - 列出发票

---

## 五、工具对比表

### 5.1 数据库工具对比

| 工具 | 类型 | 适用场景 | 特色功能 |
|------|------|----------|----------|
| **SQLite** | 嵌入式 | 本地数据、原型开发 | 无需服务器、单文件 |
| **PostgreSQL** | 关系型 | 企业应用、复杂查询 | ACID、高级索引 |
| **MongoDB** | 文档型 | 灵活模式、大数据 | 嵌套文档、聚合管道 |
| **Redis** | 缓存 | 高性能缓存、会话 | 内存存储、发布订阅 |

### 5.2 协作工具对比

| 工具 | 类型 | 主要功能 | 集成难度 |
|------|------|----------|----------|
| **Slack** | 即时通讯 | 消息、频道、机器人 | 简单 |
| **Discord** | 社区平台 | 语音、文字、频道 | 简单 |
| **Notion** | 知识管理 | 文档、数据库、协作 | 中等 |
| **GitHub** | 代码管理 | 仓库、Issues、PRs | 简单 |

### 5.3 云服务工具对比

| 工具 | 提供商 | 主要服务 | 配置复杂度 |
|------|--------|----------|------------|
| **AWS** | Amazon | EC2, S3, Lambda | 高 |
| **Google Drive** | Google | 文件存储、协作 | 中等 |
| **Azure** | Microsoft | 云计算、AI 服务 | 高 |

---

## 六、选择指南

### 6.1 按场景选择工具

**数据存储场景**：
- 小型项目 → SQLite
- 企业应用 → PostgreSQL
- 灵活模式 → MongoDB
- 高性能缓存 → Redis

**协作开发场景**：
- 代码管理 → GitHub
- 团队沟通 → Slack
- 文档协作 → Notion
- 设计协作 → Figma

**自动化场景**：
- 浏览器操作 → Chrome DevTools / Puppeteer
- 网页抓取 → Fetch
- 定时任务 → Time
- 复杂推理 → Sequential Thinking

### 6.2 按团队能力选择

**初创团队**：
- 优先选择内置工具
- 使用托管服务（GitHub、Notion）
- 避免复杂配置

**成长团队**：
- 引入数据库工具（PostgreSQL、MongoDB）
- 集成协作工具（Slack、Discord）
- 开始使用云服务

**企业团队**：
- 完整工具链集成
- 自定义 MCP 服务器
- 安全合规要求

---

## 七、工具安装和配置流程

### 7.1 通用安装流程

```
1. 检查依赖（Node.js / Python）
   ↓
2. 获取必要凭据（API Key / Token）
   ↓
3. 编辑配置文件
   ↓
4. 重启应用
   ↓
5. 验证工具可用
```

### 7.2 快速验证脚本

```bash
#!/bin/bash
# verify-mcp-tools.sh

echo "验证 MCP 工具配置..."

# 检查 Node.js
if command -v node &> /dev/null; then
    echo "✅ Node.js: $(node --version)"
else
    echo "❌ Node.js 未安装"
fi

# 检查 Python
if command -v python3 &> /dev/null; then
    echo "✅ Python: $(python3 --version)"
else
    echo "❌ Python 未安装"
fi

# 检查配置文件
if [ -f ~/.openclaw/openclaw.json ]; then
    echo "✅ 配置文件存在"
else
    echo "❌ 配置文件不存在"
fi

echo "验证完成"
```

---

## 八、常见问题

### Q1: 如何选择适合的工具？

**建议**：
1. 从内置工具开始
2. 根据实际需求添加工具
3. 避免安装过多未使用的工具

### Q2: Token 和 API Key 如何管理？

**最佳实践**：
- 使用环境变量存储
- 定期轮换密钥
- 使用最小必要权限

### Q3: 工具冲突如何解决？

**解决方案**：
- 使用不同的工具名称前缀
- 分开配置文件
- 逐个测试工具

---

## 九、更新和维护

### 9.1 工具更新

```bash
# 更新 npm 包
npm update -g

# 更新 Python 包
pip install --upgrade mcp-server-xxx

# 检查过期包
npm outdated
```

### 9.2 配置备份

```bash
# 备份配置
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup

# 版本控制
git init ~/.openclaw
git add openclaw.json
git commit -m "Backup config"
```

---

**参考文档**：
- [MCP 快速入门](./mcp-quick-start.md)
- [MCP 最佳实践](./mcp-best-practices.md)
- [MCP 配置手册](./mcp-tools-configuration.md)
- [MCP 故障排除](./mcp-troubleshooting.md)
