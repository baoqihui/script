---
title: CentOS7修改密码 --菜鸟小回.md
date:  2022/9/7 10:56
category_bar: true
categories: 运维
tags:
- CentOS
---
# CentOS7忘记密码,修改密码。
1. 开机选择你要修改密码的系统
![image-20220509175235812](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175235812.png)
2. 找到修改 `ro` 为 `rw` 
![image-20220509175243591](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175243591.png)
3. 本行最后继续添加 `init=/sysroot/bin/sh` 
![image-20220509175252768](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175252768.png)
4. ctrl+x 进入如下界面
![image-20220509175300216](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175300216.png)
5.分别输入命令
```
//进入系统环境里面
chroot /sysroot 
//进入系统环境里面
passwd root 
```
![image-20220509175308615](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175308615.png)

6. 出现方框说明乱码
```
//退出输入
ctrl+c
//修改语言
LANG=en
//重新修改(root为你想修改的用户名)
passwd root 
//创建开机项
touch /.autorelabel 
```
7. 重启
```
//退出当前模式
exit
// 重启
reboot
```
![image-20220509175316969](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175316969.png)
<font color=red size=5>博主测试两台虚拟主机，均用上述方式两次成功修改。原因未知；如有一次修改无效的情况建议也再重复一次。如有解决办法，烦请告知。。。</font>
