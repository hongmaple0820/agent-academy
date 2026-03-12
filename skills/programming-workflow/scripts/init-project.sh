#!/bin/bash
# init-project.sh - 初始化新项目工作流

set -e

PROJECT_NAME=${1:-"my-project"}
PROJECT_DIR="${HOME}/.openclaw/projects/${PROJECT_NAME}"

echo "🚀 初始化项目: ${PROJECT_NAME}"

# 创建项目目录
mkdir -p "${PROJECT_DIR}"
mkdir -p "${PROJECT_DIR}/docs"
mkdir -p "${PROJECT_DIR}/memory"
mkdir -p "${PROJECT_DIR}/tasks"

# 创建任务看板
cat > "${PROJECT_DIR}/tasks/${PROJECT_NAME}.md" << 'EOF'
# 任务看板

## 📋 待办
- [ ] 需求分析
- [ ] 产品设计
- [ ] 技术方案

## 🔄 进行中
(暂无)

## ✅ 完成
(暂无)

## ❌ 阻塞
(暂无)
EOF

# 创建每日日志模板
TODAY=$(date +%Y-%m-%d)
cat > "${PROJECT_DIR}/memory/${TODAY}.md" << EOF
# ${TODAY} 今日记录

## 完成任务
- [x] 项目初始化

## 进行中
(暂无)

## 明日计划
- [ ] 开始需求分析
EOF

# 创建 README
cat > "${PROJECT_DIR}/README.md" << EOF
# ${PROJECT_NAME}

> 创建时间: $(date +%Y-%m-%d)

## 项目描述
(待补充)

## 工作流
本项目采用 programming-workflow 技能管理

## 快速开始
(待补充)
EOF

# 初始化 Git
cd "${PROJECT_DIR}"
git init
git add .
git commit -m "init: project initialized"

echo "✅ 项目初始化完成: ${PROJECT_DIR}"
echo ""
echo "📁 目录结构:"
echo "  ${PROJECT_DIR}/"
echo "  ├── docs/          # 文档"
echo "  ├── memory/        # 每日日志"
echo "  ├── tasks/         # 任务看板"
echo "  └── README.md      # 项目说明"
echo ""
echo "📖 下一步:"
echo "  1. cd ${PROJECT_DIR}"
echo "  2. 使用 brainstorming 探索需求"
echo "  3. 使用 create-prd 编写 PRD"