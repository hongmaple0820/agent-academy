# 安全与测试类（security-testing）

> 更新时间：2026-03-13
> 分类说明：代码测试、安全验证、漏洞检测等技能

---

## 一、分类说明

本分类专注于软件安全和测试相关技能，包括：

- **安全测试**：漏洞扫描、渗透测试、安全审计
- **代码安全**：静态分析、安全编码、敏感数据检测
- **测试策略**：单元测试、集成测试、E2E测试
- **安全工具**：Semgrep、安全扫描器、加密验证

---

## 二、技能列表

| 技能名称 | 说明 | 状态 |
|---------|------|------|
| *暂无技能* | 待迁移相关技能 | - |

---

## 三、适合迁移到此分类的技能

根据优化建议，以下技能适合迁移到此分类：

| 技能名称 | 原位置 | 迁移原因 |
|---------|--------|---------|
| `insecure-defaults` | skills/ | 安全默认值检测 |
| `semgrep-rule-creator` | skills/ | Semgrep规则创建 |
| `constant-time-analysis` | skills/ | 常量时间分析（加密安全） |

---

## 四、技能分类标准

### 4.1 归类标准

符合以下任一条件的技能应归类到本分类：

1. **关键词匹配**：
   - security, secure, insecure
   - test, testing, tdd
   - vulnerability, exploit, cve
   - scan, audit, verify
   - encrypt, decrypt, crypto

2. **功能匹配**：
   - 检测安全漏洞
   - 执行代码测试
   - 进行安全审计
   - 分析加密算法

3. **工具匹配**：
   - Semgrep, SonarQube
   - OWASP工具
   - 测试框架

### 4.2 排除标准

以下情况不应归类到本分类：

- 通用开发工具 → `development`
- 数据验证（非安全相关）→ `data-analysis`

---

## 五、安全测试工具概览

### 5.1 静态分析工具

| 工具 | 用途 | 特点 |
|------|------|------|
| Semgrep | 静态分析 | 支持多种语言，规则可定制 |
| SonarQube | 代码质量 | 持续集成友好 |
| ESLint | JS/TS | 前端常用 |

### 5.2 安全测试类型

| 测试类型 | 说明 | 工具示例 |
|---------|------|---------|
| **SAST** | 静态应用安全测试 | Semgrep, Checkmarx |
| **DAST** | 动态应用安全测试 | OWASP ZAP, Burp Suite |
| **SCA** | 软件成分分析 | Snyk, Dependabot |
| **IAST** | 交互式应用安全测试 | Contrast Security |

---

## 六、使用指南

### 6.1 查找技能

```bash
# 查看本分类下的所有技能
ls skills/security-testing/

# 搜索安全相关技能
find skills/security-testing -name "*security*"
```

### 6.2 添加新技能

1. 确定技能符合本分类标准
2. 将技能目录移动到 `skills/security-testing/`
3. 更新本文档的技能列表

---

## 七、安全最佳实践

### 7.1 代码安全检查清单

- [ ] 输入验证和清理
- [ ] 输出编码
- [ ] 认证和授权
- [ ] 敏感数据保护
- [ ] 错误处理
- [ ] 日志记录

### 7.2 常见安全漏洞

| 漏洞类型 | OWASP Top 10 | 检测工具 |
|---------|--------------|---------|
| SQL注入 | A03:2021 | Semgrep |
| XSS | A03:2021 | ESLint插件 |
| CSRF | A01:2021 | Burp Suite |
| 敏感数据暴露 | A02:2021 | GitLeaks |

---

## 八、相关资源

- [OWASP Top 10](https://owasp.org/Top10/)
- [Semgrep规则库](https://semgrep.dev/explore)
- [CWE漏洞列表](https://cwe.mitre.org/)
- [技能目录索引](../../README.md)

---

*维护者：AI协作共享知识库 | 更新时间：2026-03-13*
