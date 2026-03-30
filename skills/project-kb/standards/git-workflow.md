# Git 工作流

> 规范 Git 使用流程，确保代码质量和协作效率。

---

## 🌿 分支模型

### 分支类型

```
main                    # 生产分支，始终可部署
├── develop             # 开发分支，集成测试通过
│   ├── feature/auth    # 功能分支
│   ├── feature/api     # 功能分支
│   └── bugfix/login    # 修复分支
├── release/v1.2.0      # 发布分支
└── hotfix/security     # 热修复分支
```

### 主分支

| 分支 | 用途 | 保护级别 |
|------|------|----------|
| `main` | 生产环境代码 | 🔴 严格保护 |
| `develop` | 开发集成代码 | 🟡 保护 |

### 辅助分支

| 分支前缀 | 用途 | 来源 | 合并目标 |
|----------|------|------|----------|
| `feature/*` | 新功能开发 | develop | develop |
| `bugfix/*` | 非紧急 Bug 修复 | develop | develop |
| `hotfix/*` | 紧急生产修复 | main | main + develop |
| `release/*` | 版本发布准备 | develop | main + develop |

### 分支命名规范

```
feature/user-authentication
feature/api-rate-limiting
bugfix/login-redirect-issue
hotfix/security-patch-2024
release/v2.1.0
```

命名规则：
- 使用 **kebab-case**（短横线连接）
- 简洁描述分支目的
- 避免使用个人名称或日期

---

## 📝 提交规范

### 提交信息格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

### 提交类型

| 类型 | 说明 | 示例 |
|------|------|------|
| `feat` | 新功能 | `feat(auth): 添加用户登录功能` |
| `fix` | Bug 修复 | `fix(api): 修复空指针异常` |
| `docs` | 文档更新 | `docs(readme): 更新安装说明` |
| `style` | 代码格式 | `style: 格式化缩进` |
| `refactor` | 重构 | `refactor(service): 优化查询逻辑` |
| `perf` | 性能优化 | `perf(db): 添加索引提升查询速度` |
| `test` | 测试相关 | `test(auth): 添加登录单元测试` |
| `chore` | 构建/工具 | `chore(deps): 更新依赖版本` |
| `ci` | CI/CD 配置 | `ci: 添加自动化测试工作流` |
| `revert` | 回滚提交 | `revert: 撤销上次的修改` |

### 提交信息示例

```
feat(auth): 添加 JWT 认证中间件

- 实现 token 生成和验证
- 添加登录/登出接口
- 集成 Redis 存储会话

Closes #123
```

```
fix(api): 修复分页参数解析错误

当 pageSize 为字符串时会导致 NaN，
现在统一转换为数字类型。

Fixes #456
```

### 提交规范检查

- **subject** 不超过 50 个字符
- **subject** 首字母小写，不以句号结尾
- **body** 每行不超过 72 个字符
- 使用 **现在时态**（"添加" 而非 "添加了"）
- 说明"为什么"而不是"做了什么"

---

## 🔀 PR 流程

### 创建 PR

1. **从最新 develop 创建分支**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/my-feature
   ```

2. **开发并提交代码**
   ```bash
   git add .
   git commit -m "feat(scope): 描述"
   git push origin feature/my-feature
   ```

3. **创建 Pull Request**
   - 目标分支：develop
   - 填写 PR 模板
   - 关联相关 Issue

### PR 模板

```markdown
## 描述
简要描述本次变更的内容和目的。

## 变更类型
- [ ] 新功能
- [ ] Bug 修复
- [ ] 文档更新
- [ ] 性能优化
- [ ] 代码重构

## 测试
- [ ] 单元测试通过
- [ ] 集成测试通过
- [ ] 手动测试通过

## 检查清单
- [ ] 代码遵循项目规范
- [ ] 没有引入新的警告
- [ ] 文档已更新

## 关联 Issue
Closes #123
```

### PR 审查流程

```
创建 PR → 自动检查 → 代码审查 → 修改反馈 → 批准合并
    ↑                                          ↓
    └──────────── 如有问题返回修改 ←───────────┘
