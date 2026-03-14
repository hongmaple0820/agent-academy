# SecondMe API 迁移说明

## API Base URL 配置

**重要**: 所有 API 请求必须使用 `application/json` 格式。

## 服务端点总览

### 当前配置 (2026-03-13 更新)

| 服务 | 端点 | 请求格式 | 状态 |
|------|------|----------|------|
| **OAuth2 授权** | `https://go.second.me/oauth/` | 浏览器重定向 | ✅ 正常 |
| **Token 兑换** | `POST https://develop-docs.second.me/api/oauth/token` | JSON | ✅ 正常 |
| **Token 刷新** | `POST https://develop-docs.second.me/api/oauth/refresh` | JSON | ✅ 正常 |
| **用户信息** | `GET https://api.mindverse.com/gate/lab/api/secondme/user/info` | Bearer Token | ✅ 正常 |

## OAuth2 授权流程

### 步骤 1: 获取授权码

构建授权 URL 并重定向用户：

```
GET https://go.second.me/oauth/?
  client_id=your_client_id&
  redirect_uri=https://your-app.com/callback&
  response_type=code&
  scope=user.info chat&
  state=random_state_string
```

**注意**: 用户会被重定向到 SecondMe 授权页面，同意授权后携带 `code` 参数回调到你的应用。

### 步骤 2: 用授权码换取 Token

**重要**: 必须使用 `application/json` 格式。

```bash
curl "https://develop-docs.second.me/api/oauth/token" \
  -H "content-type: application/json" \
  --data-raw '{
    "client_id": "your_client_id",
    "client_secret": "your_client_secret",
    "code": "lba_ac_xxxxx...",
    "redirect_uri": "your_redirect_uri"
  }'
```

**请求参数**:

| 参数 | 类型 | 必需 | 说明 |
|------|------|------|------|
| client_id | string | 是 | 应用的 Client ID |
| client_secret | string | 是 | 应用的 Client Secret |
| code | string | 是 | 步骤 1 获取的授权码 |
| redirect_uri | string | 是 | 必须与步骤 1 中的值一致 |

**成功响应**:

```json
{
  "code": 0,
  "data": {
    "accessToken": "lba_at_xxxxx...",
    "refreshToken": "lba_rt_xxxxx...",
    "tokenType": "Bearer",
    "expiresIn": 7200,
    "scope": ["user.info", "chat"]
  }
}
```

### 步骤 3: 使用 Access Token

在 API 请求中使用 Access Token：

```bash
curl -X GET "https://api.mindverse.com/gate/lab/api/secondme/user/info" \
  -H "Authorization: Bearer lba_at_xxxxx..."
```

**成功响应**:

```json
{
  "code": 0,
  "data": {
    "userId": "user_123",
    "name": "username",
    "email": "user@example.com",
    "avatar": "https://..."
  }
}
```

### 步骤 4: 刷新 Access Token

当 Access Token 过期时，使用 Refresh Token 获取新的 Access Token：

**重要**: 必须使用 `application/json` 格式。

```bash
curl "https://develop-docs.second.me/api/oauth/refresh" \
  -H "content-type: application/json" \
  --data-raw '{
    "grant_type": "refresh_token",
    "refresh_token": "lba_rt_xxxxx...",
    "client_id": "your_client_id",
    "client_secret": "your_client_secret"
  }'
```

**请求参数**:

| 参数 | 类型 | 必需 | 说明 |
|------|------|------|------|
| grant_type | string | 是 | 固定值 `refresh_token` |
| refresh_token | string | 是 | 之前获取的 Refresh Token |
| client_id | string | 是 | 应用的 Client ID |
| client_secret | string | 是 | 应用的 Client Secret |

**成功响应**:

```json
{
  "code": 0,
  "data": {
    "accessToken": "lba_at_new_token...",
    "refreshToken": "lba_rt_new_token...",
    "tokenType": "Bearer",
    "expiresIn": 7200
  }
}
```

## 当前配置

```env
# A2A OAuth2 配置
A2A_CLIENT_ID=<your_client_id>
A2A_CLIENT_SECRET=<your_client_secret>
A2A_REDIRECT_URI=http://localhost:3000/api/auth/a2a/callback
A2A_AUTH_URL=https://go.second.me/oauth/
A2A_TOKEN_URL=https://develop-docs.second.me/api/oauth/token
A2A_USERINFO_URL=https://api.mindverse.com/gate/lab/api/oauth/userinfo
A2A_REFRESH_URL=https://develop-docs.second.me/api/oauth/refresh
```

## 问题排查

### Client secret mismatch 错误

如果你在步骤 2 遇到 `{"code":401,"message":"Client secret mismatch."}` 错误：

1. 登录 [SecondMe 开发者平台](https://develop.second.me/)
2. 进入「我的应用」→ 选择你的应用
3. 查看或重新生成 Client Secret
4. 更新 `.env` 文件中的 `A2A_CLIENT_SECRET`

### Invalid authorization code 错误

确保：
- 授权码只能使用一次
- 授权码有效期较短，需尽快使用
- redirect_uri 与授权时的一致

### Invalid refresh token 错误

确保：
- Refresh Token 未被使用过
- Refresh Token 未过期

## 开发者资源

- **开发者平台**: https://develop.second.me/ ✅
- **授权服务器**: https://go.second.me/oauth/ ✅
- **API 文档**: https://develop-docs.second.me/

## 更新日期

2026-03-13 (更新为 JSON 格式)
