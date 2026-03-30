# 案例：OpenClaw Zero Token 多模型 AI 网关

## 项目背景

**项目名称**: OpenClaw Zero Token  
**项目类型**: 开发者工具 / AI 网关  
**开发周期**: 2025-03 至 2026-03 (持续维护)  
**技术栈**: Node.js + TypeScript + Playwright + Lit (Web UI)

### 项目简介

OpenClaw Zero Token 是一个**零成本使用多模型 AI** 的网关项目：
- 支持 DeepSeek、Claude、GPT、Gemini、Kimi、豆包等 10+ 主流模型
- 通过浏览器登录获取凭证，无需 API Key
- 提供统一 API 接口和 Web UI
- 支持工具调用 (Tool Calling)

### 核心挑战

1. **浏览器自动化**: 使用 Playwright 驱动浏览器登录并捕获凭证
2. **多平台适配**: 每个 AI 平台有不同的认证流程和 API 格式
3. **流式响应处理**: 处理各平台不同的 SSE/WebSocket 流式格式
4. **凭证管理**: 安全存储和自动刷新 cookies/tokens

---

## 复杂度评估

| 维度 | 评估 | 说明 |
|------|------|------|
| **功能复杂度** | 🔴 高 | 多平台集成 + 浏览器自动化 |
| **技术复杂度** | 🔴 高 | CDP 协议 + 逆向工程 |
| **维护成本** | 🔴 高 | 平台变更需持续跟进 |
| **稳定性要求** | 🔴 高 | 作为网关不能频繁故障 |

**综合评估**: 🔴 **复杂项目** (> 2天)

---

## 工作流应用过程

### 阶段 1：理解 (5分钟)

**需求澄清**:
1. 核心目标？→ 让用户免费使用多模型 AI
2. 技术原理？→ 浏览器自动化 + 凭证捕获
3. 支持平台？→ DeepSeek、Claude、Kimi 等 10+ 平台
4. 使用场景？→ 开发者本地开发、个人使用

**决策**: 采用 🔴 **复杂项目** 工作流模式

---

### 阶段 2：规划 (详细规划)

#### 2.1 系统架构

```
┌─────────────────────────────────────────────────────────────────┐
│                    OpenClaw Zero Token                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐        │
│  │   Web UI    │    │  CLI/TUI    │    │   Gateway   │        │
│  │  (Lit 3.x)  │    │             │    │  (Port API) │        │
│  └──────┬──────┘    └──────┬──────┘    └──────┬──────┘        │
│         │                  │                  │                 │
│         └──────────────────┴──────────────────┘                 │
│                            │                                    │
│                     ┌──────▼──────┐                            │
│                     │  Agent Core │                            │
│                     │ (PI-AI Engine)│                          │
│                     └──────┬──────┘                            │
│                            │                                    │
│  ┌─────────────────────────┼─────────────────────────────────┐ │
│  │              Provider Layer (多平台适配)                   │ │
│  ├──────────────┬──────────┼──────────┬──────────────────────┤ │
│  │ DeepSeek Web │ Qwen Web │   ...    │     GLM Web          │ │
│  │  (Auth+API)  │(Auth+API)│          │    (Auth+API)        │ │
│  └──────────────┴──────────┴──────────┴──────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

#### 2.2 模块设计

```
src/
├── providers/           # 各平台认证和 API 客户端
│   ├── deepseek-web-auth.ts
│   ├── deepseek-web-client.ts
│   ├── claude-web-auth.ts
│   └── ...
├── agents/              # 流式响应处理
│   └── deepseek-web-stream.ts
├── browser/             # 浏览器自动化
│   └── chrome.ts
├── commands/            # CLI 命令
│   └── auth-choice.apply.deepseek-web.ts
└── ui/                  # Web UI (Lit 3.x)
```

#### 2.3 核心流程设计

**认证流程 (以 DeepSeek 为例)**:

```
1. 启动 Chrome (CDP 模式)
   openclaw gateway ──▶ Chrome (port 18892)

2. 用户登录
   Browser ──▶ https://chat.deepseek.com

3. 捕获凭证
   Playwright CDP ──▶ 监听网络请求
                    └─▶ 拦截 Authorization + cookies

4. 存储凭证
   auth.json ◀── { cookie, bearer, userAgent }

5. 调用 Web API
   WebClient ──▶ DeepSeek API (reuse credentials)
