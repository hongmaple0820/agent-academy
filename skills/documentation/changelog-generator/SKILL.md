# Changelog Generator

自动从 Git 提交记录生成用户友好的更新日志。

## 激活场景

- 用户说"生成 changelog"、"更新日志"、"发布说明"
- 用户准备发布新版本
- 用户想了解最近的改动

## 功能

1. 读取 Git 提交历史
2. 按类型分类（feat/fix/docs/refactor/chore）
3. 转换为用户友好的描述
4. 生成标准格式的 CHANGELOG

## 使用方法

### 基础用法

```bash
# 获取最近的提交记录
git log --oneline -20

# 获取某个时间段的提交
git log --oneline --since="2024-01-01" --until="2024-01-31"

# 获取两个版本之间的提交
git log --oneline v1.0.0..v2.0.0
```

### 完整用法

```bash
# 获取详细提交信息（含作者和日期）
git log --pretty=format:"%h - %s (%an, %ar)" --since="1 week ago"
```

## 提交类型说明

| 类型 | 含义 | 用户描述 |
|------|------|----------|
| feat | 新功能 | ✨ 新增 |
| fix | 修复 | 🐛 修复 |
| docs | 文档 | 📝 文档 |
| refactor | 重构 | ♻️ 优化 |
| test | 测试 | ✅ 测试 |
| chore | 杂项 | 🔧 维护 |
| perf | 性能 | ⚡ 性能 |

## 输出格式

### Markdown 格式

```markdown
# Changelog

## [1.2.0] - 2024-02-06

### ✨ 新功能
- 添加用户头像上传功能
- 支持消息搜索

### 🐛 修复
- 修复登录页面样式问题
- 修复消息发送失败的 bug

### 📝 文档
- 更新 API 文档
- 添加部署指南
```

### Keep a Changelog 格式

遵循 https://keepachangelog.com 规范：

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- New feature description

### Changed
- Changed feature description

### Fixed
- Bug fix description

### Removed
- Removed feature description
```

## 操作步骤

1. **确定范围**：询问用户要生成哪个时间段/版本的 changelog
2. **获取提交**：使用 git log 获取提交记录
3. **分类整理**：按 feat/fix/docs 等分类
4. **美化描述**：把技术性描述转换为用户友好的语言
5. **生成文件**：输出 CHANGELOG.md 或直接展示

## 示例对话

**用户**：帮我生成这周的更新日志

**AI**：
1. 先获取本周的提交记录
2. 分类整理
3. 生成如下格式：

```markdown
## 本周更新 (2024-02-01 ~ 2024-02-06)

### ✨ 新功能
- 私聊功能上线
- 消息已读状态

### 🐛 修复
- 修复注册失败问题
- 修复样式兼容性

### 🔧 优化
- 提升消息发送速度
- 优化数据库查询
```

## 注意事项

- 技术性的 commit message 需要转换为用户能理解的语言
- 合并相似的提交，避免重复
- 突出重要的功能更新
- 省略不影响用户的内部改动（如 refactor、chore）
