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
[服务器配置篇汇总（linux）+（jdk）+（tomcat）+（mysql）+（nginx）+（redis）+（fastDFS）+（mycat）](https://blog.huijia21.com/archives/fu-wu-qi-pei-zhi-pian-hui-zong-linuxjdktomcatmysqlnginxredisfastdfsmycatgitmaven)

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
[服务器部署---《tomcat篇》 ](https://blog.huijia21.com/archives/fu-wu-qi-bu-shu-tomcat-pian-)

---
