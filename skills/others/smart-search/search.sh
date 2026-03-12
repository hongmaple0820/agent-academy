#!/bin/bash
# 智能搜索脚本 v3.1 - 完整版
# 支持: DuckDuckGo (免费) / Tavily (深度) / web_fetch (已知URL)

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 显示帮助
show_help() {
  echo "🔍 智能搜索工具 v3.1"
  echo ""
  echo "用法:"
  echo "  search.sh <查询内容>              # 自动选择最佳方式"
  echo "  search.sh --url <URL>             # 抓取指定网页"
  echo "  search.sh --deep <查询内容>       # 强制深度搜索 (Tavily)"
  echo "  search.sh --quick <查询内容>      # 强制快速搜索 (DuckDuckGo)"
  echo ""
  echo "示例:"
  echo "  search.sh Docker 容器技术"
  echo "  search.sh --url https://example.com"
  echo "  search.sh --deep AI 发展趋势分析"
  echo ""
  exit 0
}

# 检查参数
if [ $# -eq 0 ]; then
  show_help
fi

# DuckDuckGo 搜索
search_duckduckgo() {
  local query="$1"
  echo -e "${BLUE}🦆 DuckDuckGo 搜索: $query${NC}"
  echo ""

  # URL 编码
  local encoded=$(echo "$query" | sed 's/ /+/g')

  # 调用 API
  curl -s "https://api.duckduckgo.com/?q=${encoded}&format=json&no_html=1" > /tmp/ddg.json

  # 提取结果
  local abstract=$(grep -oP '"AbstractText"\s*:\s*"\K[^"]+' /tmp/ddg.json | head -1)
  local source=$(grep -oP '"AbstractSource"\s*:\s*"\K[^"]+' /tmp/ddg.json | head -1)
  local url=$(grep -oP '"AbstractURL"\s*:\s*"\K[^"]+' /tmp/ddg.json | head -1)

  if [ -n "$abstract" ]; then
    echo -e "${GREEN}✅ 找到即时答案${NC}"
    echo ""
    echo "📝 摘要:"
    echo "$abstract"
    echo ""
    [ -n "$source" ] && echo "📌 来源: $source"
    [ -n "$url" ] && echo "🔗 链接: $url"
  else
    echo -e "${YELLOW}⚠️  未找到直接答案，显示相关主题${NC}"
    echo ""

    # 提取相关主题
    local topics=$(grep -oP '"Text"\s*:\s*"\K[^"]+' /tmp/ddg.json | head -5)

    if [ -n "$topics" ]; then
      echo "📚 相关主题:"
      echo "$topics" | while read -r line; do
        echo "• $line"
      done
    else
      echo "💡 建议: 尝试更具体的关键词或使用深度搜索"
      echo "   search.sh --deep \"$query\""
    fi
  fi

  echo ""
  echo "💾 完整结果: /tmp/ddg.json"
}

# Tavily 深度搜索
search_tavily() {
  local query="$1"

  # 检查 API Key
  if [ -z "$TAVILY_API_KEY" ]; then
    echo -e "${RED}❌ 错误: 未设置 TAVILY_API_KEY 环境变量${NC}"
    echo ""
    echo "请设置: export TAVILY_API_KEY=\"tvly-your-key\""
    echo "或使用免费的 DuckDuckGo: search.sh --quick \"$query\""
    exit 1
  fi

  echo -e "${CYAN}🔍 Tavily 深度搜索: $query${NC}"
  echo ""cho ""

  # 调用 Tavily API
  local response=$(curl -s -X POST "https://api.tavily.com/search" \
    -H "Content-Type: application/json" \
    -d "{
      \"api_key\": \"$TAVILY_API_KEY\",
      \"query\": \"$query\",
      \"search_depth\": \"advanced\",
      \"max_results\": 5,
      \"include_answer\": true
    }")

  # 保存完整结果
  echo "$response" > /tmp/tavily.json

  # 检查是否有错误
  local error=$(echo "$response" | grep -oP '"error"\s*:\s*"\K[^"]+' | head -1)

  if [ -n "$error" ]; then
    echo -e "${RED}❌ API 错误: $error${NC}"
    echo ""
    echo "💡 降级使用 DuckDuckGo..."
    echo ""
    search_duckduckgo "$query"
    return
  fi

  # 提取 AI 综合答案
  local answer=$(echo "$response" | grep -oP '"answer"\s*:\s*"\K[^"]+' | head -1)

  if [ -n "$answer" ]; then
    echo -e "${GREEN}✅ AI 综合答案${NC}"
    echo ""
    echo "$answer"
    echo ""
  fi

  # 提取搜索结果
  echo "📚 搜索结果:"
  echo ""

  # 使用 Python 解析（如果可用）
  if command -v python3 &> /dev/null; then
    python3 << 'PYEOF'
import json
import sys

try:
    with open('/tmp/tavily.json', 'r') as f:
        data = json.load(f)

    results = data.get('results', [])

    for i, result in enumerate(results[:5], 1):
        print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        print(f"{i}. {result.get('title', 'N/A')}")
        print(f"🔗 {result.get('url', 'N/A')}")

        content = result.get('content', '')
        if content:
            # 截取前200字符
            preview = content[:200] + "..." if len(content) > 200 else content
            print(f"📝 {preview}")

        score = result.get('score', 0)
        print(f"⭐ 相关度: {score:.2f}")
        print()

except Exception as e:
    print(f"解析错误: {e}")
PYEOF
  else
    # 简单提取（无 Python）
    local titles=$(grep -oP '"title"\s*:\s*"\K[^"]+' /tmp/tavily.json | head -5)
    local urls=$(grep -oP '"url"\s*:\s*"\K[^"]+' /tmp/tavily.json | head -5)

    local count=1
    while IFS= read -r title && IFS= read -r url <&3; do
      echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      echo "$count. $title"
      echo "🔗 $url"
      echo ""
      count=$((count + 1))
    done <<< "$titles" 3<<< "$urls"
  fi

  echo "💾 完整结果: /tmp/tavily.json"
}

# 抓取网页
fetch_url() {
  local url="$1"
  echo -e "${BLUE}🌐 抓取网页: $url${NC}"
  echo ""

  curl -s -L "$url" > /tmp/page.html

  if [ ! -s /tmp/page.html ]; then
    echo -e "${RED}❌ 无法访问网页${NC}"
    exit 1
  fi

  # 提取标题
  local title=$(grep -oP '<title>\K[^<]+' /tmp/page.html | head -1)
  [ -n "$title" ] && echo "📄 标题: $title" && echo ""

  # 显示内容预览
  echo "📝 内容预览:"
  sed 's/<[^>]*>//g' /tmp/page.html | sed '/^\s*$/d' | head -30

  echo ""
  echo "💾 完整内容: /tmp/page.html"
}

# 智能选择搜索方式
smart_search() {
  local query="$1"

  # 判断是否为 URL
  if [[ "$query" =~ ^https?:// ]]; then
    echo -e "${YELLOW}🤖 检测到 URL，使用 web_fetch 模式${NC}"
    echo ""
    fetch_url "$query"
    return
  fi

  # 判断是否需要深度搜索（关键词检测）
  if [[ "$query" =~ (趋势|分析|研究|对比|评测|深度|详细|报告|如何|怎么) ]]; then
    echo -e "${YELLOW}🤖 检测到深度查询关键词，使用 Tavily${NC}"
    e
    if [ -n "$TAVILY_API_KEY" ]; then
      search_tavily "$query"
    else
      echo -e "${YELLOW}⚠️  未配置 Tavily，降级使用 DuckDuckGo${NC}"
      echo ""
      search_duckduckgo "$query"
    fi
    return
  fi

  # 默认使用 DuckDuckGo（快速且免费）
  echo -e "${YELLOW}🤖 使用快速搜索模式 (DuckDuckGo)${NC}"
  echo ""
  search_duckduckgo "$query"
}

# 主逻辑
case "$1" in
  -h|--help)
    show_help
    ;;
  --url)
    [ -z "$2" ] && echo -e "${RED}❌ 请提供 URL${NC}" && exit 1
    fetch_url "$2"
    ;;
  --deep)
    [ -z "$2" ] && echo -e "${RED}❌ 请提供搜索内容${NC}" && exit 1
    shift
    search_tavily "$*"
    ;;
  --quick)
    [ -z "$2" ] && echo -e "${RED}❌ 请提供搜索内容${NC}" && exit 1
    shift
    search_duckduckgo "$*"
    ;;
  *)
    smart_search "$*"
    ;;
esac
