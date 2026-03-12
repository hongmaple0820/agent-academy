# YouTube Transcript

获取 YouTube 视频的字幕/文字记录，用于总结、翻译或提取信息。

## 激活场景

- 用户分享 YouTube 链接并要求总结
- 用户说"获取视频字幕"、"视频内容"、"视频说了什么"
- 用户想翻译或分析视频内容

## 依赖

需要安装 yt-dlp：

```bash
# macOS
brew install yt-dlp

# Linux
pip install yt-dlp

# 或直接下载
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
chmod a+rx /usr/local/bin/yt-dlp
```

## 使用方法

### 获取字幕

```bash
# 获取自动生成的中文字幕
yt-dlp --skip-download --write-auto-sub --sub-lang zh --convert-subs srt "VIDEO_URL"

# 获取英文字幕
yt-dlp --skip-download --write-auto-sub --sub-lang en --convert-subs srt "VIDEO_URL"

# 获取所有可用字幕
yt-dlp --skip-download --write-auto-sub --all-subs "VIDEO_URL"

# 列出可用的字幕语言
yt-dlp --list-subs "VIDEO_URL"
```

### 获取视频信息

```bash
# 获取视频标题、描述、时长等
yt-dlp --dump-json "VIDEO_URL" | jq '{title, description, duration, upload_date}'

# 只获取标题
yt-dlp --get-title "VIDEO_URL"

# 获取视频描述
yt-dlp --get-description "VIDEO_URL"
```

### 下载音频（用于语音转文字）

```bash
# 下载最佳音频质量
yt-dlp -x --audio-format mp3 "VIDEO_URL"

# 下载并限制大小
yt-dlp -x --audio-format mp3 --audio-quality 5 "VIDEO_URL"
```

## 操作步骤

### 方法 1：使用自动字幕

1. 检查是否安装了 yt-dlp
2. 列出可用字幕语言
3. 下载对应语言的字幕
4. 读取 .srt 文件并提取文本
5. 总结或处理内容

### 方法 2：使用第三方 API

如果 yt-dlp 不可用，可以使用在线服务：

```bash
# 使用 youtubetranscript.com API
curl "https://youtubetranscript.com/?server_vid=VIDEO_ID"
```

### 方法 3：通过描述和评论推断

如果字幕不可用：
1. 获取视频描述
2. 获取热门评论
3. 基于这些信息推断视频内容

## SRT 字幕格式解析

SRT 文件格式：
```
1
00:00:00,000 --> 00:00:02,500
这是第一句话

2
00:00:02,500 --> 00:00:05,000
这是第二句话
```

提取纯文本的方法：
```bash
# 去除时间戳，只保留文本
grep -v "^[0-9]" video.srt | grep -v "^$" | grep -v "\-\->"
```

## 示例对话

**用户**：帮我总结这个视频 https://youtube.com/watch?v=xxxxx

**AI**：
1. 先获取视频信息（标题、时长）
2. 下载字幕
3. 提取文本内容
4. 生成摘要

## 常见问题

### 没有字幕怎么办？

1. 检查是否有自动生成的字幕（`--write-auto-sub`）
2. 尝试其他语言
3. 使用视频描述推断内容
4. 告知用户该视频暂无字幕

### 字幕质量差？

自动生成的字幕可能有错误，需要：
1. 理解上下文纠正错误
2. 补充标点符号
3. 整理成通顺的段落

### 视频太长？

1. 分段处理
2. 只提取关键时间点
3. 生成章节摘要

## 输出格式

### 视频摘要

```markdown
## 视频信息

- **标题**：xxx
- **时长**：12:34
- **上传日期**：2024-02-06

## 内容摘要

视频主要讲述了...

## 关键要点

1. 要点一
2. 要点二
3. 要点三

## 完整字幕

[可选：附上完整字幕文本]
```
