#!/bin/bash

# 提示用户输入本地IP地址
echo "请输入您的本地IP地址："
read local_ip

# 从本地IP地址中提取网络地址
network=$(echo $local_ip | cut -d"." -f1,2,3)

# 设置要扫描的网络地址范围
start_ip=1
end_ip=255

# 初始化可达 IP 地址列表
reachable_ip_list=""

# 使用 for 循环逐个扫描 IP 地址
for ((ip=$start_ip; ip<=$end_ip; ip++)); do
    # 设置当前要扫描的 IP 地址
    ip_address="$network.$ip"

    # 使用 ping 命令测试 IP 地址的可达性
    ping -c 1 -W 1 $ip_address > /dev/null

    # 检查 ping 命令的返回值
    if [ $? -eq 0 ]; then
        echo "IP地址 $ip_address 可达"
        # 将可达 IP 地址添加到列表中
        reachable_ip_list="$reachable_ip_list $ip_address"
    else
        echo "IP地址 $ip_address 不可达"
    fi
done

# 显示可达的 IP 地址列表
echo
echo "可达的 IP 地址列表："
for ip in $reachable_ip_list; do
    echo $ip
done


