---
title: idea新建一个Spring Boot项目+项目目录简单介绍+项目打包运行+导入Module项目无法识别问题（全部报红或灰色）解决
date: 2022-09-05 17:09:05
category_bar: true
categories: Spring Boot
tags:
  - Spring Boot
  - idea
---

# idea新建一个Spring Boot项目+项目目录简单介绍+项目打包运行+导入Module项目无法识别问题（全部报红或灰色）解决

---

[toc]

+ 本文主要记录首次使用idea创建Spring Boot项目过程以及常见问题，适合初学者。在此之前使用eclipse，打包一般为war包，使用外部tomcat方式部署项目。
  另外spring boot项目内置tomcat，可以将项目打成jar包直接部署。
+ 首先建议更改自己的maven仓库，更快下载所需jar包：[修改maven仓库秒下依赖](https://blog.huijia.cf/archives/xiu-gai-maven-cang-ku-dao-zi-ding-yi-wei-zhi--tian-jia-a-li-yi-lai-miao-xia-jar-bao-eclipseidea)

---

## 一、新建Spring Boot jar包项目

1. ![image-20220430165217870](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430165217870.png)
2. ![image-20220430165224591](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430165224591.png)
3. ![image-20220430165233112](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430165233112.png)

---

## 二、 新建Spring Boot war包项目

+ ![image-20220430165238795](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430165238795.png)新建项目选项不同处： ![image-20220430165248817](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430165248817.png)
+ 添加外部tomcat的pom依赖

```
<dependency>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-starter-tomcat</artifactId>
   <scope>provided</scope>
</dependency>
```

+ 新建web.xml

1. ![image-20220430165308426](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430165308426.png)
2. 然后选择Modules，点击web（如果没有就点击左上角的加号新建一个），接着双击下方的Web Resource Directory中的第一项，这里是来设置webapp的路径，一般是自动设置好了的，直接点ok，然后点yes。
   ![image-20220430165324886](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430165324886.png)
3. 最后点击上面的加号新建web.xml
   ![image-20220430165331877](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430165331877.png)
4. 这里要注意路径，要放到刚才创建的webapp文件夹内。点击ok，然后再点击ok，web.xml就创建好了。
   ![image-20220430165345116](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430165345116.png)

+ 到此war包项目创建完毕，war包项目可使用外部tomcat运行。

---

## 三、项目目录简单介绍

![image-20220430165350127](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430165350127.png)

---

## 四、项目打包运行

1. 右侧maven，找到项目，install
   ![image-20220430165404671](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430165404671.png)
2. jar包运行（主机有jdk）

```
java -jar 包名
//Linux中后台运行
nohup java -jar 包名 &
```

3. war包运行（tomcat的webapps文件夹下）
   ![image-20220430165417686](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430165417686.png)

---

## 五、新手常见问题--module转移后项目全部变灰色或报错。

+ 现象如图
  ![image-20220430165424262](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430165424262.png)
+ 解决

1. 在idea右侧找到maven
   ![image-20220430165435006](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430165435006.png)
2. 发现此处没有该module
   ![image-20220430165448018](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430165448018.png)
3. 添加该module的pom.xml
   ![image-20220430165453164](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430165453164.png)

+ ![image-20220430165500622](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430165500622.png)问题解决
  
  