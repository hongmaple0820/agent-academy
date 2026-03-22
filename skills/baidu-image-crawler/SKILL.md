# 百度图片爬虫 (baidu-image-crawler)

按关键词搜索并批量下载百度图片的 Python 爬虫工具。

## 功能特点

- ✅ 按关键词搜索百度图片
- ✅ 支持多页爬取
- ✅ 并发下载，速度快
- ✅ 自动去重，避免重复下载
- ✅ 断点续传，已下载图片自动跳过
- ✅ 详细的错误处理和重试机制
- ✅ 支持自定义下载目录和并发数

## 安装

```bash
# 克隆或复制项目到本地
cd ~/projects
# 项目文件已包含在 skill 目录中
```

## 依赖

```bash
pip install requests
```

## 使用方法

### 命令行

```bash
# 基础用法（搜索关键词，默认3页）
python baidu_image_crawler.py 猫咪

# 爬取5页
python baidu_image_crawler.py 风景 -p 5

# 每页50张，爬取2页
python baidu_image_crawler.py 汽车 -p 2 -n 50

# 指定下载目录
python baidu_image_crawler.py 美食 -d ./my_images

# 增加并发数
python baidu_image_crawler.py 风景 -w 10

# 组合使用
python baidu_image_crawler.py 星空壁纸 -p 5 -n 50 -d ./wallpapers -w 8
```

### 参数说明

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `keyword` | 搜索关键词（必填） | - |
| `-p, --pages` | 爬取页数 | 3 |
| `-n, --num` | 每页图片数 | 30 |
| `-d, --dir` | 下载目录 | ./images |
| `-w, --workers` | 并发线程数 | 5 |

### Python 代码调用

```python
from baidu_image_crawler import BaiduImageCrawler

# 创建爬虫实例
crawler = BaiduImageCrawler(
    download_dir='./my_images',
    max_workers=5
)

# 开始爬取
crawler.crawl(
    keyword='猫咪',
    pages=3,
    per_page=30
)
```

## 项目结构

```
baidu-image-crawler/
├── baidu_image_crawler.py  # 主程序
├── requirements.txt        # 依赖列表
└── README.md              # 使用说明
```

## 输出示例

```
============================================================
🚀 开始爬取百度图片
关键词: 美女
页数: 5
保存目录: /home/maple/projects/baidu-image-crawler/images
============================================================

🔍 正在搜索: '美女' 第 1 页...
✅ 找到 50 张图片
🔍 正在搜索: '美女' 第 2 页...
✅ 找到 50 张图片
...

📥 开始下载 250 张图片（并发数: 5）...
✅ 下载成功: ffbacad3.jpg (1080x1920)
✅ 下载成功: 9812f0b0.jpg (800x1280)
...

============================================================
📈 爬取统计
============================================================
总计: 250
成功: 250 ✅
失败: 0 ❌
跳过: 0 ⏭️
============================================================
```

## 注意事项

1. **遵守法律法规**：请确保爬取的图片用于合法用途
2. **尊重版权**：下载的图片仅供个人学习使用，请勿商用
3. **控制频率**：不要过于频繁地爬取，避免对服务器造成压力
4. **免责声明**：本工具仅供学习交流，使用者需自行承担相关责任

## 技术细节

- 使用百度图片搜索 API (`https://image.baidu.com/search/acjson`)
- 采用 `requests.Session` 保持会话
- 使用 `ThreadPoolExecutor` 实现并发下载
- MD5 哈希去重，避免重复下载
- 支持常见图片格式：jpg、jpeg、png、gif、webp、bmp

## License

MIT License

## 作者

OpenClaw Agent Team
