# MCP 内置工具快速配置指南

> 版本：v1.0
> 更新时间：2026-03-13
> 适用人群：所有用户

---

## 一、内置工具概览

MCP 协议提供了 7 个开箱即用的内置工具，无需额外配置或只需最小配置。

| 工具名称 | 功能 | 配置难度 | 状态 |
|---------|------|---------|------|
| **chrome-devtools** | Chrome 浏览器自动化 | ⭐ | 内置 |
| **context7** | 官方文档搜索（50+ 库） | ⭐ | 内置 |
| **fetch** | 网页内容抓取 | ⭐ | 内置 |
| **memory** | 短期记忆存储 | ⭐ | 内置 |
| **sequential-thinking** | 顺序思考工具 | ⭐ | 内置 |
| **time** | 时间工具 | ⭐ | 内置 |
| **mem0** | 长期记忆层 | ⭐⭐ | 需配置 |

---

## 二、一键配置方案

### 2.1 完整配置模板

将以下配置添加到 `~/.openclaw/openclaw.json`：

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-chromium-devtools"]
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/mcp-server"]
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    },
    "time": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-time"]
    },
    "mem0": {
      "command": "npx",
      "args": ["-y", "@mem0/mcp-server"],
      "env": {
        "MEM0_API_KEY": "your_mem0_api_key"
      }
    }
  }
}
```

### 2.2 最小配置（无需 API Key）

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-chromium-devtools"]
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    },
    "time": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-time"]
    }
  }
}
```

---

## 三、各工具详细配置

### 3.1 Chrome DevTools - 浏览器自动化

**功能**：通过 Chrome DevTools Protocol 控制浏览器

**使用场景**：
- 网页截图
- 自动化测试
- 数据抓取
- 性能分析

**配置**：

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

**使用示例**：

```
用户：访问 https://example.com 并截图

AI：
[调用 chrome-devtools]
✅ 已访问页面并截图
```

**高级选项**：

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-chromium-devtools",
        "--headless=true",
        "--window-size=1920,1080"
      ]
    }
  }
}
```

---

### 3.2 Context7 - 官方文档搜索

**功能**：搜索 50+ 主流库的官方文档

**支持的文档**：

| 类别 | 支持的库 |
|------|---------|
| **前端框架** | React, Vue, Angular, Svelte, SolidJS |
| **元框架** | Next.js, Nuxt.js, SvelteKit, Remix |
| **后端框架** | Express, Fastify, NestJS, Hono |
| **语言** | TypeScript, JavaScript, Python, Go |
| **数据库** | MongoDB, PostgreSQL, Redis, Prisma |
| **UI 库** | Tailwind CSS, Chakra UI, MUI, shadcn/ui |
| **工具** | Vite, Webpack, ESLint, Prettier |

**配置**：

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

**使用示例**：

```
用户：查找 React useState 的用法

AI：
[调用 context7]
📄 useState - React 官方文档

useState 是一个 Hook，用于在函数组件中添加状态...

const [state, setState] = useState(initialValue);
```

**优势**：
- 直接获取官方文档
- 无需网络搜索
- 版本准确

---

### 3.3 Fetch - 网页内容抓取

**功能**：抓取网页内容并转换为 Markdown

**配置**：

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

**使用示例**：

```
用户：抓取 https://docs.example.com/api 的内容

AI：
[调用 fetch]
📄 API 文档

# API 概述
本文档描述了 API 的使用方法...

## 端点列表
- GET /users
- POST /users
- GET /users/:id
```

**支持的格式**：
- HTML → Markdown
- JSON → 格式化输出
- 纯文本

---

### 3.4 Memory - 短期记忆存储

**功能**：在会话期间存储和检索键值对数据

**配置**：

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

**使用示例**：

```
用户：记住我的邮箱是 user@example.com

AI：
[调用 memory]
✅ 已存储：email = "user@example.com"

---

用户：我的邮箱是什么？

AI：
[调用 memory]
📌 您的邮箱是：user@example.com
```

**特点**：
- 会话级别存储
- 简单键值对
- 快速检索

**限制**：
- 仅当前会话有效
- 重启后数据丢失

---

### 3.5 Sequential Thinking - 顺序思考

**功能**：结构化思维链推理

**配置**：

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

**使用示例**：

```
用户：用思维链分析：如何设计一个推荐系统？

AI：
[调用 sequential-thinking]

📌 步骤 1：理解需求
- 推荐什么内容？
- 目标用户是谁？
- 数据来源有哪些？

📌 步骤 2：设计方案
- 协同过滤（用户行为相似性）
- 内容推荐（物品特征匹配）
- 混合推荐（结合多种方法）

📌 步骤 3：技术选型
- 存储层：Redis（热数据）+ MongoDB（冷数据）
- 计算层：Spark MLlib / TensorFlow
- 服务层：REST API

📌 步骤 4：评估指标
- 准确率、召回率
- 覆盖率、多样性
- 实时性要求

✅ 完成：推荐系统设计方案
```

**适用场景**：
- 复杂问题分析
- 架构设计
- 决策推理
- 算法设计

---

### 3.6 Time - 时间工具

**功能**：时间相关的操作和转换

**配置**：

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

**使用示例**：

```
用户：现在是几点？北京时间

AI：
[调用 time]
📅 当前北京时间：2026-03-13 14:30:25 (UTC+8)

---

用户：时间戳 1703275200 转日期

AI：
[调用 time]
📅 时间戳 1703275200 对应：
- UTC: 2023-12-22 20:00:00
- 北京时间: 2023-12-23 04:00:00

---

用户：计算从现在到 2026-12-31 还有多少天

