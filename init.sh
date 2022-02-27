echo " --------------------------------------------------------------------"
echo -e " ---------------------- \033[33m一键初始化常用系统设置\033[0m ---------------------- "
echo -e " ------- \033[33m功能 1、开放所有端口\033[0m --------------------------------------- "
echo -e " ------- \033[33m功能 2、统一本地时间\033[0m --------------------------------------- "
echo -e " ------- \033[33m功能 3、更新及安装组件\033[0m ------------------------------------- "
echo -e " ------- \033[33m功能 4、开启BBR加速\033[0m ---------------------------------------- "
echo -e " ------- \033[33m功能 5、测速\033[0m ----------------------------------------------- "
echo -e " ------- \033[33m功能 6、关闭Iptable规则\033[0m ------------------------------------ "
echo " --------------------------------------------------------------------"

echo -e "\033[32m 1.开放所有端口 \033[0m"
echo -e "\033[32m 2.统一本地时间 \033[0m"
echo -e "\033[32m 3.更新及安装组件 \033[0m"
echo -e "\033[32m 4.开启BBR加速 \033[0m"
echo -e "\033[32m 5.测速 \033[0m"
echo -e "\033[32m 6.关闭Iptable规则 \033[0m"
echo -e "\033[32m 7.依次执行1~6 \033[0m"
read -p " 请选择你要执行的项(默认'7'):" index
index=${index:-'7'}

case $index in
    1)
		iptables -P INPUT ACCEPT
		iptables -P FORWARD ACCEPT
		iptables -P OUTPUT ACCEPT
		iptables -F
		echo -e "\033[32m 已开放所有端口！！！ \033[0m"
        ;;
    2)
		rm -rf /etc/localtime
		ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
		echo -e "\033[32m 已统一本地时间！！！ \033[0m"
        ;;
    3)
		apt update -y
		apt install -y curl
		apt install -y socat
		echo -e "\033[32m 已更新及安装组件！！！ \033[0m"
        ;;
    4)
		echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
		sysctl -p
		sysctl net.ipv4.tcp_available_congestion_control
		sysctl net.ipv4.tcp_congestion_control
		echo -e "\033[32m 开启BBR加速完成！！！ \033[0m"
	;;
    5)
		apt install speedtest-cli
		speedtest-cli
		echo -e "\033[32m 测速完成！！！ \033[0m"
	;;
    6)
		apt-get purge -y  netfilter-persistent
		echo -e "\033[32m 已关闭Iptable规则(重启生效)！！！ \033[0m"
		
		read -p " 是否重启？(默认回车重启，输入任意字符不重启):" isReboot
		isReboot=${isReboot}
		if test ! -z "${isReboot}"
		    then 
		        echo -e "\033[32m 您选择了不重启，部分设置需重启后生效(命令：reboot) \033[0m"
		        exit
		    else
		        echo -e "\033[33m 重启... \033[0m"
		        reboot
		fi
        ;;
    7)
		iptables -P INPUT ACCEPT
		iptables -P FORWARD ACCEPT
		iptables -P OUTPUT ACCEPT
		iptables -F
		echo -e "\033[32m 已开放所有端口！！！ \033[0m"
		
		rm -rf /etc/localtime
		ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
		echo -e "\033[32m 已统一本地时间！！！ \033[0m"
		
		apt update -y
		apt install -y curl
		apt install -y socat
		echo -e "\033[32m 已更新及安装组件！！！ \033[0m"
		
		echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
		sysctl -p
		sysctl net.ipv4.tcp_available_congestion_control
		sysctl net.ipv4.tcp_congestion_control
		echo -e "\033[32m 开启BBR加速完成！！！ \033[0m"
		
		apt install speedtest-cli
		speedtest-cli
		echo -e "\033[32m 测速完成！！！ \033[0m"
		
		apt-get purge -y  netfilter-persistent
		echo -e "\033[32m 已关闭Iptable规则(重启生效)！！！ \033[0m"
		
		read -p " 是否重启？(默认回车重启，输入任意字符不重启):" isReboot
		isReboot=${isReboot}
		if test ! -z "${isReboot}"
		    then 
		        echo -e "\033[32m 您选择了不重启，部分设置需重启后生效(命令：reboot) \033[0m"
		        exit
		    else
		        echo -e "\033[33m 重启... \033[0m"
		        reboot
		fi
esac
