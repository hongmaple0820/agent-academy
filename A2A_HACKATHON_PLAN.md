# A2A 黑客松接入计划

## 任务概述
将中国象棋 Agent 系统接入 A2A (Agent-to-Agent) 协议，参加 SecondMe 举办的 A2A 黑客松比赛。

## 核心要求

### 1. OAuth2 认证集成 ✅
根据 SecondMe 开发者文档，需要实现 OAuth2 授权码流程：

**流程步骤：**
1. 登录 https://develop.second.me/ 创建 OAuth2 应用
2. 获取 `client_id` 和 `client_secret`
3. 实现授权码流程:
   - 重定向用户到授权页面
   - 获取授权码 (authorization code)
   - 用授权码换取 Access Token
4. 使用 Access Token 调用 API

**需要的权限范围：**
- 获取用户授权的个人信息

### 2. A2A Agent Card 实现 ✅
创建符合 A2A 协议标准的 `agent-card.json` 描述文件

**核心字段：**
```json
{
  "name": "中国象棋 Agent",
  "description": "支持自主对弈的中国象棋 AI Agent",
  "url": "https://your-domain.com/.well-known/agent-card.json",
  "capabilities": {
    "game_play": true,
    "autonomous_decision": true,
    "real_time_response": true
  },
  "authentication": {
    "type": "oauth2",
    "flows": {
      "authorization_code": {
        "authorizationUrl": "https://auth.second.me/oauth2/authorize",
        "tokenUrl": "https://auth.second.me/oauth2/token",
        "scopes": ["user_profile", "agent_control"]
      }
    }
  },
  "api": {
    "endpoints": {
      "create_game": "/api/skill-link/game",
      "make_move": "/api/skill-link/game/{id}/move",
      "get_invites": "/api/skill-link/invite"
    }
  }
}
```

### 3. 需要实现的功能

#### 3.1 OAuth2 认证模块 ✅
- [x] `src/lib/a2a/oauth2.ts` - OAuth2 流程实现
- [x] `src/app/api/auth/a2a/callback/route.ts` - OAuth2 回调处理
- [x] `src/app/api/auth/a2a/token/route.ts` - Token 刷新

#### 3.2 A2A Agent Card ✅
- [x] `public/.well-known/agent-card.json` - A2A 标准 Agent 描述
- [x] `src/app/api/a2a/agent-card/route.ts` - Agent Card API

#### 3.3 A2A 协议适配 ✅
- [x] `src/lib/a2a/protocol.ts` - A2A 协议解析器 (oauth2.ts 中实现)
- [x] `src/lib/a2a/message-format.ts` - A2A 消息格式 (agent-card.json 中定义)
- [x] `src/lib/a2a/task-management.ts` - A2A 任务管理 (skill-link 中实现)

#### 3.4 UI 组件 ✅
- [x] `src/components/auth/A2ALoginButton.tsx` - A2A 登录按钮
- [x] 主页集成 A2A 登录选项

#### 3.5 数据库 ✅
- [x] `prisma/schema.prisma` - 添加 A2aToken 模型

## 实施步骤

### 第 1 步：创建 OAuth2 应用
1. 访问 https://develop.second.me/
2. 创建 OAuth2 应用
3. 配置回调 URL: `http://localhost:3000/api/auth/a2a/callback`
4. 保存 `client_id` 和 `client_secret`

### 第 2 步：实现 OAuth2 流程
1. 添加环境变量到 `.env`:
   ```
   A2A_CLIENT_ID=your_client_id
   A2A_CLIENT_SECRET=your_client_secret
   A2A_REDIRECT_URI=http://localhost:3000/api/auth/a2a/callback
   A2A_AUTH_URL=https://auth.second.me/oauth2/authorize
   A2A_TOKEN_URL=https://auth.second.me/oauth2/token
   ```

2. 创建 OAuth2 工具模块
3. 实现授权码换取 Token
4. 实现 Token 刷新机制

### 第 3 步：创建 Agent Card
1. 创建 `public/.well-known/agent-card.json`
2. 实现动态 Agent Card API
3. 添加能力描述

### 第 4 步：适配 A2A 协议
1. 实现 A2A 消息格式解析
2. 实现任务管理接口
3. 测试与其他 Agent 的互操作

### 第 5 步：测试与提交
1. 端到端测试 OAuth2 流程
2. 测试 A2A 协议兼容性
3. 提交黑客松作品

## 时间估算
- 第 1-2 步：2-3 小时
- 第 3 步：1 小时
- 第 4 步：3-4 小时
- 第 5 步：1-2 小时

**总计：7-10 小时**
