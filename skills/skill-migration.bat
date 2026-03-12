@echo off
echo === 开始技能目录分类迁移 ===

REM 定义分类映射
REM PM与产品类
set pm-skills=pm-product
set product-team=pm-product
set project-management=pm-product
set project-standards=pm-product
set brainstorming=pm-product
set planning-with-files=pm-product
set executing-plans=pm-product

REM 开发类
set coding-agent=development
set git-commit=development
set requesting-code-review=development
set receiving-code-review=development
set finishing-a-development-branch=development
set deploying-applications=development
set writing-github-actions=development
set test-driven-development=development
set testing-strategies=development
set property-based-testing=development
set root-cause-tracing=development
set verification-before-completion=development
set systematic-debugging=development

REM 设计类
set frontend-design=design
set designing-layouts=design
set designing-apis=design
set canvas=design
set ui-ux-pro-max=design
set ppt-style-guide=design
set composition-patterns=design
set building-forms=design
set building-tables=design
set building-secure-contracts=design

REM 文档类
set writing-skills=documentation
set writing-plans=documentation
set markdown-to-epub=documentation
set changelog-generator=documentation
set diagram-generator=documentation

REM 数据分析类
set deep-research=data-analysis
set statistical-analysis=data-analysis
set visualizing-data=data-analysis
set matplotlib=data-analysis
set d3js-visualization=data-analysis
set implementing-search-filter=data-analysis

REM 工具开发类
set mcp-builder=tool-development
set creating-skillsbasic=tool-development
set skill-creator=tool-development
set memory-systems=tool-development
set context-fundamentals=tool-development
set skill-seekers=tool-development
set skills-updater=tool-development
set tool-design=tool-development

REM Web API类
set building-forms=web-api
set building-tables=web-api
set building-secure-contracts=web-api
set implementing-search-filter=web-api
set designing-apis=web-api

REM 安全测试类
set test-driven-development=security-testing
set testing-strategies=security-testing
set property-based-testing=security-testing
set root-cause-tracing=security-testing
set verification-before-completion=security-testing

REM AI机器学习类
set hugging-face-model-trainer=ai-ml
set hugging-face-datasets=ai-ml
set hugging-face-evaluation=ai-ml
set hugging-face-cli=ai-ml
set hugging-face-trackio=ai-ml
set pytorch-lightning=ai-ml

REM 框架类
set react-best-practices=frameworks
set react-best-practices-build=frameworks
set react-native-skills=frameworks
set composition-patterns=frameworks

REM 集成类
set supabase-postgres-best-practices=integrations
set secret-management=integrations
set google-calendar=integrations
set google-docs=integrations
set google-drive=integrations
set google-sheets=integrations
set notion=integrations
set slack=integrations
set discord=integrations

REM 其他类
set engineering-team=others
set c-level-advisor=others
set marketing-skill=others
set web-design-guidelines=others
set using-git-worktrees=others
set using-superpowers=others

REM 高频核心技能（保持独立）
set daily-review=keep
set programming-workflow=keep
set pm-skills=keep
set project-standards=keep

echo === 检查目录存在 ===

REM 检查分类目录是否存在
for %%c in (pm-product development design documentation data-analysis tool-development web-api security-testing ai-ml frameworks integrations others) do (
    if not exist %%c (
        mkdir %%c
        echo 创建分类目录: %%c
    )
)

echo === 迁移技能目录 ===

REM 统计迁移数量
set moved_count=0
set skipped_count=0

for %%s in (pm-skills product-team project-management project-standards brainstorming planning-with-files executing-plans 
           coding-agent git-commit requesting-code-review receiving-code-review finishing-a-development-branch deploying-applications 
           writing-github-actions test-driven-development testing-strategies property-based-testing root-cause-tracing 
           verification-before-completion systematic-debugging frontend-design designing-layouts designing-apis canvas ui-ux-pro-max 
           ppt-style-guide composition-patterns building-forms building-tables building-secure-contracts writing-skills writing-plans 
           markdown-to-epub changelog-generator diagram-generator deep-research statistical-analysis visualizing-data matplotlib 
           d3js-visualization implementing-search-filter mcp-builder creating-skillsbasic skill-creator memory-systems context-fundamentals 
           skill-seekers skills-updater tool-design hugging-face-model-trainer hugging-face-datasets hugging-face-evaluation 
           hugging-face-cli hugging-face-trackio pytorch-lightning react-best-practices react-best-practices-build react-native-skills 
           supabase-postgres-best-practices secret-management google-calendar google-docs google-drive google-sheets notion slack discord 
           engineering-team c-level-advisor marketing-skill web-design-guidelines using-git-worktrees using-superpowers) do (
    
    if exist %%s (
        REM 检查是否为高频核心技能
        if "%%s"=="daily-review" goto skip_core
        if "%%s"=="programming-workflow" goto skip_core
        if "%%s"=="pm-skills" goto skip_core
        if "%%s"=="project-standards" goto skip_core
        
        set category=
        call set category=%%%s%
        
        if not defined category (
            echo 未定义分类: %%s
            set /a skipped_count+=1
            goto next_skill
        )
        
        if exist %category%/%%s (
            echo 目标已存在: %category%/%%s
            set /a skipped_count+=1
        ) else (
            move %%s %category%/
            echo 迁移: %%s -> %category%/
            set /a moved_count+=1
        )
        goto next_skill
        
        :skip_core
        echo 跳过核心技能: %%s (保持独立)
        set /a skipped_count+=1
        goto next_skill
        
        :next_skill
    ) else (
        echo 未找到: %%s
        set /a skipped_count+=1
    )
)

echo === 迁移完成 ===
echo 总迁移技能数: %moved_count%
echo 总跳过技能数: %skipped_count%
echo 核心技能保持独立: 4个

echo === 更新分类README.md ===

for %%c in (pm-product development design documentation data-analysis tool-development web-api security-testing ai-ml frameworks integrations others) do (
    echo # %%c 分类 > %%c/README.md
    echo. >> %%c/README.md
    echo ## 技能列表 >> %%c/README.md
    echo. >> %%c/README.md
    
    if exist %%c (
        for /d %%s in %%c/* do (
            echo - %%s >> %%c/README.md
        )
    ) else (
        echo - (暂无技能) >> %%c/README.md
    )
    
    echo 已更新: %%c/README.md
)

echo === 脚本执行完成 ===