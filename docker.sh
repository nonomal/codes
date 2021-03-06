#!/bin/bash                                                                                               
#===================================================================#
#   System Required:  CentOS 7                                 #
#   Description: Install Docker for Linux #
#   Author: Azure <2894049053@qq.com>                               #
#   github: @baiyutribe <https://github.com/baiyuetribe>                     #
#   Blog:  佰阅部落 https://baiyue.one                           #
#===================================================================#
#
#  .______        ___       __  ____    ____  __    __   _______      ______   .__   __.  _______ 
#  |   _  \      /   \     |  | \   \  /   / |  |  |  | |   ____|    /  __  \  |  \ |  | |   ____|
#  |  |_)  |    /  ^  \    |  |  \   \/   /  |  |  |  | |  |__      |  |  |  | |   \|  | |  |__   
#  |   _  <    /  /_\  \   |  |   \_    _/   |  |  |  | |   __|     |  |  |  | |  . `  | |   __|  
#  |  |_)  |  /  _____  \  |  |     |  |     |  `--'  | |  |____  __|  `--'  | |  |\   | |  |____ 
#  |______/  /__/     \__\ |__|     |__|      \______/  |_______|(__)\______/  |__| \__| |_______|
#
#一键脚本(智能检测docker环境，若存在则跳过，若不存在，则执行安装)
# bash <(curl -L -s https://raw.githubusercontent.com/Baiyuetribe/v2ray_docker/master/v2ray.sh)             
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#check root
[ $(id -u) != "0" ] && { echo "错误: 您必须以root用户运行此脚本"; exit 1; }

#工具安装
install_pack() {
    pack_name="wget未知"
    echo "===> Start to install curl"    
    if [ -x "$(command -v yum)" ]; then
        command -v curl > /dev/null || yum install -y curl
    elif [ -x "$(command -v apt)" ]; then
        command -v curl > /dev/null || apt install -y curl
    else
        echo "Package manager is not support this OS. Only support to use yum/apt."
        exit -1
    fi
    
}

# @安装docker
install_docker() {
    docker version > /dev/null || curl -fsSL get.docker.com | bash 
    service docker restart 
    systemctl enable docker  
}
install_docker_compose() {
	curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
}

# 单独检测docker是否安装，否则执行安装docker。
check_docker() {
	if [ -x "$(command -v docker)" ]; then
		echo "您的系统已安装docker"
		# command
	else
		echo "开始安装docker。。。"
		# command
		install_docker        
	fi
}
check_docker_compose() {
	if [ -x "$(command -v docker-compose)" ]; then
		echo "docker-compose is installed"
        echo -e "\033[32m====================================\033[0m"	
        echo -e "\033[32m 系统已存在Docker环境                        "
        echo -e "\033[32m====================================\033[0m"
	else
		echo "Install docker-compose"
		# command
		install_docker_compose
	fi
}



#开始菜单
start_menu(){
    clear
	echo "
    ___              _               
   /   \ ___    ___ | | __ ___  _ __ 
  / /\ // _ \  / __|| |/ // _ \| '__|
 / /_//| (_) || (__ |   <|  __/| |   
/___,'  \___/  \___||_|\_\\___||_|  	
    "
    echo -e "\033[43;42m ====================================\033[0m"
    echo -e "\033[43;42m 介绍：Docker一键安装脚本               \033[0m"
    echo -e "\033[43;42m 作者：Azure                          \033[0m"
    echo -e "\033[43;42m 网站：https://baiyue.one             \033[0m"
    echo -e "\033[43;42m Youtube/B站：佰阅部落                 \033[0m"
    echo -e "\033[43;42m 适合centos、ubuntu、debian           \033[0m"
    echo -e "\033[43;42m =====================================\033[0m"
    echo
    echo -e "\033[0;33m  确认请按回车键Enter；否则按Ctrl+C退出 \033[0m"
    echo
    read -p "是否继续？:" num
    case "$num" in   
    *)
    install_pack
	check_docker
    check_docker_compose
    echo -e "\033[32m====================================\033[0m"	
    echo -e "\033[32m 恭喜，您已经完成docker环境的安装                        "
    echo -e "\033[32m====================================\033[0m"	
	;;
    esac
}

start_menu
