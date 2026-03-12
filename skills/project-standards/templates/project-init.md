# 项目初始化模板

> 使用此模板创建符合规范的新项目

## 标准目录创建

```bash
#!/bin/bash
# init-project-structure.sh

PROJECT_NAME=${1:-"my-project"}

mkdir -p "$PROJECT_NAME"/{src/{components,hooks,utils,services,types,styles},tests,scripts/{sql,build,deploy,test},temp/scripts,docs/{open,internal,dev,plans},config,public}

echo "✅ 项目结构已创建: $PROJECT_NAME"
```

## README.md 模板

```markdown
# 项目名称

> 一句话描述

## 快速开始

\`\`\`bash
npm install
npm run dev
\`\`\`

## 项目结构

\`\`\`
├── src/          # 源代码
├── tests/        # 测试
├── scripts/      # 脚本
├── docs/         # 文档
└── config/       # 配置
\`\`\`

## 文档

- [用户指南](docs/open/)
- [开发文档](docs/internal/)

## License

MIT
```

## .gitignore 模板

```gitignore
# Dependencies
node_modules/

# Build
dist/
build/
.next/

# Environment
.env
.env.local

# IDE
.vscode/
.idea/

# Logs
*.log

# Temp
temp/

# Coverage
coverage/
```

## tsconfig.json 模板

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "lib": ["ES2022", "DOM"],
    "moduleResolution": "bundler",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["src/*"]
    }
  },
  "include": ["src/**/*", "tests/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

## 文档头部模板

```markdown
# 文档标题

**版本号**: v1.0.0
**最后更新**: YYYY-MM-DD
**状态**: 草稿
**作者**: AI Assistant

---

## 概述

<!-- 文档内容 -->
```