---
title: Eclipse+idea修改maven仓库到自定义位置+添加阿里依赖秒下jar包 --菜鸟小回.md
date:  2022/9/7 10:34
category_bar: true
categories: 安装配置
tags:
- maven
---
# Eclipse修改maven仓库到自定义位置+添加阿里依赖秒下jar包
---

---

[toc]

+ 前言：
+ 大家在刚开始使用eclipse使用坐标下载maven的jar包时一定出现过下载过慢或者缺包错误等等问题。出现该问题一般是因为使用系统默认的maven仓库，也就是用户.m2下的仓库。解决思路就是自己创建一个新的本地仓库。并使用国内阿里镜像下载。完美解决!
+ [maven3.6.1包](https://alist.huijia.cf/d/hui/%E8%BD%AF%E4%BB%B6/Java/apache-maven-3.6.1-bin.zip) 


---
## 一、Maven配置
1. 解压我们的maven包。
2. 新建一个空文件夹作为你的maven仓库
![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/aHR0cDovL2hicS5pZHNlLnRvcC9ibG9nLzE1NzE2NjI0NjgyMDMucG5n)
3. 找到D:\maven\apache-maven-3.6.2\conf目录下setting.xml修改配置：
```
//ctrl+f搜索“repository”在注视下方加入下边语句，路径改为你新建的仓库路径（注意不要加在注释代码内）
 <localRepository>D:\maven\repository</localRepository>
//Ctrl+f搜“mirrors”注释下方添加阿里镜像
<mirror>
      <id>alimaven</id>
      <name>aliyun maven</name>
      <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
      <mirrorOf>central</mirrorOf>        
</mirror>
```

![image-20220430163617258](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430163617258.png)

## 二、eclipse

1. 进入eclipse配置新的maven

+ `Window -> preferences -> maven -> installations -> add`
![image-20220430163632556](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430163632556.png)
+ 选择刚配置的maven
![image-20220430163643969](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430163643969.png)
+ 勾选，应用
![image-20220430163649253](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430163649253.png)

2. 更换新的仓库

+ `Window -> preferences -> maven -> user sertting -> browse`
![image-20220430163801768](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430163801768.png)
+ 找到我们刚才修改的setting设置，选中。
![image-20220430163814828](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430163814828.png)
+ 可以看到仓库已经自动由默认仓库换为我们自定义的
+ `updata settings ->APPLY -> OK`
![image-20220430163820272](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430163820272.png)

3. 导入你的pom依赖飞速下载吧！！！

## 二、idea
1. 点击File-settings
![image-20220430163829194](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430163829194.png)
2. 设置maven![image-20220430163843789](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430163843789.png)

3. 设置setting.xml位置和仓库位置。
   ![image-20220430163903454](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430163903454.png)<font color=red size=5> 注：请使用idea请使用maven3.6.1版本</font>
