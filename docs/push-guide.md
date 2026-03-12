# 多平台推送指南

## 📋 当前远程仓库配置

```bash
origin  -> https://gitee.com/hongmaple/agent-academy.git (已推送)
github  -> https://github.com/hongmaple0820/agent-academy.git
gitcode -> https://gitcode.com/maple168/agent-academy.git
```

## 🚀 推送步骤

### 方式一：使用 SSH（推荐）

如果你已配置 SSH 密钥：

```bash
cd e:/project/openclaw/agent-academy

# 更新远程地址为 SSH
git remote set-url github git@github.com:hongmaple0820/agent-academy.git
git remote set-url gitcode git@gitcode.com:maple168/agent-academy.git

# 推送到 GitHub
git push github master

# 推送到 GitCode
git push gitcode master
```

### 方式二：使用 Personal Access Token

#### GitHub

1. 生成 Token：GitHub -> Settings -> Developer settings -> Personal access tokens -> Generate new token
2. 选择权限：`repo` (全部)
3. 推送：

```bash
cd e:/project/openclaw/agent-academy

# 使用 Token 推送
git push https://<YOUR_TOKEN>@github.com/hongmaple0820/agent-academy.git master
```

#### GitCode

1. 生成 Token：GitCode -> 设置 -> 访问令牌 -> 新建令牌
2. 推送：

```bash
git push https://<YOUR_TOKEN>@gitcode.com/maple168/agent-academy.git master
```

### 方式三：使用 Git Credential Manager

```bash
# Windows 会弹出登录对话框，输入用户名和密码/Token
cd e:/project/openclaw/agent-academy

git push github master
# 在弹出对话框中输入 GitHub 用户名和 Personal Access Token

git push gitcode master
# 在弹出对话框中输入 GitCode 用户名和密码/Token
```

### 方式四：一键推送所有平台

```bash
# 推送到所有远程仓库
git push origin master && git push github master && git push gitcode master
```

## 📊 推送状态

| 平台 | 地址 | 状态 |
|------|------|------|
| Gitee | https://gitee.com/hongmaple/agent-academy | ✅ 已推送 |
| GitHub | https://github.com/hongmaple0820/agent-academy | ⏳ 待推送 |
| GitCode | https://gitcode.com/maple168/agent-academy | ⏳ 待推送 |

## ⚠️ 注意事项

1. **首次推送**：可能需要 `-u` 参数设置上游分支
   ```bash
   git push -u github master
   git push -u gitcode master
   ```

2. **强制推送**（谨慎使用）：
   ```bash
   git push github master --force
   git push gitcode master --force
   ```

3. **推送所有分支**：
   ```bash
   git push github --all
   git push gitcode --all
   ```

4. **推送标签**：
   ```bash
   git push github --tags
   git push gitcode --tags
   ```

## 🔧 常见问题

### Q: 推送时提示 "fatal: could not read Username"

**A**: 需要配置认证信息：
- 使用 SSH 密钥认证
- 或使用 Personal Access Token
- 或配置 Git Credential Manager

### Q: 推送时提示 "fatal: repository not found"

**A**: 请确认：
- 仓库已在对应平台创建
- 远程地址正确
- 有推送权限

### Q: 如何查看推送状态？

**A**: 
```bash
# 查看远程仓库信息
git remote -v

# 查看分支追踪关系
git branch -vv
```

---

**创建时间**：2026-03-13
