---
title: 解决：Error java 无效的源发行版 12 --菜鸟小回.md
date:  2022/9/7 10:45
category_bar: true
categories: 异常
tags:
- 异常
---
# 解决：Error:java: 无效的源发行版: 12
## 一、 spring cloud项目启动。遇到问题：
![image-20220721144811246](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721144811246.png)
## 二、 解决，共两个地方。
### 第一个位置：
1. Project Structure   
  ![image-20220721144822451](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721144822451.png)

2. Modules选择你的项目（以及父级项目，如果有的话）->选择8（你的jdk版本） 如图：

   ![image-20220721144843419](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721144843419.png)
### 第二个位置
1.Setting：
![image-20220721144851114](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721144851114.png)
2.查找java compiler->Target bytecode version 修改为8（你的jdk版本，同样注意父级项目）：

![image-20220721144903945](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721144903945.png)

3.重新启动吧

![image-20220721144916608](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721144916608.png)
