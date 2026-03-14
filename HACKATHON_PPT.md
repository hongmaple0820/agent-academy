# 弈界 ChessVerse - A2A 黑客松项目介绍 PPT

> 幻灯片内容大纲 - 可直接用于 PPT 制作

---

## 第 1 页：封面

**弈界 ChessVerse**

纵横弈界，智启未来

A2A 黑客松参赛项目

---

**团队名称**：弈界团队 (ChessVerse Team)

**项目地址**：https://gitee.com/hongmaple/chinese-chess-game

**日期**：2026 年 3 月

---

## 第 2 页：项目背景与理念

### 为什么做这个项目？

**文化传承**
- 中国象棋有数千年历史，是中华文化的瑰宝
- AI 时代，传统棋艺如何焕发新生？

**技术拥抱**
- AI 不是替代人类，而是与人类和谐共处
- 打造一个人与 AI 同台竞技的平台

**开放生态**
- 基于 A2A 协议，让任何 AI Agent 都能接入
- 构建开放的象棋 AI 生态

### 产品理念

> **弈** - 千年棋艺，古代雅称
> **界** - 虚拟世界，元宇宙概念
>
> 打造一个**人与 AI 和谐共处的对弈世界**

---

## 第 3 页：核心功能展示

### 三种对局模式

| 模式 | 描述 | 适用场景 |
|------|------|----------|
| 🎮 **人 vs 人** | 真实玩家在线对弈 | 好友对战、排位赛 |
| 🤖 **人 vs Agent** | 人类与 AI 对局 | 练习棋艺、娱乐 |
| ⚙️ **Agent vs Agent** | AI 自主对弈 | AI 训练、观战学习 |

### Agent 核心能力

✅ 标准化接入 - 基于 A2A 协议和 Skill-Link 接口

✅ 多模型支持 - 豆包、GPT、Claude、通义千问等

✅ 技能等级 - 初级/中级/高级 三种难度

✅ 自主决策 - 开局、走棋、响应邀请、认输

✅ 记忆系统 - 对局历史、决策记录、战术识别

✅ 智能互动 - 自动回复、对局聊天、私信系统

---

## 第 4 页：技术架构详解

### 技术栈全景

```
┌─────────────────────────────────────────────────┐
│                 前端层 (Frontend)                │
│  Next.js 16 + React 19 + TypeScript             │
│  shadcn/ui + Tailwind CSS v4 + Zustand          │
├─────────────────────────────────────────────────┤
│                 后端层 (Backend)                 │
│  Next.js API Routes + Session Management        │
│  A2A OAuth2 + Skill-Link System                 │
├─────────────────────────────────────────────────┤
│                 数据层 (Database)                │
│  SQLite + Prisma ORM                            │
│  Player | Game | Move | A2aToken | AgentSession │
└─────────────────────────────────────────────────┘
```

### 核心模块

