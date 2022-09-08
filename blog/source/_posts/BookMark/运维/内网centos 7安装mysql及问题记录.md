---
title: 内网centos 7安装mysql及问题记录.md
date:  2022/9/7 12:41
category_bar: true
categories: 运维
tags:
- Centos
---
# 内网centos 7安装mysql及可能出现问题记录

---

[toc]

---

公网centos 7安装mysql见：
[服务器部署---《mysql篇》 --菜鸟小回](https://blog.huijia21.com/archives/fu-wu-qi-bu-shu-mysql-pian-)
因内网原因，公网个别命令出现问题，只能采取解压包形式安装。
主流程参考：
[CentOS 7.2内网环境搭建MySQL5.7.24](https://www.cnblogs.com/yybrhr/p/9914427.html)

# 可能出现问题：
## 一、在使用msqld命令时： -bash: mysqld: 未找到命令。
出现该问题是因为环境变量问题，解决方案为配置环境变量，配置完成后重新使用mysqld命令
```
vi /etc/profile
#末尾添加
export PATH=$PATH:/usr/local/mysql/bin
#刷新环境变量
source /etc/profile
```
## 二、执行mysqld --initialize --user=mysql报错：Can't change to run as user 'mysql' Please check that the user exists
解决：
```
#创建mysql用户
useradd mysql
#mysql目录改为mysql读写权限
chown -R mysql:mysql /var/lib/mysql
chown -R mysql:mysql /usr/local/mysql
```
[方案来源](https://blog.csdn.net/u012889638/article/details/51395327)

## 三、使用navicate连接mysql时：ERROR 1062 (23000): Duplicate entry '%-root' for key 'PRIMARY'
+ 原因：老生常谈的防火墙问题，3306端口未开放
+ 解决：
```
#开放防火墙3306端口
firewall-cmd --zone=public --add-port=3306/tcp --permanent
#重启防火墙
systemctl restart firewalld.service
```