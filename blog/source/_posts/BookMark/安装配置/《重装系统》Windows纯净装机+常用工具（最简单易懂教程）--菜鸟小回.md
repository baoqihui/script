---
title: 《重装系统》Windows纯净装机+常用工具（最简单易懂教程）--菜鸟小回.md
date:  2022/9/7 10:41
category_bar: true
categories: 安装配置
tags:
- 重装系统
---
# 重装系统教程

---
+ 入门IT第一步，来一个干净的电脑系统吧？
[toc]

---

**（装机需谨慎，系统盘必须格式化，其他风险自测。）**
本教程提供三种重装系统方式，三种均为纯净装机,均需要U盘。

1. windows10官方系统重装（新增！win10推荐）
2. PE 重装，此方式会为装机者提供更多工具，包括分区大师，电脑密码解除等等工具。
3. ISO重装，此方法傻瓜式操作，简单快捷，一键重装。

---

##  windows10官方系统重装（新增！win10推荐）

---

+ 无需下载百度网盘中的系统镜像，但要注意在U盘制作过程保持网络畅通。win10工具会帮助我们自动下载系统。
+ 优点：为系统自动是官网较新的系统，重装完成后无需更新太多。而且绕过了限速的某云下载。
+ 缺点：只能安装win10系统

---

### 一、下载Windows10官网工具助手

