---
title: VMware中centos7网络配置（桥接自定义ip）.md
date:  2022/9/7 12:36
category_bar: true
categories: 运维
tags:
- VMware
- CentOS
---
# VMware中centos7网络配置（桥接自定义ip）
1. 虚拟机设置->网络适配器->桥接模式
![image-20220509174335340](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509174335340.png)
2. 查看寄主机的网络设置-> cmd模式->ipconfig
![image-20220509174341999](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509174341999.png)
3. 进入centos编辑" ifcfg-ens33"文件
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
![image-20220509174346845](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509174346845.png)

 4. 编辑"resolv.conf"文件
 ```
vi /etc/resolv.conf
//添加如下内容即可
nameserver 114.114.114.114
nameserver 8.8.8.8
 ```

5. 重启network;`service network restart`

---
附加命令：
```
查看防火墙状态：firewall-cmd --state
停止防火墙服务：systemctl stop firewalld.service
进制开机自启动：systemctl disable firewalld.service
```