# MCP 实际案例集

> 版本：v1.0
> 更新时间：2026-03-13
> 适用人群：所有用户

---

## 一、数据分析案例

### 案例 1：销售数据分析

**场景**：分析 SQLite 数据库中的销售数据，生成报告

**工具配置**：
```json
{
  "mcpServers": {
    "sqlite": {
      "command": "uvx",
      "args": ["mcp-server-sqlite", "--db-path", "/data/sales.db"]
    }
  }
}
```

**对话示例**：

```
用户：请帮我分析 2025 年 Q4 的销售数据

AI：
我来分析 2025 年 Q4（10-12月）的销售数据。

[调用 sqlite_query]
SELECT 
  strftime('%Y-%m', sale_date) as month,
  COUNT(*) as order_count,
  SUM(amount) as total_sales,
  AVG(amount) as avg_order_value
FROM sales
WHERE sale_date BETWEEN '2025-10-01' AND '2025-12-31'
GROUP BY month
ORDER BY month;

[返回结果]
| 月份  | 订单数 | 总销售额    | 平均订单额 |
|-------|--------|-------------|------------|
| 10月  | 1,234  | ¥2,456,000  | ¥1,991    |
| 11月  | 1,567  | ¥3,123,000  | ¥1,993    |
| 12月  | 2,345  | ¥4,890,000  | ¥2,086    |

**Q4 销售分析总结**：
- 总订单数：5,146 笔
- 总销售额：¥10,469,000
- 平均订单额：¥2,034
- 12月表现最佳，销售额环比增长 56.6%
- 整体呈上升趋势，建议备货充足应对需求
```

### 案例 2：用户行为分析

**场景**：分析用户行为数据，找出活跃用户

**对话示例**：

```
用户：找出过去 30 天最活跃的前 10 名用户

AI：
[调用 sqlite_query]
SELECT 
  u.user_id,
  u.username,
  COUNT(DISTINCT l.id) as login_count,
  COUNT(DISTINCT o.id) as order_count,
  SUM(o.amount) as total_spent
FROM users u
LEFT JOIN login_logs l ON u.user_id = l.user_id 
  AND l.login_time >= date('now', '-30 days')
LEFT JOIN orders o ON u.user_id = o.user_id 
  AND o.order_time >= date('now', '-30 days')
GROUP BY u.user_id
ORDER BY login_count DESC, total_spent DESC
LIMIT 10;

[返回结果]
| 用户ID | 用户名    | 登录次数 | 订单数 | 消费总额  |
|--------|-----------|----------|--------|-----------|
| 10042  | zhang_wei | 45       | 12     | ¥8,900   |
| 10231  | li_na     | 42       | 15     | ¥12,300  |
| ...

**活跃用户分析**：
- 前 10 名用户平均登录 38 次/月
- 平均消费 ¥9,450
- 建议对这些高价值用户提供专属优惠
```

---

## 二、GitHub 集成案例

### 案例 3：项目概览分析

**场景**：快速了解一个 GitHub 项目的基本情况

**工具配置**：
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

**对话示例**：

```
用户：帮我分析 openclaw/ai-collab-space 这个项目

AI：
我来分析这个项目的基本情况。

[调用 github 工具]
- 获取仓库信息
- 查看 README
- 列出最近的 Issues 和 PRs
- 分析贡献者

[返回结果]
**项目概览：ai-collab-space**

📊 基本信息：
- 描述：AI 协作共享知识库
- Stars：256
- Forks：45
- 主要语言：Markdown, TypeScript
- 创建时间：2025-06-15

📈 活跃度：
- 最近 30 天：23 commits
- 开放 Issues：12
- 开放 PRs：3
- 活跃贡献者：8 人

📝 最近更新：
- 新增 MCP 知识库模块
- 优化技能目录结构
- 添加自动化脚本

💡 建议：
- 文档结构清晰，适合贡献
- Issues 响应及时
- 欢迎新贡献者
```

### 案例 4：代码审查自动化

**场景**：批量审查 Pull Requests

**对话示例**：

```
用户：帮我检查今天提交的所有 PR，列出需要关注的

AI：
[调用 github 工具]
列出今天创建的所有 PRs

[返回结果]
今天共有 5 个新 PR：

🔴 需要关注：
1. #456 - refactor: 重构认证系统
   - 变更文件：23 个
   - 需要仔细审查安全相关改动

2. #454 - feat: 添加支付集成
   - 涉及敏感功能
   - 建议添加测试用例

🟡 一般关注：
3. #453 - docs: 更新 README
   - 文档更新，影响较小

✅ 可直接合并：
4. #452 - fix: 修复登录 bug
   - 单文件小改动
   - 已有 2 个 approve

5. #451 - style: 代码格式化
   - 纯格式化，无逻辑变更
```

### 案例 5：Issue 管理

