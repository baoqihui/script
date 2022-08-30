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
