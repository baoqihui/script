---
title: 从docker安装到前后端分离项目启动完成（docker安装mysql、nginx；启动jar包）.md
date:  2022/9/7 12:40
category_bar: true
categories: 运维
tags:
- docker
- mysql
- nginx
---
# 从docker安装到前后端分离项目启动完成（docker安装mysql、nginx；启动jar包）
---
+ 前言：通过上篇博文：[虚拟机安装centos7并配置网络](https://blog.huijia21.com/archives/xu-ni-ji-an-zhuang-centos7-bing-pei-zhi-wang-luo)
我们已经安装好centos并配置好网络，现在来尝试docker容器的安装及基本使用。

+ 本人为Java程序猿一枚，所以此处来使用docker安装几个常用软件：mysql，nginx。部署一个jar包服务，配合vue前端。部署一个简易程序。
---
[toc]

---
## 一、安装docker
<font color=red size=5> 此部分参照[linux下安装docker并部署运行jar](https://blog.csdn.net/weixin_43827693/article/details/107934604?spm=1001.2014.3001.5506)博文</font>（ 鸣谢！侵删）

```
// 安装需要的软件包
yum install -y yum-utils device-mapper-persistent-data lvm2
//设置yum源
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
//启用 edge 和 testing 镜像仓库（可选）
yum-config-manager --enable docker-ce-edge
yum-config-manager --enable docker-ce-testing
//安装Docker最新版本
yum install -y docker-ce
//启动docker
systemctl start docker
//开机自启
systemctl  enable docker.service
```
![image-20220509180632911](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509180632911.png)

---

## 二、使用docker安装mysql
可以去[docker官网](https://hub.docker.com/)注册一下，获取可用的docker镜像。直接搜想要安装的应用
![image-20220509180638168](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509180638168.png)
![image-20220509180645355](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509180645355.png)

### 1.安装mysql
```
//这里选择安装5.7.29版本
docker pull mysql:5.7.29
//ARM框架 docker pull mysql/mysql-server
//使用以下命令来查看是否已安装了 mysql： 
docker images
```
![image-20220509180701019](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509180701019.png)
### 2. 启动mysql并设置密码
```
docker run -itd --restart=always --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=HBQ521521cf* mysql:5.7.29
```
命令解析：
+ docker run：docker容器启动命令
+ --name mysql：为此容器起名为mysql，可自定义
+ -p 3306:3306 ：映射容器服务的 3306 端口到宿主机的 3306 端口，外部主机可以直接通过 宿主机ip:3306 访问到 MySQL 的服务。 
+ -e MYSQL_ROOT_PASSWORD=123456： 初始化 MySQL 的密码为123456
+ mysql:5.7.29：你下载好的mysql镜像（需要指定版本）
### 3. 查看容器运行状况
`docker ps`
![image-20220509180705836](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509180705836.png)

### 4. 进入mysql容器中，更新访问权限，使本机或者navicat等远程连接
```
docker exec -it mysql bash
//登录mysql
mysql -uroot -p123456
```
![image-20220509180710221](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509180710221.png)

+ 修改权限
 ```
update mysql.user set host="%" where user="root";
//刷新权限
flush privileges;
 ```
![image-20220509180809450](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509180809450.png)

### 5. 使用navicat连接，测试成功
![image-20220509180817428](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509180817428.png)

## 三、使用docker安装nginx以及自定义配置文件
### 1. 同样步骤去官网搜索nginx找到你想要下载的版本
```
//这里下载1.13版本
docker pull nginx:1.13
```
### 2. 启动默认配置文件的nginx
`docker run --name nginx -p 80:80 -d nginx:1.13`
![image-20220509180824938](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509180824938.png)

### 3. 复制nginx配置文件到主机
+ `docker cp nginx:/etc/nginx/nginx.conf /opt/config/`
![在这里插入图片描述](https://img-1256282866.cos.ap-beijing.myqcloud.com/7f0551b5264c15af271cc082fa8ca82b.png)
+ 修改该配置文件为你想要的配置，我这里配置到/out/project/demo/dist文件，为我的vue项目文件（你可以随便测试一个html）
![image-20220509180924987](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509180924987.png)

### 4. 重启nginx，同时映射本机的配置文件，本机vue项目到容器中
```
//停止nginx容器
docker stop nginx
//删除
docker rm nginx
//重新启动
docker run  --restart=always --name nginx --privileged=true -p 80:80 -p8001:8001 -v /opt/config/nginx.conf:/etc/nginx/nginx.conf -v /out/project/demo/dist:/out/project/demo/dist -d nginx:1.13
```
本机访问成功
![image-20220509180941768](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509180941768.png)
命令解析：

+  --restart=always ：总是在启动docker后重启本容器
+  --privileged=true：添加root权限到容器（权限问题，详情百度）
+  -p：端口映射，使用8001端口映射到本机（与你的nginx.conf保持一致）
+  -v：分别映射你配置好的nginx配置和项目文件
+  -d：后台启动

---
## 四、部署Java项目（此处为springboot项目的jar包）
### 1. 新建Dockerfile
```
FROM java:8
ADD code-demo-persion-0.0.1-SNAPSHOT.jar  /demo.jar
EXPOSE 8088
ENTRYPOINT ["java","-Xms1024m","-Xmx1024m","-jar","/demo.jar","--spring.profiles.active=dev","-c"]
```
命令解析：
+ FROM java:8，使用java8
+ 启动文件为code-demo-persion-0.0.1-SNAPSHOT.jar 重命名为 demo.jar
+ ENTRYPOINT ：启动后执行的命令为[xxx]（语法百度）
![image-20220509180950205](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509180950205.png)
### 2. 使用新建好的Dockerfile构建项目
```
cd /out/project/demo
//构建本目录下的Dockerfile
docker build -t demo:v1 .
//查看我们构建出的镜像
docker images
```
![image-20220509180956869](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509180956869.png)
### 3.启动项目
```
docker run  -d --restart=always --name demo -p 8088:8088 -v /out/logs/demo:/out/logs/demo demo:v1
```
命令解析： 
+ -v：此处是为了将项目日志输出到本机以便查看
所有进程启动完成
![image-20220509181007080](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509181007080.png)
项目可访问
![image-20220509181019257](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509181019257.png)

---
## 五、redis安装
### 1. 下载镜像
`docker pull redis:5.0.3`

### 2. 添加配置文件启动
#### 2-1 下载对应版本的压缩包[官网](https://download.redis.io/releases/?_ga=2.47530222.850311942.1626866911-284099862.1626866911)
#### 2-2  解压后得到conf文件
![image-20220509181026055](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509181026055.png)
#### 2-3 修改配置文件
```
//找到bind 127.0.0.1改为
#bind 127.0.0.1
```
#### 2-4 将配置文件上传至centos中
+ 配置文件在主机的位置
![image-20220509181032944](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509181032944.png)

#### 2-5 启动redis同时设置密码
```
docker run -itd --restart=always  -p 6379:6379 --name redis -v /opt/config/redis.conf:/etc/redis/redis.conf -v /out/data:/data  redis:5.0.3 redis-server /etc/redis/redis.conf --requirepass HBQ521521cf* --appendonly yes
```
命令解析：
+ --requirepass xxx：xxx为你所设置的redis密码
+ --appendonly yes：开启redis 持久化

+ 启动成功
![image-20220509181041052](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509181041052.png)
---
本文大概介绍了使用docker一个前后端系统的上线流程，下面总结一点常用命令：
+ service docker start/restart/stop：docker开启/重启/关闭
+ docker images：查看镜像
+ docker ps：查看启动的容器
+ docker start/stop xxx：开启/关闭某容器
+ docker build ~：构建镜像
+ docker run ~：启动容器
+ docker exec -it xxx bash :在运行的容器中执行交互终端命令，如：docker exec -it mysql bash
+ docker rmi xxx：删除某镜像，如：docker rmi demo:v1（demo:v1为镜像名，需要携带版本）
+ docker rm xxx：删除某容器，如：docker rm demo（demo为容器名）
+ docker update xxx xxx：为某个容器更新某设置，如docker update --restart=always nginx（将nginx容器设置为自启动）
+ docker cp /out/maven xxx:/out：xxx为容器名 将主机的/out/maven文件夹复制到容器的/out文件夹

更多命令参考：[菜鸟教程](https://www.runoob.com/docker/docker-command-manual.html)

相关技术使用详情：[springBoot集成Jenkins，实现自动化部署（centos7&windows，涵盖防jenkins杀死的脚本）](https://blog.huijia21.com/archives/springboot-ji-cheng-jenkins-shi-xian-zi-dong-hua-bu-shu-centos7windows-han-gai-fang-jenkins-sha-si-de-jiao-ben-)



