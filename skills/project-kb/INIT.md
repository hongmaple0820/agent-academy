# APKS 智能加载系统 - 初始化配置

## 简介

APKS (Agent Project Knowledge System) 智能加载系统是一套用于 Agent 启动时自动加载项目画像、根据任务推荐代码的工具集。

## 组件说明

### 1. 项目画像加载器 (`load-project-profile.sh`)

自动检测项目类型并加载对应的项目画像，设置相关环境变量。

**功能:**
- 检测当前项目类型 (Node.js, Python, Go, Rust, Java 等)
- 自动加载对应的项目画像配置
- 设置环境变量供其他脚本使用

### 2. 智能推荐系统 (`recommend-snippets.sh`)

根据任务类型和文件上下文推荐代码片段。

**功能:**
- 根据任务描述推荐代码片段
- 根据文件类型推荐相关代码
- 显示推荐理由

### 3. 上下文感知工具 (`context-aware-insert.sh`)

分析代码上下文并智能插入代码。

**功能:**
- 分析当前代码上下文
- 自动调整导入路径
- 插入代码并适配项目风格

## 安装配置

### 1. 添加执行权限

```bash
chmod +x skills/project-kb/scripts/*.sh
```

### 2. 配置环境变量

在 `~/.bashrc` 或 `~/.zshrc` 中添加:

```bash
# APKS 智能加载系统配置
export APKS_ROOT="$HOME/.openclaw/workspace/skills/project-kb"
export PATH="$APKS_ROOT/scripts:$PATH"

# 可选: 自定义路径
export APKS_PROFILES_DIR="$APKS_ROOT/profiles"
export APKS_SNIPPETS_DIR="$APKS_ROOT/snippets"
```

### 3. 自动加载配置

在 Shell 配置文件中添加自动加载:

```bash
# APKS 自动加载项目画像
if [[ -f "$APKS_ROOT/scripts/load-project-profile.sh" ]]; then
    # 进入目录时自动加载项目画像
    cd() {
        builtin cd "$@" && {
            if [[ -f "$APKS_ROOT/scripts/load-project-profile.sh" ]]; then
                source "$APKS_ROOT/scripts/load-project-profile.sh" --auto 2>/dev/null || true
            fi
        }
    }
fi
```

## 使用方法

### 基础用法

#### 1. 加载项目画像

```bash
# 自动检测并加载当前项目画像
source load-project-profile.sh

# 指定项目路径
source load-project-profile.sh /path/to/project

# 调试模式
DEBUG=true source load-project-profile.sh
```

#### 2. 获取代码推荐

```bash
# 根据任务推荐代码
recommend-snippets.sh --task "创建 API 端点"

# 根据文件上下文推荐
recommend-snippets.sh --context src/app.ts

# 列出可用类别
recommend-snippets.sh --list

# 初始化代码片段库
recommend-snippets.sh --init
```

#### 3. 上下文感知插入

```bash
# 从文件插入代码
context-aware-insert.sh --file snippet.ts --target src/app.ts

# 直接插入代码
context-aware-insert.sh --target src/app.ts "console.log('hello');"

# 干运行模式
context-aware-insert.sh --file utils.ts --target app.ts --dry-run
```

### 高级用法

#### 组合使用

```bash
# 加载项目画像后推荐代码
source load-project-profile.sh && recommend-snippets.sh --task "数据库查询"

# 完整工作流
source load-project-profile.sh
recommend-snippets.sh --task "错误处理" > /tmp/snippet.txt
context-aware-insert.sh --file /tmp/snippet.txt --target src/app.ts --position end
```

#### 在脚本中使用

```bash
#!/bin/bash
# 加载 APKS
source "$APKS_ROOT/scripts/load-project-profile.sh"

# 检查项目类型
if [[ "$APKS_PROJECT_TYPE" == "nodejs" ]]; then
    echo "Node.js 项目 detected"
    # 执行 Node.js 相关操作
fi
```

## 环境变量

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| `APKS_ROOT` | APKS 根目录 | `~/.openclaw/workspace/skills/project-kb` |
| `APKS_PROFILES_DIR` | 项目画像目录 | `$APKS_ROOT/profiles` |
| `APKS_SNIPPETS_DIR` | 代码片段目录 | `$APKS_ROOT/snippets` |
| `APKS_PROJECT_TYPE` | 当前项目类型 | 自动检测 |
| `APKS_PROJECT_ROOT` | 项目根目录 | 自动检测 |
| `APKS_PROFILE_LOADED` | 画像是否已加载 | `true`/`false` |
| `DEBUG` | 调试模式 | `false` |

## 项目画像格式

项目画像使用 JSON 格式，示例:

```json
{
  "name": "My Node.js Project",
  "type": "nodejs",
  "language": "typescript",
  "framework": "express",
  "version": "1.0.0",
  "description": "项目描述",
  "scripts": {
    "dev": "npm run dev",
    "build": "npm run build",
    "test": "npm test"
  },
  "dependencies": {
    "express": "^4.18.0",
    "typescript": "^5.0.0"
  },
  "conventions": {
    "indent": "spaces:2",
    "quotes": "single",
    "semicolon": true
  }
}
```

## 代码片段格式

代码片段使用 Markdown 格式，示例:

```markdown
## API 端点模板

### Express.js
```javascript
app.get('/api/resource', async (req, res) => {
  try {
    const data = await getResource();
    res.json({ success: true, data });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});
```

### FastAPI
```python
@app.get("/api/resource")
async def get_resource():
    try:
        data = await get_resource()
        return {"success": True, "data": data}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
```
```

## 调试

启用调试模式查看详细信息:

```bash
DEBUG=true ./load-project-profile.sh
DEBUG=true ./recommend-snippets.sh --task "api"
DEBUG=true ./context-aware-insert.sh --file snippet.ts --target app.ts
```

## 故障排除

### 常见问题

1. **项目类型检测失败**
   - 检查项目根目录是否有特征文件 (package.json, requirements.txt 等)
   - 手动设置 `APKS_PROJECT_TYPE`

2. **代码片段未找到**
   - 运行 `recommend-snippets.sh --init` 初始化示例库
   - 检查 `APKS_SNIPPETS_DIR` 路径

3. **权限问题**
   - 确保脚本有执行权限: `chmod +x *.sh`

## 扩展开发

### 添加新的项目类型检测

编辑 `load-project-profile.sh`，在 `detect_project_type` 函数中添加:

```bash
# 新项目类型
if [[ -f "$project_root/feature-file" ]]; then
    detected_type="newtype"
    confidence=80
fi
```

### 添加新的代码片段

在 `snippets/` 目录创建:

```bash
mkdir -p snippets/nodejs
cat > snippets/nodejs/api.md << 'EOF'
## API 模板
...
EOF
```

## 更新日志

### v1.0.0
- 初始版本发布
- 支持项目类型自动检测
- 支持代码片段推荐
- 支持上下文感知插入

## 许可证

MIT
