#!/bin/bash

echo "============================================"
echo "  超级今日热点 MCP 服务器安装脚本"
echo "============================================"
echo ""

# 获取脚本所在目录
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "📦 正在检查 Python 版本..."
python_version=$(python3 --version 2>&1 | awk '{print $2}')
echo "   当前 Python 版本: $python_version"

# 检查 Python 版本是否 >= 3.10
required_version="3.10"
if [ "$(printf '%s\n' "$required_version" "$python_version" | sort -V | head -n1)" != "$required_version" ]; then 
    echo "❌ 错误: 需要 Python 3.10 或更高版本"
    exit 1
fi

echo "✅ Python 版本符合要求"
echo ""

# 询问是否创建虚拟环境
read -p "是否创建虚拟环境? (推荐) [Y/n]: " create_venv
create_venv=${create_venv:-Y}

if [[ $create_venv =~ ^[Yy]$ ]]; then
    echo ""
    echo "🔧 正在创建虚拟环境..."
    python3 -m venv .venv
    
    echo "✅ 虚拟环境创建成功"
    echo ""
    echo "🔧 激活虚拟环境并安装依赖..."
    source .venv/bin/activate
    pip install --upgrade pip
    pip install -r requirements.txt
    
    PYTHON_PATH="$SCRIPT_DIR/.venv/bin/python"
else
    echo ""
    echo "🔧 正在安装依赖到系统 Python..."
    pip3 install -r requirements.txt
    
    PYTHON_PATH="python3"
fi

echo ""
echo "✅ 依赖安装完成"
echo ""

# 测试服务器
read -p "是否测试服务器? [Y/n]: " test_server
test_server=${test_server:-Y}

if [[ $test_server =~ ^[Yy]$ ]]; then
    echo ""
    echo "🧪 正在测试服务器..."
    $PYTHON_PATH test_server.py
fi

echo ""
echo "============================================"
echo "  安装完成！"
echo "============================================"
echo ""
echo "📝 下一步操作："
echo ""
echo "1. 配置 Claude Desktop"
echo "   配置文件位置: ~/Library/Application Support/Claude/claude_desktop_config.json"
echo ""
echo "2. 添加以下配置："
echo ""
echo '{'
echo '  "mcpServers": {'
echo '    "hot-news": {'
echo "      \"command\": \"$PYTHON_PATH\","
echo '      "args": ['
echo "        \"$SCRIPT_DIR/server.py\""
echo '      ]'
echo '    }'
echo '  }'
echo '}'
echo ""
echo "3. 重启 Claude Desktop"
echo ""
echo "📖 更多信息请查看 README.md 和 USAGE.md"
echo ""

