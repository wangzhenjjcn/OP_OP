@echo off
chcp 65001

:: Disable command echo to keep the output clean.
:: 禁用命令回显，保持执行输出的清洁。

set "SCRIPT_DIR=%~dp0"
:: Set the variable for the script's directory.
:: 设置脚本所在目录的变量。

echo Installing dependencies...
:: Display message indicating the installation of dependencies.
:: 显示正在安装依赖包的信息。

pip install -r "%SCRIPT_DIR%\requirements.txt" -i https://pypi.tuna.tsinghua.edu.cn/simple
:: Use Tsinghua University's PyPI mirror to install dependencies listed in requirements.txt.
:: 使用清华大学的PyPI镜像安装requirements.txt中列出的依赖。

echo Dependencies installation completed!
:: Display message indicating that the dependencies have been installed.
:: 显示依赖包安装完成的信息。

echo Running the script, press any key to continue...
:: Prompt the user that the script is ready to run and wait for user action.
:: 提示用户脚本准备运行，等待用户操作。

@pause
:: Pause the script, waiting for the user to press any key to continue.
:: 暂停脚本，等待用户按任意键继续。
