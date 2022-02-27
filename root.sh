echo " --------------------------------------------------------------------"
echo -e " ------------------------ \033[33m一键修改root账户密码\033[0m -------------------------- "
echo " --------------------------------------------------------------------"

echo -e "\033[32m 开始执行... \033[0m"

read -p " 请输入你root密码:" password                                   
password=${password}
if test ! -z "${password}"
	then 
		echo -e "\033[32m password:$password \033[0m"
	else
		echo -e "\033[33m password为空，退出程序... \033[0m"
		exit
fi
sudo -i
echo root:$password|chpasswd
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
service sshd restart
