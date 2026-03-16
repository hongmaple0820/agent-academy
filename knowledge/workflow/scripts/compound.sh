#!/bin/bash
# 枫林工作流 - 知识沉淀自动化脚本
# 自动从 daily 日志提取有价值内容

WORKSPACE="/home/maple/.openclaw/workspace"
MEMORY_DIR="$WORKSPACE/memory"
DAILY_DIR="$MEMORY_DIR/daily"

# 获取今天的日期
TODAY=$(date +%Y-%m-%d)
TODAY_FILE="$DAILY_DIR/$TODAY.md"

# 创建 daily 目录（如果不存在）
mkdir -p "$DAILY_DIR"

# 函数：追加到今日日志
append_to_daily() {
    local content="$1"
    if [ ! -f "$TODAY_FILE" ]; then
        echo -e "# $TODAY 工作日志\n\n" > "$TODAY_FILE"
    fi
    echo -e "$content" >> "$TODAY_FILE"
}

# 函数：记录项目开始
log_project_start() {
    local project_name="$1"
    local complexity="$2"
    append_to_daily "\n## $(date +%H:%M) 项目开始\n\n- **项目**: $project_name\n- **复杂度**: $complexity\n- **状态**: 进行中\n"
}

# 函数：记录项目完成
log_project_complete() {
    local project_name="$1"
    local duration="$2"
    local result="$3"
    local key_decisions="$4"
    local issues="$5"
    local solutions="$6"
    
    append_to_daily "\n## $(date +%H:%M) 项目完成\n\n- **项目**: $project_name\n- **耗时**: $duration\n- **结果**: $result\n- **关键决策**: $key_decisions\n- **遇到的问题**: $issues\n- **解决方案**: $solutions\n"
}

# 函数：记录经验教训（有价值时）
log_lesson() {
    local lesson="$1"
    local category="$2"  # technical | process | tool
    local lessons_file="$MEMORY_DIR/core/lessons.md"
    
    # 确保 lessons.md 存在
    if [ ! -f "$lessons_file" ]; then
        mkdir -p "$MEMORY_DIR/core"
        echo -e "# 经验教训\n\n> 自动收集自日常工作\n" > "$lessons_file"
    fi
    
    # 追加经验教训
    echo -e "\n## $(date +%Y-%m-%d) [$category]\n\n$lesson\n" >> "$lessons_file"
}

# 函数：创建解决方案文档（解决有价值问题时）
create_solution_doc() {
    local problem="$1"
    local solution="$2"
    local tags="$3"
    local solutions_dir="$WORKSPACE/docs/solutions"
    
    mkdir -p "$solutions_dir"
    
    local filename="$(date +%Y-%m-%d)-$(echo "$problem" | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | cut -c1-30).md"
    local filepath="$solutions_dir/$filename"
    
    cat > "$filepath" << EOF
---
date: $(date +%Y-%m-%d)
tags: [$tags]
---

# $problem

## 问题描述

$problem

## 解决方案

$solution

## 参考

- 记录时间: $(date +%Y-%m-%d)
- 来源: 实际项目经验
EOF

    echo "Created: $filepath"
}

# 主函数
main() {
    case "$1" in
        start)
            log_project_start "$2" "$3"
            ;;
        complete)
            log_project_complete "$2" "$3" "$4" "$5" "$6" "$7"
            ;;
        lesson)
            log_lesson "$2" "$3"
            ;;
        solution)
            create_solution_doc "$2" "$3" "$4"
            ;;
        *)
            echo "Usage:"
            echo "  $0 start <project_name> <complexity>"
            echo "  $0 complete <project_name> <duration> <result> <key_decisions> <issues> <solutions>"
            echo "  $0 lesson <lesson_content> <category>"
            echo "  $0 solution <problem> <solution> <tags>"
            ;;
    esac
}

main "$@"
