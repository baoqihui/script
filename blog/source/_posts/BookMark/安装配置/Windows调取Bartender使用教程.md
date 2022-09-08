---
title: Windows调取Bartender使用教程.md
date:  2022/9/7 10:41
category_bar: true
categories: 安装配置
tags:
- Bartender
---
# Windows调取Bartender使用教程

---

[toc]
---

## 非首次安装

### 一、在已安装目录中双击"stop.vbs"停止原有程序
![image-20220720151256266](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720151256266.png)
### 二、下载新的打印模板"JavaBarTenderPrint.zip"并解压
![image-20220720151305465](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720151305465.png)
### 三、替换原有"model"和"project"文件夹
![image-20220720151314891](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720151314891.png)
### 四、双击"start.vbs"启动程序
![image-20220720151332385](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720151332385.png)

## 首次安装
### 一、复制解压压缩包JavaBarTenderPrint.zip到C盘根目录下：
![image-20220720151340085](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720151340085.png)

### 二、文件夹内容介绍
+ jacob： 存放java-windows连接程序，以及需要dll（32&64bit）
+ jdk：存放java运行环境安装包（32&64bit）
+ model：存放Bartender打印模板
+ project：存放java服务及项目日志
+ start.vbs：启动服务
+ stop.vbs：关闭服务
 ![image-20220720151406261](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720151406261.png)

 ### 三、jdk安装
1. 进入“jdk”目录下，双击安装电脑对应位数jdk包
2. 一直点击下一步保存，不要修改文件安装路径

 ### 四、jdk环境变量配置
 ### 方式一：右键文件以管理员形式运行 “jdk”目录下的init.bat（不成功请使用方式二）
 + 检验jdk配置是否成功
 + 打开运行"win+R”->输入`cmd`回车
    ![image-20220720151414639](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720151414639.png)
  
 + 输入`java -version`和`javac`显示如下内容：
    ![image-20220720151702965](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720151702965.png)
 ### 方式二：
 1. 右键”我的电脑“->“属性”->“高级系统设置”
      ![image-20220720152138943](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720152138943.png)
   
 2. “高级”->“环境变量”；找到系统变量的 ”Path” 双击，window10以下系统直接编辑内容
    ![image-20220720152149510](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720152149510.png)
  
 3. 编辑环境变量页面 ”新建“ 填入已下内容，确定保存
windows10系统：` C:\Program Files\Java\jdk1.8.0_261\bin`
windows10以下系统：`;C:\Program Files\Java\jdk1.8.0_261\bin`

![image-20220720152158054](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720152158054.png)
4. 检验jdk配置是否成功
 + 打开运行"win+R”->输入`cmd`回车
    ![image-20220720152212129](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720152212129.png)
  
 + 输入`java -version`和`javac`显示如下内容：
    ![image-20220720152220868](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720152220868.png)

### 五、复制jacob.dll文件到jdk目录
+ 进入“jacob”目录-> 右键以管理员身份运行 “copy-jacob-dll.bat”文件
 ![image-20220720152229871](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720152229871.png)

 ### 六、启动java服务
 1. 双击“JavaBarTenderPrint”目录下的start.vbs
 2. 查看启动日志 在 C:\JavaBarTenderPrint\project\info中查看
 ![image-20220720152244911](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720152244911.png)

 ### 七、设置开机自启
 1. 打开运行"win+R”->输入`shell:startup`回车 打开开机启动文件夹
    ![image-20220720152419018](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720152419018.png)
 2. 将“start.vbs”移动到开机启动文件夹
 ![image-20220720152428392](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720152428392.png)

