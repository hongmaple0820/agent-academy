# MCP 最佳实践指南

> 版本：v1.0
> 更新时间：2026-03-13
> 适用人群：工具开发者、架构师

---

## 一、设计原则

### 1.1 核心原则

**1. 以用户任务为中心**
- 工具设计应该围绕用户的实际任务，而非简单的 API 映射
- 提供高层工作流工具，也提供细粒度的基础工具
- 让 AI 能够灵活组合工具完成复杂任务

**2. 清晰的命名和描述**
- 工具名称使用一致的前缀（如 `github_create_issue`）
- 描述简洁明了，说明功能、参数和返回值
- 在参数描述中提供示例值

**3. 可操作的错误信息**
- 错误信息应该指导用户如何解决问题
- 提供具体的建议和下一步操作
- 避免模糊的错误消息

**4. 灵活的响应格式**
- 支持结构化数据输出（JSON）
- 也支持人类可读的格式（Markdown）
- 让 AI 根据场景选择合适的格式

### 1.2 API 覆盖 vs 工作流工具

**平衡策略**：

| 类型 | 优点 | 缺点 | 适用场景 |
|------|------|------|----------|
| **API 覆盖型** | 灵活性高，可组合 | 需要多次调用 | 复杂任务、定制需求 |
| **工作流型** | 一次调用完成 | 灵活性低 | 常见任务、固定流程 |

**推荐做法**：
1. 优先实现完整的 API 覆盖
2. 针对高频场景添加工作流工具
3. 提供配置选项让用户选择

---

## 二、工具设计模式

### 2.1 工具命名规范

**命名格式**：`<service>_<action>_<resource>`

**示例**：
```typescript
// 好的命名
github_create_issue
github_list_repos
github_search_code
github_get_user

// 不好的命名
createIssue  // 缺少服务前缀
githubIssueCreate  // 顺序不一致
do_github_stuff  // 过于模糊
```

### 2.2 参数设计

**输入验证**：

使用 Zod (TypeScript) 或 Pydantic (Python) 进行参数验证：

```typescript
// TypeScript + Zod
import { z } from "zod";

const QuerySchema = z.object({
  query: z.string().describe("SQL 查询语句，例如：SELECT * FROM users"),
  limit: z.number().optional().default(100).describe("返回结果数量限制")
});

// Python + Pydantic
from pydantic import BaseModel, Field

class QueryParams(BaseModel):
    query: str = Field(description="SQL 查询语句，例如：SELECT * FROM users")
    limit: int = Field(default=100, description="返回结果数量限制")
```

**参数分组**：

对于复杂工具，将相关参数分组：

```json
{
  "name": "github_create_issue",
  "inputSchema": {
    "type": "object",
    "properties": {
      "repo": {
        "type": "string",
        "description": "仓库名称，格式：owner/repo"
      },
      "title": {
        "type": "string",
        "description": "Issue 标题"
      },
      "body": {
        "type": "string",
        "description": "Issue 内容（可选）"
      },
      "labels": {
        "type": "array",
        "items": { "type": "string" },
        "description": "标签列表（可选）"
      }
    },
    "required": ["repo", "title"]
  }
}
```

### 2.3 输出格式

**结构化输出**：

使用 `outputSchema` 定义返回结构：

```typescript
server.registerTool({
  name: "github_list_issues",
  outputSchema: {
    type: "object",
    properties: {
      issues: {
        type: "array",
        items: {
          type: "object",
          properties: {
            number: { type: "number" },
            title: { type: "string" },
            state: { type: "string" },
            created_at: { type: "string" }
          }
        }
      },
      total: { type: "number" }
    }
  }
});
```

**多格式支持**：

同时返回文本和结构化数据：

```typescript
return {
  content: [
    {
      type: "text",
      text: formatAsMarkdown(issues)  // 人类可读
    },
    {
      type: "resource",
      resource: {
        mimeType: "application/json",
        text: JSON.stringify(issues)  // 结构化数据
      }
    }
  ]
};
```

### 2.4 错误处理

**可操作的错误信息**：

