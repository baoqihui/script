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