AI：
[调用 time]
📅 距离 2026-12-31 还有 293 天
```

**功能列表**：
- 获取当前时间
- 时间戳转换
- 时区转换
- 时间计算
- 格式化输出

---

### 3.7 Mem0 - 长期记忆层

**功能**：持久化的长期记忆存储，支持语义搜索

**前置条件**：
- 注册 Mem0 账户：https://mem0.ai
- 获取 API Key

**配置**：

```json
{
  "mcpServers": {
    "mem0": {
      "command": "npx",
      "args": ["-y", "@mem0/mcp-server"],
      "env": {
        "MEM0_API_KEY": "your_mem0_api_key"
      }
    }
  }
}
```

**使用示例**：

```
用户：记住我正在进行的项目名称是 "ai-collab-space"

AI：
[调用 mem0]
✅ 已长期记忆：项目名称 = "ai-collab-space"

---

用户：我之前说的项目叫什么？

AI：
[调用 mem0 语义搜索]
📌 根据长期记忆，您的项目名称是：ai-collab-space
```

**与 Memory 的区别**：

| 特性 | Memory | Mem0 |
|------|--------|------|
| **持久性** | 会话级别 | 永久存储 |
| **搜索方式** | 键值查找 | 语义搜索 |
| **数据结构** | 简单键值对 | 复杂记忆对象 |
| **适用场景** | 临时存储 | 长期知识积累 |

---

## 四、配置验证

### 4.1 验证脚本

创建 `verify-mcp-config.sh`：

```bash
#!/bin/bash

echo "🔍 验证 MCP 内置工具配置..."

# 检查配置文件
CONFIG_FILE="$HOME/.openclaw/openclaw.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ 配置文件不存在: $CONFIG_FILE"
    exit 1
fi

echo "✅ 配置文件存在"

# 检查 Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "✅ Node.js 版本: $NODE_VERSION"
else
    echo "❌ Node.js 未安装"
    exit 1
fi

# 检查 npm
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo "✅ npm 版本: $NPM_VERSION"
else
    echo "❌ npm 未安装"
    exit 1
fi

# 验证 JSON 格式
if command -v python3 &> /dev/null; then
    python3 -m json.tool "$CONFIG_FILE" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✅ JSON 格式正确"
    else
        echo "❌ JSON 格式错误"
        exit 1
    fi
fi

# 统计配置的工具数量
TOOL_COUNT=$(grep -c '"command"' "$CONFIG_FILE" 2>/dev/null || echo "0")
echo "📊 已配置 $TOOL_COUNT 个 MCP 工具"

echo ""
echo "✅ 验证完成！"
echo "💡 提示：重启应用以加载新配置"
```

### 4.2 快速测试

重启应用后，发送以下消息测试：

```
测试所有内置工具：

1. 使用 time 工具显示当前时间
2. 使用 memory 工具存储一个测试值
3. 使用 sequential-thinking 工具分析一个简单问题
```

---

## 五、常见问题

### Q1: npx 下载很慢怎么办？

**解决方案**：使用国内镜像

```bash
# 设置 npm 淘宝镜像
npm config set registry https://registry.npmmirror.com

# 或使用 cnpm
npm install -g cnpm --registry=https://registry.npmmirror.com
```

### Q2: Chrome DevTools 无法启动？

**可能原因**：
- Chrome/Chromium 未安装
- 端口被占用
- 权限不足

**解决方案**：

```bash
# Linux: 安装 Chromium
sudo apt-get install chromium-browser

# macOS: 安装 Chrome
brew install --cask google-chrome

# Windows: 下载安装 Chrome
# https://www.google.com/chrome/
```

### Q3: Context7 搜索不到结果？

**可能原因**：
- 网络问题
- 文档库暂不支持

**解决方案**：
- 检查网络连接
- 尝试搜索其他文档库
- 使用 Fetch 工具作为替代

### Q4: Mem0 需要 API Key，有免费方案吗？

**答案**：Mem0 提供免费额度

- 免费额度：1000 次/月
- 适合个人使用
- 注册地址：https://mem0.ai

---

## 六、最佳实践

### 6.1 工具选择建议

**推荐配置**（按使用频率）：

```
必装：
- memory (短期记忆)
- time (时间工具)
- sequential-thinking (思维链)

常用：
- fetch (网页抓取)
- context7 (文档搜索)

按需：
- chrome-devtools (浏览器自动化)
- mem0 (长期记忆)
```

### 6.2 性能优化

**减少启动时间**：
- 只配置必要的工具
- 使用 `-y` 参数避免交互

**内存优化**：
- 定期清理 memory 存储
- 合理使用 mem0 分类

### 6.3 安全建议

**API Key 管理**：
- 使用环境变量
- 不要提交到版本控制
- 定期轮换密钥

**权限控制**：
- 只授予必要权限
- 使用只读模式（如适用）

---

## 七、快速启动模板

### 7.1 个人用户配置

```json
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    },
    "time": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-time"]
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
  }
}
```

### 7.2 开发者配置

```json
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    },
    "time": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-time"]
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/mcp-server"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    },
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-chromium-devtools"]
    }
  }
}
```

### 7.3 企业用户配置

```json
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    },
    "mem0": {
      "command": "npx",
      "args": ["-y", "@mem0/mcp-server"],
      "env": {
        "MEM0_API_KEY": "${MEM0_API_KEY}"
      }
    },
    "time": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-time"]
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fetch"]
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/mcp-server"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
  }
}
```

---

**下一步**：
- [MCP 工具完整参考](./mcp-tools-reference.md)
- [MCP 实际案例集](./mcp-examples.md)
- [MCP 故障排除](./mcp-troubleshooting.md)
