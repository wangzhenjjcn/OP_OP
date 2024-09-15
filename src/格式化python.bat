@echo off
chcp 65001
setlocal enabledelayedexpansion

:: Check if 'black' is installed by running it and checking the error level.
:: 检查'black'是否已安装，通过运行并检查错误级别来确认。
black --version >nul 2>&1
if not %errorlevel% == 0 (
    echo 'black' is not installed. Attempting to install...
    :: 'black'未安装，尝试安装...
    pip install black
    if not %errorlevel% == 0 (
        echo Failed to install 'black'. Please install it manually.
        :: 安装'black'失败。请手动安装。
        goto end
    )
)

:: Define the directory to search for Python files.
:: 定义要搜索Python文件的目录。
set "SEARCH_DIR=%~dp0"

:: Format all Python files found in the directory.
:: 格式化目录中找到的所有Python文件。
echo Formatting Python files in %SEARCH_DIR%
:: 在指定目录格式化Python文件。
for /R "%SEARCH_DIR%" %%f in (*.py) do (
    echo Formatting: %%f
    :: 显示正在格式化的文件名。
    black "%%f"
)

echo Formatting complete.
:: 格式化完成。
 

:end
endlocal

@pause
:: Pause the script, waiting for the user to press any key to continue.
:: 暂停脚本，等待用户按任意键继续。
