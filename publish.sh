#!/bin/bash

echo "=========================================="
echo "  超级今日热点 - PyPI 发布脚本"
echo "=========================================="
echo ""

# 切换到项目目录
cd "$(dirname "$0")"

# 检查是否安装了必要的工具
echo "1️⃣  检查发布工具..."
if ! command -v python3 &> /dev/null; then
    echo "❌ 错误: 未找到 python3"
    exit 1
fi

# 安装/升级发布工具
echo ""
echo "2️⃣  安装/升级发布工具..."
python3 -m pip install --upgrade pip setuptools wheel twine build

# 清理旧的构建文件
echo ""
echo "3️⃣  清理旧的构建文件..."
rm -rf build/ dist/ *.egg-info hot_news_mcp.egg-info

# 构建包
echo ""
echo "4️⃣  构建 Python 包..."
python3 -m build

# 检查构建结果
if [ ! -d "dist" ]; then
    echo "❌ 构建失败"
    exit 1
fi

echo ""
echo "✅ 构建成功！生成的文件："
ls -lh dist/

# 检查包
echo ""
echo "5️⃣  检查包的完整性..."
python3 -m twine check dist/*

# 询问是否上传
echo ""
echo "=========================================="
echo "  准备上传到 PyPI"
echo "=========================================="
echo ""
echo "请选择上传目标："
echo "  1) TestPyPI (测试环境，推荐先测试)"
echo "  2) PyPI (正式环境)"
echo "  3) 取消"
echo ""
read -p "请输入选择 [1-3]: " choice

case $choice in
    1)
        echo ""
        echo "6️⃣  上传到 TestPyPI..."
        echo "提示: 需要 TestPyPI 账号和 API Token"
        echo "注册地址: https://test.pypi.org/account/register/"
        echo ""
        python3 -m twine upload --repository testpypi dist/*
        echo ""
        echo "✅ 上传完成！"
        echo "查看地址: https://test.pypi.org/project/hot-news-mcp/"
        echo ""
        echo "测试安装:"
        echo "  pip install -i https://test.pypi.org/simple/ hot-news-mcp"
        ;;
    2)
        echo ""
        echo "6️⃣  上传到 PyPI..."
        echo "提示: 需要 PyPI 账号和 API Token"
        echo "注册地址: https://pypi.org/account/register/"
        echo ""
        read -p "确认上传到正式环境? [y/N]: " confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            python3 -m twine upload dist/*
            echo ""
            echo "✅ 上传完成！"
            echo "查看地址: https://pypi.org/project/hot-news-mcp/"
            echo ""
            echo "安装命令:"
            echo "  pip install hot-news-mcp"
        else
            echo "❌ 已取消上传"
        fi
        ;;
    3)
        echo "❌ 已取消上传"
        ;;
    *)
        echo "❌ 无效的选择"
        exit 1
        ;;
esac

echo ""
echo "=========================================="
echo "  完成"
echo "=========================================="

