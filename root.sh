echo " --------------------------------------------------------------------"
echo -e " ------------------------ \033[33m一键修改root账户密码\033[0m -------------------------- "
echo " --------------------------------------------------------------------"
echo -e "\033[32m 开始执行... \033[0m"

sudo -i
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
service sshd restart

echo -e "\033[32m 开始修改密码... \033[0m"
sudo passwd root


