---
title: 服务器部署---《jdk篇》 --菜鸟小回.md
date:  2022/9/8 17:56
category_bar: true
categories: 运维
tags:
- jdk
---
# 服务器部署---《jdk篇》
---
汇总篇：
[服务器配置篇汇总（linux）+（jdk）+（tomcat）+（mysql）+（nginx）+（redis）+（fastDFS）+（mycat）](https://blog.huijia.cf/2022/09/08/BookMark/%E8%BF%90%E7%BB%B4/%E6%9C%8D%E5%8A%A1%E5%99%A8%E9%85%8D%E7%BD%AE%E7%AF%87%E6%B1%87%E6%80%BB%EF%BC%88linux%EF%BC%89+%EF%BC%88jdk%EF%BC%89+%EF%BC%88tomcat%EF%BC%89+%EF%BC%88mysql%EF%BC%89+%EF%BC%88nginx%EF%BC%89+%EF%BC%88redis%EF%BC%89+%EF%BC%88fastDFS%EF%BC%89+%EF%BC%88mycat%EF%BC%89+%EF%BC%88git%EF%BC%89+(maven)%20--%E8%8F%9C%E9%B8%9F%E5%B0%8F%E5%9B%9E/)

---
## 一、jdk
1. 创建：`mkdir -p /opt/java`
2. 进入：`cd /opt/java`
3. 下载jdk包：`wget http://file.huijia.cf/file/jdk-8u141-linux-x64.tar.gz`
4. 解压：`tar -zxvf jdk-8u141-linux-x64.tar.gz`
5. 编辑：`vi /etc/profile`
6. 配置环境变量：
```
//进编辑模式
i 
//文档最后添加：
export JAVA_HOME=/opt/java/jdk1.8.0_141
export PATH=$PATH:$JAVA_HOME/bin
//保存退出
ESC
:wq
//更新配置
source /etc/profile
```
7. 验证：输出长内容
```
java
javac
java -version
```
![image-20220430210253258](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430210253258.png)

---
接下篇：
[服务器部署---《tomcat篇》 ](https://blog.huijia.cf/2022/09/08/BookMark/%E8%BF%90%E7%BB%B4/%E6%9C%8D%E5%8A%A1%E5%99%A8%E9%83%A8%E7%BD%B2---%E3%80%8Atomcat%E7%AF%87%E3%80%8B%20--%E8%8F%9C%E9%B8%9F%E5%B0%8F%E5%9B%9E/)

---
