# 🌐 浏览器自动化知识库

> 让 AI Agent 自动操作浏览器，实现自动化任务

## 概述

本知识库包含浏览器自动化的完整实现方案，包括：
- Puppeteer 使用指南
- Playwright 使用指南
- MCP 浏览器工具
- 自动化测试实践

## 核心价值

| 手动操作 | 浏览器自动化 |
|---------|-------------|
| 重复劳动 | 自动执行 |
| 易出错 | 精准稳定 |
| 效率低 | 批量处理 |
| 难以扩展 | 脚本复用 |

## 文档目录

| 文档 | 说明 |
|------|------|
| [Puppeteer 指南](puppeteer-guide.md) | Puppeteer 使用教程 |
| [Playwright 指南](playwright-guide.md) | Playwright 使用教程 |
| [MCP 浏览器工具](mcp-browser-tools.md) | MCP 集成方案 |
| [自动化测试](automation-testing.md) | 测试最佳实践 |

## 快速开始

### 1. 选择工具

| 工具 | 特点 | 适用场景 |
|------|------|---------|
| Puppeteer | Chrome 官方、轻量 | 爬虫、截图、PDF |
| Playwright | 跨浏览器、功能全 | 测试、自动化 |
| Selenium | 兼容性好、生态大 | 传统测试 |

### 2. 安装

```bash
# Puppeteer
npm install puppeteer

# Playwright
npm install playwright
npx playwright install
```

### 3. 基础示例

```javascript
const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  
  await page.goto('https://example.com');
  await page.screenshot({ path: 'screenshot.png' });
  
  await browser.close();
})();
```

## MCP 集成

### 配置

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-chrome"]
    }
  }
}
```

### 可用功能

| 功能 | 说明 |
|------|------|
| 导航 | 打开网页、前进后退 |
| 截图 | 全页截图、元素截图 |
| 点击 | 点击按钮、链接 |
| 输入 | 填写表单 |
| 提取 | 获取文本、属性 |
| 等待 | 等待元素、网络 |

## 使用场景

### 1. 数据采集

```javascript
// 爬取网页数据
const data = await page.evaluate(() => {
  return Array.from(document.querySelectorAll('.item')).map(el => ({
    title: el.querySelector('.title').textContent,
    price: el.querySelector('.price').textContent
  }));
});
```

### 2. 自动化测试

```javascript
// 登录测试
await page.goto('https://example.com/login');
await page.type('#username', 'user@example.com');
await page.type('#password', 'password');
await page.click('button[type="submit"]');
await page.waitForNavigation();
```

### 3. 截图生成

```javascript
// 全页截图
await page.goto('https://example.com');
await page.screenshot({ path: 'full.png', fullPage: true });

// 元素截图
const element = await page.$('#chart');
await element.screenshot({ path: 'chart.png' });
```

### 4. PDF 生成

```javascript
// 生成 PDF
await page.goto('https://example.com/report');
await page.pdf({
  path: 'report.pdf',
  format: 'A4',
  printBackground: true
});
```

## 最佳实践

### 1. 等待策略

```javascript
// 等待元素出现
await page.waitForSelector('#content');

// 等待网络空闲
await page.waitForLoadState('networkidle');

// 等待特定条件
await page.waitForFunction(() => {
  return document.querySelector('#result').textContent.includes('完成');
});
```

### 2. 错误处理

```javascript
try {
  await page.click('#button');
} catch (error) {
  console.error('点击失败:', error.message);
  // 截图保存现场
  await page.screenshot({ path: 'error.png' });
}
```

### 3. 反爬虫应对

```javascript
// 设置 User-Agent
await page.setUserAgent('Mozilla/5.0...');

// 隐藏自动化特征
await page.evaluateOnNewDocument(() => {
  Object.defineProperty(navigator, 'webdriver', {
    get: () => false
  });
});
```

## 故障排除

### 问题：元素找不到

```javascript
// 使用更宽松的选择器
await page.waitForSelector('#content', { timeout: 10000 });

// 或使用 XPath
await page.waitForSelector('xpath=//div[contains(text(), "内容")]');
```

### 问题：超时

```javascript
// 增加超时时间
await page.goto('https://example.com', {
  timeout: 60000,
  waitUntil: 'domcontentloaded'
});
```

---

**创建时间**：2026-03-13
**来源**：Puppeteer/Playwright 官方文档 + 实战经验
