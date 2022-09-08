---
title: 服务器部署---《tomcat篇》 --菜鸟小回.md
date:  2022/9/8 17:58
category_bar: true
categories: 运维
tags:
- tomcat
---
# 服务器部署---《tomcat篇》
---
汇总篇：
[服务器配置篇汇总（linux）+（jdk）+（tomcat）+（mysql）+（nginx）+（redis）+（fastDFS）+（mycat）](https://blog.huijia21.com/archives/fu-wu-qi-pei-zhi-pian-hui-zong-linuxjdktomcatmysqlnginxredisfastdfsmycatgitmaven)
接上篇：
[服务器部署---《jdk篇》](https://blog.huijia21.com/archives/fu-wu-qi-bu-shu-jdk-pian-)

---
## 二、tomcat（安全组开启80、8080端口）
1. 创建：`mkdir -p /opt/tomcat`
2. 进入：`cd /opt/tomcat`
3. 上传：`wget http://file.huijia.cf/file/apache-maven-3.6.1-bin.tar.gz`
4. 解压：`tar -zxvf apache-tomcat-8.5.34.tar.gz`
5. 改名：`mv apache-tomcat-8.5.34 tomcat-8.5.34`
6. 启动：
```
cd /opt/tomcat/tomcat-8.5.34/bin/
./startup.sh
```
7. 关防火墙
```
systemctl stop firewalld.service
systemctl disable firewalld.service
```
8. 开安全组
![image-20220430213423919](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430213423919.png)
9. 访问：`http://120.27.244.176:8080` 耐心等待......
![image-20220430213433355](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430213433355.png)
10. 修改端口，配置默认访问项目名
```
//编辑配置文件
vi ../conf/server.xml
//搜索端口
:/8080
改为80
//搜索Host
//添加;root可改为你的项目名
<Context path="/" docBase="root" />
//保存退出
:wq
```
![image-20220430213444811](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430213444811.png)
![image-20220430213454713](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430213454713.png)

11. 重启tomcat
```
cd /opt/tomcat/tomcat-8.5.34/bin/
//关闭
./shutdown.sh
//查看关闭成功（一行输出为成功，多行未成功）
ps -ef|grep java
//未成功，杀死线程
kill -9 线程号
//启动
./startup.sh
```
![image-20220430213505555](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430213505555.png)

12. 访问：`http://120.27.244.176` 等待......
![image-20220430213513763](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430213513763.png)

---
接下篇：
[服务器部署---《mysql篇》](https://blog.huijia21.com/archives/fu-wu-qi-bu-shu-mysql-pian-)

---
