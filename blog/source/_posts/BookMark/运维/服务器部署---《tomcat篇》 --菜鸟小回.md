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
[服务器配置篇汇总（linux）+（jdk）+（tomcat）+（mysql）+（nginx）+（redis）+（fastDFS）+（mycat）](https://blog.huijia.cf/2022/09/08/BookMark/%E8%BF%90%E7%BB%B4/%E6%9C%8D%E5%8A%A1%E5%99%A8%E9%85%8D%E7%BD%AE%E7%AF%87%E6%B1%87%E6%80%BB%EF%BC%88linux%EF%BC%89+%EF%BC%88jdk%EF%BC%89+%EF%BC%88tomcat%EF%BC%89+%EF%BC%88mysql%EF%BC%89+%EF%BC%88nginx%EF%BC%89+%EF%BC%88redis%EF%BC%89+%EF%BC%88fastDFS%EF%BC%89+%EF%BC%88mycat%EF%BC%89+%EF%BC%88git%EF%BC%89+(maven)%20--%E8%8F%9C%E9%B8%9F%E5%B0%8F%E5%9B%9E/)
接上篇：
[服务器部署---《jdk篇》](https://blog.huijia.cf/2022/09/08/BookMark/%E8%BF%90%E7%BB%B4/%E6%9C%8D%E5%8A%A1%E5%99%A8%E9%83%A8%E7%BD%B2---%E3%80%8Ajdk%E7%AF%87%E3%80%8B%20--%E8%8F%9C%E9%B8%9F%E5%B0%8F%E5%9B%9E/)

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
[服务器部署---《mysql篇》](https://blog.huijia.cf/2022/09/08/BookMark/%E8%BF%90%E7%BB%B4/%E6%9C%8D%E5%8A%A1%E5%99%A8%E9%83%A8%E7%BD%B2---%E3%80%8Amysql%E7%AF%87%E3%80%8B%20--%E8%8F%9C%E9%B8%9F%E5%B0%8F%E5%9B%9E/)

---
