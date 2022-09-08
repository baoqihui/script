---
title: 服务器部署---《redis篇》 --菜鸟小回.md
date:  2022/9/8 17:58
category_bar: true
categories: 运维
tags:
- redis
---
# 服务器部署---《redis篇》
---
汇总篇：
[服务器配置篇汇总（linux）+（jdk）+（tomcat）+（mysql）+（nginx）+（redis）+（fastDFS）+（mycat）](https://blog.huijia21.com/archives/fu-wu-qi-pei-zhi-pian-hui-zong-linuxjdktomcatmysqlnginxredisfastdfsmycatgitmaven)
接上篇：
[服务器部署---《nginx篇》](https://blog.huijia21.com/archives/fu-wu-qi-bu-shu-nginx-pian-)

---

## 五、redis(安全组开启6379)
1. 创建：`mkdir /opt/redis`
2. 进入：`cd /opt/redis`
3. 下载：`wget http://file.huijia21.com/redis-5.0.3.tar.gz`
4. 解压：`tar -zxvf redis-5.0.3.tar.gz`
5. 编译：
```
cd redis-5.0.3
make
```
6. 安装：`make install`
7. 创建新目录方便管理：`mkdir -p /opt/redis/redis-5.0.3/bin`
8. 拷贝文件：
```
cd src/
cp redis-server /opt/redis/redis-5.0.3/bin/
cp redis-benchmark /opt/redis/redis-5.0.3/bin/
cp redis-cli /opt/redis/redis-5.0.3/bin/
cp /opt/redis/redis-5.0.3/redis.conf  /opt/redis/redis-5.0.3/bin/
```
9. 修改配置文件
```
cd ../bin
//修改配置文件
vi redis.conf
//找到daemonize no改为：
daemonize yes
//找到bind 127.0.0.1改为
#bind 127.0.0.1
//找到#requirepass foobared去掉注释并改为自己的密码
requirepass youpassword

```
10. 启动：` ./redis-server redis.conf`
11. 测试：
```
./redis-cli -a youpassword

set key "hello world!"
get key
//得到hello world!成功
```
12. 远程连接，先创建安全组6379端口！

![image-20220430213243585](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430213243585.png)
![image-20220430213252132](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430213252132.png)

---
接下篇：
[服务器部署---《fastDFS篇》](https://blog.huijia21.com/archives/fu-wu-qi-bu-shu-fastdfs-pian-)

---
