#!/bin/bash

red='\e[91m'
green='\e[92m'
yellow='\e[93m'
# 紫色
magenta='\e[95m'
cyan='\e[96m'
none='\e[0m'
_red() { echo -e ${red}$*${none}; }
_green() { echo -e ${green}$*${none}; }
_yellow() { echo -e ${yellow}$*${none}; }
_magenta() { echo -e ${magenta}$*${none}; }
_cyan() { echo -e ${cyan}$*${none}; }


# 需要编译环境变量的脚本，需要使用 source 脚本名  来调用 ！！！

# echo 使用案例，把需要变色的包起来
echo -e "${green}安装${none}${yellow}Java${none}"
echo " ————————————————————"
echo " | author：jsy       |"
echo " ————————————————————"


sleep 3

echo "解压Java至/usr/java目录"

rm -rf /usr/java/*

mkdir /usr/java

tar -zxf /root/app/jdk-8u181-linux-x64.tar.gz -C /usr/java

echo "解压完成"
chown -R root:root /usr/java/jdk1.8.0_181/

sleep 3

echo "开始配置环境变量"

echo "export JAVA_HOME=/usr/java/jdk1.8.0_181" >> /etc/profile
echo "export PATH=/usr/java/jdk1.8.0_181/bin:${PATH}" >> /etc/profile

source /etc/profile

sleep 3

echo "配置完成"


