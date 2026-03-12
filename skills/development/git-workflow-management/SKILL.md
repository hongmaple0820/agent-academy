# Git Workflow Management

> 版本：1.0.0
> 更新时间：2026-03-13
> 分类：开发与编程类

## 📋 技能概述

这是一个综合性的 Git 工作流管理技能，提供：
- 📊 代码统计分析
- ✅ 提交规范检查
- 🔍 代码审查流程
- 🤖 自动化 CI/CD 集成
- 📈 定期统计报告

## 🎯 核心功能

### 1. Git 提交统计分析

#### 1.1 提交历史统计

```bash
# 查看最近 N 次提交统计
git log --oneline -N

# 按作者统计提交数量
git shortlog -sn --all

# 按时间段统计
git log --since="2026-01-01" --until="2026-03-13" --oneline | wc -l

# 查看代码变更统计
git log --author="username" --pretty=tformat: --numstat | awk '{add+=$1; del+=$2} END {print "added:", add, "deleted:", del}'
```

#### 1.2 文件变更统计

```bash
# 统计各文件变更次数
git log --pretty=format: --name-only | sort | uniq -c | sort -rg | head -20

# 统计代码行数变化
git log --shortstat --oneline | grep -E "fil(e|es) changed" | awk '{files+=$1; inserted+=$4; deleted+=$6} END {print "Files:", files, "Inserted:", inserted, "Deleted:", deleted}'

# 查看最近一周的变更
git log --since="1 week ago" --stat
```

#### 1.3 分支统计

```bash
# 查看所有分支
git branch -a

# 查看分支合并情况
git branch --merged master
git branch --no-merged master

# 统计分支数量
git branch -a | wc -l
```

### 2. 提交规范检查

#### 2.1 提交消息格式

**推荐格式**（Conventional Commits）：
```
<type>(<scope>): <subject>

<body>

<footer>
```

**类型（type）**：
| 类型 | 说明 | 示例 |
|------|------|------|
| `feat` | 新功能 | feat: add user authentication |
| `fix` | Bug 修复 | fix: resolve login timeout issue |
| `docs` | 文档更新 | docs: update README |
| `style` | 代码格式 | style: format code with prettier |
| `refactor` | 重构 | refactor: extract user service |
| `test` | 测试 | test: add unit tests for auth |
| `chore` | 构建/工具 | chore: update dependencies |
| `ci` | CI/CD | ci: add github actions workflow |
| `perf` | 性能优化 | perf: optimize query performance |

#### 2.2 提交检查脚本

```bash
#!/bin/bash
# scripts/git-commit-check.sh

# 获取提交消息
COMMIT_MSG_FILE=$1
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

# 提交消息格式正则
PATTERN="^(feat|fix|docs|style|refactor|test|chore|ci|perf)(\(.+\))?: .{1,50}$"

if ! echo "$COMMIT_MSG" | grep -qE "$PATTERN"; then
    echo "❌ 提交消息格式错误！"
    echo ""
    echo "正确格式：<type>(<scope>): <subject>"
    echo ""
    echo "示例："
    echo "  feat: add user authentication"
    echo "  fix(api): resolve timeout issue"
    echo "  docs: update installation guide"
    echo ""
    echo "类型列表：feat, fix, docs, style, refactor, test, chore, ci, perf"
    exit 1
fi

echo "✅ 提交消息格式正确"
exit 0
```

#### 2.3 Git Hook 配置

```bash
# .git/hooks/commit-msg
#!/bin/bash
./scripts/git-commit-check.sh $1
```

### 3. 代码审查流程

#### 3.1 审查检查清单

**功能审查**：
- [ ] 功能是否按需求实现
- [ ] 边界条件是否处理
- [ ] 错误处理是否完善
- [ ] 是否有安全漏洞

**代码质量**：
- [ ] 代码是否清晰易读
- [ ] 命名是否规范
- [ ] 是否有重复代码
- [ ] 是否有足够的注释

**测试覆盖**：
- [ ] 是否有单元测试
- [ ] 测试覆盖率是否达标
- [ ] 边界条件是否测试

**性能考虑**：
- [ ] 是否有性能问题
- [ ] 是否有不必要的循环
- [ ] 数据库查询是否优化

#### 3.2 PR 审查模板

