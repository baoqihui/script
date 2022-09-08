---
title: 虚拟机安装centos7并配置网络.md
date:  2022/9/8 18:00
category_bar: true
categories: 运维
tags:
- CentOS
---
# 虚拟机安装centos7并配置网络
---
[toc]

---
# 一、软件准备
+ 虚拟机：[VMware](https://www.aliyundrive.com/s/qpLZrLZyWav)
+ 系统镜像：[Centos7](http://mirrors.163.com/centos/7/isos/x86_64/CentOS-7-x86_64-DVD-2009.iso)
注：虚拟机安装教程参考文件内教程连接。鸣谢 “软件智库”！（侵删）

---



# 二、新建虚拟机

##  1.“文件”->“新建虚拟机”->“自定义”
![image-20220509175549104](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175549104.png)
##  2.默认硬件兼容性
![image-20220509175554682](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175554682.png)
## 3.稍后安装操作系统
![image-20220509175601779](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175601779.png)
## 4.选择“Linux”操作系统，“CentOS 7 64 位”
![image-20220509175608411](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175608411.png)
## 5.定义虚拟机名字和位置
![image-20220509175616641](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175616641.png)
## 6.处理器配置，虚拟机内存等默认即可
## 7.网络类型选择“使用网络地址转换”
![image-20220509175625265](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175625265.png)
## 8.控制器类型选择，磁盘类型 “推荐”即可
![image-20220509175634123](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175634123.png)
![image-20220509175644381](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175644381.png)

## 9.磁盘“新建”，容量自定义
![image-20220509175651338](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175651338.png)
![image-20220509175657980](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175657980.png)

## 10.默认到下一步到完成，可以在虚拟机列表找到新建的虚拟机
![image-20220509175709634](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175709634.png)
![image-20220509175716557](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175716557.png)
![image-20220509175724252](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175724252.png)

---

# 三、配置虚拟机镜像，安装系统
## 1.进入虚拟机设置选择“CD/DVD”，选定你下载好的ISO映像文件
![image-20220509175736410](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175736410.png)
![image-20220509175743409](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175743409.png)

## 2.开机 并 配置系统
### 2-1.选择安装系统
![image-20220509175750267](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175750267.png)
### 2-2.选择语言拉到最下方有中文
![image-20220509175757193](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175757193.png)
### 2-3.安装信息点击“安装位置”->“完成”->“开始安装”
![image-20220509175803657](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175803657.png)
![image-20220509175811105](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175811105.png)
![image-20220509175816581](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175816581.png)

### 2-4.设置“root密码”->“完成”，等待安装
![image-20220509175823109](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175823109.png)
### 2-5.安装完成“重启”，启动后输入账号和密码
+ 账号：默认：root
+ 密码：你自己设置的密码，输入是隐形的无法看到
![image-20220509175836903](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175836903.png)
### 2-6.登录系统，安装完成
![image-20220509175843207](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175843207.png)

---

# 四、设置虚拟机网络
## 1.虚拟机设置->网络适配器->桥接模式
![image-20220509175852742](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175852742.png)
## 2.查看<font color=red size=5>寄主机（本机）</font>的网络设置-> cmd模式->ipconfig
![image-20220509175901207](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175901207.png)
## 3.进入centos编辑" ifcfg-ens33"文件
```
vi /etc/sysconfig/network-scripts/ifcfg-ens33
//修改红色区内容
BOOTPROTO=static
ONBOOT=yes
//新增黄色区内容；IPADDR：就是ip保持频段与寄主机相同；GATEWAY：就是网关，直接保持与寄主机相同，DNS固定即可。
IPADDR=192.168.1.250
GATEWAY=192.168.1.1
DNS1=114.114.114.114
DNS2=8.8.8.8
```
![image-20220509175909441](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509175909441.png)

 ## 4.编辑"resolv.conf"文件
 ```
vi /etc/resolv.conf
//添加如下内容即可
nameserver 114.114.114.114
nameserver 8.8.8.8
 ```

## 5.重启network;
`service network restart`

---
附加命令：
```
查看防火墙状态：firewall-cmd --state
停止防火墙服务：systemctl stop firewalld.service
进制开机自启动：systemctl disable firewalld.service
```
