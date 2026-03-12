#!/bin/bash
# Git 代码审查检查脚本
# 用于 PR 审查和本地检查

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 统计变量
WARNINGS=0
ERRORS=0

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}       Git 代码审查检查${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 获取变更文件
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    if [ -n "$(git diff --cached --name-only 2>/dev/null)" ]; then
        CHANGED_FILES=$(git diff --cached --name-only)
        echo -e "${YELLOW}📁 检查暂存区文件...${NC}"
    elif [ -n "$(git diff --name-only 2>/dev/null)" ]; then
        CHANGED_FILES=$(git diff --name-only)
        echo -e "${YELLOW}📁 检查工作区文件...${NC}"
    else
        echo -e "${GREEN}✅ 没有发现变更文件${NC}"
        exit 0
    fi
else
    echo -e "${RED}❌ 不在 Git 仓库中${NC}"
    exit 1
fi

echo ""

# 1. 检查敏感信息
echo -e "${BLUE}🔐 检查敏感信息...${NC}"
SENSITIVE_PATTERNS=(
    "password\s*=\s*[\"'][^\"']+[\"']"
    "api_key\s*=\s*[\"'][^\"']+[\"']"
    "secret\s*=\s*[\"'][^\"']+[\"']"
    "token\s*=\s*[\"'][^\"']+[\"']"
    "private_key\s*=\s*[\"'][^\"']+[\"']"
    "-----BEGIN.*PRIVATE KEY-----"
)

FOUND_SENSITIVE=false
for pattern in "${SENSITIVE_PATTERNS[@]}"; do
    if echo "$CHANGED_FILES" | xargs grep -E "$pattern" 2>/dev/null; then
        FOUND_SENSITIVE=true
        break
    fi
done

if [ "$FOUND_SENSITIVE" = true ]; then
    echo -e "${RED}❌ 发现可能的敏感信息！请检查以下文件：${NC}"
    echo "$CHANGED_FILES" | xargs grep -l -E "${SENSITIVE_PATTERNS[0]}" 2>/dev/null || true
    ERRORS=$((ERRORS + 1))
else
    echo -e "${GREEN}   ✅ 未发现敏感信息${NC}"
fi

# 2. 检查大文件
echo ""
echo -e "${BLUE}📦 检查文件大小...${NC}"
MAX_SIZE=$((1 * 1024 * 1024))  # 1MB

for file in $CHANGED_FILES; do
    if [ -f "$file" ]; then
        size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null || echo 0)
        if [ "$size" -gt "$MAX_SIZE" ]; then
            echo -e "${YELLOW}   ⚠️  大文件: $file ($(echo "scale=2; $size / 1024 / 1024" | bc)MB)${NC}"
            WARNINGS=$((WARNINGS + 1))
        fi
    fi
done

if [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}   ✅ 文件大小正常${NC}"
fi

# 3. 检查代码风格（如果配置了 linter）
echo ""
echo -e "${BLUE}🎨 检查代码风格...${NC}"

# ESLint
if [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ] || [ -f ".eslintrc.yml" ]; then
    if command -v npx &> /dev/null; then
        echo "   运行 ESLint..."
        npx eslint $CHANGED_FILES --ext .js,.ts,.vue,.jsx,.tsx 2>/dev/null && echo -e "${GREEN}   ✅ ESLint 检查通过${NC}" || {
            echo -e "${YELLOW}   ⚠️  ESLint 发现问题${NC}"
            WARNINGS=$((WARNINGS + 1))
        }
    fi
fi

# Prettier
if [ -f ".prettierrc" ] || [ -f ".prettierrc.js" ] || [ -f ".prettierrc.json" ]; then
    if command -v npx &> /dev/null; then
        echo "   运行 Prettier 检查..."
        npx prettier --check $CHANGED_FILES 2>/dev/null && echo -e "${GREEN}   ✅ Prettier 检查通过${NC}" || {
            echo -e "${YELLOW}   ⚠️  Prettier 格式不一致${NC}"
            WARNINGS=$((WARNINGS + 1))
        }
    fi
fi

# 4. 检查测试覆盖率（如果有测试）
echo ""
echo -e "${BLUE}🧪 检查测试...${NC}"

if [ -f "package.json" ]; then
    if grep -q "\"test\"" package.json; then
        echo "   运行测试..."
        npm test -- --passWithNoTests 2>/dev/null && echo -e "${GREEN}   ✅ 测试通过${NC}" || {
            echo -e "${RED}   ❌ 测试失败${NC}"
            ERRORS=$((ERRORS + 1))
        }
    else
        echo -e "${YELLOW}   ⚠️  未配置测试脚本${NC}"
    fi
fi

# 5. 检查文档更新
echo ""
echo -e "${BLUE}📝 检查文档...${NC}"

DOC_FILES=$(echo "$CHANGED_FILES" | grep -E "(README|CHANGELOG|docs/)" || true)
CODE_FILES=$(echo "$CHANGED_FILES" | grep -vE "(README|CHANGELOG|docs/|\.md$)" || true)

if [ -n "$CODE_FILES" ] && [ -z "$DOC_FILES" ]; then
    echo -e "${YELLOW}   ⚠️  代码变更但未更新文档${NC}"
    WARNINGS=$((WARNINGS + 1))
else
    echo -e "${GREEN}   ✅ 文档已更新或无需更新${NC}"
fi

# 6. 变更统计
echo ""
echo -e "${BLUE}📊 变更统计...${NC}"

TOTAL_FILES=$(echo "$CHANGED_FILES" | wc -l)
ADDITIONS=0
DELETIONS=0

if [ -n "$(git diff --cached --stat 2>/dev/null)" ]; then
    STATS=$(git diff --cached --stat | tail -1)
elif [ -n "$(git diff --stat 2>/dev/null)" ]; then
    STATS=$(git diff --stat | tail -1)
fi

echo "   变更文件: $TOTAL_FILES 个"
echo "   $STATS"

# 总结
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}       审查结果总结${NC}"
echo -e "${BLUE}========================================${NC}"

if [ $ERRORS -gt 0 ]; then
    echo -e "${RED}❌ 发现 $ERRORS 个错误，请修复后提交${NC}"
    exit 1
elif [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}⚠️  发现 $WARNINGS 个警告，建议检查${NC}"
    exit 0
else
    echo -e "${GREEN}✅ 所有检查通过${NC}"
    exit 0
fi
