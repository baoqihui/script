echo " ------------------------------------------------------------------------"
echo -e " ------------------------ \033[33m自动安装acme证书\033[0m ------------------------------ "
echo -e " ------- \033[33m功能 1、全自动安装证书到指定文件夹\033[0m ----------------------------- "
echo -e " ------- \033[33m功能 2、范域名安装\033[0m --------------------------------------------- "
echo -e " ------- \033[33m功能 3、自动续期\033[0m ----------------------------------------------- "
echo -e " ------- \033[33m功能 4、附加命令\033[0m ----------------------------------------------- "
echo -e " ------- \033[33mCF KEY获取地址 https://dash.cloudflare.com/profile/api-tokens\033[0m --"
echo -e " ------- \033[33m此脚本绝不会保存任何信息 \033[0m --------------------------------------"
echo " ------------------------------------------------------------------------"

echo -e "\033[32m 开始执行... \033[0m"

read -p " 请输入你要安装的根目录(默认'/opt/cert',最终生成默认目录为'/opt/cert/domain/'):" path
path=${path:-'/opt/cert'}
echo -e "\033[32m path:$path \033[0m"

read -p " 请输入你的cloudflare email:" email
email=${email:-'baoqi.hui@qq.com'}
echo -e "\033[32m email:$email \033[0m"

read -p " 请输入你的cloudflare key:" key
key=${key:-'a1e21b38726d8f875247157d9ddee64e270c3'}
echo -e "\033[32m key:$key\033[0m"

read -p " 请输入你的范域名（如：example@qq.com）:" i
i=${i}
echo -e "\033[32m domains:$i \033[0m"

read -p " 请输入在申请完域名后要执行的命令，如：docker restart nginx:" reloadcmd
reloadcmd=${reloadcmd:-'docker restart nginx'}
echo -e "\033[32m reloadcmd:$reloadcmd \033[0m"

#安装acme
curl  https://get.acme.sh | sh -s email=$email
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
export CF_Email=$email
export CF_Key=$key

#安装证书
echo -e "\033[32m 安装$i证书到'$path/$i'............................. \033[0m"
mkdir -p $path/$i
~/.acme.sh/acme.sh --issue -d $i -d *.$i --dns dns_cf --key-file $path/$i/$i.key --fullchain-file $path/$i/fullchain.cert --reloadcmd "$reloadcmd"
