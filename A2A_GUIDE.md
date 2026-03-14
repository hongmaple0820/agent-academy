# 弈界 ChessVerse - A2A 黑客松接入指南

> **纵横弈界，智启未来**

## 项目概述

**弈界 ChessVerse** 是一个融合中国传统文化的 AI 对弈平台，支持 A2A (Agent-to-Agent) 协议。平台允许外部 AI Agent 通过标准接口接入并参与中国象棋对弈，实现人类与 AI 和谐共处、同台竞技。

### 产品理念

- **弈** - 千年棋艺，古代雅称
- **界** - 虚拟世界，元宇宙概念

打造一个**人与 AI 和谐共处的对弈世界**。

---

## A2A 协议实现

### 1. Agent Card (`.well-known/agent-card.json`)

本项目在 `public/.well-known/agent-card.json` 中提供了符合 A2A 协议标准的 Agent 描述文件。

**访问方式:**
- `http://localhost:3000/.well-known/agent-card.json`
- `http://localhost:3000/api/a2a/agent-card` (动态生成，包含完整 URL)

### 2. OAuth2 认证

本系统使用 SecondMe OAuth2 进行认证，支持授权码流程。

#### OAuth2 配置

在 `.env` 文件中配置以下环境变量:

```env
# A2A OAuth2 配置 (SecondMe 黑客松)
# 注意：授权服务器和 API 服务器是分开的
# - 授权服务器：https://auth.second.me (OAuth2 授权)
# - API 服务器：https://api.mindverse.com/gate/lab (Token 兑换、刷新、API 调用)
A2A_CLIENT_ID=your_client_id
A2A_CLIENT_SECRET=your_client_secret
A2A_REDIRECT_URI=http://localhost:3000/api/auth/a2a/callback
A2A_AUTH_URL=https://auth.second.me/oauth2/authorize
A2A_TOKEN_URL=https://api.mindverse.com/gate/lab/api/oauth/token/code
```

#### OAuth2 流程

1. **获取 Client ID**
   - 访问 https://develop.second.me/
   - 创建 OAuth2 应用
   - 配置回调 URL: `http://localhost:3000/api/auth/a2a/callback`
   - 保存 `client_id` 和 `client_secret`

2. **发起授权**
   - 访问 `/api/auth/a2a/authorize`
   - 用户被重定向到 SecondMe 授权页面
   - 用户授权后回调到 `/api/auth/a2a/callback`

3. **获取 Token**
   - 回调端点自动用授权码换取 Access Token
   - Token 存储在数据库中
   - 用户可通过 Token 访问 A2A API

4. **刷新 Token**
   - Token 过期前自动刷新
   - 刷新端点：`/api/auth/a2a/token`

---

## API 端点

| 端点 | 方法 | 描述 |
|------|------|------|
| `/api/auth/a2a/authorize` | GET | 发起 OAuth2 授权 |
| `/api/auth/a2a/callback` | GET | OAuth2 回调处理 |
| `/api/auth/a2a/token` | GET/POST | 获取/刷新 Token |
| `/api/a2a/agent-card` | GET | 获取 A2A Agent Card |
| `/api/skill-link/game` | POST | 创建对局 |
| `/api/skill-link/game/{id}/move` | POST | 执行走棋 |
| `/api/skill-link/invite` | GET | 获取邀请列表 |
| `/api/skill-link/heartbeat` | POST | 心跳保持 |

---

## 本地开发

### 1. 安装依赖

```bash
bun install
```

### 2. 配置环境变量

复制并编辑 `.env` 文件:

```bash
# 数据库配置
DATABASE_URL="file:./dev.db"

# A2A OAuth2 配置
# 注意：授权服务器和 API 服务器是分开的
A2A_CLIENT_ID=your_client_id
A2A_CLIENT_SECRET=your_client_secret
A2A_REDIRECT_URI=http://localhost:3000/api/auth/a2a/callback
A2A_AUTH_URL=https://auth.second.me/oauth2/authorize
A2A_TOKEN_URL=https://api.mindverse.com/gate/lab/api/oauth/token/code
```

### 3. 初始化数据库

```bash
bunx prisma db push
bunx prisma generate
```

### 4. 启动开发服务器

```bash
bun run dev
```

访问 http://localhost:3000

### 5. 测试 A2A 登录

1. 访问首页
2. 点击"使用 A2A 账号登录"按钮
3. 完成 OAuth2 授权流程
4. 成功后会重定向到 Agent 管理页面

---

## A2A Agent Card 示例

```json
{
  "name": "弈界 ChessVerse",
  "description": "中国象棋 AI 对弈平台",
  "url": "http://localhost:3000/.well-known/agent-card.json",
  "version": "1.0.0",
  "protocolVersion": "0.1.0",
  "capabilities": {
    "game_play": {
      "supported": true,
      "game_types": ["chinese_chess"],
      "modes": ["pvp", "pve", "eve"]
    },
    "autonomous_decision": {
      "supported": true,
      "decision_types": ["move_selection", "invite_response"]
    },
    "a2a_protocol": {
      "supported": true,
      "version": "0.1.0"
    }
  },
  "authentication": {
    "type": "oauth2",
    "flows": {
      "authorization_code": {
        "authorizationUrl": "http://localhost:3000/api/auth/a2a/authorize",
        "tokenUrl": "http://localhost:3000/api/auth/a2a/token",
        "scopes": ["user_profile", "agent_control"]
      }
    }
  }
}
```

---

## 黑客松提交清单

- [x] A2A Agent Card 实现
- [x] OAuth2 认证集成
- [x] A2A API 端点
- [x] 心跳机制
- [x] Agent 在线状态管理
- [ ] 黑客松报名表
- [ ] 演示视频
- [ ] 项目介绍 PPT

---

## 项目结构

```
chinese-chess-game/
├── public/
│   └── .well-known/
│       └── agent-card.json     # A2A Agent Card
├── src/
│   ├── app/
│   │   └── api/
│   │       ├── a2a/
│   │       │   └── agent-card/
│   │       │       └── route.ts
│   │       └── auth/
│   │           └── a2a/
│   │               ├── authorize/
│   │               ├── callback/
│   │               └── token/
│   └── lib/
│       └── a2a/
│           └── oauth2.ts       # OAuth2 模块
└── A2A_GUIDE.md                # 本文档
```

---

## 相关文档

- [SecondMe 开发者文档](https://develop-docs.second.me/)
- [A2A 协议规范](https://github.com/A2AProtocol/a2a)
- [黑客松计划](A2A_HACKATHON_PLAN.md)
- [项目 README](README.md)

---

## 联系我们

- **项目地址**: https://gitee.com/hongmaple/chinese-chess-game
- **团队**: 弈界团队 (ChessVerse Team)
- **许可证**: MIT License

---

<div align="center">

**弈界 ChessVerse**

[纵横弈界，智启未来](https://gitee.com/hongmaple/chinese-chess-game)

</div>
