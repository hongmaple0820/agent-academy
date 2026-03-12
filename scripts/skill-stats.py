#!/usr/bin/env python3
"""
技能使用统计脚本

统计技能目录中各类技能的分布情况，
生成分类统计和总体统计报告。
"""

import os
import json
from datetime import datetime

def count_skills_in_category(category_path):
    """统计分类目录中的技能数量"""
    if not os.path.exists(category_path):
        return 0
    
    count = 0
    for item in os.listdir(category_path):
        if os.path.isdir(os.path.join(category_path, item)):
            count += 1
    
    return count

def generate_stats_report():
    """生成统计报告"""
    skills_dir = "skills"
    
    # 分类目录列表
    categories = [
        "pm-product", "development", "design", "documentation",
        "data-analysis", "tool-development", "web-api", "security-testing",
        "ai-ml", "frameworks", "integrations", "others"
    ]
    
    # 独立核心技能目录
    core_skills = [
        "daily-review", "programming-workflow", "pm-skills", "project-standards"
    ]
    
    stats = {}
    classified_count = 0
    
    # 统计各分类目录的技能数量
    for category in categories:
        category_path = os.path.join(skills_dir, category)
        skill_count = count_skills_in_category(category_path)
        stats[category] = skill_count
        classified_count += skill_count
    
    # 统计核心技能
    core_stats = {}
    for skill in core_skills:
        skill_path = os.path.join(skills_dir, skill)
        if os.path.exists(skill_path):
            core_stats[skill] = 1
            classified_count += 1
    
    # 统计根目录下的其他技能（未被分类的）
    root_skills = []
    for item in os.listdir(skills_dir):
        item_path = os.path.join(skills_dir, item)
        if os.path.isdir(item_path):
            # 排除分类目录和核心技能
            if item not in categories and item not in core_skills:
                root_skills.append(item)
    
    # 总技能数 = 已分类 + 未分类
    total_skills = classified_count + len(root_skills)
    
    # 生成统计报告
    report = {
        "generated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "total_skills": total_skills,
        "classified_count": classified_count,
        "categories": stats,
        "core_skills": core_stats,
        "unclassified_skills": root_skills,
        "unclassified_count": len(root_skills)
    }
    
    return report

def save_stats_to_json(report):
    """保存统计数据到JSON文件"""
    stats_file = "skills-stats.json"
    with open(stats_file, "w", encoding="utf-8") as f:
        json.dump(report, f, indent=2, ensure_ascii=False)
    print(f"统计数据已保存到 {stats_file}")
    
    # 同时生成README格式的统计
    generate_readme_stats(report)

def generate_readme_stats(report):
    """生成README格式的统计"""
    stats_file = "skills-stats.md"
    
    content = f"""# 技能目录统计报告

> 统计时间：{report["generated_at"]}

## 📊 总体统计
- **总技能数**: {report["total_skills"]} 个技能
- **已分类技能**: {report["classified_count"]} 个
- **未分类技能**: {report["unclassified_count"]} 个

## 📁 分类统计

| 分类目录 | 技能数量 | 说明 |
|----------|----------|------|"""

    for category, count in report["categories"].items():
        if category == "pm-product":
            desc = "产品与项目管理类"
        elif category == "development":
            desc = "开发与编程类"
        elif category == "design":
            desc = "设计与界面类"
        elif category == "documentation":
            desc = "文档与写作类"
        elif category == "data-analysis":
            desc = "数据分析与研究类"
        elif category == "tool-development":
            desc = "技能与工具开发类"
        elif category == "web-api":
            desc = "Web与API开发类"
        elif category == "security-testing":
            desc = "安全与测试类"
        elif category == "ai-ml":
            desc = "AI与机器学习类"
        elif category == "frameworks":
            desc = "框架与库类"
        elif category == "integrations":
            desc = "存储与集成类"
        elif category == "others":
            desc = "其他重要技能类"
        else:
            desc = category
        
        content += f"\n| {category} | {count} | {desc} |"
    
    content += "\n\n## 🎯 核心技能统计\n"
    for skill, _ in report["core_skills"].items():
        content += f"- `{skill}` - 独立核心技能\n"
    
    if report["unclassified_skills"]:
        content += "\n## ⚠️ 未分类技能\n"
        for skill in report["unclassified_skills"]:
            content += f"- `{skill}`\n"
    
    content += "\n## 📈 统计分析\n"
    content += f"""
- **分类覆盖率**: {(report["classified_count"] / report["total_skills"] * 100):.1f}%
- **平均每分类技能数**: {sum(report["categories"].values()) / len(report["categories"]):.1f}
- **最大分类**: {max(report["categories"].items(), key=lambda x: x[1])[0]} ({max(report["categories"].items(), key=lambda x: x[1])[1]}个技能)
- **最小分类**: {min(report["categories"].items(), key=lambda x: x[1])[0]} ({min(report["categories"].items(), key=lambda x: x[1])[1]}个技能)

## 🔧 使用方法

### 手动运行
```bash
python scripts/skill-stats.py
```

### 自动化运行
项目已配置 GitHub Actions CI/CD 自动统计：

| 工作流 | 触发条件 | 说明 |
|--------|---------|------|
| `skills-stats.yml` | 每周一 09:00 / skills 目录变更 | 自动生成并提交统计 |
| `validate-skills.yml` | PR 涉及 skills 目录 | 验证分类结构 |

**查看工作流状态**：`.github/workflows/` 目录

## ✅ 已完成的改进

| 改进项 | 状态 | 完成时间 |
|--------|------|---------|
| 完成剩余技能的分类工作 | ✅ 已完成 | 2026-03-13 |
| 定期更新统计信息 | ✅ 已建立 | 2026-03-13 |
| 建立自动化统计机制 | ✅ CI/CD 集成 | 2026-03-13 |
"""
    
    with open(stats_file, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"README格式统计已保存到 {stats_file}")

def main():
    print("开始统计技能目录...")
    report = generate_stats_report()
    
    print(f"总计: {report['total_skills']} 个技能")
    print(f"已分类: {report['classified_count']} 个")
    print(f"未分类: {report['unclassified_count']} 个")
    
    save_stats_to_json(report)
    
    # 输出各分类统计数据
    print("\n分类统计:")
    for category, count in report["categories"].items():
        print(f"  {category}: {count} 个技能")
    
    print("\n核心技能:")
    for skill in report["core_skills"]:
        print(f"  {skill}")
    
    if report["unclassified_skills"]:
        print("\n未分类技能:")
        for skill in report["unclassified_skills"]:
            print(f"  {skill}")

if __name__ == "__main__":
    main()