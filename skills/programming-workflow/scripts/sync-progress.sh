#!/bin/bash
# sync-progress.sh - 同步项目进度到任务看板

set -e

PROJECT_DIR=${1:-"."}
TASK_FILE="${PROJECT_DIR}/tasks/$(basename ${PROJECT_DIR}).md"

if [ ! -f "${TASK_FILE}" ]; then
    echo "❌ 未找到任务看板: ${TASK_FILE}"
    exit 1
fi

echo "📊 项目进度同步"
echo ""

# 统计任务
TODO=$(grep -c "^\- \[ \]" "${TASK_FILE}" 2>/dev/null || echo 0)
DONE=$(grep -c "^\- \[x\]" "${TASK_FILE}" 2>/dev/null || echo 0)
TOTAL=$((TODO + DONE))

if [ ${TOTAL} -eq 0 ]; then
    echo "暂无任务"
    exit 0
fi

PERCENT=$((DONE * 100 / TOTAL))

echo "📋 任务统计:"
echo "   待办: ${TODO}"
echo "   完成: ${DONE}"
echo "   总计: ${TOTAL}"
echo "   进度: ${PERCENT}%"
echo ""

# 生成进度条
BAR=""
for i in $(seq 1 $((PERCENT / 5))); do
    BAR="${BAR}█"
done
for i in $(seq $((PERCENT / 5 + 1)) 20); do
    BAR="${BAR}░"
done

echo "   [${BAR}] ${PERCENT}%"

# 检查是否需要提交
cd "${PROJECT_DIR}"
if git diff --quiet 2>/dev/null; then
    echo ""
    echo "✅ 无变更需要提交"
else
    echo ""
    echo "⚠️ 有未提交的变更，请及时提交"
fi