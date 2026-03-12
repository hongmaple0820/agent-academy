# 🤖 消息发送指南

本指南帮助AI助手了解如何向钉钉用户发送消息。

## 📋 快速选择

| 场景 | 推荐方案 | 说明 |
|------|----------|------|
| 群聊推送/公告 | 方案A (webhook) | 简单快速，只支持群聊 |
| 即时交互/私聊 | 方案B (plugin) | 完整交互，支持群聊和私聊 |

---

## 📤 方案 A：Webhook 群聊

### 适用场景
- 群公告推送
- 定时提醒
- 简单群聊消息
- 不需要回复的推送

### API 调用

```bash
# 发送群聊消息
curl -X POST http://localhost:8273/api/reply \
  -H "Content-Type: application/json" \
  -d '{"content": "消息内容", "sender": "小熊"}'

# @ 用户
curl -X POST http://localhost:8273/api/reply \
  -H "Content-Type: application/json" \
  -d '{"content": "消息", "sender": "小熊", "atTargets": ["maple"]}'
```

### 限制
- ❌ 不支持私聊
- ❌ 不需要注册群聊ID

---

## 💬 方案 B：OpenClaw 钉钉插件（推荐）

### 适用场景
- 即时聊天回复
- 私聊消息
- 需要用户互动的场景
- 复杂对话场景

### 前提条件
1. 切换到 plugin 模式
2. 注册群聊ID/用户ID（首次交互时自动注册）

### API 调用

```bash
# 切换模式
curl -X POST http://localhost:8273/api/dingtalk/mode \
  -H "Content-Type: application/json" \
  -d '{"mode": "plugin"}'

# 群聊消息
curl -X POST http://localhost:8273/api/dingtalk/group \
  -H "Content-Type: application/json" \
  -d '{"groupName": "AI聊天室", "content": "消息", "sender": "小熊"}'

# 私聊消息
curl -X POST http://localhost:8273/api/dingtalk/user \
  -H "Content-Type: application/json" \
  -d '{"userId": "maple", "content": "私聊内容", "sender": "小熊"}'
```

### 自动注册 ID

当用户首次发消息时，系统会自动注册：
- 群聊：保存 `openConversationId`
- 用户：保存 `dingtalkUserId`

也可以手动注册：
```bash
# 注册群聊
curl -X POST http://localhost:8273/api/dingtalk/groups/register \
  -H "Content-Type: application/json" \
  -d '{"name": "群名", "openConversationId": "cidxxx"}'

# 注册用户
curl -X POST http://localhost:8273/api/dingtalk/users/register \
  -H "Content-Type: application/json" \
  -d '{"name": "用户名", "dingtalkUserId": "userxxx"}'
```

---

## 🔄 模式切换

```bash
# 查看当前配置
curl -s http://localhost:8273/api/dingtalk/config | jq '.'

# 切换到 webhook 模式
curl -X POST http://localhost:8273/api/dingtalk/mode \
  -H "Content-Type: application/json" \
  -d '{"mode": "webhook"}'

# 切换到 plugin 模式
curl -X POST http://localhost:8273/api/dingtalk/mode \
  -H "Content-Type: application/json" \
  -d '{"mode": "plugin"}'
```

---

## ⚠️ 注意事项

1. **确保 chat-hub 正在运行**：端口 8273
2. **方案 A 只支持群聊**：无法发送私聊
3. **私聊需要正确的用户 ID**：首次交互时自动注册
4. **网络问题**：如果消息发送失败，检查网络连接

---

## 📞 常见问题

**Q: 消息发送失败怎么办？**
A: 1. 检查 chat-hub 是否运行 2. 检查配置模式 3. 查看日志

**Q: 私聊发送失败？**
A: 需要切换到 plugin 模式，并确保已注册用户 ID

**Q: plugin 模式发送失败？**
A: 检查钉钉插件的 clientId 和 clientSecret 配置

---

## 🔗 相关文档

- chat-hub-plugin skill：`~/.openclaw/workspace/skills/chat-hub-plugin/SKILL.md`
- 钉钉配置指南：`knowledge/dingtalk-webhook-guide.md`
- AI 协作规范：`AI_COLLABORATION_GUIDE.md`
