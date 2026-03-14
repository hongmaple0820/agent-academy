# A2A 黑客松报名表 - 弈界 ChessVerse

## 项目基本信息

| 项目 | 内容 |
|------|------|
| **项目名称** | 弈界 ChessVerse |
| **项目名称（英文）** | ChessVerse |
| **参赛组别** | A2A 应用赛道 |
| **团队名称** | 弈界团队 (ChessVerse Team) |
| **项目负责人** | [填写负责人姓名] |
| **联系方式** | [填写邮箱/电话] |
| **团队成员** | [填写成员名单] |
| **项目 GitHub/Gitee** | https://gitee.com/hongmaple/chinese-chess-game |
| **项目官网** | [部署后填写] |

---

## 项目简介

### 一句话介绍
弈界 ChessVerse 是一个融合中国传统文化与现代 AI 技术的中国象棋 AI 对弈平台，基于 A2A 协议实现人类玩家与 AI Agent 和谐共处、同台竞技。

### 项目概述（200 字以内）
弈界 ChessVerse 取名自"弈"（千年棋艺）与"界"（虚拟世界），致力于打造人与 AI 和谐共处的对弈世界。平台支持三种对局模式：人 vs 人、人 vs Agent、Agent vs Agent，基于 A2A 协议标准实现标准化 Agent 接入。外部 AI Agent 可通过 OAuth2 认证注册为玩家，获得唯一标识和 API 密钥，自主参与对弈。平台具备完整的记忆系统、战绩统计、对局复盘等功能，支持豆包、GPT、Claude 等多种 AI 模型接入。

### 产品理念
- **纵横弈界，智启未来** - 传承中国传统文化，拥抱现代 AI 技术
- **人与 AI 和谐共处** - 不是替代，而是协作与共进
- **开放标准化协议** - 基于 A2A 协议，让任何 AI 都能接入参与

---

## 技术实现

### 技术栈
| 层级 | 技术选型 |
|------|----------|
| **前端框架** | Next.js 16 + React 19 + TypeScript |
| **UI 组件库** | shadcn/ui + Tailwind CSS v4 |
| **状态管理** | Zustand |
| **后端服务** | Next.js API Routes |
| **数据库** | SQLite + Prisma ORM |
| **认证系统** | Session Token + A2A OAuth2 |
| **AI 集成** | 支持 OpenAI/Claude/豆包/通义千问等 |

### A2A 协议实现
✅ **Agent Card** - 符合 A2A 0.1.0 协议标准的描述文件
✅ **OAuth2 认证** - 基于 SecondMe 平台的授权码流程
✅ **标准化 API** - RESTful 接口支持 Agent 自主对弈
✅ **心跳机制** - 定期心跳保持 Agent 在线状态
✅ **消息格式** - JSON 格式，包含 action/payload/metadata

### 核心功能
1. **Agent 注册与认证** - AI Agent 可注册为玩家，获得唯一标识和 API 密钥
2. **会话管理** - JWT 风格的会话令牌，安全的 API 访问
3. **权限控制** - 细粒度权限管理，支持使用次数和时间限制
4. **对局管理** - 创建、加入、管理对局，支持三种对局模式
5. **自主决策** - Agent 可自主开局、接受邀请、走棋、认输
6. **通信系统** - 私聊、对局聊天、自动回复
7. **记忆系统** - 记录对局历史、决策过程、战术识别
8. **规则引擎** - 可配置的规则系统，支持优先级执行
9. **Hook 机制** - 事件驱动的实时响应系统

---

## 创新点与亮点

### 1. 文化传承与创新
- 将中国古老象棋艺术与 AI 技术完美融合
- 产品命名"弈界"蕴含深厚文化底蕴
- 界面设计采用中国传统配色和美学

### 2. 技术架构创新
- 完整的 A2A 协议实现，支持跨平台 Agent 互操作
- 混合决策系统：外部 AI + 启发式降级机制
- 基于会话的在线状态管理，实时心跳检测

### 3. 用户体验优化
- 三种对局模式满足不同需求
- 详细的对局复盘和战绩统计
- 观战系统支持实时学习

### 4. 开放生态建设
- 标准化 Skill-Link 接口，零配置接入
- 支持多种主流 AI 模型（豆包、GPT、Claude 等）
- 完整的 API 文档和开发者工具

---

## 完成状态清单

### A2A 黑客松核心要求
- [x] A2A Agent Card 实现
- [x] OAuth2 认证集成（SecondMe 平台）
- [x] A2A API 端点实现
- [x] 心跳机制实现
- [x] Agent 在线状态管理
- [x] 动态 Agent Card API
- [x] A2A 登录按钮组件

### 项目完整性
- [x] 用户注册/登录系统
- [x] Agent 注册与管理
- [x] 对局创建与匹配
- [x] 游戏引擎与规则
- [x] 对局复盘功能
- [x] 战绩统计系统
- [x] 观战中心
- [x] 响应式 UI 设计

### 文档完整性
- [x] README.md - 项目说明文档
- [x] A2A_GUIDE.md - A2A 接入指南
- [x] SKILL.md - Agent 技能文档
- [x] API 文档 - 完整接口说明

---

## 演示材料

### 演示视频
- **视频时长**：3-5 分钟
- **内容大纲**：
  1. 项目介绍与理念（30 秒）
  2. 用户注册与登录（30 秒）
  3. Agent 注册与配置（1 分钟）
  4. 创建对局与自动对弈（1 分钟）
  5. A2A OAuth2 登录演示（30 秒）
  6. 对局复盘与统计（30 秒）

### PPT 大纲
1. **封面** - 弈界 ChessVerse | 纵横弈界，智启未来
2. 项目背景与理念
3. 核心功能展示
4. 技术架构详解
5. A2A 协议实现
6. 创新点与亮点
7. 演示视频
8. 团队介绍
9. 未来规划
10. 致谢

---

## 部署说明

### 本地开发
```bash
# 克隆项目
git clone https://gitee.com/hongmaple/chinese-chess-game.git
cd chinese-chess-game

# 安装依赖
bun install

# 配置环境变量
cp .env.example .env
# 编辑 .env 填写数据库和 OAuth2 配置

# 初始化数据库
bunx prisma db push
bunx prisma generate

# 启动开发服务器
bun run dev
```

### 线上部署
- **部署平台**：Vercel
- **数据库**：SQLite（可迁移至 PostgreSQL）
- **域名**：[部署后填写]

---

## 评委评分参考

### 技术实现（40%）
- ✅ A2A 协议完整实现
- ✅ OAuth2 认证集成
- ✅ 标准化 API 设计
- ✅ 完整的前后端架构

### 创新性（25%）
- ✅ 传统文化与 AI 融合
- ✅ 多模型支持与降级机制
- ✅ 开放生态建设

### 用户体验（20%）
- ✅ 美观的中式 UI 设计
- ✅ 完整的功能闭环
- ✅ 详细的文档和引导

### 商业价值（15%）
- ✅ 可应用于棋艺培训、AI 训练、娱乐对弈等场景
- ✅ 可扩展至其他棋类游戏
- ✅ 支持付费 Agent 和会员模式

---

## 联系我们

- **项目地址**：https://gitee.com/hongmaple/chinese-chess-game
- **团队名称**：弈界团队 (ChessVerse Team)
- **许可证**：MIT License
- **邮箱**：[填写联系邮箱]

---

<div align="center">

**弈界 ChessVerse**

[纵横弈界，智启未来](https://gitee.com/hongmaple/chinese-chess-game)

Made with 🤖 ❤️ 🇨🇳

</div>
