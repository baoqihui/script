---
title: Centos中修改，访问java工程直接通过ip，除去端口号和项目名访问。 --菜鸟小回.md
date:  2022/9/7 10:57
category_bar: true
categories: 运维
tags:
- CentOS
---
# Linuxs系统中修改配置文件使得访问java工程直接通过ip，除去端口号和项目名访问。
---
接上篇:[《阿里云服务器配置 + Linuxs系统安装 jdk、tomcat、MySQL汇总详细教程 + 项目上线发布中的部分小bug解决方案》](https://blog.huijia21.com/archives/a-li-yun-fu-wu-qi-pei-zhi-linuxs-xi-tong-an-zhuang-jdktomcatmysql-hui-zong-xiang-xi-jiao-cheng--xiang-mu-shang-xian-fa-bu-zhong-de-bu-fen-xiao-bug-jie-jue-fang-an)
方法很多，这里只写一种我成功的！

---

1. 删除/usr/tomcat/tomcat8/webapps下的ROOT文件夹
2. 将你的war包改名为ROOT.war
3. 上传ROOT.war
4. 进入你的conf->service.xml
4. 修改端口号为80
![image-20220509174919118](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509174919118.png)w)
5. 在下面<Host>  </Host>中添加下面语句，位置填你的项目位置；
`  <Context path="/" docBase="ss"/> `
![image-20220509174955454](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509174955454.png)6.只输入ip访问下试试吧
![image-20220509175007683](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175007683.png)