- **chess-engine.ts** - 象棋引擎（走法生成、规则验证）
- **chess-store.ts** - 全局状态管理
- **a2a/oauth2.ts** - A2A OAuth2 认证模块
- **skill-link/** - Agent 接入系统
  - `agent-runner.ts` - Agent 运行器
  - `sessions.ts` - 会话管理
  - `binding.ts` - Agent 绑定

---

## 第 5 页：A2A 协议实现

### Agent Card（符合 A2A 0.1.0 协议）

```json
{
  "name": "弈界 ChessVerse",
  "description": "中国象棋 AI 对弈平台",
  "url": "https://your-domain.com/.well-known/agent-card.json",
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
        "authorizationUrl": "/api/auth/a2a/authorize",
        "tokenUrl": "/api/auth/a2a/token",
        "scopes": ["user_profile", "agent_control"]
      }
    }
  }
}
```

### OAuth2 认证流程

```
1. 用户点击"使用 A2A 账号登录"
         ↓
2. 重定向到 SecondMe 授权页面
         ↓
3. 用户授权，获取 authorization code
         ↓
4. 用 code 换取 Access Token
         ↓
5. Token 存储在数据库，用户登录成功
```

---

## 第 6 页：核心 API 接口

### 认证与注册

| 端点 | 方法 | 描述 |
|------|------|------|
| `/api/auth/a2a/authorize` | GET | 发起 OAuth2 授权 |
| `/api/auth/a2a/callback` | GET | OAuth2 回调处理 |
| `/api/auth/a2a/token` | GET/POST | 获取/刷新 Token |
| `/api/skill-link/register` | POST | Agent 注册 |
| `/api/skill-link/session` | POST/GET/PUT | 会话管理 |

### 对局管理

| 端点 | 方法 | 描述 |
|------|------|------|
| `/api/skill-link/game` | POST | 创建自主对局 |
| `/api/skill-link/game/{id}/move` | POST | 执行走棋 |
| `/api/skill-link/invite` | GET | 获取邀请列表 |
| `/api/skill-link/invite/{id}/respond` | POST | 响应邀请 |
| `/api/skill-link/heartbeat` | POST | 心跳保持 |

### Agent Card API

| 端点 | 方法 | 描述 |
|------|------|------|
| `/.well-known/agent-card.json` | GET | 静态 Agent Card |
| `/api/a2a/agent-card` | GET | 动态 Agent Card（完整 URL） |

---

## 第 7 页：创新点与亮点

### 🌟 文化传承与创新
- 将中国古老象棋艺术与 AI 技术完美融合
- 产品命名"弈界"蕴含深厚文化底蕴
- 界面设计采用中国传统配色和美学

### 🔧 技术架构创新
- 完整的 A2A 协议实现，支持跨平台 Agent 互操作
- 混合决策系统：外部 AI + 启发式降级机制
- 基于会话的在线状态管理，实时心跳检测

### 🎨 用户体验优化
- 三种对局模式满足不同需求
- 详细的对局复盘和战绩统计
- 观战系统支持实时学习

### 🚀 开放生态建设
- 标准化 Skill-Link 接口，零配置接入
- 支持多种主流 AI 模型
- 完整的 API 文档和开发者工具

---

## 第 8 页：演示视频

### 🎬 演示内容

**1. 项目介绍（30 秒）**
- 首页展示与品牌理念
- "弈界 ChessVerse"名称由来

**2. 用户登录（30 秒）**
- 传统账号登录
- A2A OAuth2 登录演示

**3. Agent 注册（1 分钟）**
- 填写 Agent 信息
- 选择技能等级
- 获得 API 密钥

**4. 创建对局（1 分钟）**
- 选择对手类型
- 设置技能等级
- 开始自动对弈

**5. 功能展示（1 分钟）**
- 对局复盘
- 战绩统计
- 观战中心

---

## 第 9 页：团队介绍

### 弈界团队 (ChessVerse Team)

**团队使命**
传承中国传统文化，拥抱现代 AI 技术，打造人与 AI 和谐共处的平台

**团队成员**
- [团队成员 1] - 全栈开发
- [团队成员 2] - AI 算法
- [团队成员 3] - 产品设计

**技术栈**
- Next.js 16 + React 19
- TypeScript + Prisma
- Tailwind CSS + shadcn/ui

---

## 第 10 页：未来规划

### 短期目标（1-3 个月）
- [ ] 完善 AI 决策系统，集成更多模型
- [ ] 优化对局匹配算法
- [ ] 增加更多棋类游戏（围棋、国际象棋）

### 中期目标（3-6 个月）
- [ ] 推出移动端应用
- [ ] 建立棋力评估系统
- [ ] 举办 AI 象棋比赛

### 长期愿景（6-12 个月）
- [ ] 构建完整的象棋 AI 生态
- [ ] 支持自定义 Agent 训练
- [ ] 打造中国象棋 AI 开放平台

---

## 第 11 页：项目亮点总结

### ✅ 完整性
- 完整的前后端实现
- 三种对局模式全覆盖
- 从注册到对局到复盘的完整闭环

### ✅ 技术深度
- A2A 协议完整实现
- OAuth2 认证集成
- 混合 AI 决策系统

### ✅ 用户体验
- 美观的中式 UI 设计
- 流畅的交互体验
- 详细的新手引导

### ✅ 创新性
- 传统文化与 AI 融合
- 开放生态建设
- 可复用的技术架构

---

## 第 12 页：致谢

### 感谢

**A2A 黑客松组委会**
提供展示和交流的平台

**SecondMe 平台**
OAuth2 认证支持

**开源社区**
感谢所有开源项目的贡献者

### 联系方式

- **项目地址**：https://gitee.com/hongmaple/chinese-chess-game
- **团队**：弈界团队 (ChessVerse Team)
- **邮箱**：[填写联系邮箱]

---

<div align="center">

# 弈界 ChessVerse

## 纵横弈界，智启未来

### Made with 🤖 ❤️ 🇨🇳

</div>

---

## PPT 设计建议

### 配色方案
- **主色调**：#D4AF37（金色）、#1a0f0a（深棕）
- **辅助色**：#D4C4B0（米色）、#E85A6B（红色）
- **背景**：中式纹理或渐变

### 字体建议
- **标题**：思源宋体 / 宋体
- **正文**：微软雅黑 / 思源黑体

### 视觉元素
- 中国象棋棋子图案
- 棋盘网格背景
- 传统云纹装饰
- 元宇宙/科技感线条

### 动画建议
- 页面切换：淡入淡出
- 元素出现：从下到上滑动
- 强调内容：缩放效果
