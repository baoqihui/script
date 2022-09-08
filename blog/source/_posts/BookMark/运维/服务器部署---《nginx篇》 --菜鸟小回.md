---
title: 服务器部署---《nginx篇》 --菜鸟小回.md
date:  2022/9/8 17:58
category_bar: true
categories: 运维
tags:
- nginx
---
# 服务器部署---《nginx篇》
---
汇总篇：
[服务器配置篇汇总（linux）+（jdk）+（tomcat）+（mysql）+（nginx）+（redis）+（fastDFS）+（mycat）](https://blog.huijia21.com/archives/fu-wu-qi-pei-zhi-pian-hui-zong-linuxjdktomcatmysqlnginxredisfastdfsmycatgitmaven)
接上篇：
[服务器部署---《mysql篇》](https://blog.huijia21.com/archives/fu-wu-qi-bu-shu-mysql-pian-)

---
## 四、nginx(安全组开启所配置端口)
1. 创建：mkdir /opt/nginx
2. 进入：cd /opt/nginx/
3. 下载：`wget http://file.huijia.cf/file/nginx-1.13.0.tar.gz`
4. 解压：tar -zxvf nginx-1.13.0.tar.gz 
5. 编译：
```
cd nginx-1.13.0
//安装编译源码所需要的工具和库：
yum install gcc gcc-c++ ncurses-devel perl 
yum install pcre pcre-devel
yum  install zlib gzip zlib-devel
//编译
./configure 
```
6. 安装到默认位置/usr/local/nginx：`make & make install`
![image-20220430211126489](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430211126489.png)

7. 启动
```
cd /usr/local/nginx/sbin/
//启动
./nginx
//重启
./nginx -s reload
```
![image-20220430211135391](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430211135391.png)

8. 虚拟主机配置
```
vi /usr/local/nginx/conf/nginx.conf
//在原主页server上写入：

# 虚拟主机的配置

#虚拟主机一（虚拟域名）：
server { 
	listen       8081;   #端口
	server_name  hhh.idse.top;	#域名，虚拟机需要在windows的C:\Windows\System32\drivers\etc的hosts里面配置
				#120.27.244.176 hhh.idse.top
	location / {  
		root  abc; #相当于ningx目录下的hbq目录，可以写成绝对路径  /zhiyou/java 
		index a.html;  #默认跳转页面
	} 
}
#虚拟主机一（真实域名）：
server { 
	listen       8082;   #端口
	server_name  www.idse.top;     #公网域名，配置域名解析到本机ip
       
	location / {  
		root  abc; #相当于ningx目录下的hbq目录，可以写成绝对路径  /zhiyou/java 
		index b.html;  #默认跳转页面
	} 
}
#虚拟主机三（ip）：
 server{ 
	listen	8083;  #端口
	server_name 120.27.244.176; #域名        
	location / {  
		root  abc; #相当于ningx目录下的hbq目录，可以写成绝对路径  /zhiyou/java 
		index c.html;  #默认跳转页面
	}        
}
//创建文件
mkdir -p /usr/local/nginx/abc
vi /usr/local/nginx/abc/a.html  //写入aaa
vi /usr/local/nginx/abc/b.html  //写入bbb
vi /usr/local/nginx/abc/c.html  //写入ccc
//重启nginx
cd /usr/local/nginx/sbin/
./nginx -s reload
```
![image-20220430211145872](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430211145872.png)

8. 负载均衡多服务器配置
```
upstream tomcatserver1 {   #后面的名字自己起的，与下面proxy_pass后面保持一致
        server 120.27.244.176:8080  weight=2; #ip或者主机名都可以
        #server 120.27.244.176:81;
}
server {
        listen       80;   #端口
        server_name  www.idse.top;     #域名，虚拟机需要在windows的hosts里面配置

        location / {
        proxy_pass   http://tomcatserver1;    #代理，会更具名字找到上面的
        }
}

```
![image-20220430211153673](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430211153673.png)

---
接下篇：
[服务器部署---《redis篇》](https://blog.huijia21.com/archives/fu-wu-qi-bu-shu-redis-pian-)

---