*  [Win10官网](https://www.microsoft.com/zh-cn/software-download/windows10)
   ![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/aHR0cDovL2hicS5pZHNlLnRvcC9ibG9nLzE1ODYzMDk3MTcwMTEucG5n)

### 二、制作U盘启动。

+ 选择为另一台安装介质 

  ![image-20220713170952100](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220713170952100.png)

+ 取消推荐选项框，自行选择你想要的系统（仅有win10系统）
  ![image-20220713171010482](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220713171010482.png)

+ 选择U盘

  ![image-20220713171033069](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220713171033069.png)

+ 等待下载就可以了

  ![image-20220713171046576](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220713171046576.png)

### 三、 系统BIOS选择（不同电脑不同）

---

**1.进入BIOS设置，一般快捷键根据电脑有所不同；**

+ 普通电脑：度娘搜对应电脑开机快捷键，格式：*xxx型号电脑BIOS设置U盘为第一启动项*

![img](https://img-1256282866.cos.ap-beijing.myqcloud.com/20304569-7e6753d98ad53197.png)

+ 特殊电脑（联想系列部分新机）;关机状态用卡针点击电脑上的小孔（类似手机装卡孔）

**2.BIOS设置（不同电脑设置难易程度不同）：**

+ （此处为联想笔记本）进入BIOS~——>按→光标移动到boot——>设置页面如下图一：——>按→光标到exit
  ![image-20220713171534830](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220713171534830.png)
  ![image-20220713171555082](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220713171555082.png)
+ 此过程的目的就是在启动电脑选择系统时选择到你的U盘启动，而不是电脑自己的硬盘。
  所以虽然有多种启动方式，其过程一般在BOOT设置栏，看到自己的U盘，将其优先级别提高。如：
  ![image-20220713171608972](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220713171608972.png)

+ 简单的电脑一般可以直接选择启动盘，直接点击即可。如：
  ![image-20220713171616851](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220713171616851.png)

### 四、启动电脑,选择系统，划分盘符。

1. U盘启动后你会看见电脑屏幕会变为蓝色装机页面，以下的操作按照提示下一步就可以。
2. 选择自定义：
   ![image-20220713172100606](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220713172100606.png)
3. 删除原有分区
   ![image-20220713172110691](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220713172110691.png)

4. 新建分区，最先创建出主分区，就是系统盘。或产生引导分区，无需理会。![image-20220713172132928](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220713172132928.png)

5. 新建所有分区后，一直下一步然后等待，就OK。

   

---

## PE重装

+ **工具:**
  	1、8G以上U盘
  	2、微PE工具：https://www.wepe.com.cn/download.html
  	3、操作系统（此处提供纯净win10）： https://alist.huijia.cf/d/hui/%E8%BD%AF%E4%BB%B6/%E7%B3%BB%E7%BB%9F%E9%95%9C%E5%83%8F/Windows%E5%AE%98%E6%96%B9.iso

### 一、制作PE U盘

1. 下载微PE工具，win10系统：

2. 格式化U盘：
   鼠标右击插入的U盘，选择“格式化”，在文件系统处选择“NTFS”，点击“开始”（格式化时，文件系统选择NTFS是为了U盘能够存储单个内存大于4G的文件）。

3. 点击“安装PE到U盘”。

![image-20220713172804689](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220713172804689.png)

4. 点击“立即安装进U盘”（U盘卷标显示的名称为自己插入U盘的名称)。

5. 点击“开始制作”。

6. 将下载好的win10系统复制入U盘中

### 二、BIOS设置（同上）

### 三、PE系统重装Windows

---
 ~~如需重新分盘或者格式化全盘，获得一个新的电脑系统请继续阅读本段：
如需保留系统盘外磁盘内容，跳过本段，否则数据丢失不负责呦！
打开分区助手——>点击快速分区——>执行即可
快速分区弹窗出现提示，需要注意以下几点
1.磁盘类型选择【MBR】
2.分区数目选择：多少个取决需求和硬盘大小
3.分区大小选择：第一个为主分区（即系统安装的分区），
一般建议25-100G左右即可（取决需求和硬盘大小）~~  

----
1. 进入“PE系统”后，双击“**CGI备份还原**”。
   ![image-20220713173017405](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220713173017405.png)

2. 选择“**还原分区**”，**选择分区盘符为“C盘”**，请选择镜像文件”处**右侧点击“三个点”**。

   ![image-20220713173025631](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220713173025631.png)

3. 选择拷贝到U盘里的“镜像文件”（iso格式），点击“**打开**”。

   ![image-20220713173033997](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220713173033997.png)

4. 选择自己所需要安装的版本（我这里选择Windows 7 旗舰版），点击“**确定**”。
   ![image-20220713173043227](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220713173043227.png)

5. 点击“**执行**”。

6. 勾选“重启”，点击“**确定**”。

7. 正在还原分区。

8. 显示“还原成功”，此时拔掉U盘，重启完成。

---

## ISO重装
+ **工具:**
		1、8G以上U盘
		2、软碟通：[软碟通官网](https://cn.ultraiso.net/xiazai.html)（直接免费下载试用）
		3、操作系统（此处提供纯净win10）： https://alist.huijia.cf/d/hui/%E8%BD%AF%E4%BB%B6/%E7%B3%BB%E7%BB%9F%E9%95%9C%E5%83%8F/Windows%E5%AE%98%E6%96%B9.iso

### 一、制作U盘启动盘
1. 首先下载“软碟通”软件，下载后安装，选项默认，***不要自己去勾选***；安装完成后，**不需要**运行此软件。

   ![image-20220713173540878](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220713173540878.png)

2. 下载一个win10操作系统，下载的操作系统不要下载在U盘里，电脑的任意一个盘都可以
3. 下载好系统后，插好U盘，直接**双击下载好的iso文件**
   ![image-20220713173610731](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220713173610731.png)
   弹出以下界面：点击“**继续试用**”
   ![image-20220713173624605](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220713173624605.png)
4. 选择左侧“**本地目录**”的U盘盘符，***千万不要选错***，再选择工具拦的“启动”
   ![image-20220713173641447](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220713173641447.png)
5. 在选中“**写入硬盘映像**”，（启动项里的第4个），跳出一个对话框，默认设置，直接点“**格式化**”，格式化完成后点“**写入**”，等待**刻录成功**，完成制作。
   ![image-20220713173655658](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220713173655658.png)

### 二、 BIOS设置（同上Win10重装）

### 三、启动电脑,选择系统，划分盘符（同上Win10重装）。
---
提供常用装机后、升级 以及 无线网卡驱动：

+ **win10易升：**  [win10易升](https://alist.huijia.cf/d/hui/%E8%BD%AF%E4%BB%B6/%E9%87%8D%E8%A3%85%E7%B3%BB%E7%BB%9F/win10%E6%98%93%E5%8D%87.exe) 
+ **360驱动大师（无线网卡驱动版）**： [驱动大师](https://alist.huijia.cf/d/hui/%E8%BD%AF%E4%BB%B6/%E9%87%8D%E8%A3%85%E7%B3%BB%E7%BB%9F/360DrvMgrInstaller_net.exe)
+ **虚拟机(害怕电脑难以恢复的小白可以利用虚拟机进行第一次模拟测试)**：[虚拟机](https://alist.huijia.cf/d/hui/%E8%BD%AF%E4%BB%B6/%E9%87%8D%E8%A3%85%E7%B3%BB%E7%BB%9F/VMware/VMware-workstation-full-16.0.exe) 
+ **启动系统后。激活工具链接**: [工具系统](https://alist.huijia.cf/d/hui/%E8%BD%AF%E4%BB%B6/%E9%87%8D%E8%A3%85%E7%B3%BB%E7%BB%9F/Win10%20%E6%95%B0%E5%AD%97%E6%BF%80%E6%B4%BB%E5%B7%A5%E5%85%B7.zip) 

