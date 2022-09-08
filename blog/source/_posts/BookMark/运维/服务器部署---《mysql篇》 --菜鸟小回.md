---
title: 服务器部署---《mysql篇》 --菜鸟小回.md
date:  2022/9/8 17:57
category_bar: true
categories: 运维
tags:
- mysql
---
# 服务器部署---《mysql篇》
---
汇总篇：
[服务器配置篇汇总（linux）+（jdk）+（tomcat）+（mysql）+（nginx）+（redis）+（fastDFS）+（mycat）](https://blog.huijia21.com/archives/fu-wu-qi-pei-zhi-pian-hui-zong-linuxjdktomcatmysqlnginxredisfastdfsmycatgitmaven)
接上篇：
[服务器部署---《tomcat篇》](https://blog.huijia21.com/archives/fu-wu-qi-bu-shu-tomcat-pian-)

---
## 三、mysql（安全组开启3306端口）
<font color=red size=5>所有确认操作均为：y </font>
1. 安装 wget 下载器：`sudo yum install wget`
2. 创建：`mkdir /opt/mysql`
3. 进入：`cd /opt/mysql/`
4. 安装
```
wget http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm
//用 yum 安装MySQL Yum
yum localinstall mysql57-community-release-el7-8.noarch.rpm
安装 MySQL
yum install mysql-community-server
```
5. 启动
```
//启动 MySQL
systemctl start mysqld
//设置开机启动 MySQL
systemctl enable mysqld
systemctl daemon-reload
```
6. 查看密码：`sudo grep 'temporary password' /var/log/mysqld.log`
密码：`qGOzkVMGZ0%A`
![image-20220430210854417](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430210854417.png)
7. 设置新密码
```
sudo mysql_secure_installation
//输入临时密码
qGOzkVMGZ0%A
//输入新密码（大写+小写+数字+符号）
***********
```
![image-20220430210901320](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430210901320.png)

8. 开启端口3306
![image-20220430210909710](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430210909710.png)

9.  改变策略让root远程连接，或者创建新用户去远程连接
```
//1. 登录,-u账号 -p密码
 mysql -uroot -p521521
//2. 进入mysql:
 use mysql;
//3.更新user表数据，添加远程访问权限；
update user set Host='%' where User='root';
//4.刷新属性
flush privileges;
```
![image-20220430210919571](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430210919571.png)

10. navicat远程连接
![image-20220430210934055](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430210934055.png)

---
接下篇：
[服务器部署---《nginx篇》](https://blog.huijia21.com/archives/fu-wu-qi-bu-shu-nginx-pian-)

---
