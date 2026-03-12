# MCP 故障排除指南

> 版本：v1.0
> 更新时间：2026-03-13
> 适用人群：所有用户

---

## 一、常见问题快速索引

| 问题类型 | 常见错误 | 快速跳转 |
|---------|---------|---------|
| **启动失败** | MCP 服务器无法启动 | [二、启动问题](#二启动问题) |
| **连接问题** | 无法连接到 MCP 服务器 | [三、连接问题](#三连接问题) |
| **认证问题** | Token 无效或权限不足 | [四、认证问题](#四认证问题) |
| **性能问题** | 响应慢、超时 | [五、性能问题](#五性能问题) |
| **功能问题** | 工具调用失败 | [六、功能问题](#六功能问题) |

---

## 二、启动问题

### 2.1 MCP 服务器无法启动

#### 症状
- 应用启动时没有加载 MCP 工具
- 日志显示 "Failed to start MCP server"
- 工具列表为空

#### 诊断步骤

**步骤 1：检查命令是否可执行**

```bash
# 测试 npx 命令
npx -y @modelcontextprotocol/server-github --version

# 测试 uvx 命令
uvx mcp-server-sqlite --help

# 测试 Python 脚本
python /path/to/your/server.py --help
```

**步骤 2：检查环境依赖**

```bash
# 检查 Node.js 版本（需要 v18+）
node --version

# 检查 Python 版本（需要 3.10+）
python --version

# 检查 uvx 是否安装
uvx --version
```

**步骤 3：验证配置文件格式**

```bash
# 使用 JSON 验证工具
cat ~/.openclaw/openclaw.json | python -m json.tool

# 或使用 jq
cat ~/.openclaw/openclaw.json | jq .
```

#### 解决方案

**问题：命令找不到**

```json
// 错误配置
{
  "mcpServers": {
    "github": {
      "command": "npx",  // npx 不在 PATH 中
      "args": ["-y", "@modelcontextprotocol/server-github"]
    }
  }
}

// 正确配置（使用完整路径）
{
  "mcpServers": {
    "github": {
      "command": "/usr/local/bin/npx",
      "args": ["-y", "@modelcontextprotocol/server-github"]
    }
  }
}
```

**问题：Node.js 版本过低**

```bash
# 升级 Node.js
# macOS
brew install node@18

# Linux
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Windows
# 下载安装 https://nodejs.org/
```

**问题：JSON 格式错误**

```json
// 常见错误：缺少引号、多余的逗号
{
  "mcpServers": {
    "sqlite": {
      "command": "uvx",
      "args": ["mcp-server-sqlite"],  // 不要在最后一个元素后加逗号
    }
  }
}
```

### 2.2 依赖安装失败

#### 症状
- npm install 报错
- pip install 失败
- 网络超时

#### 解决方案

**使用国内镜像**

```bash
# npm 使用淘宝镜像
npm config set registry https://registry.npmmirror.com

# pip 使用清华镜像
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# uvx 使用镜像
UV_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple uvx mcp-server-sqlite
```

**清除缓存后重试**

```bash
# 清除 npm 缓存
npm cache clean --force

# 清除 pip 缓存
pip cache purge

# 清除 uvx 缓存
uvx cache clean
```

---

## 三、连接问题

### 3.1 无法连接到 MCP 服务器

#### 症状
- "Connection refused"
- "Timeout waiting for server"
- 工具调用无响应

#### 诊断步骤

**步骤 1：检查进程是否运行**

```bash
# 查看相关进程
ps aux | grep mcp
ps aux | grep node

# 查看端口占用（HTTP 模式）
lsof -i :3000
netstat -tuln | grep 3000
```

**步骤 2：检查日志**

```bash
# OpenClaw 日志
cat ~/.openclaw/logs/mcp.log

# Claude Desktop 日志（macOS）
cat ~/Library/Logs/Claude/mcp*.log

# 实时查看日志
tail -f ~/.openclaw/logs/mcp.log
```

**步骤 3：使用 MCP Inspector 测试**

```bash
# 启动 Inspector
npx @modelcontextprotocol/inspector

# 在浏览器中测试连接
# http://localhost:5173
```

#### 解决方案

**问题：stdio 模式通信失败**

```json
// 确保使用正确的传输模式
{
  "mcpServers": {
    "sqlite": {
      "command": "uvx",
      "args": ["mcp-server-sqlite", "--db-path", "/path/to/db"],
      // stdio 模式不需要额外配置
    }
  }
}
```

**问题：HTTP 模式端口冲突**

```bash
# 检查端口是否被占用
lsof -i :3000

# 使用其他端口
npx @modelcontextprotocol/server-github --port 3001
```

### 3.2 连接不稳定

#### 症状
- 频繁断开重连
- 间歇性超时
- 响应时间波动大

#### 解决方案

**调整超时设置**

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "MCP_TIMEOUT": "30000",  // 30 秒超时
        "MCP_RETRY_COUNT": "3"
      }
    }
  }
}
```

**检查网络状况**

```bash
# 测试网络延迟
ping api.github.com

# 检查 DNS 解析
nslookup api.github.com

# 测试 HTTPS 连接
curl -I https://api.github.com
```

---

## 四、认证问题

### 4.1 Token 无效

#### 症状
- "Authentication failed"
- "Invalid token"
- "Unauthorized"

#### 诊断步骤

**步骤 1：验证 Token 格式**

```bash
# GitHub Token 应以 ghp_ 开头
echo $GITHUB_TOKEN

# 验证 Token 有效性
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user
```

**步骤 2：检查 Token 权限**

```bash
# GitHub：检查 Token 权限
curl -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/user \
  -I | grep "x-oauth-scopes"
```

#### 解决方案

**问题：Token 过期**

```bash
# GitHub：重新生成 Token
# 1. 访问 https://github.com/settings/tokens
# 2. 点击 "Generate new token"
# 3. 选择所需权限
# 4. 复制新 Token
```

**问题：权限不足**

```json
// 确保选择了正确的权限范围
// GitHub Token 权限：
// - repo: 完整仓库访问
// - read:org: 读取组织信息
// - user: 用户信息
```

**问题：环境变量未加载**

```bash
# 确认环境变量已设置
echo $GITHUB_TOKEN

# 在配置中使用环境变量
{
  "mcpServers": {
    "github": {
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"  // 从环境变量读取
      }
    }
  }
}
```

### 4.2 API 限流

#### 症状
- "Rate limit exceeded"
- "Too many requests"
- 请求被拒绝

#### 解决方案

**检查限流状态**

```bash
# GitHub API 限流状态
curl -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/rate_limit
```

**应对策略**

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_your_token",
        "MCP_RATE_LIMIT_DELAY": "1000"  // 请求间隔 1 秒
      }
    }
  }
}
```