**场景**：整理和处理 Issues

**对话示例**：

```
用户：帮我把 openclaw/ai-collab-space 中标记为 bug 且超过 7 天未更新的 Issues 列出来

AI：
[调用 github 工具]
搜索符合条件的 Issues

[返回结果]
找到 3 个符合条件的 Issues：

1. #423 - 登录页面加载缓慢
   - 创建于：2025-11-15（30 天前）
   - 最后更新：2025-11-20
   - 需要跟进处理

2. #418 - 移动端布局错位
   - 创建于：2025-11-10（35 天前）
   - 最后更新：2025-11-12
   - 建议：指派给前端团队

3. #401 - 搜索功能不工作
   - 创建于：2025-11-01（44 天前）
   - 最后更新：2025-11-05
   - 建议：检查是否需要更多信息

**建议操作**：
- 为 #423 添加 `priority: high` 标签
- 将 #418 指派给相关开发者
- 对 #401 发起跟进询问
```

---

## 三、文件系统案例

### 案例 6：文件整理自动化

**场景**：自动整理下载目录

**工具配置**：
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/home/user/downloads",
        "/home/user/documents"
      ]
    }
  }
}
```

**对话示例**：

```
用户：帮我把下载目录里的文件按类型整理到 documents 目录

AI：
我来帮你整理文件。

[调用 filesystem 工具]
1. 扫描下载目录
2. 识别文件类型
3. 创建目标目录
4. 移动文件

[返回结果]
**文件整理完成！**

📁 创建的目录：
- documents/images/ - 图片文件
- documents/pdfs/ - PDF 文档
- documents/archives/ - 压缩包
- documents/code/ - 代码文件
- documents/others/ - 其他文件

📊 整理结果：
- 图片：45 个 → documents/images/
- PDF：23 个 → documents/pdfs/
- 压缩包：12 个 → documents/archives/
- 代码文件：8 个 → documents/code/
- 其他：15 个 → documents/others/

✅ 共整理 103 个文件
```

### 案例 7：批量文件处理

**场景**：批量重命名文件

**对话示例**：

```
用户：把 photos 目录下所有 IMG_ 开头的文件改成 2025_vacation_ 开头

AI：
[调用 filesystem 工具]
1. 列出所有 IMG_ 开头的文件
2. 执行批量重命名

[返回结果]
**批量重命名完成**

重命名的文件：
- IMG_001.jpg → 2025_vacation_001.jpg
- IMG_002.jpg → 2025_vacation_002.jpg
- IMG_003.jpg → 2025_vacation_003.jpg
...
- IMG_156.jpg → 2025_vacation_156.jpg

✅ 共重命名 156 个文件
```

---

## 四、组合使用案例

### 案例 8：自动化报告生成

**场景**：从数据库提取数据，生成 Markdown 报告，保存到文件

**工具配置**：
```json
{
  "mcpServers": {
    "sqlite": {
      "command": "uvx",
      "args": ["mcp-server-sqlite", "--db-path", "/data/analytics.db"]
    },
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/data/reports"
      ]
    }
  }
}
```

**对话示例**：

```
用户：生成一份本周的用户增长报告，保存到 reports 目录

AI：
我来生成周报告。

[步骤 1：调用 sqlite_query]
SELECT 
  date(created_at) as date,
  COUNT(*) as new_users
FROM users
WHERE created_at >= date('now', 'weekday 0', '-7 days')
GROUP BY date
ORDER BY date;

[步骤 2：调用 filesystem 工具]
创建报告文件并写入内容

[返回结果]
**报告已生成并保存！**

📄 文件：/data/reports/weekly_user_growth_2025-03-13.md

📊 报告内容：
# 用户增长周报告
> 报告周期：2025-03-06 至 2025-03-12

## 摘要
- 本周新增用户：1,234 人
- 日均增长：176 人
- 峰值日期：2025-03-10（245 人）

## 每日数据
| 日期       | 新增用户 |
|------------|----------|
| 2025-03-06 | 145      |
| 2025-03-07 | 167      |
| 2025-03-08 | 132      |
| 2025-03-09 | 189      |
| 2025-03-10 | 245      |
| 2025-03-11 | 198      |
| 2025-03-12 | 158      |

## 趋势分析
本周用户增长稳定，周末（3月10日）达到峰值。
建议持续关注转化渠道的表现。
```

### 案例 9：项目状态同步

**场景**：从 GitHub 获取项目状态，更新到团队文档

**工具配置**：
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
    "filesystem": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-filesystem",
        "/team/docs"
      ]
    }
  }
}
```

**对话示例**：