```markdown
## 📋 PR 审查报告

> 审查人：@reviewer
> 审查时间：YYYY-MM-DD
> PR 编号：#XXX

### ✅ 通过项
- [ ] 代码风格符合规范
- [ ] 功能实现正确
- [ ] 测试覆盖充分

### ⚠️ 需要修改
- [ ] 建议优化 XXX
- [ ] 需要补充文档

### 💬 建议
- 考虑使用 XXX 模式优化代码
- 建议添加单元测试覆盖 XXX 场景

### 📊 统计
- 变更文件：X 个
- 新增代码：+XXX 行
- 删除代码：-XXX 行
```

#### 3.3 自动化审查脚本

```bash
#!/bin/bash
# scripts/git-review-check.sh

echo "🔍 开始代码审查检查..."

# 检查代码风格
if command -v eslint &> /dev/null; then
    echo "检查 ESLint..."
    npx eslint . --ext .js,.ts,.vue
fi

# 检查测试覆盖率
if [ -f "package.json" ]; then
    echo "检查测试覆盖率..."
    npm run test:coverage 2>/dev/null || echo "未配置测试覆盖率"
fi

# 检查敏感信息
echo "检查敏感信息..."
git diff --cached --name-only | xargs grep -l "password\|secret\|api_key" 2>/dev/null && echo "⚠️ 发现可能的敏感信息" || echo "✅ 未发现敏感信息"

# 检查大文件
echo "检查大文件..."
LARGE_FILES=$(git diff --cached --name-only | xargs -I {} sh -c 'if [ -f "{}" ]; then stat -c%s "{}"; fi' 2>/dev/null | awk '$1 > 1000000')
if [ -n "$LARGE_FILES" ]; then
    echo "⚠️ 发现大于 1MB 的文件"
else
    echo "✅ 文件大小正常"
fi

echo "✅ 代码审查检查完成"
```

### 4. 自动化 CI/CD 集成

#### 4.1 完整的 Git 工作流 CI/CD

```yaml
# .github/workflows/git-workflow.yml
name: Git Workflow CI

on:
  push:
    branches: [ master, develop ]
  pull_request:
    branches: [ master ]

jobs:
  commit-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - name: Validate commit messages
        run: |
          # 获取所有提交消息
          COMMITS=$(git log --pretty=format:"%s" origin/master..HEAD)
          
          # 检查格式
          echo "$COMMITS" | while read -r msg; do
            if ! echo "$msg" | grep -qE "^(feat|fix|docs|style|refactor|test|chore|ci|perf)(\(.+\))?: .{1,50}$"; then
              echo "❌ Invalid commit message: $msg"
              exit 1
            fi
          done
          echo "✅ All commit messages are valid"
  
  code-stats:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - name: Generate statistics
        run: |
          echo "## 📊 代码统计报告" >> $GITHUB_STEP_SUMMARY
          echo "" >> $GITHUB_STEP_SUMMARY
          
          # 提交统计
          echo "### 提交统计" >> $GITHUB_STEP_SUMMARY
          echo "| 指标 | 数值 |" >> $GITHUB_STEP_SUMMARY
          echo "|------|------|" >> $GITHUB_STEP_SUMMARY
          echo "| 总提交数 | $(git rev-list --count HEAD) |" >> $GITHUB_STEP_SUMMARY
          echo "| 贡献者数 | $(git shortlog -sn --all | wc -l) |" >> $GITHUB_STEP_SUMMARY
          echo "| 分支数 | $(git branch -a | wc -l) |" >> $GITHUB_STEP_SUMMARY
          
          # 代码行数
          echo "" >> $GITHUB_STEP_SUMMARY
          echo "### 代码规模" >> $GITHUB_STEP_SUMMARY
          git ls-files | xargs wc -l 2>/dev/null | tail -1 >> $GITHUB_STEP_SUMMARY

  review-check:
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request'
    steps:
      - uses: actions/checkout@v4
      
      - name: Check for sensitive data
        run: |
          echo "检查敏感信息..."
          git diff origin/master...HEAD --name-only | xargs grep -l "password\|secret\|api_key" 2>/dev/null && exit 1 || echo "✅ 未发现敏感信息"
      
      - name: Check file sizes
        run: |
          echo "检查文件大小..."
          find . -type f -size +1M -not -path "./.git/*" -not -path "./node_modules/*" && echo "⚠️ 发现大文件" || echo "✅ 文件大小正常"
```

#### 4.2 定期统计工作流

