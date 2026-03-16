#!/usr/bin/env python3
"""
技能质量评分系统

评估技能的质量，从多个维度打分：
- 文档完整度 (30%)
- 示例代码质量 (25%)
- 维护频率 (20%)
- 使用频率 (15%)
- 用户评分 (10%)

输出综合评分和详细报告
"""

import os
import json
from datetime import datetime, timedelta
from pathlib import Path

class SkillQualityScorer:
    def __init__(self, skills_dir="skills"):
        self.skills_dir = Path(skills_dir)
        self.scores = []
    
    def score_documentation(self, skill_path):
        """评估文档完整度 (0-100 分)"""
        score = 0
        max_score = 100
        
        # 检查 SKILL.md (40 分)
        skill_md = skill_path / "SKILL.md"
        if skill_md.exists():
            content = skill_md.read_text(encoding='utf-8')
            # 检查关键章节
            if "功能" in content or "功能说明" in content:
                score += 15
            if "使用" in content or "使用方法" in content:
                score += 15
            if len(content) > 500:  # 文档长度
                score += 10
        
        # 检查 README.md (30 分)
        readme_md = skill_path / "README.md"
        if readme_md.exists():
            content = readme_md.read_text(encoding='utf-8')
            if len(content) > 300:
                score += 30
            elif len(content) > 100:
                score += 15
        
        # 检查 references/ 目录 (20 分)
        references_dir = skill_path / "references"
        if references_dir.exists():
            ref_count = len(list(references_dir.glob("*.md")))
            score += min(ref_count * 5, 20)
        
        # 检查 scripts/ 目录 (10 分)
        scripts_dir = skill_path / "scripts"
        if scripts_dir.exists():
            script_count = len(list(scripts_dir.glob("*.sh")))
            score += min(script_count * 2, 10)
        
        return score
    
    def score_examples(self, skill_path):
        """评估示例代码质量 (0-100 分)"""
        score = 0
        max_score = 100
        
        # 检查 examples/ 目录 (50 分)
        examples_dir = skill_path / "examples"
        if examples_dir.exists():
            example_count = len(list(examples_dir.glob("*.md")))
            score += min(example_count * 10, 50)
        
        # 检查代码文件 (30 分)
        code_files = list(skill_path.glob("*.ts")) + list(skill_path.glob("*.py")) + list(skill_path.glob("*.js"))
        if code_files:
            # 有代码文件
            score += 15
            # 代码长度合理
            for code_file in code_files:
                if code_file.stat().st_size > 1000:
                    score += 15
                    break
        
        # 检查测试文件 (20 分)
        test_files = list(skill_path.glob("*.test.ts")) + list(skill_path.glob("*.test.py")) + list(skill_path.glob("tests/*.py"))
        if test_files:
            score += 20
        
        return score
    
    def score_maintenance(self, skill_path):
        """评估维护频率 (0-100 分)"""
        score = 0
        
        # 获取最新修改时间
        try:
            latest_mtime = max(f.stat().st_mtime for f in skill_path.rglob("*") if f.is_file())
            days_ago = (datetime.now().timestamp() - latest_mtime) / 86400
            
            if days_ago < 7:
                score = 100  # 最近 7 天更新
            elif days_ago < 30:
                score = 80   # 最近 30 天更新
            elif days_ago < 90:
                score = 60   # 最近 90 天更新
            elif days_ago < 180:
                score = 40   # 最近 180 天更新
            elif days_ago < 365:
                score = 20   # 最近 1 年更新
            else:
                score = 0    # 超过 1 年未更新
        except Exception:
            score = 50  # 无法获取时间，给平均分
        
        return score
    
    def score_usage(self, skill_path):
        """评估使用频率 (0-100 分) - 基于启发式规则"""
        score = 50  # 基础分
        
        # 核心技能加分
        core_skills = ["daily-review", "programming-workflow", "pm-skills", "project-standards"]
        if skill_path.name in core_skills:
            score += 30
        
        # 有详细文档加分
        skill_md = skill_path / "SKILL.md"
        if skill_md.exists() and skill_md.stat().st_size > 2000:
            score += 10
        
        # 有使用示例加分
        examples_dir = skill_path / "examples"
        if examples_dir.exists():
            score += 10
        
        return min(score, 100)
    
    def score_user_rating(self, skill_path):
        """用户评分 (0-100 分) - 暂时用固定值"""
        # TODO: 实现用户评分系统
        return 75
    
    def calculate_total_score(self, skill_path):
        """计算综合评分"""
        scores = {
            "documentation": self.score_documentation(skill_path),
            "examples": self.score_examples(skill_path),
            "maintenance": self.score_maintenance(skill_path),
            "usage": self.score_usage(skill_path),
            "user_rating": self.score_user_rating(skill_path)
        }
        
        # 加权平均
        weights = {
            "documentation": 0.30,
            "examples": 0.25,
            "maintenance": 0.20,
            "usage": 0.15,
            "user_rating": 0.10
        }
        
        total = sum(scores[k] * weights[k] for k in scores)
        
        return {
            "skill": skill_path.name,
            "scores": scores,
            "total": round(total, 1),
            "level": self.score_to_level(total)
        }
    
    def score_to_level(self, score):
        """分数转等级"""
        if score >= 90:
            return "⭐⭐⭐⭐⭐"
        elif score >= 80:
            return "⭐⭐⭐⭐☆"
        elif score >= 70:
            return "⭐⭐⭐☆☆"
        elif score >= 60:
            return "⭐⭐☆☆☆"
        else:
            return "⭐☆☆☆☆"
    
    def score_all_skills(self):
        """评估所有技能"""
        categories = [
            "pm-product", "development", "design", "documentation",
            "data-analysis", "tool-development", "web-api", "security-testing",
            "ai-ml", "frameworks", "integrations", "others"
        ]
        
        core_skills = ["daily-review", "programming-workflow", "pm-skills", "project-standards"]
        
        all_scores = []
        
        # 评估分类技能
        for category in categories:
            category_path = self.skills_dir / category
            if category_path.exists():
                for skill_dir in category_path.iterdir():
                    if skill_dir.is_dir() and not skill_dir.name.startswith("."):
                        score = self.calculate_total_score(skill_dir)
                        score["category"] = category
                        all_scores.append(score)
        
        # 评估核心技能
        for skill_name in core_skills:
            skill_path = self.skills_dir / skill_name
            if skill_path.exists():
                score = self.calculate_total_score(skill_path)
                score["category"] = "core"
                all_scores.append(score)
        
        # 排序
        all_scores.sort(key=lambda x: x["total"], reverse=True)
        
        return all_scores
    
    def generate_report(self, scores):
        """生成评分报告"""
        report = {
            "generated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            "total_skills": len(scores),
            "scores": scores,
            "statistics": self.calculate_statistics(scores)
        }
        
        return report
    
    def calculate_statistics(self, scores):
        """计算统计信息"""
        if not scores:
            return {}
        
        totals = [s["total"] for s in scores]
        
        return {
            "average": round(sum(totals) / len(totals), 1),
            "max": max(totals),
            "min": min(totals),
            "five_star": len([s for s in scores if s["total"] >= 90]),
            "four_star": len([s for s in scores if 80 <= s["total"] < 90]),
            "three_star": len([s for s in scores if 70 <= s["total"] < 80]),
            "two_star": len([s for s in scores if 60 <= s["total"] < 70]),
            "one_star": len([s for s in scores if s["total"] < 60])
        }
    
    def save_report(self, report):
        """保存报告"""
        # 保存 JSON
        json_file = self.skills_dir / "skill-quality-scores.json"
        with open(json_file, "w", encoding="utf-8") as f:
            json.dump(report, f, indent=2, ensure_ascii=False)
        print(f"评分报告已保存到 {json_file}")
        
        # 保存 Markdown
        md_file = self.skills_dir / "skill-quality-scores.md"
        self.save_markdown_report(report, md_file)
        print(f"Markdown 报告已保存到 {md_file}")
    
    def save_markdown_report(self, report, md_file):
        """保存 Markdown 格式报告"""
        content = f"""# 技能质量评分报告

> 生成时间：{report['generated_at']}

## 📊 总体统计

| 指标 | 数值 |
|------|------|
| **总技能数** | {report['total_skills']} |
| **平均评分** | {report['statistics']['average']} |
| **最高分** | {report['statistics']['max']} |
| **最低分** | {report['statistics']['min']} |

## ⭐ 评分分布

| 等级 | 数量 | 占比 |
|------|------|------|
| ⭐⭐⭐⭐⭐ (≥90) | {report['statistics']['five_star']} | {report['statistics']['five_star']/report['total_skills']*100:.1f}% |
| ⭐⭐⭐⭐☆ (80-89) | {report['statistics']['four_star']} | {report['statistics']['four_star']/report['total_skills']*100:.1f}% |
| ⭐⭐⭐☆☆ (70-79) | {report['statistics']['three_star']} | {report['statistics']['three_star']/report['total_skills']*100:.1f}% |
| ⭐⭐☆☆☆ (60-69) | {report['statistics']['two_star']} | {report['statistics']['two_star']/report['total_skills']*100:.1f}% |
| ⭐☆☆☆☆ (<60) | {report['statistics']['one_star']} | {report['statistics']['one_star']/report['total_skills']*100:.1f}% |

## 🏆 TOP 10 技能

| 排名 | 技能 | 分类 | 评分 | 等级 |
|------|------|------|------|------|"""
        
        for i, score in enumerate(report["scores"][:10], 1):
            content += f"\n| {i} | {score['skill']} | {score['category']} | {score['total']} | {score['level']} |"
        
        content += "\n\n## 📈 评分维度说明\n\n"
        content += """| 维度 | 权重 | 评估内容 |
|------|------|---------|
| 文档完整度 | 30% | SKILL.md、README.md、references、scripts |\n| 示例代码质量 | 25% | examples、代码文件、测试文件 |\n| 维护频率 | 20% | 最近更新时间 |\n| 使用频率 | 15% | 核心技能、文档详细程度 |\n| 用户评分 | 10% | 用户手动评分 (待实现) |\n"""
        
        content += "\n## 📝 改进建议\n\n"
        content += "### 低分技能需要改进:\n\n"
        
        low_scores = [s for s in report["scores"] if s["total"] < 70]
        if low_scores:
            for score in low_scores[:10]:
                content += f"- `{score['skill']}` ({score['category']}): {score['total']} 分\n"
        else:
            content += "所有技能评分都在 70 分以上，继续保持！\n"
        
        content += "\n---\n\n*报告由 skill-quality-scorer.py 自动生成*\n"
        
        with open(md_file, "w", encoding="utf-8") as f:
            f.write(content)
    
    def main(self):
        """主函数"""
        print("开始评估技能质量...")
        
        # 评估所有技能
        scores = self.score_all_skills()
        
        # 生成报告
        report = self.generate_report(scores)
        
        # 保存报告
        self.save_report(report)
        
        # 输出摘要
        print(f"\n总计评估 {report['total_skills']} 个技能")
        print(f"平均评分：{report['statistics']['average']}")
        print(f"最高分：{report['statistics']['max']}")
        print(f"最低分：{report['statistics']['min']}")
        print(f"\n评分分布:")
        print(f"  ⭐⭐⭐⭐⭐: {report['statistics']['five_star']} 个")
        print(f"  ⭐⭐⭐⭐☆: {report['statistics']['four_star']} 个")
        print(f"  ⭐⭐⭐☆☆: {report['statistics']['three_star']} 个")
        print(f"  ⭐⭐☆☆☆: {report['statistics']['two_star']} 个")
        print(f"  ⭐☆☆☆☆: {report['statistics']['one_star']} 个")

if __name__ == "__main__":
    scorer = SkillQualityScorer()
    scorer.main()
