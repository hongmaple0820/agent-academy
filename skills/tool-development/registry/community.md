# 社区技能注册表

> 仅记录安装方法，不存储完整代码

---

## one-search-mcp
- **功能**：多搜索引擎 MCP 服务器（Tavily、DuckDuckGo、Bing、SearXNG）
- **类型**：MCP 服务器
- **安装**：
  ```bash
  npm install -g one-search-mcp
  ```
- **配置**：
  ```json
  {
    "mcpServers": {
      "one-search": {
        "command": "npx",
        "args": ["-y", "one-search-mcp"],
        "env": {
          "SEARCH_PROVIDER": "duckduckgo"
        }
      }
    }
  }
  ```
- **GitHub**：https://github.com/fatwang2/one-search-mcp
- **已知问题**：
  - Tavily API Key 传递问题
  - DuckDuckGo VQD token 获取失败
  - 详见：`knowledge/issues/openclaw-mcp-integration-issues.md`

---

## playwright
- **功能**：浏览器自动化测试
- **类型**：Node.js 库
- **安装**：
  ```bash
  npm install -g playwright
  npx playwright install chromium
  ```
- **文档**：https://playwright.dev
- **使用示例**：
  ```javascript
  const { chromium } = require('playwright');
  
  (async () => {
    const browser = await chromium.launch({ 
      headless: true,
      executablePath: '/usr/bin/google-chrome',
      args: ['--no-sandbox', '--disable-setuid-sandbox']
    });
    
    const page = await browser.newPage();
    await page.goto('https://example.com');
    await browser.close();
  })();
  ```
- **WSL 配置**：见 `learnings/2026-02-14-wsl-gui-playwright.md`

---

## agent-browser
- **功能**：AI 代理专用浏览器自动化 CLI
- **类型**：CLI 工具
- **安装**：
  ```bash
  npm install -g agent-browser
  ```
- **文档**：https://github.com/agent-browser/agent-browser
- **使用示例**：
  ```bash
  agent-browser open https://example.com
  agent-browser click "button.submit"
  agent-browser type "#input" "Hello"
  agent-browser screenshot output.png
  agent-browser snapshot  # AI 可读的 accessibility tree
  ```

---

## firecrawl-mcp
- **功能**：网页抓取和爬虫 MCP 服务器
- **类型**：MCP 服务器
- **安装**：
  ```bash
  npm install -g @firecrawl/mcp-server
  ```
- **配置**：
  ```json
  {
    "mcpServers": {
      "firecrawl": {
        "command": "npx",
        "args": ["-y", "@firecrawl/mcp-server"],
        "env": {
          "FIRECRAWL_API_KEY": "your-api-key"
        }
      }
    }
  }
  ```
- **文档**：https://www.firecrawl.dev

---

## browserbase-mcp
- **功能**：云端浏览器自动化 MCP 服务器
- **类型**：MCP 服务器
- **安装**：
  ```bash
  npm install -g @browserbase/mcp-server
  ```
- **配置**：
  ```json
  {
    "mcpServers": {
      "browserbase": {
        "command": "npx",
        "args": ["-y", "@browserbase/mcp-server"],
        "env": {
          "BROWSERBASE_API_KEY": "your-api-key",
          "BROWSERBASE_PROJECT_ID": "your-project-id"
        }
      }
    }
  }
  ```
- **文档**：https://www.browserbase.com

---

*来源: 社区贡献*  
*最后更新: 2026-02-15 03:43*