---

## 五、性能问题

### 5.1 响应缓慢

#### 症状
- 工具调用超过 10 秒
- 频繁超时
- CPU/内存占用高

#### 诊断步骤

**步骤 1：监控资源使用**

```bash
# 查看 CPU/内存使用
top -pid $(pgrep -f "mcp-server")

# 或使用 htop
htop -p $(pgrep -f "mcp-server")
```

**步骤 2：分析慢查询**

```bash
# 启用调试日志
export MCP_LOG_LEVEL=debug

# 查看日志中的耗时
tail -f ~/.openclaw/logs/mcp.log | grep "duration"
```

#### 解决方案

**问题：数据库查询慢**

```json
// 添加索引
{
  "mcpServers": {
    "sqlite": {
      "command": "uvx",
      "args": [
        "mcp-server-sqlite",
        "--db-path", "/path/to/db",
        "--enable-indexes"  // 启用索引
      ]
    }
  }
}
```

**问题：内存不足**

```json
// 限制返回结果数量
{
  "mcpServers": {
    "github": {
      "env": {
        "MCP_MAX_RESULTS": "100"  // 限制最大返回数
      }
    }
  }
}
```

**问题：并发请求过多**

```json
{
  "mcpServers": {
    "github": {
      "env": {
        "MCP_CONCURRENT_REQUESTS": "5",  // 限制并发数
        "MCP_REQUEST_DELAY": "100"       // 请求间隔（毫秒）
      }
    }
  }
}
```

### 5.2 内存泄漏

#### 症状
- 内存使用持续增长
- 系统变慢
- 最终崩溃

#### 解决方案

**定期重启服务**

```bash
# 使用进程管理器（如 pm2）
pm2 start "npx @modelcontextprotocol/server-github" --name mcp-github
pm2 restart mcp-github --cron "0 3 * * *"  # 每天凌晨 3 点重启
```

**限制内存使用**

```json
{
  "mcpServers": {
    "github": {
      "command": "node",
      "args": [
        "--max-old-space-size=512",  // 限制 Node.js 内存为 512MB
        "/path/to/server.js"
      ]
    }
  }
}
```

---

## 六、功能问题

### 6.1 工具调用失败

#### 症状
- "Tool call failed"
- "Invalid parameters"
- "Unknown error"

#### 诊断步骤

**步骤 1：使用 Inspector 测试**

```bash
npx @modelcontextprotocol/inspector

# 在界面中：
# 1. 连接服务器
# 2. 列出工具
# 3. 测试单个工具调用
# 4. 检查返回结果
```

**步骤 2：检查参数格式**

```json
// 常见参数错误

// 错误：数字作为字符串
{"limit": "100"}  // 应该是数字

// 正确
{"limit": 100}

// 错误：数组格式
{"labels": "bug,feature"}  // 应该是数组

// 正确
{"labels": ["bug", "feature"]}
```

#### 解决方案

**问题：参数类型错误**

```json
// 查看工具的 inputSchema
// 确保参数类型匹配

{
  "name": "github_create_issue",
  "inputSchema": {
    "type": "object",
    "properties": {
      "repo": {"type": "string"},
      "title": {"type": "string"},
      "labels": {
        "type": "array",
        "items": {"type": "string"}
      }
    }
  }
}
```

**问题：缺少必填参数**

