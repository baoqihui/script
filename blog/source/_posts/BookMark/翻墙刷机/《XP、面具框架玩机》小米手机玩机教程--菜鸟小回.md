---
title: 《XP、面具框架玩机》小米手机玩机教程--菜鸟小回.md
date:  2022/9/7 10:51
category_bar: true
categories: 翻墙刷机
tags:
- MIUI
---
# 《框架玩机》小米手机玩机教程

---

[toc]

---

<center><font color=red>注：刷机有风险，玩机需谨慎。
 操作不当所造成后果与菜鸟小回无关！！！


---

今天来分享小米手机玩机技巧，Magisk面具+Xp框架!
可能你多上面的名词还有些陌生。
但下面的手机功能你应该是听说过的，刷步数，虚拟定位，蚂蚁森林自动偷能量，QQ,微信自动抢红包，防撤回，防闪照......也是因为近期好多朋友问我如何实现一些特殊功能，才有我现在的分享！
看下部分功能：
**1.部分模块预览**
![在这里插入图片描述](https://img-1256282866.cos.ap-beijing.myqcloud.com/20190717212437872.png)![在这里插入图片描述](https://img-1256282866.cos.ap-beijing.myqcloud.com/20190717212459469.png)

---

**2.部分模块功能预览**

![image-20220721154345687](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154345687.png)
![image-20220721154439132](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154439132.png)
![image-20220721154449114](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154449114.png)
![在这里插入图片描述](https://img-1256282866.cos.ap-beijing.myqcloud.com/2019071721305823.gif)
![image-20220721154630183](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154630183.png)

![image-20220721154703333](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154703333.png)

部分功能展示完毕，是不是有一丢丢心动呢？以上功能均为本人在用，再提醒一次，刷机过程可能存在数据清除，卡米，无限重启等等后果，虽均有处理方案，但还是**不建议玩机新手学习**。**后果自负！！！**


---
教程开始（小米9为例）：
**主分六步：**
 **1.刷开发版系统
 2.解BootLoader锁
 3.解锁手机root权限
 4.刷入面具并安装
 5.刷入Xposed框架
 6.刷入所需模块**
## 一、先给你的手机来一个开发版系统 
此处较为简单，但注意更换版本需要<font color=red>清理掉手机所有数据，请**及时备份**！！！</font>
[最新开发版包下载](http://www.miui.com/getrom-357.html?m=yes&mobile=2)

1. 首先在官网下载最新卡刷包到手机（记住放的位置，无需解压）。

2. 在系统更新界面点击中间10十下即可激活隐藏功能，右上角点击从本地选择安装包更新。
   ![image-20220721154718939](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154718939.png)

3. 选择刚才下载的zip文件就可以了。***注意备份一下数据哦！***

## 二、解BootLoader锁
1. 在小米官方申请小米解锁        [解锁地址](http://www.miui.com/unlock/index.html)

2. 填写申请解锁信息，然后会出现申请成功，然后就等待小米公司发来的解锁通过短信为基准
   ![image-20220721154730350](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154730350.png)

3. 解锁申请通过后请到小米申请解锁链接中下载小米手机解锁工具。
   ![image-20220721154849708](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154849708.png)

4. 下载解压之后点击图片中的MiUsbDriver进行安装驱动，如果检测已安装可以忽视此过程。
   ![image-20220721154905452](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154905452.png)         

5. 安装成功后我们现在就可以打开miflash_unlock解锁软件了。
   ![image-20220721154919401](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154919401.png)
   ![image-20220721154954560](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721154954560.png)

6. 接下来我们可以来绑定手机设备了。找到手机设备信息，连续点击MIUI系统版本号开启开发者模式。

   ![image-20220721155014921](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721155014921.png)

   + 在设置—更多设置中找到开发者模式
     ![image-20220721155032367](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721155032367.png)

   7. 在开发者模式里面找到设备就锁状态，小米账号绑定此设备。如图下：
      ![image-20220721155049830](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721155049830.png)
   8. 绑定后我们再打开解锁工具。
      ![image-20220721155102452](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721155102452.png)
      这时会显示当前未连接手机，我们需要关机手机，“音量键减+开机键同时按”，进入fastboot模式
      此时会出现一只小兔子，解锁工具会显示已连接手机
      ![image-20220721155114600](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721155114600.png)    
   9. 点击下面的解锁按键，出现正在解锁当中。
      ![image-20220721155136183](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721155136183.png)
      + 如果出现解锁失败或者是请绑定设备开机后检查是否绑定；重启到fastboot模式重新解锁即可
        ![image-20220721155155195](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721155155195.png)
      + 开机后找到开发者模式，如果显示已解锁，说明你就成功了
        ![image-20220721155203957](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721155203957.png)
        **到此为止，你的手机已经解锁成功。**

---
## 三、解锁root权限
1. 回到安全中心，**应用管理**
   ![image-20220721155221083](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721155221083.png)

2. 点击 **权限**
   ![image-20220721155232075](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721155232075.png)



3. 点击**root权限管理**
   ![image-20220721155251563](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721155251563.png)
4. 勾选同意服务，等待进度条走满手机自动重启

5. 重启完成后再回到当前位置查看，可以看到已经可以管理root权限了。
   ![image-20220721155421058](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721155421058.png)

---
## 四、刷入面具并安装

 - **工具：**

可手机百度 **酷安**并下载安装--->酷安app中搜索 **"Magisk "** 下载安装。

---

- **过程：**

  1. 打开Mgisk看到此页面。
     ![image-20220721155328467](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721155328467.png)

  2. 开启Maisk ROOT权限:
     + 返回桌面“**安全中心**”-->“**应用管理**”-->“**权限**”-->"**ROOT权限管理**"-->**选上Magisk**（多次警告全部同意）
  3. (**清理后台或重启手机后**)重新进入Maisk-->点击左上角**菜单栏**看到如下菜单，点击“**设置**”
     ![image-20220721155433878](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721155433878.png)
  4. 找到“**更新通道**”
     ![image-20220721155520989](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721155520989.png)
  5. 选择“**测试版**”
     ![image-20220721155601806](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721155601806.png)
  6. 回到Magisk主页面安装Magisk
     ![image-20220721155641924](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721155641924.png)
  7. 选择“直接安装”
     ![image-20220721155654012](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721155654012.png)
  8. 等待刷入，显示“All done”，安装成功（若出现安装进度条卡死，请更换网络重试，一般联通流量成功率高）；重启面具安装完成。
     ![image-20220721155724424](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721155724424.png)

9. 装入所需模块：下载需要模块**记住所放位置**(无需解压)，
   ![image-20220721155855882](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721155855882.png)
10. Magisk主页面左上方**菜单栏**-->“**模块**”（找不到说明前面步骤出了问题，解决问题后再试)

![image-20220721160035656](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721160035656.png)

11. “**选择下好的zip格式模块**”-->自动安装，成功后重启生效。
    ![image-20220721160047520](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721160047520.png)
12. 重启后再次来到 **“模块”** 这里，整个面具模块完成。
    ![image-20220721160113642](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721160113642.png)



---
 ## 五、刷入Xposed框架
1. 下载第一个模块链接内两个zip文件
2. 进入magisk模块，刷magisk-riru-core模块，然后刷magisk-EdXposed模块。（方法见上方Magisk模块安装过程）
    ![image-20220721160203168](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721160203168.png)

3. 下载第二个链接内EdxposedInstaller.apk，安装EdxposedInstaller.apk，看到以下页面表示xp框架安装成功
   ![image-20220721160218621](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721160218621.png)

----
 ##  六.刷入XP模块

1. 只需下载上方需要模块，APK格式，直接安装。
2. 安装成功后打开XP软件，左上角菜单栏点击选择“**模块**”
   ![image-20220721160258947](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721160258947.png)
3. 进入XP主页，找到菜单，选择“**模块**”，打上对勾**重启**即可。
   ![image-20220721160309704](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721160309704.png)
   + 注：如果打开支付宝森林模块和运动模块未生效，可更换支付宝版本。

----

 

<center><font color=green size=6 face="楷体">完成了，飞奔吧！</font></center>