```

### 合并策略

| 策略 | 适用场景 | 说明 |
|------|----------|------|
| **Squash Merge** | 功能分支 | 压缩为单个提交，历史整洁 |
| **Merge Commit** | 发布分支 | 保留完整历史 |
| **Rebase** | 个人分支 | 线性历史，需强制推送 |

---

## 👀 代码审查清单

### 审查者检查项

#### 功能性

- [ ] 代码实现了 PR 描述的功能
- [ ] 边界情况已处理
- [ ] 错误处理完善
- [ ] 没有明显的逻辑错误

#### 代码质量

- [ ] 遵循项目编码规范
- [ ] 命名清晰有意义
- [ ] 函数/类职责单一
- [ ] 没有重复代码
- [ ] 复杂度在合理范围

#### 测试

- [ ] 新功能有对应的测试
- [ ] 测试覆盖边界情况
- [ ] 所有测试通过
- [ ] 没有破坏现有测试

#### 文档

- [ ] 公共 API 有文档
- [ ] 复杂逻辑有注释
- [ ] README 已更新（如需要）

#### 性能与安全

- [ ] 没有明显的性能问题
- [ ] 没有安全漏洞
- [ ] 没有敏感信息泄露

### 审查反馈规范

#### 评论级别

| 级别 | 标识 | 说明 | 示例 |
|------|------|------|------|
| **阻塞** | 🔴 | 必须修改 | "这里存在空指针风险" |
| **建议** | 🟡 | 建议修改 | "可以考虑使用常量代替魔法数字" |
| **疑问** | 🟢 | 需要确认 | "这个逻辑是否考虑了并发情况？" |
| **赞赏** | 👍 | 做得好的地方 | "这个实现很优雅！" |

#### 反馈示例

```
🔴 阻塞：这里应该添加 null 检查，否则可能抛出异常

🟡 建议：可以将这个逻辑提取为一个单独的函数，提高可读性

🟢 疑问：这个方法是否线程安全？

👍 这个错误处理很完善！
```

### 作者响应规范

- 对每条评论进行回复或修改
- 修改后回复 "已修复" 或 "已修改"
- 如有不同意见，说明理由
- 保持专业和尊重

---

## 🚀 发布流程

### 版本号规范（SemVer）

```
主版本.次版本.修订号
 1.   2.    3
```

| 版本变化 | 说明 | 示例 |
|----------|------|------|
| 主版本 | 不兼容的 API 修改 | `1.x.x` → `2.0.0` |
| 次版本 | 向下兼容的功能添加 | `1.2.x` → `1.3.0` |
| 修订号 | 向下兼容的问题修复 | `1.2.3` → `1.2.4` |

### 发布步骤

1. **创建发布分支**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b release/v1.2.0
   ```

2. **版本更新**
   - 更新版本号
   - 更新 CHANGELOG
   - 修复发现的问题

3. **合并到 main**
   ```bash
   git checkout main
   git merge release/v1.2.0
   git tag -a v1.2.0 -m "Release version 1.2.0"
   git push origin main --tags
   ```

4. **合并回 develop**
   ```bash
   git checkout develop
   git merge release/v1.2.0
   git push origin develop
   ```

### 热修复流程

```
main (v1.2.0) → hotfix/critical-bug → main (v1.2.1)
                     ↓
                  develop
```

1. 从 main 创建 hotfix 分支
2. 修复问题并测试
3. 合并到 main 并打标签
4. 同时合并到 develop

---

## 🛠️ 常用命令速查

### 分支操作

```bash
# 查看分支
git branch              # 本地分支
git branch -r           # 远程分支
git branch -a           # 所有分支

# 创建分支
git checkout -b feature/xxx develop

# 切换分支
git checkout feature/xxx

# 删除分支
git branch -d feature/xxx      # 已合并
git branch -D feature/xxx      # 强制删除

# 推送分支
git push -u origin feature/xxx
```

### 提交操作

```bash
# 添加文件
git add filename        # 添加指定文件
git add .               # 添加所有变更

# 提交
git commit -m "message"
git commit -am "message"  # 添加并提交

# 修改提交
git commit --amend      # 修改最后一次提交
```

### 同步操作

```bash
# 拉取更新
git pull origin develop

# 推送提交
git push origin feature/xxx

# 获取远程分支
git fetch origin

# 变基
git rebase develop
```

---

*工作流版本: v1.0*
*最后更新: 2026-03-27*
