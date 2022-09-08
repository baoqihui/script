---
title: 服务器部署---《fastDFS篇》 --菜鸟小回.md
date:  2022/9/8 17:56
category_bar: true
categories: 运维
tags:
- fastDFS
---
# 服务器部署---《fastDFS篇》
---
汇总篇：
[服务器配置篇汇总（linux）+（jdk）+（tomcat）+（mysql）+（nginx）+（redis）+（fastDFS）+（mycat）](https://blog.huijia.cf/2022/09/08/BookMark/%E8%BF%90%E7%BB%B4/%E6%9C%8D%E5%8A%A1%E5%99%A8%E9%85%8D%E7%BD%AE%E7%AF%87%E6%B1%87%E6%80%BB%EF%BC%88linux%EF%BC%89+%EF%BC%88jdk%EF%BC%89+%EF%BC%88tomcat%EF%BC%89+%EF%BC%88mysql%EF%BC%89+%EF%BC%88nginx%EF%BC%89+%EF%BC%88redis%EF%BC%89+%EF%BC%88fastDFS%EF%BC%89+%EF%BC%88mycat%EF%BC%89+%EF%BC%88git%EF%BC%89+(maven)%20--%E8%8F%9C%E9%B8%9F%E5%B0%8F%E5%9B%9E/)
接上篇：
[服务器部署---《redis篇》](https://blog.huijia.cf/2022/09/08/BookMark/%E8%BF%90%E7%BB%B4/%E6%9C%8D%E5%8A%A1%E5%99%A8%E9%83%A8%E7%BD%B2---%E3%80%8Aredis%E7%AF%87%E3%80%8B%20--%E8%8F%9C%E9%B8%9F%E5%B0%8F%E5%9B%9E/)

---

## 六、fastDFS（安全组开启22122、23000端口）
1. 创建：`mkdir /opt/fastDFS`
2. 进入：`cd /opt/fastDFS`
3. 下载libfastcommon：`wget http://file.huijia.cf/file/libfastcommon-1.0.7.tar.gz`
4. 解压：`tar -zxvf V1.0.7.tar.gz`
5. 编译安装
```
cd libfastcommon-1.0.7
./make.sh
./make.sh install
```
6. 创建软链接
```
ln -s /usr/lib64/libfastcommon.so /usr/local/lib/libfastcommon.so
ln -s /usr/lib64/libfastcommon.so /usr/lib/libfastcommon.so
ln -s /usr/lib64/libfdfsclient.so /usr/local/lib/libfdfsclient.so
ln -s /usr/lib64/libfdfsclient.so /usr/lib/libfdfsclient.so 
```
7. 下载fastDFS: `wget https://github.com/happyfish100/fastdfs/archive/V5.05.tar.gz`
8. 解压：`tar -zxvf V5.05.tar.gz`
10. 编译安装
```
cd fastdfs-5.05
./make.sh
./make.sh install
```

11. 建立软连接
```
ln -s /usr/bin/fdfs_trackerd   /usr/local/bin
ln -s /usr/bin/fdfs_storaged   /usr/local/bin
ln -s /usr/bin/stop.sh         /usr/local/bin
ln -s /usr/bin/restart.sh      /usr/local/bin
```
12. 配置FastDFS跟踪器
```
cd /etc/fdfs
cp tracker.conf.sample tracker.conf
vi tracker.conf
//查找修改如下内容
base_path=/home/idse/fastdfs/tracker
http.server_port=80
//创建上方修改后的目录
mkdir -p /home/idse/fastdfs/tracker
```
13. 启动tracker：
```
/etc/init.d/fdfs_trackerd start
//查看启动成功
netstat -unltp|grep fdfs
//设置开机自启
chkconfig fdfs_trackerd on
```
14. 配置 FastDFS 存储
```
cd /etc/fdfs
cp storage.conf.sample storage.conf
vi storage.conf
//查找修改如下内容
base_path=/home/idse/fastdfs/storage
store_path0=/home/idse/fastdfs/storage/file
tracker_server=www.idse.top:22122
http.server_port=80
//创建上方修改后的目录
mkdir -p /home/idse/fastdfs/storage
mkdir -p /home/idse/fastdfs/storage/file
```
15. 启动Storage
```
/etc/init.d/fdfs_storaged start
//查看 Storage 是否成功启动
netstat -unltp|grep fdfs
//查看Storage和Tracker是否在通信：
/usr/bin/fdfs_monitor /etc/fdfs/storage.conf
//设置 Storage 开机启动
chkconfig fdfs_storaged on
```
16. 修改 Tracker 服务器中的客户端配置文件 
```
cd /etc/fdfs
cp client.conf.sample client.conf
vi client.conf
//查找修改如下内容
base_path=/home/idse/fastdfs/client
tracker_server=www.idse.top:22122
//创建上方修改后的文件夹
mkdir -p /home/idse/fastdfs/client
```
17. 上传测试
```
/usr/bin/fdfs_upload_file /etc/fdfs/client.conf /ti.jpg
//返回所传图片地址
group1/M00/00/00/rBDsh12jLdKAZCXFAAGTJAL2pIQ680.jpg
//查看该图片
cd /home/idse/fastdfs/storage/file/data/00/00
ls
```
![image-20220430205735349](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430205735349.png)
![image-20220430205753760](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430205753760.png)

18. nginx中配置访问
```
vi /usr/local/nginx/conf/nginx.conf
//插入如下代码到nginx.conf
//fastDFS图片上传配置
server {
        listen       80;
        server_name  120.27.244.176;

        location / {
                root   html;
                index  index.html index.htm;
        }
        location /group1/M00{
                alias /home/idse/fastdfs/storage/file/data;
        }
}
//重启nginx
cd /usr/local/nginx/sbin/
./nginx -s reload
```
19. 浏览器访问图片 `http://120.27.244.176/group1/M00/00/00/rBDsh12jLdKAZCXFAAGTJAL2pIQ680.jpg`
![image-20220430205851120](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430205851120.png)
---

接下篇：
[服务器部署---《mycat篇》](https://blog.huijia.cf/2022/09/08/BookMark/%E8%BF%90%E7%BB%B4/%E6%9C%8D%E5%8A%A1%E5%99%A8%E9%83%A8%E7%BD%B2---%E3%80%8Amycat%E7%AF%87%E3%80%8B%20--%E8%8F%9C%E9%B8%9F%E5%B0%8F%E5%9B%9E/)

附加篇：
[java中使用fastDFS上传图片(前端ajax+后端ssm)](https://blog.huijia.cf/2022/09/05/BookMark/%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0/java%E4%B8%AD%E4%BD%BF%E7%94%A8fastDFS%E4%B8%8A%E4%BC%A0%E5%9B%BE%E7%89%87(%E5%89%8D%E7%AB%AFajax+%E5%90%8E%E7%AB%AFssm)%20--%E8%8F%9C%E9%B8%9F%E5%B0%8F%E5%9B%9E/)

---
