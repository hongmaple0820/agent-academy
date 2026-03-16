# Git 工作流管理技能使用示例

> 使用 `git-workflow-management` 技能管理 Git 分支和提交

## 📋 场景说明

**场景**: 分支管理、代码提交、合并冲突解决
**技能**: git-workflow-management
**触发**: 说"git xxx"、"创建分支"、"合并代码"、"解决冲突"

---

## 💬 完整对话示例

### 示例 1: 创建功能分支

```
用户：我要开发 MCP 服务器功能，帮我创建分支。

小熊：好的！使用 Git 工作流创建功能分支。🐻

🌿 **创建分支**
```bash
# 切换到主分支并更新
git checkout master
git pull origin master

# 创建功能分支
git checkout -b feat-mcp-server

# 验证分支
git branch
```

✅ 分支创建成功！

**分支命名**: `feat-mcp-server`
**命名规范**: `feat-<功能名>`

**下一步**:
1. 开始开发功能
2. 完成后提交代码
3. 创建 Pull Request

需要我帮你初始化项目结构吗？
```

---

### 示例 2: 提交代码

```
用户：我完成了 MCP 服务器的基础功能，帮我提交。

小熊：好的！先检查一下变更。🐻

📊 **检查状态**
```bash
git status
```

**变更文件**:
- M src/mcp/server.js      (新增 MCP 服务器)
- M src/mcp/tools.js       (新增 Tool 定义)
- A tests/mcp.test.js      (新增测试)
- M docs/mcp-guide.md     (更新文档)

**提交建议**:
```bash
# 添加变更
git add src/mcp/server.js src/mcp/tools.js
git commit -m "feat(mcp): 实现 MCP 服务器基础功能

- 创建 Express 服务器
- 实现 Tool 注册机制
- 添加配置管理
- 编写单元测试

Closes: #45"

git add tests/mcp.test.js
git commit -m "test(mcp): 添加 MCP 服务器测试

- 单元测试覆盖核心功能
- 集成测试验证 Tool 调用
- 测试覆盖率 85%"

git add docs/mcp-guide.md
git commit -m "docs(mcp): 更新 MCP 使用指南

- 添加服务器搭建步骤
- 补充 Tool 开发示例"
```

✅ 提交完成！共 3 个提交。

需要我推送到远程仓库吗？
```

---

### 示例 3: 创建 Pull Request

```
用户：功能开发完了，帮我创建 PR。

小熊：好的！先推送分支到远程。🐻

🚀 **推送分支**
```bash
git push -u origin feat-mcp-server
```

✅ 推送成功！

📝 **创建 PR**
```bash
gh pr create \
  --title "feat: 实现 MCP 服务器基础功能" \
  --body "## 变更说明

### 新增功能
- ✅ MCP 服务器核心实现
- ✅ Tool 注册和调用机制
- ✅ 配置管理系统

### 测试覆盖
- ✅ 单元测试 (85% 覆盖率)
- ✅ 集成测试
- ✅ 端到端测试

### 文档更新
- ✅ MCP 使用指南
- ✅ API 文档
- ✅ 部署说明

## 测试验证
- [x] 本地测试通过
- [x] CI/CD 通过
- [x] 手动验证完成

## 相关 Issue
Closes: #45" \
  --base master \
  --head feat-mcp-server
```

✅ PR 创建成功！

**PR 链接**: https://github.com/your-org/repo/pull/123

**下一步**:
1. 等待 CI/CD 检查
2. 请求代码审查
3. 根据反馈修改

需要我通知团队审查吗？
```

---

### 示例 4: 解决合并冲突

```
用户：我的 PR 有合并冲突，怎么办？

小熊：让我帮你解决冲突。🐻

🔍 **检查冲突**
```bash
# 切换到主分支
git checkout master
git pull origin master

# 切换到功能分支
git checkout feat-mcp-server

# 尝试合并
git merge master
```

**冲突文件**:
```
CONFLICT (content): Merge conflict in src/mcp/server.js
CONFLICT (content): Merge conflict in docs/mcp-guide.md
```

📝 **解决冲突 - src/mcp/server.js**

打开文件，找到冲突标记：
```javascript
<<<<<<< HEAD
// 你的修改
const server = express();
server.use(cors());
=======
// master 分支的修改
const server = express();
server.use(helmet());
>>>>>>> master
```

**解决后**:
```javascript
// 合并双方的修改
const server = express();
server.use(cors());
server.use(helmet());  // 保留 master 的安全中间件
```

**解决步骤**:
```bash
# 1. 编辑文件解决冲突
vim src/mcp/server.js

# 2. 标记冲突已解决
git add src/mcp/server.js

# 3. 继续合并
git merge --continue

# 4. 完成合并提交
git commit -m "Merge master into feat-mcp-server

Resolved conflicts in:
- src/mcp/server.js (合并 cors 和 helmet)
- docs/mcp-guide.md (更新部署步骤)"
```

✅ 冲突解决完成！

**验证**:
```bash
git status  # 确保工作区干净
git log     # 查看合并提交
```

需要我重新推送并更新 PR 吗？
```

---

### 示例 5: 完成功能分支

```
用户：PR 已经合并了，帮我清理分支。

小熊：好的！完成分支清理流程。🐻

🧹 **清理分支**
```bash
# 切换回主分支
git checkout master

# 更新主分支
git pull origin master

# 删除本地分支
git branch -d feat-mcp-server

# 删除远程分支
git push origin --delete feat-mcp-server

# 验证
git branch -a
```

✅ 分支清理完成！

📊 **完成检查清单**
- [x] PR 已合并到 master
- [x] 本地分支已删除
- [x] 远程分支已删除
- [x] 主分支已更新

**下一步**:
- 开始新功能开发
- 或切换到其他任务

---

## 🔧 Git 工作流规范

### 分支命名

| 类型 | 前缀 | 示例 |
|------|------|------|
| 功能 | feat- | feat-mcp-server |
| 修复 | fix- | fix-redis-bug |
| 文档 | docs- | docs-api-guide |
| 重构 | refactor- | refactor-auth |
| 测试 | test- | test-user-login |

### 提交规范

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Type 类型**:
- feat: 新功能
- fix: Bug 修复
- docs: 文档更新
- style: 代码格式
- refactor: 重构
- test: 测试
- chore: 构建/工具

**示例**:
```
feat(mcp): 实现 MCP 服务器

- 创建 Express 服务器
- 实现 Tool 注册机制

Closes: #45
```

### 合并策略

```
master (主分支)
  ↑
  ├── feat-mcp-server (功能分支)
  ├── fix-redis-bug (修复分支)
  └── docs-api-guide (文档分支)
```

**规则**:
- 功能分支从 master 创建
- 开发完成后 PR 到 master
- 至少 1 人审查
- CI/CD 必须通过

---

## 💡 最佳实践

### 1. 小步提交
```
❌ 一次提交 1000 行代码
✅ 多次小提交，每次一个功能点
```

### 2. 原子提交
```
❌ 混入无关的修改
✅ 每个提交只做一件事
```

### 3. 及时同步
```
❌ 开发一周不 pull
✅ 每天 pull 远程更新
```

### 4. 清理分支
```
❌ 保留已合并的分支
✅ 合并后立即删除
```

---

## 🔗 相关技能

- `requesting-code-review` - 代码审查
- `test-driven-development` - 测试驱动开发
- `deploying-applications` - 应用部署
- `programming-workflow` - 编程工作流

---

*示例版本：v1.0*
*更新时间：2026-03-14*
