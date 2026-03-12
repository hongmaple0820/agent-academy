# OpenClaw 官方技能注册表

> 仅记录安装方法，不存储完整代码

---

## mcporter
- **功能**：MCP 服务器管理工具
- **类型**：CLI 工具
- **安装**：
  ```bash
  npm install -g mcporter
  ```
- **配置**：`~/.openclaw/workspace/config/mcporter.json`
- **文档**：http://mcporter.dev
- **常用命令**：
  ```bash
  mcporter list                    # 列出所有 MCP 服务器
  mcporter list <server> --schema  # 查看服务器工具
  mcporter call <server.tool>      # 调用工具
  ```

---

## weather
- **功能**：天气查询
- **类型**：内置技能
- **安装**：无需安装（OpenClaw 内置）
- **文档**：`~/.openclaw/workspace/skills/weather/SKILL.md`
- **使用**：
  ```bash
  # 在对话中直接询问
  "今天东莞的天气怎么样？"
  ```

---

## github
- **功能**：GitHub 操作（issues、PRs、CI runs）
- **类型**：内置技能
- **依赖**：需要 `gh` CLI
- **安装**：
  ```bash
  # Ubuntu/Debian
  sudo apt install gh
  
  # 或通过官方脚本
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
    sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
    sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt update
  sudo apt install gh
  
  # 认证
  gh auth login
  ```
- **文档**：`~/.openclaw/workspace/skills/github/SKILL.md`
- **使用**：
  ```bash
  gh issue list
  gh pr create
  gh run list
  ```

---

## healthcheck
- **功能**：主机安全加固和风险检查
- **类型**：内置技能
- **安装**：无需安装（OpenClaw 内置）
- **文档**：`~/.openclaw/workspace/skills/healthcheck/SKILL.md`
- **使用**：
  ```bash
  # 在对话中请求安全审计
  "检查系统安全状态"
  ```

---

## tmux
- **功能**：远程控制 tmux 会话
- **类型**：内置技能
- **依赖**：需要 `tmux`
- **安装**：
  ```bash
  sudo apt install tmux
  ```
- **文档**：`~/.openclaw/workspace/skills/tmux/SKILL.md`

---

## coding-agent
- **功能**：运行 Codex CLI、Claude Code 等编程助手
- **类型**：内置技能
- **安装**：无需安装（OpenClaw 内置）
- **文档**：`~/.openclaw/workspace/skills/coding-agent/SKILL.md`

---

## 其他内置技能

OpenClaw 还有更多内置技能，可通过以下命令查看：

```bash
openclaw skills list
```


```bash
ls ~/.openclaw/workspace/skills/
```

---

*来源: OpenClaw 内置技能*  
*最后更新: 2026-02-15 03:43*
