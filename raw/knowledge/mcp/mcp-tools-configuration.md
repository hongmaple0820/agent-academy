# MCP 工具配置手册

> 版本：v1.0
> 更新时间：2026-03-13
> 适用人群：所有用户

---

## 一、配置文件结构

### 1.1 配置文件位置

不同应用的配置文件位置：

| 应用 | 配置文件路径 |
|------|-------------|
| **OpenClaw** | `~/.openclaw/openclaw.json` |
| **Claude Desktop** | `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS) |
| **Claude Desktop** | `%APPDATA%\Claude\claude_desktop_config.json` (Windows) |

### 1.2 基本结构

```json
{
  "mcpServers": {
    "server-name": {
      "command": "命令",
      "args": ["参数列表"],
      "env": {
        "环境变量名": "值"
      },
      "disabled": false
    }
  }
}
```

### 1.3 配置项说明

| 配置项 | 类型 | 必需 | 说明 |
|--------|------|------|------|
| **command** | string | 是 | 启动 MCP 服务器的命令 |
| **args** | string[] | 否 | 命令行参数 |
| **env** | object | 否 | 环境变量 |
| **disabled** | boolean | 否 | 是否禁用（默认 false） |

---

## 二、传输方式配置

### 2.1 stdio 传输（本地）

**适用场景**：本地运行的 MCP 服务器

**特点**：
- 通过标准输入输出通信
- 适合本地工具和脚本
- 配置简单

**配置示例**：

```json
{
  "mcpServers": {
    "sqlite": {
      "command": "uvx",
      "args": ["mcp-server-sqlite", "--db-path", "/path/to/database.db"]
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/allowed/directory"
      ]
    },
    "custom-tool": {
      "command": "python",
      "args": ["/path/to/your/server.py"]
    }
  }
}
```

### 2.2 HTTP/SSE 传输（远程）

**适用场景**：远程运行的 MCP 服务器

**特点**：
- 通过 HTTP 协议通信
- 支持远程部署
- 适合分布式架构

**配置示例**：

```json
{
  "mcpServers": {
    "remote-api": {
      "url": "https://api.example.com/mcp",
      "transport": "sse"
    }
  }
}
```

---

## 三、常用 MCP 工具配置

### 3.1 SQLite

**功能**：操作 SQLite 数据库

**前置条件**：
- 安装 Python 和 uvx

**配置**：

```json
{
  "mcpServers": {
    "sqlite": {
      "command": "uvx",
      "args": [
        "mcp-server-sqlite",
        "--db-path",
        "/path/to/your/database.db"
      ]
    }
  }
}
```

**多数据库配置**：

```json
{
  "mcpServers": {
    "sqlite-main": {
      "command": "uvx",
      "args": ["mcp-server-sqlite", "--db-path", "/data/main.db"]
    },
    "sqlite-archive": {
      "command": "uvx",
      "args": ["mcp-server-sqlite", "--db-path", "/data/archive.db"]
    }
  }
}
```

### 3.2 GitHub

**功能**：GitHub API 集成

**前置条件**：
- 安装 Node.js (v18+)
- 获取 GitHub Personal Access Token

**获取 Token**：
1. 访问 https://github.com/settings/tokens
2. 点击 "Generate new token (classic)"
3. 选择权限：
   - `repo` - 完整仓库访问
   - `read:org` - 读取组织信息
   - `write:discussion` - 写入讨论
4. 生成并复制 Token

**配置**：

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_your_token_here"
      }
    }
  }
}
```

**安全建议**：
- 不要将 Token 提交到版本控制
- 定期轮换 Token
- 使用最小必要权限

### 3.3 文件系统

**功能**：安全的文件系统操作

**前置条件**：
- 安装 Node.js (v18+)

**配置**：

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/path/to/allowed/dir1",
        "/path/to/allowed/dir2"
      ]
    }
  }
}
```

**安全说明**：
- 只允许访问配置中指定的目录
- 路径遍历会被阻止
- 敏感操作需要用户确认

### 3.4 Brave Search

**功能**：Brave 搜索引擎集成

**前置条件**：
- 安装 Node.js (v18+)
- 获取 Brave Search API Key

**获取 API Key**：
1. 访问 https://brave.com/search/api/
2. 注册并创建 API Key

**配置**：

```json
{
  "mcpServers": {
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "your_api_key_here"
      }
    }
  }
}
```

### 3.5 Puppeteer

**功能**：浏览器自动化

**前置条件**：
- 安装 Node.js (v18+)

**配置**：

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

**使用场景**：
- 网页截图
- 自动化测试
- 数据抓取

### 3.6 Sequential Thinking

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

### 3.7 Google Drive

**功能**：Google Drive 集成

**前置条件**：
- Google Cloud 项目
- OAuth 2.0 凭据

**配置**：

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

### 3.8 Slack

**功能**：Slack 集成

**前置条件**：
- Slack Bot Token
- Slack App 凭据

**配置**：

```json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "xoxb-your-bot-token",
        "SLACK_TEAM_ID": "T0XXXXXXXX"
      }
    }
  }
}
```

---

## 四、完整配置示例

### 4.1 开发环境配置

```json
{
  "mcpServers": {
    "sqlite-dev": {
      "command": "uvx",
      "args": ["mcp-server-sqlite", "--db-path", "~/projects/dev.db"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_your_token"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "~/projects"
      ]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
  }
}
```

### 4.2 数据分析环境配置

```json
{
  "mcpServers": {
    "sqlite-analytics": {
      "command": "uvx",
      "args": ["mcp-server-sqlite", "--db-path", "/data/analytics.db"]
    },
    "brave-search": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-brave-search"],
      "env": {
        "BRAVE_API_KEY": "your_key"
      }
    },
    "puppeteer": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-puppeteer"]
    }
  }
}
```

### 4.3 团队协作环境配置

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_your_token"
      }
    },
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "xoxb_your_token",
        "SLACK_TEAM_ID": "T0XXXXXXXX"
      }
    },
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

---

## 五、环境变量管理

### 5.1 使用 .env 文件

**创建 .env 文件**：

```bash
# .env
GITHUB_TOKEN=ghp_your_token
BRAVE_API_KEY=your_key
SLACK_BOT_TOKEN=xoxb_your_token
```

**配置加载**：

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

### 5.2 系统环境变量

**设置环境变量**：

```bash
# Linux/macOS
export GITHUB_TOKEN="ghp_your_token"

