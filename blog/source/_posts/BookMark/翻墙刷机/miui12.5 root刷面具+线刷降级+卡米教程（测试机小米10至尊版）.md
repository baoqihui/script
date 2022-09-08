---
title: miui12.5 root刷面具+线刷降级+卡米教程（测试机小米10至尊版）.md
date:  2022/9/7 10:51
category_bar: true
categories: 翻墙刷机
tags:
- MIUI
- 刷机
---
# miui12.5 最简单快捷root刷面具+线刷降级+卡米解决教程（测试机小米10至尊版）
---
[toc]

前言：本人在2019年发布过原创[《框架玩机》小米手机玩机教程 ](https://blog.csdn.net/qq_39231769/article/details/96366590?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522162035309516780271581145%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fblog.%2522%257D&request_id=162035309516780271581145&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~first_rank_v2~rank_v29-1-96366590.nonecase&utm_term=%E5%B0%8F%E7%B1%B3)
时隔两年，突发奇想像看看2021年的搞机是否有新花样。
此次搞机经历一次降级，两次卡米。（因为第三方rec刷机玩的不熟，miui12.5的第三方rec并未成熟）
最后找到最简单最直接的root方式：感谢b站 up："可爱的小潇潇"
参考[无twrp和root刷面具教程 修补boot的方法适用于任何版本任何手机](https://www.bilibili.com/video/BV1EX4y1M7aM)

---
+ 本教程正常情况无需双清或重装系统，可以进行OTA升级。升级后重复教程即可重新root。
但还是要记得备份数据后进行以下操作。
<font color=red size=5>注：刷机有风险，玩机需谨慎。 操作不当所造成后果与菜鸟小回无关！！！  </font>

---
## 一、本教程适合开发或稳定版miui系统。需解BL锁，教程参考[小米官网](https://www.miui.com/unlock/index.html)；[相关文件](https://pan.baidu.com/s/1lc8sDTkFb6DFxyqWQD1UKA)分享，密码：6666；这里展示我的机型信息及成功截图

![image-20220721153844232](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721153844232.png)
![image-20220721153857445](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721153857445.png)
![image-20220721153909873](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721153909873.png)

## 二、使用magisk制作修补文件。

1. 点击下载最新完整包（需要和你当前手机版本一致，不一致请先升级）。
2. 更新页面取消下载。去浏览器继续下载剩余部分。（防止自动解密）

![image-20220721154014584](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154014584.png)

3. 解压下载好的安装包找到`boot.img`文件，位置如图
![image-20220721154003081](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154003081.png)
4. 下载并安装magisk，酷安下载或者从我的百度网盘取。->>
 + 安装
![image-20220721154027005](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154027005.png)
 + 选择一个修补文件（无root时没有直接安装选项，此处演示手机已root）
![image-20220721154039420](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154039420.png)
 + 选择`boot.img`
 ![image-20220721154050158](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154050158.png)
 + 在download目录下生成文件，修改后缀为`magisk.img`
    ![image-20220721154112647](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154112647.png) 
 + 上传至电脑

## 三、使用`adb命令包`安装magisk

1. 解压文件`adb_Magisk.zip`，并将magisk.img放至此目录。
 ![image-20220721154125609](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154125609.png)

2. 手机开发者模式，USB调试连接电脑（连接不上可能是没有安卓驱动可能要下载）。关机并按住`音量下键`和`开机键`。进入`FastBoot`模式。

3. 双击`双击安装Magisk.bat`。等待ok后自动重启即可。

+ 至此，ROOT完成，可以看到magisk中有了直接安装选项。
![image-20220721154136802](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154136802.png)

## 四、如果需要安装magisk的相关模块，只需点击直接安装然后重启手机即可。

---
## 五、后续，如果刷机卡米、死机，亦或你想降级miui。继续下方教程：

1. 恢复教程访问小米官网线刷：[官网地址](http://www.miui.com/shuaji-393.html)
2. 可能遇到错误 `update sparse crc list failed`
解决：
+ 查看右下角你刷机要调用的bat文件。
 ![image-20220721154209786](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154209786.png)
+ 从解压的rom中找到该文件
 ![image-20220721154147360](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154147360.png)
+  打开找到下面两句并删除
 ```
fastboot %* flash crclist %~dp0images\crclist.txt || @echo "Flash crclist error" && exit /B 1

fastboot %* flash sparsecrclist %~dp0images\sparsecrclist.txt || @echo "Flash sparsecrclist error" && exit /B 1
 ```
![image-20220721154157654](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154157654.png)
+ 重新刷机即可