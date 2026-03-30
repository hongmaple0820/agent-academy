# Project KB - 代码资产库

## 概述

本项目知识库（Project KB）是从现有项目中提取的可复用代码资产集合，包含代码片段、模块文档和配置模板。

## 目录结构

```
project-kb/
├── README.md                    # 本文件
├── code-assets/
│   ├── snippets/               # 代码片段
│   │   ├── 001-button-component.md
│   │   ├── 002-toast-notification.md
│   │   ├── 003-socket-hook.md
│   │   ├── 004-mobile-detection.md
│   │   ├── 005-modal-component.md
│   │   ├── 006-api-error-handler.md
│   │   ├── 007-classname-utils.md
│   │   ├── 008-date-formatter.md
│   │   ├── 009-array-utils.md
│   │   ├── 010-form-validation.md
│   │   ├── 011-local-storage-hook.md
│   │   └── 012-debounce-throttle.md
│   └── modules/                # 模块文档
│       ├── auth-module.md
│       ├── form-validation-module.md
│       └── notification-module.md
└── config-templates/           # 配置模板
    ├── project-init.md
    ├── env-config.md
    └── database-config.md
```

## 代码片段统计

**总计: 12 个代码片段**

### 按类别分布

| 类别 | 数量 | 片段 |
|------|------|------|
| UI 组件 | 4 | Button, Toast, Modal, Mobile Detection |
| 网络请求 | 2 | Socket Hook, API Error Handler |
| 数据处理 | 2 | Form Validation, Array Utils |
| 工具函数 | 4 | ClassName Utils, Date Formatter, LocalStorage Hook, Debounce/Throttle |

### 按语言分布

- **TypeScript**: 12 个
- **React/TSX**: 10 个

## 模块资产统计

**总计: 3 个模块**

| 模块 | 类型 | 复杂度 | 描述 |
|------|------|--------|------|
| Auth Module | 认证 | 高 | Cookie-based 会话 + OAuth2 集成 |
| Form Validation | 验证 | 中 | 类型安全的表单验证系统 |
| Notification | 通知 | 中 | 全局消息通知系统 |

## 配置模板统计

**总计: 3 个模板**

| 模板 | 描述 |
|------|------|
| Project Init | Next.js + TypeScript + Tailwind 项目初始化 |
| Env Config | 环境变量配置模板 |
| Database Config | Prisma + SQLite/PostgreSQL 配置 |

## 设计思路

### 代码片段设计原则

1. **单一职责**: 每个片段专注于解决一个具体问题
2. **类型安全**: 完整的 TypeScript 类型定义
3. **可复用性**: 不依赖特定业务逻辑
4. **文档完整**: 包含使用说明和示例

### 模块设计原则

1. **接口优先**: 先定义接口，再实现功能
2. **关注点分离**: 状态管理、UI 渲染、业务逻辑分离
3. **测试友好**: 提供完整的测试用例
4. **渐进增强**: 基础功能可用，高级功能可选

### 配置模板设计原则

1. **开箱即用**: 复制即可使用
2. **环境区分**: 开发/测试/生产环境配置
3. **安全优先**: 敏感信息使用环境变量
4. **可扩展**: 预留扩展点

## 提取来源

代码资产提取自以下项目：

1. **ChessVerse** (~/projects/ChessVerse)
   - 中国象棋在线对战平台
   - 技术栈: Next.js 14, TypeScript, Tailwind CSS, Socket.io, Prisma

2. **Skills System** (~/.openclaw/workspace/skills/)
   - OpenClaw 技能系统
   - 包含多个独立技能模块

## 使用方式

### 代码片段

1. 复制对应的 `.md` 文件中的代码
2. 根据项目需求调整导入路径
3. 安装必要的依赖

### 模块

1. 阅读模块文档了解接口定义
2. 复制核心实现代码
3. 根据项目调整数据模型
4. 运行测试用例验证

### 配置模板

1. 复制模板内容到项目对应位置
2. 修改环境变量值
3. 安装依赖并运行

## 遇到的问题

### 1. 项目访问问题

**问题**: chat-hub 项目目录不存在
**解决**: 仅从 ChessVerse 和 Skills 系统提取

### 2. 代码依赖分析

**问题**: 部分代码片段依赖特定库（如 Radix UI）
**解决**: 在文档中明确标注依赖项和安装命令

### 3. 类型定义完整性

**问题**: 提取的代码可能缺少上下文类型
**解决**: 补充完整的类型定义，确保代码可独立使用

### 4. 样式系统差异

**问题**: 不同项目使用不同的 Tailwind 配置
**解决**: 提供通用的样式类名，避免项目特定变量

## 未来扩展

- [ ] 添加更多代码片段（API 路由、中间件、测试工具等）
- [ ] 创建 CLI 工具自动生成代码片段
- [ ] 添加更多模块（权限管理、文件上传、支付等）
- [ ] 支持多框架（Vue、Svelte 等）
- [ ] 添加代码片段搜索功能

## 贡献

如需添加新的代码资产：

1. 遵循现有的文件命名和格式规范
2. 包含完整的元数据（ID、语言、分类、标签）
3. 提供使用说明和示例
4. 添加测试用例（模块级别）

---

*最后更新: 2026-03-27*
