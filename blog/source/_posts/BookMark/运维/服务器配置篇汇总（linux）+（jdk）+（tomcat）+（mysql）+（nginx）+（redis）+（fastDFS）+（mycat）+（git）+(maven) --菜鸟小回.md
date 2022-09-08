---
title: 服务器配置篇汇总（linux）+（jdk）+（tomcat）+（mysql）+（nginx）+（redis）+（fastDFS）+（mycat）+（git）+(maven) --菜鸟小回.md
date:  2022/9/8 17:59
category_bar: true
categories: 运维
tags:
- 服务器
---
# 服务器配置篇汇总（linux）+（jdk）+（tomcat）+（mysql）+（nginx）+（redis）+（fastDFS）+（mycat）+（git）+(maven)
---
<font color=red size=5>本文说明：经一段时间学习，汇总整理了服务器配置方面的安装方式。发表在此用于分享交流学习！</font>
+ [阿里服务器大礼包](https://www.aliyun.com/minisite/goods?userCode=e3v6m6yo) 
+ [ECS服务器购买程序](https://blog.csdn.net/qq_39231769/article/details/100587577)
+ 相关运维教程：[从docker安装到前后端分离项目启动完成（docker安装mysql、nginx；启动jar包）](https://blog.csdn.net/qq_39231769/article/details/119008899?spm=1001.2014.3001.5502)
---
## 一、标题技术简介：
1. linux：Linux是一套免费使用和自由传播的类Unix操作系统。主流版本：debian、ubuntu、centos；多用于服务器配置。此处不做过多介绍，大家自行百度。博主此次选用阿里云的ECS服务器。系统版本为Centos 7。
2. jdk：Java 开发工具包。整个Java的核心，包括了Java运行环境JRE、Java工具和Java基础类库。java运行的必备环境，博主项目为java的 ssm+maven项目。所以需要安装jdk。
3. tomcat：Tomcat 服务器是一个免费的开放源代码的Web 应用服务器。属于轻量级应用服务器，在中小型系统和并发访问用户不是很多的场合下被普遍使用，是开发和调试JSP 程序的首选。免费，快速，方便，易部署。这些特性让他成我我们首选服务器。
4. mysql：MySQL是一个关系型数据库管理系统，由于其体积小、速度快、总体拥有成本低，尤其是开放源码这一特点，一般中小型网站的开发都选择 MySQL 作为网站数据库。博主项目数据库使用mysql数据库。
5. nginx：Nginx (engine x) 是一个高性能的HTTP和反向代理web服务器，Nginx作为代理服务器。此处主要使用nginx配置负载均衡，让部署在两台ECS服务器的两个相同项目都可以被用户用同一域名访问。用一个域名去映射两个ip。配置负载，让项目更好的面对高并发。
6. redis：是一个开源的使用ANSI C语言编写、支持网络、可基于内存亦可持久化的日志型、Key-Value数据库。一个高性能的key-value数据库。由于使用上方的nginx代理服务器。客户端访问项目时很可能访问我们两台服务器上的同一项目。我们的项目session共享问题就需要借助redis短暂共享存储。
7. fastDFS：FastDFS是一个开源的轻量级分布式文件系统，它对文件进行管理，功能包括：文件存储、文件同步、文件访问（文件上传、文件下载）等，解决了大容量存储和负载均衡的问题。博主项目中用到了图片上传下载功能。使用fastDFS制作一个属于自己的图库，再合适不过了。
8. mycat：Mycat 是一个开源的分布式数据库系统，mycat是一个数据库中间件，也可以理解为是数据库代理。mycat的三大功能：分表、读写分离、主从切换。此处暂时只是简单模拟分表功能。也用来降低单个mysql数据库读写压力。
9. git+maven:实现Spring Boot项目的快速上传服务器并打包运行

---

## 二、阿里云服务器的购买，简单配置连接在上篇博客已经写过。另外如果没有linux命令使用经验也建议先去阅读下方链接博文，比较详细。
+ 链接：[阿里云服务器配置](https://blog.huijia21.com/archives/a-li-yun-fu-wu-qi-pei-zhi-linuxs-xi-tong-an-zhuang-jdktomcatmysql-hui-zong-xiang-xi-jiao-cheng--xiang-mu-shang-xian-fa-bu-zhong-de-bu-fen-xiao-bug-jie-jue-fang-an)

---
## 三、创建安全组规则（开放端口）
1. 管理ECS![enter description here](https://imgconvert.csdnimg.cn/aHR0cDovL2hicS5pZHNlLnRvcC9ibG9nLzE1NzA5NzY4NzQzNjYucG5n?x-oss-process=image/format,png)
2. 进去本实例安全组，配置规则。

![image-20220509151906341](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509151906341.png)
3. 快速创建规则
![image-20220509151844712](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509151844712.png)
4. 配置下方所用技术端口
![image-20220509151914789](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509151914789.png)

---
# 四、标题技术安装方法。太长不易阅读，故分开发布。
使用教程前请先安装wget以便下载相关安装包：`sudo yum install wget`

[1.服务器部署---《jdk篇》](https://blog.huijia21.com/archives/fu-wu-qi-bu-shu-jdk-pian-)

[2.服务器部署---《tomcat篇》](https://blog.huijia21.com/archives/fu-wu-qi-bu-shu-tomcat-pian-)

[3.服务器部署---《mysql篇》](https://blog.huijia21.com/archives/fu-wu-qi-bu-shu-mysql-pian-)

[4.服务器部署---《nginx篇》](https://blog.huijia21.com/archives/fu-wu-qi-bu-shu-nginx-pian-)

[5.服务器部署---《redis篇》](https://blog.huijia21.com/archives/fu-wu-qi-bu-shu-redis-pian-)

[6.服务器部署---《fastDFS篇》](https://blog.huijia21.com/archives/fu-wu-qi-bu-shu-fastdfs-pian-)

[7.服务器部署---《mycat篇》](https://blog.huijia21.com/archives/fu-wu-qi-bu-shu-mycat-pian-)

[7.服务器部署---《linux加载git仓库代码打包并运行》](https://blog.huijia21.com/archives/fu-wu-qi-bu-shu-linux-jia-zai-git-cang-ku-dai-ma-da-bao-bing-yun-xing-)