```typescript
// 好的错误信息
throw new ToolError(
  "GitHub API rate limit exceeded",
  "You have exceeded the GitHub API rate limit. Options:\n" +
  "1. Wait 1 hour for the limit to reset\n" +
  "2. Use a GitHub token with higher rate limits\n" +
  "3. Reduce the number of API calls in your workflow"
);

// 不好的错误信息
throw new Error("API error");
```

**错误类型**：

| 错误类型 | 示例 | 处理建议 |
|---------|------|---------|
| **参数错误** | 缺少必填参数 | 指出具体缺少的参数 |
| **权限错误** | Token 无效 | 提示如何获取正确权限 |
| **资源错误** | 文件不存在 | 提供可能的替代路径 |
| **服务错误** | API 超时 | 建议重试或稍后再试 |

---

## 三、性能优化

### 3.1 分页处理

**实现分页**：

```typescript
async function listItems(params: {
  page?: number;
  per_page?: number;
}) {
  const page = params.page || 1;
  const perPage = params.per_page || 100;
  
  const response = await api.list({
    page,
    per_page: perPage
  });
  
  return {
    items: response.data,
    pagination: {
      page,
      per_page: perPage,
      total: response.total,
      has_more: response.data.length === perPage
    }
  };
}
```

**提示用户分页**：

在工具描述中说明分页行为：

```json
{
  "description": "列出仓库 Issues，默认返回 100 条。如需更多结果，请使用 page 参数获取下一页。",
  "inputSchema": {
    "properties": {
      "page": {
        "type": "number",
        "description": "页码，从 1 开始"
      }
    }
  }
}
```

### 3.2 缓存策略

**适用场景**：
- 不经常变化的数据（如仓库信息）
- 昂贵的 API 调用
- 静态资源

**实现示例**：

```typescript
const cache = new Map<string, { data: any; expires: number }>();

async function getCached(key: string, fetcher: () => Promise<any>, ttl = 3600) {
  const cached = cache.get(key);
  if (cached && Date.now() < cached.expires) {
    return cached.data;
  }
  
  const data = await fetcher();
  cache.set(key, { data, expires: Date.now() + ttl * 1000 });
  return data;
}
```

### 3.3 批量操作

**支持批量请求**：

```typescript
// 单个请求
async function getIssue(repo: string, number: number) {
  return await api.get(`/repos/${repo}/issues/${number}`);
}

// 批量请求
async function getIssues(repo: string, numbers: number[]) {
  const results = await Promise.all(
    numbers.map(n => getIssue(repo, n))
  );
  return results;
}
```

---

## 四、安全最佳实践

### 4.1 认证管理

**使用环境变量**：

```typescript
// 好的做法
const token = process.env.GITHUB_TOKEN;

// 不好的做法（硬编码）
const token = "ghp_xxxxxxxxxxxx";
```

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

### 4.2 权限最小化

**原则**：
- 只请求必要的权限
- 使用只读 Token 进行只读操作
- 定期审查和轮换 Token

**示例**：

```typescript
// 检查权限
if (action === 'write' && !tokenHasWritePermission) {
  throw new Error(
    "This operation requires write permission. " +
    "Please use a token with 'repo' scope."
  );
}
```

### 4.3 输入验证

**防止注入攻击**：

```typescript
// SQL 注入防护
function sanitizeQuery(query: string): string {
  // 使用参数化查询而非字符串拼接
  // 或使用 ORM/查询构建器
}

// 路径遍历防护
function sanitizePath(basePath: string, userPath: string): string {
  const resolved = path.resolve(basePath, userPath);
  if (!resolved.startsWith(basePath)) {
    throw new Error("Invalid path: directory traversal detected");
  }
  return resolved;
}
```

### 4.4 敏感数据处理

**过滤敏感信息**：

```typescript
function filterSensitive(data: any): any {
  const sensitive = ['password', 'token', 'secret', 'key'];
  
  if (typeof data === 'object' && data !== null) {
    const filtered = {};
    for (const [key, value] of Object.entries(data)) {
      if (sensitive.some(s => key.toLowerCase().includes(s))) {
        filtered[key] = '[REDACTED]';
      } else {
        filtered[key] = filterSensitive(value);
      }
    }
    return filtered;
  }
  return data;
}
```

---

## 五、测试策略

### 5.1 单元测试

**测试工具逻辑**：