```
用户：更新项目状态文档，包含最近的 PRs 和 Issues

AI：
[步骤 1：调用 github 工具]
获取最近的 PRs 和 Issues

[步骤 2：调用 filesystem 工具]
更新项目状态文档

[返回结果]
**项目状态文档已更新！**

📄 文件：/team/docs/project_status.md

📊 更新内容：
- 最近 7 天合并的 PRs：8 个
- 最近 7 天关闭的 Issues：12 个
- 新增 Issues：5 个
- 待处理 Issues：15 个

主要更新：
✅ 功能：用户认证优化
✅ 功能：支付系统集成
🐛 修复：登录超时问题
🐛 修复：数据导出错误
```

---

## 五、思维链案例

### 案例 10：复杂问题分析

**场景**：使用思维链工具分析复杂的架构设计问题

**工具配置**：
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

**对话示例**：

```
用户：使用思维链分析：如何设计一个支持百万用户的聊天系统？

AI：
[调用 sequential-thinking 工具]

**思维链分析：百万用户聊天系统设计**

📌 步骤 1：理解需求
- 用户规模：100 万+
- 核心功能：实时消息、群聊、文件传输
- 性能要求：低延迟（<100ms）、高可用（99.9%）

📌 步骤 2：识别关键挑战
- 并发连接：百万级 WebSocket 连接
- 消息投递：实时性要求高
- 数据存储：消息历史量大
- 可扩展性：需要水平扩展能力

📌 步骤 3：架构设计
- 接入层：WebSocket 网关集群
- 服务层：消息路由、用户状态、群组管理
- 存储层：Redis（会话）、MongoDB（消息历史）
- 消息队列：Kafka 处理高吞吐

📌 步骤 4：关键技术选型
- WebSocket：长连接管理
- Redis Cluster：分布式缓存
- Kafka：消息队列
- MongoDB：文档存储

📌 步骤 5：容灾设计
- 多机房部署
- 数据分片和复制
- 故障自动切换
- 灰度发布机制

📌 步骤 6：优化建议
- 连接池优化
- 消息压缩
- 离线消息推送
- 监控告警系统

✅ 结论：
采用微服务架构，关键组件包括：
1. WebSocket 网关集群处理连接
2. Redis Cluster 管理会话状态
3. Kafka 处理消息路由
4. MongoDB 存储历史消息
5. 多机房部署保证高可用
```

---

## 六、自定义工具案例

### 案例 11：企业内部 API 集成

**场景**：开发自定义 MCP 服务器，集成企业内部 API

**工具代码示例（Python）**：

```python
from mcp.server import Server
from mcp.server.stdio import stdio_server
import httpx

server = Server("enterprise-api")

@server.list_tools()
async def list_tools():
    return [
        {
            "name": "get_employee",
            "description": "查询员工信息",
            "inputSchema": {
                "type": "object",
                "properties": {
                    "employee_id": {
                        "type": "string",
                        "description": "员工ID"
                    }
                },
                "required": ["employee_id"]
            }
        },
        {
            "name": "list_departments",
            "description": "列出所有部门"
        }
    ]

@server.call_tool()
async def call_tool(name: str, arguments: dict):
    if name == "get_employee":
        async with httpx.AsyncClient() as client:
            response = await client.get(
                f"https://api.company.com/employees/{arguments['employee_id']}",
                headers={"Authorization": f"Bearer {API_TOKEN}"}
            )
            return {"content": [{"type": "text", "text": response.text}]}
    
    elif name == "list_departments":
        async with httpx.AsyncClient() as client:
            response = await client.get(
                "https://api.company.com/departments",
                headers={"Authorization": f"Bearer {API_TOKEN}"}
            )
            return {"content": [{"type": "text", "text": response.text}]}

async def main():
    async with stdio_server() as (read_stream, write_stream):
        await server.run(read_stream, write_stream)

if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
```

**配置**：

```json
{
  "mcpServers": {
    "enterprise-api": {
      "command": "python",
      "args": ["/path/to/enterprise_mcp_server.py"],
      "env": {
        "API_TOKEN": "your_internal_token"
      }
    }
  }
}
```

---

## 七、最佳实践总结

### 7.1 工具组合原则

| 原则 | 说明 |
|------|------|
| **按需组合** | 根据任务需求选择合适的工具组合 |
| **最小权限** | 只授予必要的权限 |
| **错误处理** | 预期可能的失败，提供备选方案 |
| **性能优化** | 批量操作减少调用次数 |

### 7.2 常见模式

| 模式 | 描述 | 示例 |
|------|------|------|
| **数据管道** | 读取 → 处理 → 写入 | 数据库 → 分析 → 报告文件 |
| **状态同步** | 多源 → 整合 → 更新 | GitHub + 文件 → 状态文档 |
| **自动化流程** | 监控 → 判断 → 执行 | 检查 Issues → 分类 → 指派 |
| **智能分析** | 收集 → 分析 → 建议 | 日志收集 → 异常检测 → 建议 |

---

**参考下一步**：[MCP 故障排除指南](./mcp-troubleshooting.md)
