@echo off
chcp 65001 >nul
echo ============================================
echo   超级今日热点 MCP 服务器安装脚本
echo ============================================
echo.

cd /d "%~dp0"

echo 📦 正在检查 Python 版本...
python --version
if errorlevel 1 (
    echo ❌ 错误: 未找到 Python，请先安装 Python 3.10 或更高版本
    pause
    exit /b 1
)

echo ✅ Python 已安装
echo.

set /p create_venv="是否创建虚拟环境? (推荐) [Y/n]: "
if "%create_venv%"=="" set create_venv=Y

if /i "%create_venv%"=="Y" (
    echo.
    echo 🔧 正在创建虚拟环境...
    python -m venv .venv
    
    echo ✅ 虚拟环境创建成功
    echo.
    echo 🔧 激活虚拟环境并安装依赖...
    call .venv\Scripts\activate.bat
    python -m pip install --upgrade pip
    pip install -r requirements.txt
    
    set "PYTHON_PATH=%~dp0.venv\Scripts\python.exe"
) else (
    echo.
    echo 🔧 正在安装依赖到系统 Python...
    pip install -r requirements.txt
    
    set "PYTHON_PATH=python"
)

echo.
echo ✅ 依赖安装完成
echo.

set /p test_server="是否测试服务器? [Y/n]: "
if "%test_server%"=="" set test_server=Y

if /i "%test_server%"=="Y" (
    echo.
    echo 🧪 正在测试服务器...
    "%PYTHON_PATH%" test_server.py
)

echo.
echo ============================================
echo   安装完成！
echo ============================================
echo.
echo 📝 下一步操作：
echo.
echo 1. 配置 Claude Desktop
echo    配置文件位置: %%APPDATA%%\Claude\claude_desktop_config.json
echo.
echo 2. 添加以下配置：
echo.
echo {
echo   "mcpServers": {
echo     "hot-news": {
echo       "command": "%PYTHON_PATH%",
echo       "args": [
echo         "%~dp0server.py"
echo       ]
echo     }
echo   }
echo }
echo.
echo 3. 重启 Claude Desktop
echo.
echo 📖 更多信息请查看 README.md 和 USAGE.md
echo.
pause