# Windows (PowerShell)
$env:GITHUB_TOKEN="ghp_your_token"

# Windows (CMD)
set GITHUB_TOKEN=ghp_your_token
```

---

## 六、故障排除

### 6.1 常见问题

**问题 1：MCP 服务器无法启动**

检查清单：
- [ ] 命令是否正确
- [ ] Node.js/Python 版本是否满足要求
- [ ] 依赖是否安装
- [ ] 文件路径是否正确

**解决方案**：

```bash
# 测试命令是否可执行
npx -y @modelcontextprotocol/server-github --version
uvx mcp-server-sqlite --help

# 检查路径
ls /path/to/database.db
```

**问题 2：环境变量未生效**

检查清单：
- [ ] 环境变量名称是否正确
- [ ] JSON 格式是否正确
- [ ] 是否重启了应用

**解决方案**：

```bash
# 验证环境变量
echo $GITHUB_TOKEN

# 使用 MCP Inspector 测试
npx @modelcontextprotocol/inspector
```

**问题 3：权限不足**

检查清单：
- [ ] GitHub Token 权限是否足够
- [ ] 文件系统权限是否正确
- [ ] 目录是否在允许列表中

**解决方案**：

```bash
# 检查文件权限
ls -la /path/to/directory

# 验证 Token 权限
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user
```

### 6.2 调试技巧

**使用 MCP Inspector**：

```bash
# 启动 Inspector
npx @modelcontextprotocol/inspector

# 在浏览器中打开 Inspector
# 测试工具连接和调用
```

**查看日志**：

```bash
# 查看应用日志
# 日志位置因应用而异

# OpenClaw
cat ~/.openclaw/logs/mcp.log

# Claude Desktop (macOS)
cat ~/Library/Logs/Claude/mcp*.log
```

---

## 七、安全最佳实践

### 7.1 Token 管理

**推荐做法**：
- 使用环境变量存储敏感信息
- 定期轮换 Token
- 使用最小必要权限
- 不要将 Token 提交到版本控制

**示例**：

```bash
# 将 Token 添加到 shell 配置文件
echo 'export GITHUB_TOKEN="ghp_your_token"' >> ~/.bashrc
source ~/.bashrc
```

### 7.2 权限限制

**文件系统**：
- 限制允许访问的目录
- 避免包含敏感信息的目录

**API Token**：
- 只授予必要的权限
- 使用只读 Token 进行只读操作

### 7.3 审计日志

**记录工具调用**：

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_your_token",
        "MCP_LOG_LEVEL": "debug"
      }
    }
  }
}
```

---

## 八、进阶配置

### 8.1 多实例配置

```json
{
  "mcpServers": {
    "github-work": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_work_token"
      }
    },
    "github-personal": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_personal_token"
      }
    }
  }
}
```

### 8.2 自定义 MCP 服务器

```json
{
  "mcpServers": {
    "custom-tool": {
      "command": "python",
      "args": [
        "/path/to/your/mcp_server.py",
        "--config",
        "/path/to/config.yaml"
      ],
      "env": {
        "API_KEY": "your_key",
        "DEBUG": "true"
      }
    }
  }
}
```

### 8.3 Docker 部署

```json
{
  "mcpServers": {
    "dockerized-tool": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-v",
        "/host/path:/container/path",
        "your-image:latest"
      ]
    }
  }
}
```

---

## 九、配置模板

### 9.1 最小配置

```json
{
  "mcpServers": {
    "sqlite": {
      "command": "uvx",
      "args": ["mcp-server-sqlite"]
    }
  }
}
```

### 9.2 标准配置

```json
{
  "mcpServers": {
    "sqlite": {
      "command": "uvx",
      "args": ["mcp-server-sqlite", "--db-path", "~/data/app.db"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_your_token"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "~/workspace"
      ]
    }
  }
}
```

### 9.3 完整配置

参见上文 "四、完整配置示例"。

---

**参考下一步**：[MCP 实际案例集](./mcp-examples.md)
