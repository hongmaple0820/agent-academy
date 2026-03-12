#!/bin/bash

# 技能迁移脚本
# 将技能目录移动到对应的分类目录中

echo "=== 开始技能目录分类迁移 ==="

# 定义分类映射
declare -A category_map

# PM与产品类
category_map["pm-skills"]="pm-product"
category_map["product-team"]="pm-product"
category_map["project-management"]="pm-product"
category_map["project-standards"]="pm-product"
category_map["brainstorming"]="pm-product"
category_map["planning-with-files"]="pm-product"
category_map["executing-plans"]="pm-product"

# 开发类
category_map["coding-agent"]="development"
category_map["git-commit"]="development"
category_map["requesting-code-review"]="development"
category_map["receiving-code-review"]="development"
category_map["finishing-a-development-branch"]="development"
category_map["deploying-applications"]="development"
category_map["writing-github-actions"]="development"
category_map["test-driven-development"]="development"
category_map["testing-strategies"]="development"
category_map["property-based-testing"]="development"
category_map["root-cause-tracing"]="development"
category_map["verification-before-completion"]="development"
category_map["systematic-debugging"]="development"

# 设计类
category_map["frontend-design"]="design"
category_map["designing-layouts"]="design"
category_map["designing-apis"]="design"
category_map["canvas"]="design"
category_map["ui-ux-pro-max"]="design"
category_map["ppt-style-guide"]="design"
category_map["composition-patterns"]="design"
category_map["building-forms"]="design"
category_map["building-tables"]="design"
category_map["building-secure-contracts"]="design"

# 文档类
category_map["writing-skills"]="documentation"
category_map["writing-plans"]="documentation"
category_map["markdown-to-epub"]="documentation"
category_map["changelog-generator"]="documentation"
category_map["diagram-generator"]="documentation"

# 数据分析类
category_map["deep-research"]="data-analysis"
category_map["statistical-analysis"]="data-analysis"
category_map["visualizing-data"]="data-analysis"
category_map["matplotlib"]="data-analysis"
category_map["d3js-visualization"]="data-analysis"
category_map["implementing-search-filter"]="data-analysis"

# 工具开发类
category_map["mcp-builder"]="tool-development"
category_map["creating-skillsbasic"]="tool-development"
category_map["skill-creator"]="tool-development"
category_map["memory-systems"]="tool-development"
category_map["context-fundamentals"]="tool-development"
category_map["skill-seekers"]="tool-development"
category_map["skills-updater"]="tool-development"
category_map["tool-design"]="tool-development"

# Web API类
category_map["building-forms"]="web-api"
category_map["building-tables"]="web-api"
category_map["building-secure-contracts"]="web-api"
category_map["implementing-search-filter"]="web-api"
category_map["designing-apis"]="web-api"

# 安全测试类
category_map["test-driven-development"]="security-testing"
category_map["testing-strategies"]="security-testing"
category_map["property-based-testing"]="security-testing"
category_map["root-cause-tracing"]="security-testing"
category_map["verification-before-completion"]="security-testing"

# AI机器学习类
category_map["hugging-face-model-trainer"]="ai-ml"
category_map["hugging-face-datasets"]="ai-ml"
category_map["hugging-face-evaluation"]="ai-ml"
category_map["hugging-face-cli"]="ai-ml"
category_map["hugging-face-trackio"]="ai-ml"
category_map["pytorch-lightning"]="ai-ml"

# 框架类
category_map["react-best-practices"]="frameworks"
category_map["react-best-practices-build"]="frameworks"
category_map["react-native-skills"]="frameworks"
category_map["composition-patterns"]="frameworks"

# 集成类
category_map["supabase-postgres-best-practices"]="integrations"
category_map["secret-management"]="integrations"
category_map["google-calendar"]="integrations"
category_map["google-docs"]="integrations"
category_map["google-drive"]="integrations"
category_map["google-sheets"]="integrations"
category_map["notion"]="integrations"
category_map["slack"]="integrations"
category_map["discord"]="integrations"

# 其他类
category_map["engineering-team"]="others"
category_map["c-level-advisor"]="others"
category_map["marketing-skill"]="others"
category_map["web-design-guidelines"]="others"
category_map["using-git-worktrees"]="others"
category_map["using-superpowers"]="others"

# 高频核心技能（保持独立）
core_skills=("daily-review" "programming-workflow" "pm-skills" "project-standards")

echo "=== 检查目录存在 ==="

# 检查分类目录是否存在
for category in "pm-product" "development" "design" "documentation" "data-analysis" "tool-development" "web-api" "security-testing" "ai-ml" "frameworks" "integrations" "others"; do
    if [ ! -d "$category" ]; then
        mkdir "$category"
        echo "创建分类目录: $category"
    fi
done

echo "=== 迁移技能目录 ==="

# 统计迁移数量
moved_count=0
skipped_count=0

for skill in "${!category_map[@]}"; do
    category="${category_map[$skill]}"
    
    if [ -d "$skill" ]; then
        # 检查是否为高频核心技能
        is_core=false
        for core in "${core_skills[@]}"; do
            if [ "$skill" == "$core" ]; then
                is_core=true
                break
            fi
        done
        
        if [ "$is_core" == true ]; then
            echo "跳过核心技能: $skill (保持独立)"
            skipped_count=$((skipped_count+1))
            continue
        fi
        
        if [ -d "$category/$skill" ]; then
            echo "目标已存在: $category/$skill"
            skipped_count=$((skipped_count+1))
        else
            mv "$skill" "$category/"
            echo "迁移: $skill -> $category/"
            moved_count=$((moved_count+1))
        fi
    else
        echo "未找到: $skill"
        skipped_count=$((skipped_count+1))
    fi
done

echo "=== 迁移完成 ==="
echo "总迁移技能数: $moved_count"
echo "总跳过技能数: $skipped_count"
echo "核心技能保持独立: 4个"

# 更新README.md
echo "=== 更新分类README.md ==="

for category in "pm-product" "development" "design" "documentation" "data-analysis" "tool-development" "web-api" "security-testing" "ai-ml" "frameworks" "integrations" "others"; do
    echo "# $category 分类" > "$category/README.md"
    echo "" >> "$category/README.md"
    echo "## 技能列表" >> "$category/README.md"
    echo "" >> "$category/README.md"
    
    if [ -d "$category" ] && [ "$(ls "$category" | wc -l)" -gt 0 ]; then
        for skill_dir in "$category"/*; do
            if [ -d "$skill_dir" ]; then
                skill_name=$(basename "$skill_dir")
                echo "- $skill_name" >> "$category/README.md"
            fi
        done
    else
        echo "- (暂无技能)" >> "$category/README.md"
    fi
    
    echo "已更新: $category/README.md"
done

echo "=== 脚本执行完成 ==="