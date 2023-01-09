echo " --------------------------------------------------------------------"
echo -e " ---------------------- \033[33m汇总常用脚本集\033[0m ------------------------------ "
echo -e " ------- \033[33m功能 1、root密码\033[0m ------------------------------------------- "
echo -e " ------- \033[33m功能 2、初始化系统\033[0m ----------------------------------------- "
echo -e " ------- \033[33m功能 3、申请范域名证书\033[0m ------------------------------------- "
echo -e " ------- \033[33m功能 4、申请单域名证书\033[0m ------------------------------------- "
echo -e " ------- \033[33m功能 5、恢复数据库\033[0m ----------------------------------------- "
echo -e " ------- \033[33m功能 6、恢复rclone备份\033[0m ------------------------------------- "
echo " --------------------------------------------------------------------"


read -p "请选择你需要的服务编号(1~6): " service
service=${service}

case $service in
  1)
  echo " --------------------------------------------------------------------"
  echo -e " ---------------------- \033[33m一键修改root账户密码\033[0m ------------------------ "
  echo -e " ------- \033[33m功能 1、修改Ubuntu的root密码\033[0m ------------------------------- "
  echo -e " ------- \033[33m功能 2、持久化root密码，可永久连接\033[0m ------------------------- "
  echo " --------------------------------------------------------------------"

  echo -e "\033[32m 确认你的root密码（两次输入且无提示）... \033[0m"
  sudo passwd root

  echo -e "\033[32m 修改成功！！！ \033[0m"

  sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
  sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
  sudo service sshd restart
  sudo -i
  ;;
  2)
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
  ;;
  3)
  echo " ------------------------------------------------------------------------"
  echo -e " ------------------------ \033[33m自动安装acme证书\033[0m ------------------------------ "
  echo -e " ------- \033[33m功能 1、全自动安装证书到指定文件夹\033[0m ----------------------------- "
  echo -e " ------- \033[33m功能 2、泛域名安装\033[0m --------------------------------------------- "
  echo -e " ------- \033[33m功能 3、自动续期\033[0m ----------------------------------------------- "
  echo -e " ------- \033[33m功能 4、附加命令\033[0m ----------------------------------------------- "
  echo -e " ------- \033[33mCF KEY获取地址 https://dash.cloudflare.com/profile/api-tokens\033[0m --"
  echo -e " ------- \033[33m阿里 KEY获取地址 https://ram.console.aliyun.com/users\033[0m ----------"
  echo -e " ------- \033[33mCF DNS现不支持.cf, .ga, .gq, .ml, or .tk 域名\033[0m ------------------"
  echo -e " ------- \033[33m此脚本绝不会保存任何信息 \033[0m --------------------------------------"
  echo " ------------------------------------------------------------------------"

  read -p "请选择你的域名服务商: 1.cloudflare(DNS)  2.阿里云(DNS)：" types
  types=${types}

  case "$types" in
    1)
  	echo -e "\033[32m -----------------cloudflare(DNS)start----------------------------\033[0m"
  	echo -e "\033[32m 开始执行... \033[0m"

  	read -p " 请输入你要安装的根目录(默认'/opt/cert'):" path
  	path=${path:-'/opt/cert'}
  	echo -e "\033[32m path:$path \033[0m"

  	read -p " 请输入你的cloudflare email:" email
  	email=${email}
  	echo -e "\033[32m email:$email \033[0m"

  	read -p " 请输入你的cloudflare key:" key
  	key=${key}
  	echo -e "\033[32m key:$key\033[0m"

  	read -p " 请输入你的泛域名，多个空格隔开（如：aaa.com bb.cn）:" domains
  	domains=${domains}
  	echo -e "\033[32m domains:$domains \033[0m"

  	read -p " 请输入在申请完域名后要执行的命令，如：docker restart nginx:" reloadcmd
  	reloadcmd=${reloadcmd:-'docker restart nginx'}
  	echo -e "\033[32m reloadcmd:$reloadcmd \033[0m"

  	#安装acme
  	curl  https://get.acme.sh | sh -s email=$email
  	~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
  	export CF_Email=$email
  	export CF_Key=$key

  	domain='';
  	for i in $domains;
  	do
  	domain="$domain -d $i -d *.$i"
  	done

  	#安装证书
  	echo -e "\033[32m 安装证书到'$path'............................. \033[0m"
  	mkdir -p $path
  	~/.acme.sh/acme.sh --issue --dns dns_cf $domain --key-file $path/fullchain.key --fullchain-file $path/fullchain.cer --reloadcmd "$reloadcmd"
    ;;
    2)
  	echo -e "\033[32m -----------------阿里云(DNS)start----------------------------\033[0m"
  	echo -e "\033[32m 开始执行... \033[0m"

  	read -p " 请输入你要安装的根目录(默认'/opt/nginx/cert'):" path
  	path=${path:-'/opt/nginx/cert'}
  	echo -e "\033[32m path:$path \033[0m"

  	read -p " 请输入你的Ali_Key:" Ali_Key
  	Ali_Key=${Ali_Key}
  	echo -e "\033[32m Ali_Key:$Ali_Key \033[0m"

  	read -p " 请输入你的Ali_Secret:" Ali_Secret
  	Ali_Secret=${Ali_Secret}
  	echo -e "\033[32m Ali_Secret:$Ali_Secret\033[0m"

  	read -p " 请输入你的泛域名，多个空格隔开（如：aaa.com bb.cn）:" domains
  	domains=${domains}
  	echo -e "\033[32m domains:$domains \033[0m"

  	read -p " 请输入在申请完域名后要执行的命令，如：docker restart nginx:" reloadcmd
  	reloadcmd=${reloadcmd:-'docker restart nginx'}
  	echo -e "\033[32m reloadcmd:$reloadcmd \033[0m"

  	#安装acme
  	curl  https://get.acme.sh | sh -s email=email@qq.com
  	~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
  	export Ali_Key=$Ali_Key
  	export Ali_Secret=$Ali_Secret

  	domain='';
  	for i in $domains;
  	do
  	domain="$domain -d $i -d *.$i"
  	done

  	#安装证书
  	echo -e "\033[32m 安装证书到'$path'............................. \033[0m"
  	mkdir -p $path
  	~/.acme.sh/acme.sh --issue --dns dns_ali $domain --key-file $path/fullchain.key --fullchain-file $path/fullchain.cer --reloadcmd "$reloadcmd"
  	;;
    *) echo "暂不支持..."
  esac
  ;;
  4)
  echo " --------------------------------------------------------------------"
  echo -e " ------------------------ \033[33m自动安装acme证书\033[0m -------------------------- "
  echo -e " ------- \033[33m功能 1、全自动安装证书到指定文件夹\033[0m ------------------------- "
  echo -e " ------- \033[33m功能 2、批量安装\033[0m ------------------------------------------- "
  echo -e " ------- \033[33m功能 3、自动续期\033[0m ------------------------------------------- "
  echo -e " ------- \033[33m功能 4、docker中nginx续费重启\033[0m ------------------------------ "
  echo -e " ------- \033[33m此脚本默认自动关闭80端口服务...若未成功请手动关闭... \033[0m ------"
  echo " --------------------------------------------------------------------"

  echo -e "\033[32m 开始执行... \033[0m"
  pids=$(lsof -t -i:80)

  if test ! -z "${pids}"
  	then
  		kill -9 $pids
  		echo -e "\033[32m 80端口已关闭... \033[0m"
  	else
  		echo -e "\033[32m 80端口空闲... \033[0m"
  fi

  read -p " 请输入你要安装的根目录(默认'/opt/cert',最终生成默认目录为'/opt/cert/domain/'):" path
  path=${path:-'/opt/cert'}
  echo -e "\033[32m path:$path \033[0m"

  read -p " 请输入你的邮箱(默认'example@qq.com'):" email
  email=${email:-'example@qq.com'}
  echo -e "\033[32m email:$email \033[0m"

  read -p " 请输入你的域名(多个使用空格隔开: 如 'example.com www.example.com'):" domains
  domains=${domains}
  if test ! -z "${domains}"
  	then
  		echo -e "\033[32m domains:$domains \033[0m"
  	else
  		echo -e "\033[33m domains为空，退出程序... \033[0m"
  		exit
  fi

  read -p " 是否需要在自动续期后重启docker下的nginx（默认不需要，若需要则输入docker容器名字如：nginx）:" dockername
  dockername=${dockername}
  echo -e "\033[32m dockername:$dockername \033[0m"
  curl  https://get.acme.sh | sh -s email=$email
  ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
  if test ! -z "${dockername}"
  	then
  		echo -e "\033[32m $dockername自重启安装... \033[0m"
  		#安装acme
  		for i in $domains;
  		do
  		echo -e "\033[32m 安装$i证书到'$path/$i'............................. \033[0m"
  		docker stop $dockername

  		mkdir -p $path/$i
  		~/.acme.sh/acme.sh --issue -d $i --standalone
  		~/.acme.sh/acme.sh --install-cert -d $i --key-file $path/$i/private.key --fullchain-file $path/$i/cert.crt --reloadcmd "docker restart $dockername"
  		done
  	else
  		echo -e "\033[33m 普通安装... \033[0m"
  		#安装acme
  		for i in $domains;
  		do
  		echo -e "\033[32m 安装$i证书到'$path/$i'............................. \033[0m"
  		mkdir -p $path/$i
  		~/.acme.sh/acme.sh --issue -d $i --standalone
  		~/.acme.sh/acme.sh --install-cert -d $i --key-file $path/$i/private.key --fullchain-file $path/$i/cert.crt
  		done
  fi
  ;;
  5)
  read -p " 请输入你要还原的数据库容器名:" name
  name=${name:-"mysql"}
  #需要还原的文件列表
  nowDate=$(date "+%Y%m%d")
  read -p " 请输入你要还原的数据库容器中绝对路径(多个空格隔开):" mdatas
  mdatas=${mdatas:-"/out/mysql/all-db-$nowDate.sql"}
  read -p " 请输入数据库密码(脚本不记录):" password
  password=${password:-"HBQ521521cf*"}
  #遍历数据库进行还原
  for i in $mdatas;
  do
  	nowTime=$(date "+%Y-%m %d-%H:%M:%S")
  	echo -e "\033[32m $nowTime: 还原 $i -> $name \033[0m"
  	docker exec $name sh -c "mysql -uroot -p$password < $i";
  done
  ;;
  6)
  #需要还原的文件列表
  read -p " 请输入你要还原的文件绝对路径(多个空格隔开):" rdatas
  rdatas=${rdatas:-'/backup/opt.zip /backup/mysql.zip /backup/mysql7.zip /backup/mysql8.zip'}
  #还原位置
  outDir="/out/recover"
  mkdir -p $outDir

  for i in $rdatas;
  do
  	nowTime=$(date "+%Y-%m %d-%H:%M:%S")
  	#获取文件名字
  	fileName=${i##*/}
  	#最终的文件存放路径
  	outFilePath=$outDir/$fileName
  	#阿里云盘下载
  	echo -e "\033[32m 下载$i到$outFilePath开始... \033[0m"
  	rclone sync -P onedrive:$i $outDir
  	echo -e "\033[32m 下载$i到$outFilePath完成... \033[0m"
  	#zip解压
  	unzip -o -d / $outFilePath
  	echo -e "\033[32m $nowTime: $i还原完成!!! \033[0m"
  done
  ;;
  *) echo "暂不支持..."
esac
