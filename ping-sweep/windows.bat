@echo off

:: 设置控制台代码页为 65001，以支持中文显示
chcp 65001

:: 启用延迟变量扩展，以便在循环中使用变量
setlocal enabledelayedexpansion

:: 提示用户输入本地 IP 地址
echo 请输入您的本地IP地址：
set /p local_ip=

:: 从本地 IP 地址中提取网络地址
set network=%local_ip:~0,9%

:: 设置起始 IP 地址和结束 IP 地址
set start_ip=1
set end_ip=255

:: 初始化可达 IP 地址列表
set reachable_ip_list=

:: 使用 FOR 循环逐个扫描 IP 地址
for /L %%i in (%start_ip%, 1, %end_ip%) do (
    :: 设置当前要扫描的 IP 地址
	set ip=!network!.%%i
	:: 使用 ping 命令测试 IP 地址的可达性
    ping -n 1 -w 1000 !ip! > nul
	
	:: 检查 ping 命令的返回值
    if !errorlevel! equ 0 (
        echo IP地址 !ip! 可达
        :: 将可达 IP 地址添加到列表中
        set reachable_ip_list=!reachable_ip_list! !ip!
    ) else (
        echo IP地址 !ip! 不可达
    )
)

:: 显示可达的 IP 地址列表
echo.
echo 可达的 IP 地址列表：
for %%i in (%reachable_ip_list%) do echo %%i
