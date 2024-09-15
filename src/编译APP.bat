@echo off
chcp 65001
setlocal enabledelayedexpansion

:: Define the directory and default target file.
:: 定义目录和默认目标文件。
set "SCRIPT_DIR=%~dp0"
set "TARGET_FILE=app.py"

:: Check if the default Python file exists.
:: 检查默认的Python文件是否存在。
if exist "%SCRIPT_DIR%app.py" (
    echo Default app.py found.
    echo 找到默认的 app.py 文件。
) else (
    :: Search for any Python file containing 'app' in its name in current directory and src directory.
    :: 在当前目录和src目录中搜索名字中包含 'app' 的任何Python文件。
    set "FOUND_APP_FILE=NO"
    for %%d in (., src) do (
        for %%i in (%%d\*app*.py) do (
            if not !FOUND_APP_FILE! == YES (
                set "TARGET_FILE=%%~nxi"
                set "FOUND_APP_FILE=YES"
                goto FileChecked
            )
        )
    )

    :: If no such file found, find the first .py file larger than 1KB and contains a main function in current directory and src directory.
    :: 如果没有找到这样的文件，在当前目录和src目录寻找第一个大于1KB且包含主函数的.py文件。
    if not !FOUND_APP_FILE! == YES (
        for %%d in (., src) do (
            for %%j in (%%d\*.py) do (
                if %%~zj GTR 1024 (
                    findstr /C:"if __name__ == \"__main__\":" "%%j" >nul
                    if !errorlevel! == 0 (
                        set "TARGET_FILE=%%~nxj"
                        goto FileFound
                    )
                )
            )
        )
    )
)

:FileChecked
:FileFound
echo Selected file: %TARGET_FILE%
:: 显示选中的文件。

echo Overwrite output files without asking (default Y) [Y/N]? 覆盖输出文件，不进行询问（默认Y）[Y/N]?
set /P "RESPONSE_Y="
if /I "!RESPONSE_Y!"=="N" (set "OPTION_Y=") else (set "OPTION_Y=-y")

echo Create a one-file bundled executable (default Y) [Y/N]? 创建单文件捆绑可执行文件（默认Y）[Y/N]?
set /P "RESPONSE_F="
if /I "!RESPONSE_F!"=="N" (set "OPTION_F=") else (set "OPTION_F=-F")

set "DEFAULT_NAME=%TARGET_FILE:~0,-3%"
echo Name to assign to the bundled app, default is the filename without extension '%DEFAULT_NAME%': 为捆绑应用程序指定一个名称（默认为文件名 '%DEFAULT_NAME%'）:
set /P "APP_NAME="
if "!APP_NAME!"=="" (set "APP_NAME=%DEFAULT_NAME%")

echo Running PyInstaller with options: %OPTION_Y% %OPTION_F% -n %APP_NAME%
:: 显示正在运行PyInstaller的选项。
python -O -m PyInstaller %OPTION_Y% %OPTION_F% -n %APP_NAME% "%SCRIPT_DIR%%TARGET_FILE%"

endlocal

@pause
:: Pause the script, waiting for the user to press any key to continue.
:: 暂停脚本，等待用户按任意键继续。
