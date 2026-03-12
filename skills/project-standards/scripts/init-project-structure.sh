#!/bin/bash
# init-project-structure.sh - 创建符合规范的项目目录结构

set -e

PROJECT_NAME=${1:-"my-project"}
PROJECT_DIR="${PROJECT_NAME}"

echo "🚀 创建项目: $PROJECT_NAME"
echo ""

# 创建目录结构
mkdir -p "$PROJECT_DIR"/{src/{components,hooks,utils,services,types,styles},tests,scripts/{sql,build,deploy,test},temp/scripts,docs/{open,internal,dev,plans},config,public}

# 创建 README
cat > "$PROJECT_DIR/README.md" << 'EOF'
# 项目名称

> 一句话描述

## 快速开始

```bash
npm install
npm run dev
```

## 项目结构

```
├── src/          # 源代码
│   ├── components/
│   ├── hooks/
│   ├── utils/
│   ├── services/
│   ├── types/
│   └── styles/
├── tests/        # 测试
├── scripts/      # 脚本
│   ├── sql/
│   ├── build/
│   ├── deploy/
│   └── test/
├── docs/         # 文档
│   ├── open/      # 用户文档
│   ├── internal/  # 开发文档
│   ├── dev/       # 开发笔记
│   └── plans/     # 计划文档
├── config/       # 配置
├── public/       # 静态资源
└── temp/         # 临时文件（不提交）
```

## 文档

- [用户指南](docs/open/)
- [开发文档](docs/internal/)

## License

MIT
EOF

# 创建 .gitignore
cat > "$PROJECT_DIR/.gitignore" << 'EOF'
# Dependencies
node_modules/

# Build
dist/
build/
.next/

# Environment
.env
.env.local
.env.*.local

# IDE
.vscode/
.idea/

# Logs
*.log
logs/

# Temp
temp/
*.tmp

# Coverage
coverage/

# OS
.DS_Store
Thumbs.db
EOF

# 创建初始文档
cat > "$PROJECT_DIR/docs/open/README.md" << 'EOF'
# 用户文档

**版本号**: v1.0.0
**最后更新**: '"$(date +%Y-%m-%d)"'
**状态**: 草稿

---

## 概述

（待补充）
EOF

cat > "$PROJECT_DIR/docs/internal/README.md" << 'EOF'
# 开发文档

**版本号**: v1.0.0
**最后更新**: '"$(date +%Y-%m-%d)"'
**状态**: 草稿

---

## 架构设计

（待补充）
EOF

cat > "$PROJECT_DIR/docs/plans/ROADMAP.md" << 'EOF'
# 项目路线图

**版本号**: v1.0.0
**最后更新**: '"$(date +%Y-%m-%d)"'

---

## v1.0.0

- [ ] 核心功能

## v1.1.0

- [ ] 增强功能

## v2.0.0

- [ ] 重大更新
EOF

echo ""
echo "✅ 项目结构已创建: $PROJECT_DIR"
echo ""
echo "📁 目录结构:"
echo "   $PROJECT_DIR/"
echo "   ├── src/           # 源代码"
echo "   ├── tests/         # 测试"
echo "   ├── scripts/       # 脚本"
echo "   ├── docs/          # 文档"
echo "   ├── config/        # 配置"
echo "   ├── public/        # 静态资源"
echo "   └── temp/          # 临时文件（不提交）"
echo ""
echo "📖 下一步:"
echo "   1. cd $PROJECT_DIR"
echo "   2. npm init -y"
echo "   3. 开始开发"