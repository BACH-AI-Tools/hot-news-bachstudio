#!/usr/bin/env python3
"""
演示脚本 - 展示如何直接使用 HotNewsAPI
不需要 MCP 协议，可以在任何 Python 项目中使用
"""

import asyncio
import json
from server import HotNewsAPI


async def demo_single_platform():
    """演示：获取单个平台的热点"""
    print("\n" + "="*60)
    print("演示 1: 获取单个平台的热点")
    print("="*60)
    
    api = HotNewsAPI()
    
    # 获取微博热搜
    print("\n📱 获取微博热搜前5条...")
    weibo_data = await api.get_weibo_hot()
    
    if weibo_data:
        for i, item in enumerate(weibo_data[:5], 1):
            print(f"\n{i}. {item['title']}")
            print(f"   热度: {item['hot_value']:,}")
            if item.get('label'):
                print(f"   标签: {item['label']}")
    
    await api.close()


async def demo_all_platforms():
    """演示：获取所有平台的热点"""
    print("\n" + "="*60)
    print("演示 2: 获取所有平台的热点")
    print("="*60)
    
    api = HotNewsAPI()
    
    # 获取所有平台
    print("\n🌐 正在获取所有平台的热点...")
    all_data = await api.get_all_hot()
    
    print("\n📊 数据统计:")
    for platform, items in all_data.items():
        status = "✅" if items else "❌"
        print(f"{status} {platform:10s}: {len(items):2d} 条数据")
    
    # 显示每个平台的第一条
    print("\n📰 各平台热点第一条:")
    for platform, items in all_data.items():
        if items:
            print(f"\n【{platform}】")
            print(f"  {items[0]['title']}")
    
    await api.close()


async def demo_search():
    """演示：搜索关键词"""
    print("\n" + "="*60)
    print("演示 3: 搜索包含特定关键词的热点")
    print("="*60)
    
    api = HotNewsAPI()
    keyword = "科技"
    
    print(f"\n🔍 搜索关键词: '{keyword}'")
    all_data = await api.get_all_hot()
    
    # 搜索匹配的热点
    matches = {}
    for platform, items in all_data.items():
        matched = [item for item in items if keyword in item.get('title', '')]
        if matched:
            matches[platform] = matched
    
    print(f"\n📊 搜索结果: 在 {len(matches)} 个平台找到 {sum(len(v) for v in matches.values())} 条匹配")
    
    for platform, items in matches.items():
        print(f"\n【{platform}】找到 {len(items)} 条:")
        for item in items[:3]:  # 只显示前3条
            print(f"  • {item['title']}")
    
    await api.close()


async def demo_compare_platforms():
    """演示：对比不同平台"""
    print("\n" + "="*60)
    print("演示 4: 对比不同平台的热点特征")
    print("="*60)
    
    api = HotNewsAPI()
    
    print("\n📊 正在分析各平台数据...")
    all_data = await api.get_all_hot()
    
    # 分析每个平台的特征
    print("\n📈 平台特征分析:")
    
    for platform, items in all_data.items():
        if not items:
            continue
        
        print(f"\n【{platform}】")
        print(f"  热点数量: {len(items)}")
        
        # 提取标题关键词（简单统计）
        titles = [item.get('title', '') for item in items]
        print(f"  平均标题长度: {sum(len(t) for t in titles) / len(titles):.1f} 字")
        
        # 显示前3条
        print(f"  热点示例:")
        for i, item in enumerate(items[:3], 1):
            print(f"    {i}. {item['title'][:30]}...")
    
    await api.close()


async def demo_export_json():
    """演示：导出JSON数据"""
    print("\n" + "="*60)
    print("演示 5: 导出JSON格式数据")
    print("="*60)
    
    api = HotNewsAPI()
    
    print("\n📦 获取微博热搜数据...")
    weibo_data = await api.get_weibo_hot()
    
    # 构建输出数据
    output = {
        "platform": "微博热搜",
        "timestamp": "2026-01-07",
        "count": len(weibo_data),
        "data": weibo_data[:5]  # 只导出前5条
    }
    
    # 转换为JSON
    json_str = json.dumps(output, ensure_ascii=False, indent=2)
    
    print("\n📄 JSON 格式数据:")
    print(json_str)
    
    # 可以保存到文件
    # with open('weibo_hot.json', 'w', encoding='utf-8') as f:
    #     f.write(json_str)
    
    await api.close()


async def main():
    """主函数 - 运行所有演示"""
    print("\n" + "="*60)
    print("  超级今日热点 API 演示")
    print("="*60)
    print("\n本演示将展示如何使用 HotNewsAPI 获取各平台热点")
    print("你可以在任何 Python 项目中使用这些 API")
    
    # 运行所有演示
    demos = [
        demo_single_platform,
        demo_all_platforms,
        demo_search,
        demo_compare_platforms,
        demo_export_json,
    ]
    
    for demo in demos:
        try:
            await demo()
            await asyncio.sleep(1)  # 稍微延迟，避免请求过快
        except Exception as e:
            print(f"\n❌ 演示出错: {e}")
    
    print("\n" + "="*60)
    print("  演示完成！")
    print("="*60)
    print("\n💡 提示:")
    print("  • 这些API可以在任何Python项目中使用")
    print("  • 在MCP服务器中，这些API通过MCP协议暴露给Claude")
    print("  • 你可以根据需要修改和扩展这些API")
    print("\n📖 查看 server.py 了解完整实现")
    print()


if __name__ == "__main__":
    asyncio.run(main())

