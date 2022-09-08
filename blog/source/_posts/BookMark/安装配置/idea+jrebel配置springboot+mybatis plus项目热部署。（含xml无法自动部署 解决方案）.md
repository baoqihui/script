---
title: idea+jrebel配置springboot+mybatis plus项目热部署。（含xml无法自动部署 解决方案）.md
date:  2022/9/7 10:37
category_bar: true
categories: 安装配置
tags:
- JRebel
- Spring Boot
---
# idea+JRebel配置springboot+mybatis plus项目热部署。（含xml无法自动部署 解决方案）

---

[toc]

---

本文参照文章地址：

1. [【idea】JRebel mybatisPlus extension是JRebel热部署插件的扩展支持mybatis的xml文件热部署](https://www.cnblogs.com/xiaostudy/p/11890444.html)
2. [在IDEA中安装配置并使用Jrebel热部署插件](https://www.cnblogs.com/fangts/p/13709977.html)

---

## 一、直接到idea插件库搜索`JRebel`,安装并重启idea
![image-20220430164359993](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430164359993.png)

---

## 二、激活JRebel
![image-20220430164408231](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430164408231.png)
+ 激活步骤：
	 1. [生成UUID](https://www.guidgen.com/)
	 2. `https://jrebel.qekang.com/`后拼接上你生成的UUID填写至“1”处；
	 3. 在“2”处填写任意格式邮箱
	 4. 查看激活状态并更换为离线运行，至此已可以进行java项目的热部署测试。
	    ![image-20220430164413734](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430164413734.png)
---

## 三、mybatis plus的xml文件热部署
1. 此时在项目java代码中已经可以实现自动部署，但如图我们的xml文件还无法自动部署。
![image-20220430164419157](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430164419157.png)
2. 解决：安装插件`JRebel mybatisPlus extension`并重启idea即可。
 ![image-20220430164433938](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430164433938.png)