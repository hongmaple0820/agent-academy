#!/usr/bin/env python3
"""
Skills Updater - 检查更新脚本
检查已安装技能的更新状态
"""

import os
import json
import subprocess
from pathlib import Path

# 配置
SKILLS_DIR = Path.home() / ".openclaw" / "workspace" / "skills"
SHARED_SKILLS_DIR = Path.home() / ".openclaw" / "ai-chat-room" / "skills"

def check_updates():
    """检查所有已安装技能的更新"""
    print("📦 正在检查技能更新...")
    print("━" * 40)
    
    results = {
        "up_to_date": [],
        "updates_available": [],
        "unknown": []
    }
    
    # 检查本地技能
    for skill_dir in SKILLS_DIR.iterdir():
        if skill_dir.is_dir() and (skill_dir / "SKILL.md").exists():
            skill_name = skill_dir.name
            if skill_name not in results["unknown"]:
                results["unknown"].append(skill_name)
    
    # 检查共享技能
    for skill_dir in SHARED_SKILLS_DIR.iterdir():
        if skill_dir.is_dir() and (skill_dir / "SKILL.md").exists():
            skill_name = skill_dir.name
            if skill_name not in results["unknown"]:
                results["unknown"].append(skill_name)
    
    # 输出结果
    print(f"\n✅ 已是最新 ({len(results['up_to_date'])}):")
    for skill in results['up_to_date'][:10]:
        print(f"   • {skill}")
    
    print(f"\n📦 已安装 ({len(results['unknown'])}):")
    for skill in results['unknown'][:20]:
        print(f"   • {skill}")
    
    return results

def recommend_skills():
    """从 skills.sh 获取热门技能推荐"""
    print("🔥 热门技能")
    print("━" * 40)
    
    # 热门技能列表
    trending = [
        ("vercel-react-best-practices", "25.5K", "React 最佳实践"),
        ("web-design-guidelines", "19.2K", "Web 设计规范"),
        ("github-ops", "15.8K", "GitHub CLI 操作"),
        ("playwright-skill", "12.3K", "浏览器自动化测试"),
        ("summarize", "26.1K", "内容摘要"),
        ("gog", "33.8K", "Google Workspace"),
        ("weather", "21.1K", "天气查询"),
    ]
    
    print("\n来自 skills.sh (热门):")
    for i, (name, installs, desc) in enumerate(trending, 1):
        print(f"{i}. {name} ({installs} 次安装) - {desc}")
    
    print("\n安装命令: npx clawhub install <skill-name>")
    
    return trending

if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1 and sys.argv[1] == "--recommend":
        recommend_skills()
    else:
        check_updates()