---
title: JVM.md
date:  2022/9/8 18:01
category_bar: true
categories: 面试
tags:
- JVM
---
# JVM调优

## JVM执行一个Math方法图解

![image-20220721150149118](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721150149118.png)

每启动一个方法，从栈中获取一个线程；每个方法对应栈中的一个栈帧

黄色区域为公有的，紫色部分线程私有。

+ 栈：存放方法
  + 操作数栈：记录计算操作过程

+ 动态链接：记录该方法在方法区的地址

+ 堆：存放对象的内存地址
+ 方法区：存放常量，静态变量，类信息

## 堆

![image-20220721150157709](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721150157709.png)

当Eden放满触发minor gc 垃圾回收机制

GC：从Eden中找到GC root(方法区：静态属性引用对象，常量引用 栈帧中引用对象)，放入survivor区，每次操作代+1，达到15放入老年代



## 调优

减少GC次数，减少STW（Stop-The-World机制，Java中一种全局暂停现象 ）时间