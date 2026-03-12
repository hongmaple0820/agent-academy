#!/bin/bash
# Git 提交规范检查脚本
# 用于 Git commit-msg hook

set -e

# 获取提交消息文件
COMMIT_MSG_FILE=$1
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 提交消息格式正则（Conventional Commits）
# 格式：<type>(<scope>): <subject>
PATTERN="^(feat|fix|docs|style|refactor|test|chore|ci|perf|build|revert)(\(.+\))?: .{1,50}$"

# 类型说明
declare -A TYPE_DESC
TYPE_DESC["feat"]="新功能"
TYPE_DESC["fix"]="Bug 修复"
TYPE_DESC["docs"]="文档更新"
TYPE_DESC["style"]="代码格式（不影响代码运行的变动）"
TYPE_DESC["refactor"]="重构（既不是新增功能，也不是修改 bug 的代码变动）"
TYPE_DESC["test"]="增加测试"
TYPE_DESC["chore"]="构建过程或辅助工具的变动"
TYPE_DESC["ci"]="CI/CD 配置变动"
TYPE_DESC["perf"]="性能优化"
TYPE_DESC["build"]="构建系统或外部依赖项的更改"
TYPE_DESC["revert"]="回退之前的 commit"

echo -e "${YELLOW}🔍 检查提交消息格式...${NC}"

# 检查是否为空
if [ -z "$COMMIT_MSG" ]; then
    echo -e "${RED}❌ 提交消息不能为空！${NC}"
    exit 1
fi

# 检查格式
if ! echo "$COMMIT_MSG" | grep -qE "$PATTERN"; then
    echo -e "${RED}❌ 提交消息格式错误！${NC}"
    echo ""
    echo -e "${YELLOW}正确格式：<type>(<scope>): <subject>${NC}"
    echo ""
    echo -e "${YELLOW}示例：${NC}"
    echo "  feat: add user authentication"
    echo "  fix(api): resolve timeout issue"
    echo "  docs: update installation guide"
    echo "  refactor(utils): extract helper function"
    echo ""
    echo -e "${YELLOW}可用类型：${NC}"
    for type in "${!TYPE_DESC[@]}"; do
        printf "  %-12s %s\n" "$type" "${TYPE_DESC[$type]}"
    done
    echo ""
    echo -e "${YELLOW}您的消息：${NC}"
    echo "  $COMMIT_MSG"
    exit 1
fi

# 提取类型
TYPE=$(echo "$COMMIT_MSG" | grep -oE "^(feat|fix|docs|style|refactor|test|chore|ci|perf|build|revert)")

echo -e "${GREEN}✅ 提交消息格式正确${NC}"
echo -e "   类型: ${TYPE} - ${TYPE_DESC[$TYPE]}"

# 检查是否需要 Issue 关联（可选）
# if ! echo "$COMMIT_MSG" | grep -qE "#[0-9]+"; then
#     echo -e "${YELLOW}⚠️  建议关联 Issue（在消息中添加 #issue_number）${NC}"
# fi

exit 0