```yaml
# .github/workflows/weekly-stats.yml
name: Weekly Statistics

on:
  schedule:
    - cron: '0 9 * * 1'  # 每周一 09:00 UTC
  workflow_dispatch:

jobs:
  generate-stats:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - name: Generate weekly report
        run: |
          python scripts/git-stats-report.py
      
      - name: Commit report
        run: |
          git config --local user.email "github-actions[bot]@users.noreply.github.com"
          git config --local user.name "github-actions[bot]"
          git add reports/
          git diff --quiet && git diff --staged --quiet || git commit -m "chore: update weekly stats report [skip ci]"
          git push
```

### 5. 统计脚本

#### 5.1 Git 统计报告生成器

```python
#!/usr/bin/env python3
"""
Git 统计报告生成器
生成代码提交、变更、贡献者等统计报告
"""

import os
import subprocess
from datetime import datetime, timedelta

def run_git_command(cmd):
    """运行 git 命令"""
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return result.stdout.strip()

def generate_report():
    """生成统计报告"""
    report = {
        "generated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "total_commits": int(run_git_command("git rev-list --count HEAD")),
        "contributors": len(run_git_command("git shortlog -sn --all").split('\n')),
        "branches": int(run_git_command("git branch -a | wc -l")),
        "last_week_commits": int(run_git_command(
            f'git log --since="{(datetime.now() - timedelta(days=7)).strftime("%Y-%m-%d")}" --oneline | wc -l'
        )),
    }
    
    # 获取贡献者列表
    contributors = []
    for line in run_git_command("git shortlog -sn --all").split('\n'):
        if line.strip():
            parts = line.strip().split('\t')
            if len(parts) == 2:
                contributors.append({
                    "commits": int(parts[0]),
                    "name": parts[1]
                })
    report["top_contributors"] = contributors[:10]
    
    return report

def save_report(report):
    """保存报告"""
    os.makedirs("reports", exist_ok=True)
    
    filename = f"reports/git-stats-{datetime.now().strftime('%Y-%m-%d')}.md"
    
    content = f"""# Git 统计报告

> 生成时间：{report['generated_at']}

## 📊 总体统计

| 指标 | 数值 |
|------|------|
| 总提交数 | {report['total_commits']} |
| 贡献者数 | {report['contributors']} |
| 分支数 | {report['branches']} |
| 最近一周提交 | {report['last_week_commits']} |

## 👥 贡献者排行

| 排名 | 贡献者 | 提交数 |
|------|--------|--------|
"""
    
    for i, c in enumerate(report['top_contributors'], 1):
        content += f"| {i} | {c['name']} | {c['commits']} |\n"
    
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"报告已保存到 {filename}")

if __name__ == "__main__":
    report = generate_report()
    save_report(report)
```

## 🚀 使用方法

### 快速使用

```bash
# 1. 查看提交统计
python scripts/git-stats-report.py

# 2. 检查提交规范
./scripts/git-commit-check.sh

# 3. 运行代码审查
./scripts/git-review-check.sh

# 4. 查看分支统计
git branch -a | wc -l
```

### 集成到项目

1. **复制脚本到项目**：
   ```bash
   mkdir -p scripts
   # 复制相关脚本
   ```

2. **配置 Git Hooks**：
   ```bash
   # 使脚本可执行
   chmod +x scripts/*.sh
   
   # 配置 commit-msg hook
   ln -s ../../scripts/git-commit-check.sh .git/hooks/commit-msg
   ```

3. **配置 CI/CD**：
   - 将工作流文件复制到 `.github/workflows/`
   - 根据项目需求调整触发条件

## 📁 文件结构

```
skills/development/git-workflow-management/
├── SKILL.md                      # 技能说明文档
├── scripts/
│   ├── git-commit-check.sh       # 提交规范检查
│   ├── git-review-check.sh       # 代码审查检查
│   └── git-stats-report.py       # 统计报告生成
├── workflows/
│   ├── git-workflow.yml          # Git 工作流 CI
│   └── weekly-stats.yml          # 定期统计
└── templates/
    ├── commit-template.txt       # 提交消息模板
    └── pr-review-template.md     # PR 审查模板
```

## 📚 相关资源

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Git Best Practices](https://git-scm.com/book/en/v2/Distributed-Git-Contributing-to-a-Project)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## 🔄 更新记录

| 版本 | 日期 | 更新内容 |
|------|------|---------|
| 1.0.0 | 2026-03-13 | 初始版本，包含统计、审查、提交规范 |