```

---

### 阶段 3：执行 (Build)

#### 3.1 核心实现

**浏览器自动化** (`src/browser/chrome.ts`):
```typescript
export async function startChromeDebug(options: {
  port: number;
  userDataDir: string;
}): Promise<Browser> {
  // 启动 Chrome 调试模式
  const browser = await chromium.launch({
    headless: false,
    args: [
      `--remote-debugging-port=${options.port}`,
      `--user-data-dir=${options.userDataDir}`
    ]
  });
  return browser;
}
```

**凭证捕获** (`src/providers/deepseek-web-auth.ts`):
```typescript
export async function loginDeepSeekWeb(params: {
  onProgress: (msg: string) => void;
}): Promise<Credentials> {
  const browser = await startChromeDebug({ port: 9222 });
  const context = browser.defaultBrowserContext();
  
  // 监听网络请求
  context.on('request', async (request) => {
    const headers = request.headers();
    if (headers['authorization']) {
      // 捕获 Bearer Token
      credentials.bearer = headers['authorization'];
    }
  });
  
  // 用户登录后返回凭证
  return credentials;
}
```

**流式响应处理** (`src/agents/deepseek-web-stream.ts`):
```typescript
export function createDeepSeekWebStreamFn(credentials: Credentials): StreamFn {
  return async function* (params: ChatParams) {
    const response = await fetch(API_URL, {
      headers: {
        'Authorization': credentials.bearer,
        'Cookie': credentials.cookie
      },
      body: JSON.stringify(params)
    });
    
    // 处理 SSE 流
    for await (const chunk of parseSSEStream(response.body)) {
      yield chunk;
    }
  };
}
```

#### 3.2 多平台适配

| 平台 | 认证方式 | 流式格式 | 工具调用 |
|------|----------|----------|----------|
| DeepSeek | Cookie + Bearer | SSE | ✅ |
| Claude | Cookie | SSE | ✅ |
| Kimi | Cookie | SSE | ✅ |
| 豆包 | Cookie + Sign | SSE | ✅ |
| GPT | Cookie | SSE | ✅ |
| Gemini | Cookie | SSE | ✅ |

每个平台需要独立的 `auth.ts` + `client.ts` + `stream.ts`

#### 3.3 质量把关

| 审查类型 | 触发条件 | 执行者 | 结果 |
|----------|----------|--------|------|
| 安全审查 | 凭证存储 | security-sentinel | ✅ 通过 |
| 代码审查 | 核心模块 | 小熊-统筹 | ✅ 通过 |
| 兼容性测试 | 新平台接入 | 自动化测试 | ✅ 通过 |

---

### 阶段 4：沉淀 (Compound)

#### 4.1 文档沉淀

**用户文档**:
- `README.md` - 项目介绍和快速开始
- `INSTALLATION.md` - 详细安装指南
- `TROUBLESHOOTING.md` - 常见问题解决

**开发文档**:
- `ARCHITECTURE.md` - 架构设计文档
- `docs/` - 各平台接入指南

#### 4.2 脚本工具

```bash
# 核心脚本
start-chrome-debug.sh    # 启动 Chrome 调试模式
onboard.sh               # 认证向导
server.sh                # 启动网关服务

# 使用示例
./start-chrome-debug.sh  # 步骤 1: 启动浏览器
./onboard.sh webauth     # 步骤 2: 登录并捕获凭证
./server.sh              # 步骤 3: 启动服务
```

#### 4.3 经验教训

**技术经验**:
1. CDP (Chrome DevTools Protocol) 是浏览器自动化的关键
2. 凭证捕获需要在请求发出时拦截，不能事后获取
3. 每个平台的反爬虫策略不同，需要针对性处理

**维护经验**:
1. 平台页面改版会导致认证失效，需要持续跟进
2. 凭证有有效期，需要设计自动刷新机制
3. 用户代理 (User-Agent) 需要与浏览器版本匹配

---

## 关键决策点

### 决策 1：浏览器自动化 vs API 逆向

**选项对比**:

| 方案 | 优点 | 缺点 | 选择 |
|------|------|------|------|
| 浏览器自动化 | 稳定、合法 | 资源占用高 | ✅ |
| API 逆向 | 轻量、快速 | 易失效、风险 | ❌ |

**决策理由**: 浏览器自动化更稳定，且符合平台使用条款

---

### 决策 2：统一接口设计

**OpenAI 兼容 API**:

```typescript
// 统一接口格式
POST /v1/chat/completions
{
  "model": "deepseek-web/deepseek-chat",
  "messages": [
    {"role": "user", "content": "Hello"}
  ],
  "stream": true
}
```

**优势**:
- 兼容 OpenAI SDK
- 降低用户学习成本
- 易于集成到现有项目

---

### 决策 3：凭证存储安全

**存储策略**:

```
.openclaw-zero-state/
├── openclaw.json          # 配置文件
└── agents/main/agent/
    └── auth.json          # 凭证文件 (敏感)
```

**安全措施**:
- 凭证文件 `.gitignore` 排除
- 文件权限设置为 600
- 支持加密存储（可选）

---

## 结果和经验

### 项目成果

| 指标 | 成果 |
|------|------|
| 支持平台 | 10+ 主流 AI 平台 |
| 模型数量 | 30+ 模型 |
| 工具调用 | 全平台支持 |
| 开源协议 | MIT |
| GitHub Stars | 持续增长 |

### 核心功能

```
功能清单
├── ✅ 浏览器自动化登录
├── ✅ 凭证自动捕获
├── ✅ 多平台统一 API
├── ✅ 流式响应支持
├── ✅ 工具调用 (Tool Calling)
├── ✅ Web UI 界面
├── ✅ CLI/TUI 交互
├── ✅ AskOnce 多模型对比
└── 📋 自动刷新凭证 (进行中)
```

### 关键经验

#### ✅ 做得好的

1. **模块化设计**: 每个平台独立模块，易于扩展新平台
2. **用户友好**: 提供 onboarding 向导，降低使用门槛
3. **文档完善**: 详细的 README 和安装指南
4. **开源协作**: 接受社区贡献，快速迭代

#### ⚠️ 需要改进

1. **平台稳定性**: 官方页面改版会导致功能失效
2. **凭证过期**: 需要更智能的自动刷新机制
3. **错误处理**: 部分边界情况处理不够优雅

### 复用价值

**可复用组件**:
- 浏览器自动化框架 (CDP 封装)
- 凭证管理模块
- SSE 流式解析器
- OpenAI 兼容 API 层

**工作流优化建议**:
- 多平台项目需要设计清晰的扩展接口
- 自动化工具需要提供完善的错误提示
- 文档应该包含详细的故障排除指南

---

## 总结

OpenClaw Zero Token 是枫林工作流在工具类项目上的典型应用：

1. **规划阶段**: 清晰的架构设计，模块化思路
2. **执行阶段**: 分平台逐步实现，持续集成
3. **沉淀阶段**: 完善的文档和脚本工具

**项目特点**:
- 🔧 开发者工具属性
- 🔄 持续维护需求
- 📚