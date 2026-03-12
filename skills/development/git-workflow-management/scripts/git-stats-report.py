#!/usr/bin/env python3
"""
Git 统计报告生成器
生成代码提交、变更、贡献者等统计报告
"""

import os
import json
import subprocess
from datetime import datetime, timedelta
from pathlib import Path

def run_git_command(cmd):
    """运行 git 命令并返回输出"""
    try:
        result = subprocess.run(
            cmd, 
            shell=True, 
            capture_output=True, 
            text=True,
            cwd=os.getcwd()
        )
        return result.stdout.strip()
    except Exception as e:
        print(f"Error running command '{cmd}': {e}")
        return ""

def get_commit_count(since=None):
    """获取提交数量"""
    cmd = "git rev-list --count HEAD"
    if since:
        cmd += f' --since="{since}"'
    result = run_git_command(cmd)
    return int(result) if result.isdigit() else 0

def get_contributors():
    """获取贡献者列表"""
    output = run_git_command("git shortlog -sn --all")
    contributors = []
    for line in output.split('\n'):
        if line.strip():
            parts = line.strip().split('\t')
            if len(parts) == 2:
                contributors.append({
                    "commits": int(parts[0]),
                    "name": parts[1]
                })
    return contributors

def get_branch_stats():
    """获取分支统计"""
    branches = run_git_command("git branch -a")
    branch_list = [b.strip() for b in branches.split('\n') if b.strip()]
    
    local_branches = len([b for b in branch_list if not b.startswith('remotes/')])
    remote_branches = len([b for b in branch_list if b.startswith('remotes/')])
    
    return {
        "total": len(branch_list),
        "local": local_branches,
        "remote": remote_branches
    }

def get_code_stats():
    """获取代码统计"""
    # 获取所有追踪的文件
    files = run_git_command("git ls-files")
    file_list = [f for f in files.split('\n') if f]
    
    # 按扩展名分类
    extensions = {}
    for f in file_list:
        ext = Path(f).suffix or 'no_extension'
        extensions[ext] = extensions.get(ext, 0) + 1
    
    # 获取总行数
    total_lines = 0
    try:
        result = run_git_command("git ls-files | xargs wc -l 2>/dev/null | tail -1")
        if result:
            parts = result.split()
            if parts:
                total_lines = int(parts[0])
    except:
        pass
    
    return {
        "total_files": len(file_list),
        "total_lines": total_lines,
        "by_extension": dict(sorted(extensions.items(), key=lambda x: x[1], reverse=True)[:10])
    }

def get_recent_activity(days=7):
    """获取最近活动"""
    since = (datetime.now() - timedelta(days=days)).strftime("%Y-%m-%d")
    
    return {
        "commits": get_commit_count(since=since),
        "active_contributors": len([c for c in get_contributors() if c["commits"] > 0])
    }

def get_commit_activity_by_day(days=30):
    """获取每日提交活动"""
    since = (datetime.now() - timedelta(days=days)).strftime("%Y-%m-%d")
    output = run_git_command(f'git log --since="{since}" --date=short --pretty=format:"%ad"')
    
    activity = {}
    for date in output.split('\n'):
        if date:
            activity[date] = activity.get(date, 0) + 1
    
    return dict(sorted(activity.items()))

def generate_report():
    """生成完整统计报告"""
    now = datetime.now()
    
    report = {
        "meta": {
            "generated_at": now.strftime("%Y-%m-%d %H:%M:%S"),
            "repository": os.path.basename(os.getcwd()),
            "report_version": "1.0"
        },
        "overview": {
            "total_commits": get_commit_count(),
            "contributors": len(get_contributors()),
            "branches": get_branch_stats()
        },
        "code": get_code_stats(),
        "contributors": get_contributors()[:20],
        "activity": {
            "last_week": get_recent_activity(7),
            "last_month": get_recent_activity(30),
            "daily_commits": get_commit_activity_by_day(30)
        }
    }
    
    return report

def save_json_report(report, filename):
    """保存 JSON 格式报告"""
    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(report, f, indent=2, ensure_ascii=False)
    print(f"JSON 报告已保存到 {filename}")

def save_markdown_report(report, filename):
    """保存 Markdown 格式报告"""
    content = f"""# Git 统计报告

> 生成时间：{report['meta']['generated_at']}
> 仓库：{report['meta']['repository']}

## 📊 总体统计

| 指标 | 数值 |
|------|------|
| 总提交数 | {report['overview']['total_commits']} |
| 贡献者数 | {report['overview']['contributors']} |
| 本地分支 | {report['overview']['branches']['local']} |
| 远程分支 | {report['overview']['branches']['remote']} |
| 文件总数 | {report['code']['total_files']} |
| 代码总行数 | {report['code']['total_lines']} |

## 📈 近期活动

| 时间段 | 提交数 |
|--------|--------|
| 最近 7 天 | {report['activity']['last_week']['commits']} |
| 最近 30 天 | {report['activity']['last_month']['commits']} |

## 👥 贡献者排行

| 排名 | 贡献者 | 提交数 |
|------|--------|--------|
"""
    
    for i, c in enumerate(report['contributors'], 1):
        content += f"| {i} | {c['name']} | {c['commits']} |\n"
    
    content += """
## 📁 文件类型分布

| 类型 | 文件数 |
|------|--------|
"""
    
    for ext, count in report['code']['by_extension'].items():
        ext_name = ext if ext else '(无扩展名)'
        content += f"| {ext_name} | {count} |\n"
    
    content += """
## 📅 每日提交活动（最近 30 天）

```
"""
    
    # 简单的 ASCII 图表
    max_commits = max(report['activity']['daily_commits'].values()) if report['activity']['daily_commits'] else 1
    for date, count in sorted(report['activity']['daily_commits'].items(), reverse=True)[:15]:
        bar = '█' * int(count / max_commits * 20) if max_commits > 0 else ''
        content += f"{date}: {bar} {count}\n"
    
    content += """```

---

*由 Git Stats Report Generator 自动生成*
"""
    
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Markdown 报告已保存到 {filename}")

def main():
    """主函数"""
    print("正在生成 Git 统计报告...")
    
    # 创建报告目录
    reports_dir = Path("reports/git-stats")
    reports_dir.mkdir(parents=True, exist_ok=True)
    
    # 生成报告
    report = generate_report()
    
    # 保存报告
    date_str = datetime.now().strftime("%Y-%m-%d")
    
    json_file = reports_dir / f"git-stats-{date_str}.json"
    md_file = reports_dir / f"git-stats-{date_str}.md"
    
    save_json_report(report, json_file)
    save_markdown_report(report, md_file)
    
    # 同时保存最新报告（方便 CI 使用）
    save_json_report(report, reports_dir / "git-stats-latest.json")
    save_markdown_report(report, reports_dir / "git-stats-latest.md")
    
    print("\n📊 报告摘要：")
    print(f"   总提交数: {report['overview']['total_commits']}")
    print(f"   贡献者数: {report['overview']['contributors']}")
    print(f"   最近 7 天提交: {report['activity']['last_week']['commits']}")

if __name__ == "__main__":
    main()
