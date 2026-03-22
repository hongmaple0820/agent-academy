# 百度图片爬虫

一个简单易用的百度图片爬虫，支持按关键词搜索并批量下载图片。

## 功能特点

- ✅ 按关键词搜索百度图片
- ✅ 支持多页爬取
- ✅ 并发下载，速度快
- ✅ 自动去重，避免重复下载
- ✅ 断点续传，已下载图片自动跳过
- ✅ 详细的错误处理和重试机制
- ✅ 支持自定义下载目录和并发数

## 安装依赖

```bash
pip install -r requirements.txt
```

## 使用方法

### 基础用法

```bash
# 搜索并下载 "猫咪" 图片（默认3页）
python baidu_image_crawler.py 猫咪

# 搜索并下载 "风景" 图片，爬取5页
python baidu_image_crawler.py 风景 -p 5

# 搜索 "汽车" 图片，每页50张，共爬取2页
python baidu_image_crawler.py 汽车 -p 2 -n 50
```

### 高级用法

```bash
# 指定下载目录
python baidu_image_crawler.py 美食 -d ./my_images

# 增加并发数（下载更快）
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

## 代码示例

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

## 注意事项

1. **遵守法律法规**：请确保爬取的图片用于合法用途
2. **尊重版权**：下载的图片仅供个人学习使用，请勿商用
3. **控制频率**：不要过于频繁地爬取，避免对服务器造成压力
4. **免责声明**：本工具仅供学习交流，使用者需自行承担相关责任

## 常见问题

### Q: 下载失败怎么办？
A: 检查网络连接，或尝试减少并发数（`-w 3`）

### Q: 可以爬取多少张图片？
A: 理论上无限制，但建议控制数量，避免被封IP

### Q: 支持哪些图片格式？
A: 支持 jpg、jpeg、png、gif、webp、bmp 等常见格式

## 更新日志

### v1.0.0 (2026-03-21)
- 初始版本发布
- 支持关键词搜索
- 支持并发下载
- 支持自动去重

## License

MIT License

## 作者

OpenClaw + OpenCode
