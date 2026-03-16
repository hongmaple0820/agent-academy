# Playwright 技能使用示例

> 使用 `playwright-skill` 进行浏览器自动化测试和网页抓取

## 📋 场景说明

**场景**: 网页自动化测试、截图、数据抓取
**技能**: playwright-skill
**支持**: Chromium、Firefox、WebKit

---

## 💬 完整对话示例

### 示例 1: 网页截图

```
用户：帮我截一张 baidu.com 的首页。

小熊：好的！使用 Playwright 截图。🐻

📸 **执行截图**
```javascript
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto('https://www.baidu.com');
  await page.screenshot({ 
    path: 'baidu-homepage.png',
    fullPage: true 
  });
  await browser.close();
})();
```

✅ 截图完成！
文件：`baidu-homepage.png`
尺寸：1920x4800 (全屏)

需要我调整视口大小或只截取可见区域吗？
```

### 示例 2: 自动化登录测试

```
用户：测试一下 chat-hub 的登录功能。

小熊：使用 Playwright 进行 E2E 测试。🐻

🧪 **测试脚本**
```javascript
const { test, expect } = require('@playwright/test');

test('用户登录成功', async ({ page }) => {
  // 访问登录页
  await page.goto('http://localhost:3000/login');
  
  // 填写表单
  await page.fill('#username', 'testuser');
  await page.fill('#password', 'password123');
  await page.click('button[type="submit"]');
  
  // 验证登录成功
  await expect(page).toHaveURL('http://localhost:3000/dashboard');
  await expect(page.locator('.welcome-message'))
    .toContainText('欢迎，testuser');
});
```

**运行测试**:
```bash
npx playwright test login.spec.js
```

✅ 测试通过！
- 登录页面加载正常
- 表单提交成功
- 重定向到仪表盘
- 欢迎消息显示正确

需要我添加更多测试用例吗？
```

### 示例 3: 网页数据抓取

```
用户：帮我抓取 GitHub  trending 页面的项目列表。

小熊：使用 Playwright 抓取数据。🐻

📊 **抓取脚本**
```javascript
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.goto('https://github.com/trending');
  
  // 提取项目信息
  const projects = await page.$$eval('.Box-row', rows => {
    return rows.map(row => {
      const titleEl = row.querySelector('h2 a');
      const descEl = row.querySelector('.py-1 p');
      const starsEl = row.querySelector('.Link--muted');
      
      return {
        name: titleEl?.textContent.trim(),
        url: titleEl?.href,
        description: descEl?.textContent.trim(),
        stars: starsEl?.textContent.trim()
      };
    });
  });
  
  await browser.close();
  
  console.log(JSON.stringify(projects, null, 2));
})();
```

**抓取结果**:
```json
[
  {
    "name": "openclaw/openclaw",
    "url": "https://github.com/openclaw/openclaw",
    "description": "AI 助手框架",
    "stars": "1.2k stars"
  },
  {
    "name": "phuryn/pm-skills",
    "url": "https://github.com/phuryn/pm-skills",
    "description": "产品经理技能包",
    "stars": "856 stars"
  }
]
```

✅ 成功抓取 25 个项目！
需要我保存到文件吗？
```

### 示例 4: 性能测试

```
用户：测试一下 chat-hub 首页的加载性能。

小熊：使用 Playwright 进行性能分析。🐻

⚡ **性能测试脚本**
```javascript
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  
  // 开始性能监控
  const client = await page.context().newCDPSession(page);
  await client.send('Performance.enable');
  
  // 访问页面
  const startTime = Date.now();
  await page.goto('http://localhost:3000');
  const loadTime = Date.now() - startTime;
  
  // 获取性能指标
  const metrics = await client.send('Performance.getMetrics');
  
  await browser.close();
  
  console.log('加载时间:', loadTime, 'ms');
  console.log('性能指标:', metrics);
})();
```

**性能报告**:
```
📊 chat-hub 首页性能

加载时间：1250ms

核心指标:
- First Contentful Paint: 450ms
- DOM Content Loaded: 800ms
- Load Complete: 1250ms
- Total DOM Nodes: 1,245
- JS Heap Size: 12.5MB

性能评分：85/100

建议:
✅ 加载速度快 (<2s)
⚠️ DOM 节点较多 (>1000)
⚠️ JS 堆内存偏大 (>10MB)
```

需要我优化建议吗？
```

---

## 🔧 高级用法

### 1. 无头模式 vs 有头模式

```javascript
// 无头模式（CI/CD、服务器）
const browser = await chromium.launch({
  headless: true
});

// 有头模式（调试、演示）
const browser = await chromium.launch({
  headless: false,
  slowMo: 100  // 慢动作，方便观察
});
```

### 2. 多浏览器测试

```javascript
const { chromium, firefox, webkit } = require('playwright');

// 测试所有浏览器
for (const browserType of [chromium, firefox, webkit]) {
  const browser = await browserType.launch();
  const page = await browser.newPage();
  await page.goto('https://example.com');
  // ... 测试逻辑
  await browser.close();
}
```

### 3. 处理弹窗和对话框

```javascript
// 处理 alert
page.on('dialog', async dialog => {
  console.log(dialog.message());
  await dialog.accept();
});

// 处理新窗口
const [newPage] = await Promise.all([
  context.waitForEvent('page'),
  page.click('a[target="_blank"]')
]);
```

### 4. 等待元素

```javascript
// 等待元素出现
await page.waitForSelector('.content');

// 等待元素可见
await page.waitForSelector('.content', { state: 'visible' });

// 等待特定时间
await page.waitForTimeout(1000);

// 等待网络空闲
await page.waitForLoadState('networkidle');
```

---

## 📁 项目结构

```
playwright-tests/
├── tests/
│   ├── login.spec.js        # 登录测试
│   ├── search.spec.js       # 搜索测试
│   └── e2e/
│       └── checkout.spec.js # 结账流程
├── pages/
│   ├── LoginPage.js         # 页面对象
│   ├── DashboardPage.js
│   └── base.js              # 基类
├── utils/
│   └── test-data.js         # 测试数据
├── playwright.config.js     # 配置文件
└── package.json
```

---

## 💡 最佳实践

### 1. 使用页面对象模式
```javascript
class LoginPage {
  constructor(page) {
    this.page = page;
    this.usernameInput = page.locator('#username');
    this.passwordInput = page.locator('#password');
    this.submitButton = page.locator('button[type="submit"]');
  }
  
  async login(username, password) {
    await this.usernameInput.fill(username);
    await this.passwordInput.fill(password);
    await this.submitButton.click();
  }
}
```

### 2. 使用 Fixtures
```javascript
const { test, expect } = require('@playwright/test');

test.use({
  viewport: { width: 1920, height: 1080 },
  baseURL: 'http://localhost:3000'
});

test('测试用例', async ({ page }) => {
  // 自动使用配置的 viewport 和 baseURL
});
```

### 3. 截图和录屏
```javascript
// 失败时自动截图
test.afterEach(async ({ page }, testInfo) => {
  if (testInfo.status !== testInfo.expectedStatus) {
    await page.screenshot({ path: `failures/${testInfo.title}.png` });
  }
});

// 录屏
const video = await page.recordVideo({ dir: 'videos/' });
```

---

## 🔗 相关技能

- `test-driven-development` - 测试驱动开发
- `systematic-debugging` - 系统调试
- `web-scraping` - 网页抓取
- `visual-regression` - 视觉回归测试

---

*示例版本：v1.0*
*更新时间：2026-03-14*
