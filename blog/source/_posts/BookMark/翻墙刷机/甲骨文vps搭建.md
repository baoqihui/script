---
title: 甲骨文vps搭建.md
date:  2022/9/7 10:53
category_bar: true
categories: 翻墙刷机
tags:
- vps
- 翻墙
---
# 甲骨文vps搭建

---

[toc]

---

## 一、服务器配置

### 1.进入自己的实例，设置子网

![image-20220721160820546](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721160820546.png)



![image-20220721160836886](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721160836886.png)

开放所有端口，当然你也可以设置需要开放的端口，我这里是所有开放

![image-20220721160845932](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721160845932.png)

## 二、域名相关的配置

https://dash.cloudflare.com/

## 三、V2ray安装

### 1.开始配置前需要做的事情

```
****************可选账号密码登录**************
#一键修改root密码
bash <(curl -sSL https://cdn.jsdelivr.net/gh/kkkyg/vpsroot/root.sh)
#手动修改
sudo passwd root
sudo -i
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
service sshd restart
```

```
#开放所有端口
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F
```

```
#修改本地的时间
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

```
**********************Ubuntu专属*********************
更新及安装组件
apt update -y          # Debian/Ubuntu 命令
apt install -y curl    #Debian/Ubuntu 命令
apt install -y socat    #Debian/Ubuntu 命令

#测速可选
apt install speedtest-cli
speedtest-cli

镜像默认设置了Iptable规则，关闭它
apt-get purge -y  netfilter-persistent
reboot
```

```
**********************CentOS专属*********************
yum update -y          #CentOS 命令
yum install -y curl    #CentOS 命令
yum install -y socat    #CentOS 命令

防火墙相关命令
firewall-cmd --state                   # 查看防火墙状态
systemctl stop firewalld.service       # 停止防火墙
systemctl disable firewalld.service    # 禁止防火墙开机自启
```

### 2.脚本一

`bash <(curl -sL https://s.hijk.art/v2ray.sh)`

### 3.脚本二（UI管理，可定制化强）

```
# 安装 Acme 脚本
curl https://get.acme.sh | sh

# 80 端口空闲的证书申请方式
# 自行更换代码中的域名、邮箱为你解析的域名及邮箱
~/.acme.sh/acme.sh --register-account -m baoqi.hui@qq.com
~/.acme.sh/acme.sh --issue -d aiqi.cf --standalone

# 安装证书到指定文件夹
# 自行更换代码中的域名为你解析的域名
~/.acme.sh/acme.sh --installcert -d service.common.cf --key-file /root/gost_cert/key.pem --fullchain-file /root/gost_cert/cert.pem

# 安装BBR加速
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
sysctl net.ipv4.tcp_available_congestion_control
sysctl net.ipv4.tcp_congestion_control

# 安装 & 升级 X-ui 面板
bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh)
```

UI页面设置参考：

![image-20220721160857103](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721160857103.png)





### 4.脚本三（前两种的折中方案）

```
安装或优化脚本
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
```

1. 安装

![image-20220721160905809](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721160905809.png)

2. 优化

![image-20220721160917230](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721160917230.png)