```typescript
import { describe, it, expect } from 'vitest';

describe('github_create_issue', () => {
  it('should create an issue with required parameters', async () => {
    const result = await createIssue({
      repo: 'test/repo',
      title: 'Test Issue'
    });
    
    expect(result.number).toBeDefined();
    expect(result.title).toBe('Test Issue');
  });
  
  it('should throw error when repo is missing', async () => {
    await expect(createIssue({ title: 'Test' }))
      .rejects.toThrow('repo is required');
  });
});
```

### 5.2 集成测试

**使用 MCP Inspector**：

```bash
# 启动 Inspector
npx @modelcontextprotocol/inspector

# 测试工具调用
# 在 Inspector 界面中：
# 1. 连接到 MCP 服务器
# 2. 列出可用工具
# 3. 测试工具调用
# 4. 验证返回结果
```

### 5.3 评估测试

**创建评估问题**：

参考 `skills/tool-development/mcp-builder/reference/evaluation.md`，创建测试问题：

```xml
<evaluation>
  <qa_pair>
    <question>列出 OpenClaw 组织下 star 最多的前 5 个仓库</question>
    <answer>ai-collab-space,chat-hub,openclaw-cli,mcp-tools,skill-builder</answer>
  </qa_pair>
</evaluation>
```

---

## 六、文档最佳实践

### 6.1 工具描述模板

```typescript
{
  name: "tool_name",
  description: `
[一句话功能描述]

功能：
- 功能点 1
- 功能点 2

参数：
- param1 (必需): 参数说明和示例
- param2 (可选): 参数说明和默认值

返回：
- 返回值说明

示例：
\`\`\`
tool_name --param1 "value1" --param2 "value2"
\`\`\`
  `.trim()
}
```

### 6.2 README 结构

```markdown
# Tool Name

简短描述工具的功能和用途。

## 安装

安装步骤和依赖要求。

## 配置

配置示例和环境变量说明。

## 使用

基本使用示例和常见场景。

## 工具列表

所有工具的详细说明。

## 常见问题

FAQ 和故障排除。

## 许可证

许可证信息。
```

---

## 七、部署和维护

### 7.1 版本管理

**语义化版本**：

```
MAJOR.MINOR.PATCH

- MAJOR: 不兼容的 API 变更
- MINOR: 向后兼容的功能新增
- PATCH: 向后兼容的问题修复
```

**版本检查**：

```typescript
// 在工具中添加版本信息
{
  name: "my_tool",
  version: "1.2.0",
  // ...
}
```

### 7.2 日志记录

**结构化日志**：

```typescript
import { logger } from './logger';

logger.info('Tool called', {
  tool: 'github_create_issue',
  params: { repo: 'test/repo', title: 'Test' },
  duration: 1234,
  success: true
});
```

### 7.3 监控告警

**监控指标**：
- 调用次数和成功率
- 平均响应时间
- 错误率
- 资源使用情况

---

## 八、检查清单

### 8.1 开发检查清单

- [ ] 工具命名清晰且一致
- [ ] 参数验证完整
- [ ] 错误信息可操作
- [ ] 支持分页（如适用）
- [ ] 实现缓存（如适用）
- [ ] 添加安全检查
- [ ] 编写单元测试
- [ ] 编写文档

### 8.2 发布检查清单

- [ ] 所有测试通过
- [ ] 文档完整
- [ ] 版本号正确
- [ ] 变更日志更新
- [ ] 安全审查完成
- [ ] 性能测试通过

---

## 九、参考资源

### 9.1 官方文档

- [MCP 规范](https://modelcontextprotocol.io/specification)
- [TypeScript SDK](https://github.com/modelcontextprotocol/typescript-sdk)
- [Python SDK](https://github.com/modelcontextprotocol/python-sdk)

### 9.2 本知识库资源

- [TypeScript 实现指南](../../skills/tool-development/mcp-builder/reference/node_mcp_server.md)
- [Python 实现指南](../../skills/tool-development/mcp-builder/reference/python_mcp_server.md)
- [评估指南](../../skills/tool-development/mcp-builder/reference/evaluation.md)

---

**遵循这些最佳实践，可以创建高质量、易用、安全的 MCP 工具。**
