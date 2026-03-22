#!/usr/bin/env python3
"""
百度图片爬虫
============
用于按关键词搜索并下载百度图片

作者: OpenClaw + OpenCode
日期: 2026-03-21
"""

import os
import re
import time
import json
import hashlib
import requests
from urllib import parse
from pathlib import Path
from typing import List, Dict, Optional
from concurrent.futures import ThreadPoolExecutor, as_completed


class BaiduImageCrawler:
    """百度图片爬虫类"""

    def __init__(self, download_dir: str = "./images", max_workers: int = 5):
        """
        初始化爬虫

        Args:
            download_dir: 图片下载目录
            max_workers: 并发下载线程数
        """
        self.download_dir = Path(download_dir)
        self.max_workers = max_workers
        self.session = requests.Session()

        # 设置请求头，模拟浏览器
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
            'Referer': 'https://image.baidu.com/',
        })

        # 创建下载目录
        self.download_dir.mkdir(parents=True, exist_ok=True)

        # 统计信息
        self.stats = {
            'total': 0,
            'success': 0,
            'failed': 0,
            'skipped': 0
        }

    def search_images(self, keyword: str, page: int = 0, num: int = 30) -> List[Dict]:
        """
        搜索百度图片

        Args:
            keyword: 搜索关键词
            page: 页码（从0开始）
            num: 每页数量

        Returns:
            图片信息列表
        """
        # 对关键词进行URL编码
        encoded_keyword = parse.quote(keyword)

        # 百度图片搜索API
        url = 'https://image.baidu.com/search/acjson'

        params = {
            'tn': 'resultjson_com',
            'logid': '',
            'ipn': 'rj',
            'ct': '201326592',
            'is': '',
            'fp': 'result',
            'queryWord': keyword,
            'cl': '2',
            'lm': '-1',
            'ie': 'utf-8',
            'oe': 'utf-8',
            'adpicid': '',
            'st': '-1',
            'z': '',
            'ic': '',
            'hd': '',
            'latest': '',
            'copyright': '',
            'word': keyword,
            's': '',
            'se': '',
            'tab': '',
            'width': '',
            'height': '',
            'face': '0',
            'istype': '2',
            'qc': '',
            'nc': '1',
            'fr': '',
            'expermode': '',
            'force': '',
            'pn': page * num,  # 起始位置
            'rn': num,  # 返回数量
            'gsm': '1e',
            '1649148306584': '',
        }

        try:
            print(f"🔍 正在搜索: '{keyword}' 第 {page + 1} 页...")
            response = self.session.get(url, params=params, timeout=10)
            response.raise_for_status()

            # 解析JSON响应
            data = response.json()

            if 'data' not in data:
                print(f"⚠️ 未找到图片数据")
                return []

            images = []
            for item in data['data']:
                if 'thumbURL' in item or 'middleURL' in item or 'hoverURL' in item:
                    image_info = {
                        'title': item.get('fromPageTitle', 'unknown'),
                        'url': item.get('thumbURL') or item.get('middleURL') or item.get('hoverURL'),
                        'width': item.get('width', 0),
                        'height': item.get('height', 0),
                        'type': item.get('type', 'jpg'),
                    }
                    images.append(image_info)

            print(f"✅ 找到 {len(images)} 张图片")
            return images

        except requests.exceptions.RequestException as e:
            print(f"❌ 搜索请求失败: {e}")
            return []
        except json.JSONDecodeError as e:
            print(f"❌ JSON解析失败: {e}")
            return []
        except Exception as e:
            print(f"❌ 搜索出错: {e}")
            return []

    def download_image(self, image_info: Dict, keyword: str) -> bool:
        """
        下载单张图片

        Args:
            image_info: 图片信息字典
            keyword: 搜索关键词（用于创建子目录）

        Returns:
            是否下载成功
        """
        url = image_info.get('url')
        if not url:
            return False

        try:
            # 创建关键词子目录
            safe_keyword = re.sub(r'[^\w\u4e00-\u9fff]', '_', keyword)
            save_dir = self.download_dir / safe_keyword
            save_dir.mkdir(parents=True, exist_ok=True)

            # 生成文件名（使用URL的MD5值，避免重复）
            url_hash = hashlib.md5(url.encode()).hexdigest()[:8]
            ext = image_info.get('type', 'jpg').lower()
            if ext not in ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp']:
                ext = 'jpg'

            filename = f"{url_hash}.{ext}"
            filepath = save_dir / filename

            # 检查文件是否已存在
            if filepath.exists():
                print(f"⏭️  跳过已存在: {filename}")
                self.stats['skipped'] += 1
                return True

            # 下载图片
            headers = {
                'Referer': 'https://image.baidu.com/',
                'User-Agent': self.session.headers['User-Agent']
            }

            response = requests.get(url, headers=headers, timeout=15, stream=True)
            response.raise_for_status()

            # 保存图片
            with open(filepath, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    if chunk:
                        f.write(chunk)

            print(f"✅ 下载成功: {filename} ({image_info.get('width', 0)}x{image_info.get('height', 0)})")
            self.stats['success'] += 1
            return True

        except requests.exceptions.Timeout:
            print(f"❌ 下载超时: {url[:50]}...")
            self.stats['failed'] += 1
            return False
        except requests.exceptions.RequestException as e:
            print(f"❌ 下载失败: {e}")
            self.stats['failed'] += 1
            return False
        except Exception as e:
            print(f"❌ 保存失败: {e}")
            self.stats['failed'] += 1
            return False

    def download_images(self, images: List[Dict], keyword: str) -> None:
        """
        批量下载图片（并发）

        Args:
            images: 图片信息列表
            keyword: 搜索关键词
        """
        if not images:
            print("⚠️ 没有图片需要下载")
            return

        print(f"\n📥 开始下载 {len(images)} 张图片（并发数: {self.max_workers}）...")

        with ThreadPoolExecutor(max_workers=self.max_workers) as executor:
            # 提交所有下载任务
            future_to_image = {
                executor.submit(self.download_image, img, keyword): img
                for img in images
            }

            # 等待所有任务完成
            for future in as_completed(future_to_image):
                try:
                    future.result()
                except Exception as e:
                    print(f"❌ 任务异常: {e}")

                # 添加小延迟，避免请求过快
                time.sleep(0.1)

    def crawl(self, keyword: str, pages: int = 3, per_page: int = 30) -> None:
        """
        执行完整的爬取流程

        Args:
            keyword: 搜索关键词
            pages: 爬取页数
            per_page: 每页图片数
        """
        print(f"\n{'='*60}")
        print(f"🚀 开始爬取百度图片")
        print(f"关键词: {keyword}")
        print(f"页数: {pages}")
        print(f"保存目录: {self.download_dir.absolute()}")
        print(f"{'='*60}\n")

        all_images = []

        # 搜索所有页面
        for page in range(pages):
            images = self.search_images(keyword, page=page, num=per_page)
            all_images.extend(images)

            # 添加延迟，避免请求过快
            if page < pages - 1:
                time.sleep(1)

        # 去重（根据URL）
        seen_urls = set()
        unique_images = []
        for img in all_images:
            url = img.get('url')
            if url and url not in seen_urls:
                seen_urls.add(url)
                unique_images.append(img)

        print(f"\n📊 共找到 {len(unique_images)} 张唯一图片")

        # 下载图片
        self.download_images(unique_images, keyword)

        # 打印统计
        print(f"\n{'='*60}")
        print(f"📈 爬取统计")
        print(f"{'='*60}")
        print(f"总计: {self.stats['total'] + self.stats['success'] + self.stats['failed'] + self.stats['skipped']}")
        print(f"成功: {self.stats['success']} ✅")
        print(f"失败: {self.stats['failed']} ❌")
        print(f"跳过: {self.stats['skipped']} ⏭️")
        print(f"{'='*60}\n")


def main():
    """主函数"""
    import argparse

    parser = argparse.ArgumentParser(description='百度图片爬虫')
    parser.add_argument('keyword', help='搜索关键词')
    parser.add_argument('-p', '--pages', type=int, default=3, help='爬取页数（默认3）')
    parser.add_argument('-n', '--num', type=int, default=30, help='每页图片数（默认30）')
    parser.add_argument('-d', '--dir', default='./images', help='下载目录（默认./images）')
    parser.add_argument('-w', '--workers', type=int, default=5, help='并发线程数（默认5）')

    args = parser.parse_args()

    # 创建爬虫实例
    crawler = BaiduImageCrawler(
        download_dir=args.dir,
        max_workers=args.workers
    )

    # 开始爬取
    crawler.crawl(
        keyword=args.keyword,
        pages=args.pages,
        per_page=args.num
    )


if __name__ == '__main__':
    main()