```json
// 检查 required 字段
{
  "inputSchema": {
    "required": ["repo", "title"]  // 必须提供这两个参数
  }
}
```

### 6.2 返回结果异常

#### 症状
- 返回空结果
- 数据格式不符合预期
- 编码问题

#### 解决方案

**问题：编码问题**

```json
// 设置正确的编码
{
  "mcpServers": {
    "filesystem": {
      "env": {
        "LANG": "en_US.UTF-8",
        "LC_ALL": "en_US.UTF-8"
      }
    }
  }
}
```

**问题：结果被截断**

```json
// 增加结果大小限制
{
  "mcpServers": {
    "sqlite": {
      "env": {
        "MCP_MAX_RESPONSE_SIZE": "10485760"  // 10MB
      }
    }
  }
}
```

---

## 七、调试技巧

### 7.1 启用调试模式

**方法 1：环境变量**

```bash
export MCP_LOG_LEVEL=debug
export MCP_DEBUG=true
```

**方法 2：配置文件**

```json
{
  "mcpServers": {
    "github": {
      "env": {
        "MCP_LOG_LEVEL": "debug",
        "MCP_DEBUG": "true"
      }
    }
  }
}
```

### 7.2 使用 MCP Inspector

```bash
# 安装并启动 Inspector
npx @modelcontextprotocol/inspector

# 访问 http://localhost:5173
# 功能：
# - 连接到 MCP 服务器
# - 列出所有工具
# - 测试工具调用
# - 查看请求/响应
# - 检查错误信息
```

### 7.3 查看详细日志

**日志位置**：

| 应用 | 日志路径 |
|------|----------|
| OpenClaw | `~/.openclaw/logs/mcp.log` |
| Claude Desktop (macOS) | `~/Library/Logs/Claude/mcp*.log` |
| Claude Desktop (Windows) | `%APPDATA%\Claude\logs\mcp*.log` |

**实时查看日志**：

```bash
tail -f ~/.openclaw/logs/mcp.log

# 过滤错误
tail -f ~/.openclaw/logs/mcp.log | grep -i error

# 显示时间戳
tail -f ~/.openclaw/logs/mcp.log | grep -E "^\[.*\]"
```

---

## 八、错误代码参考

### 8.1 常见错误代码

| 错误代码 | 含义 | 解决方案 |
|---------|------|---------|
| `ECONNREFUSED` | 连接被拒绝 | 检查服务是否启动 |
| `ETIMEDOUT` | 连接超时 | 检查网络、增加超时时间 |
| `ENOENT` | 文件或命令不存在 | 检查路径是否正确 |
| `EACCES` | 权限不足 | 检查文件权限 |
| `ENOMEM` | 内存不足 | 增加内存或限制使用 |

### 8.2 MCP 特定错误

| 错误 | 含义 | 解决方案 |
|------|------|---------|
| `ToolNotFound` | 工具不存在 | 检查工具名称拼写 |
| `InvalidParams` | 参数无效 | 检查参数类型和格式 |
| `ServerError` | 服务器内部错误 | 查看服务器日志 |
| `AuthFailed` | 认证失败 | 检查 Token 或凭据 |

---

## 九、预防措施

### 9.1 定期维护

**每周检查**：
- [ ] 检查日志中的错误
- [ ] 验证 Token 是否过期
- [ ] 清理临时文件
- [ ] 更新依赖包

**每月检查**：
- [ ] 审查权限配置
- [ ] 更新 MCP 服务器版本
- [ ] 检查性能指标
- [ ] 备份配置文件

### 9.2 监控告警

**设置监控**：

```bash
# 使用脚本监控 MCP 服务
#!/bin/bash
# monitor-mcp.sh

if ! pgrep -f "mcp-server" > /dev/null; then
  echo "MCP server is not running!" | mail -s "MCP Alert" admin@example.com
fi
```

### 9.3 备份配置

```bash
# 备份 MCP 配置
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.backup

# 使用版本控制
cd ~/.openclaw
git init
git add openclaw.json
git commit -m "Backup MCP config"
```

---

## 十、获取帮助

### 10.1 官方资源

- [MCP 官方文档](https://modelcontextprotocol.io/)
- [GitHub Issues](https://github.com/modelcontextprotocol)
- [社区论坛](https://github.com/orgs/modelcontextprotocol/discussions)

### 10.2 本知识库资源

- [MCP 快速入门](./mcp-quick-start.md)
- [MCP 最佳实践](./mcp-best-practices.md)
- [MCP 工具配置](./mcp-tools-configuration.md)
- [MCP 实际案例](./mcp-examples.md)

### 10.3 问题报告模板

```markdown
## 问题描述
[简洁描述遇到的问题]

## 环境信息
- 操作系统：
- Node.js 版本：
- Python 版本：
- MCP 工具版本：

## 配置文件
```json
[你的配置]
```

## 错误信息
```
[完整的错误日志]
```

## 已尝试的解决方案
1. [方案 1]
2. [方案 2]
```

---

**记住：大多数 MCP 问题都与配置、权限或网络相关。按照本指南逐步排查，通常能找到解决方案。**
