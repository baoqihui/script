---
title: 常用Docker.md
date:  2022/9/8 17:56
category_bar: true
categories: 运维
tags:
- docker
---
# 常用Docker脚本

---

[toc]

---

## 安装docker

```
apt install -y docker.io
apt install -y docker-compose
```

## 常用脚本

```
#ROOT密码
bash <(curl -Ls https://github.com/baoqihui/script/raw/main/root.sh)
#更新系统
bash <(curl -Ls https://github.com/baoqihui/script/raw/main/init.sh)
#证书申请
bash <(curl -Ls https://github.com/baoqihui/script/raw/main/cert.sh)

minio.huijia.cf alist.huijia.cf cms.service.cf cms-plus.service.cf minio.service.cf service.cf aixue.cf aiqi.cf
```

## 挂载nginx

```
#docker查看宿主机ip
ip addr show docker0
#下载配置文件
mkdir -p /opt/config&wget -O /opt/config/nginx.conf https://alist.huijia.cf/d/hui/config/linux/nginx.conf
#修改配置后重启
docker run \
	--name nginx \
	--restart=always \
	--privileged=true \
	--net host \
	-v /opt/config/nginx.conf:/etc/nginx/nginx.conf \
	-v /opt/cert:/etc/nginx/cert \
	-v /opt/minio/data/dev-ui:/etc/nginx/dev-ui \
	-d nginx:1.13
```

## win

```

docker run -d --name=hui --restart=always -p 81:8080 -e TZ="Asia/Shanghai" -e ALIYUNDRIVE_AUTH_USERNAME="admin" -e ALIYUNDRIVE_REFRESH_TOKEN="dea9215b0d504e50acf3495a86e3ef54" -e ALIYUNDRIVE_AUTH_PASSWORD="HBQ521521cf*" -e JAVA_OPTS="-Xmx1g" baoqihui/webdav-aliyundriver:amd

docker run --name mysql --restart=always -v D:\opt\config\mysqld.cnf:/etc/mysql/mysql.conf.d/mysqld.cnf -p 3306:3306 -e MYSQL_ROOT_PASSWORD=HBQ521521cf* -itd mysql:5.7.29

docker run --rm -d --name=ch-server --ulimit nofile=262144:262144 -p 8123:8123 -p 9009:9009 -p 9090:9000 yandex/clickhouse-server:22.1.2.2
```

## 阿里云盘

```
#hui
docker run \
    --name=hui \
    --restart=always \
    -p 81:8080 \
    -e TZ="Asia/Shanghai" \
    -e JAVA_OPTS="-Xmx1g" \
    -e ALIYUNDRIVE_REFRESH_TOKEN="dea9215b0d504e50acf3495a86e3ef54" \
    -e ALIYUNDRIVE_AUTH_PASSWORD="HBQ521521cf*" \
    -d baoqihui/webdav-aliyundriver

#xue
docker run \
    --name=xue \
    --restart=always \
    -p 82:8080 \
    -v /etc/localtime:/etc/localtime \
    -e TZ="Asia/Shanghai" \
    -e JAVA_OPTS="-Xmx1g" \
    -e ALIYUNDRIVE_REFRESH_TOKEN="796520ae8cad4b10a9681554cd1437c2" \
    -e ALIYUNDRIVE_AUTH_PASSWORD="HBQ521521cf*" \
    -d baoqihui/webdav-aliyundriver
```

## MySQL

```
mkdir -p /out/mysql&&mkdir -p /opt/config&&wget -O /opt/config/mysqld.cnf https://alist.huijia.cf/d/hui/config/linux/mysqld.cnf&&wget -O /root/backup-mysql.sh https://alist.huijia.cf/d/hui/config/linux/backup-mysql.sh

#arm框架
docker run \
	--name mysql7 \
    --restart=always \
    -v /opt/config/mysqld7.cnf:/etc/mysql/mysql.conf.d/mysqld.cnf \
    -v /out/mysql/:/out/mysql/ \
    -p 3308:3306 \
    -e MYSQL_ROOT_PASSWORD=HBQ521521cf* \
    -itd biarms/mysql:5.7.30-linux-arm64v8
    
#amd框架
docker run \
    --name mysql \
    --restart=always \
    -v /opt/config/mysqld.cnf:/etc/mysql/mysql.conf.d/mysqld.cnf \
    -p 3306:3306 \
    -e MYSQL_ROOT_PASSWORD=HBQ521521cf* \
    -itd mysql:5.7.29
    
#登录mysql刷新权限
docker exec -it mysql bash
mysql -uroot -pHBQ521521cf*
update mysql.user set host="%" where user="root";
flush privileges;
```

## Redis

```
#下载配置文件
mkdir -p /opt/config&wget -O /opt/config/redis.conf https://alist.huijia.cf/d/hui/config/linux/redis.conf

#启动redis
docker run \
	--name redis \
    --restart=always \
    -p 6379:6379 \
    -v /opt/config/redis.conf:/etc/redis/redis.conf \
    -v /out/data:/data \
    -itd redis:5.0.3 redis-server /etc/redis/redis.conf \
    --requirepass HBQ521521cf* \
    --appendonly yes
```

## MongDB

```
docker run -itd \
    --restart=always \
    --name mongo \
    -p 27017:27017 \
    mongo
```

## alist

```
docker run -d \
	--restart=always \
	-v /opt/alist:/opt/alist/data \
	-p 5244:5244 \
	--name="alist" \
	xhofe/alist:latest
```

## Nextcloud

```
docker run \
    --name nextcloud \
    -p 83:80 \
    -v /opt/nextcloud:/var/www/html \
    -d nextcloud
```

## ServerStatus-Hotaru(探针)

```
wget https://raw.githubusercontent.com/cokemine/ServerStatus-Hotaru/master/status.sh
#服务端
bash status.sh s
#客户端
bash status.sh c
#可通过删除所有下的header去除背景图
/usr/local/ServerStatus/web/css/hotaru_fix.css
#可以修改配置文件手动调整次序
/usr/local/ServerStatus/server/config.json
```

### 探针自用nginx配置

```
docker run \
	--name nginx \
	--restart=always \
	--privileged=true \
	-p 80:80 \
	-p 83:83 \
	-p 443:443 \
	-v /opt//cert:/etc/nginx/cert \
	-v /opt/config/nginx.conf:/etc/nginx/nginx.conf \
	-v /usr/local/ServerStatus/web:/usr/local/ServerStatus/web \
	-d nginx:1.13
```

## x-ui

```
#证书申请
bash <(curl -Ls https://github.com/baoqihui/script/raw/main/cert.sh)

docker run -itd \
	--network=host \
    -v /opt/x-ui/db/:/etc/x-ui/ \
    -v /opt/cert/:/root/cert/ \
    --name x-ui \
    --restart=unless-stopped \
    enwaiax/x-ui:latest
    
/root/cert/db.ivps.ga/cert.crt
/root/cert/db.ivps.ga/private.key
```

## minio

```
docker run -d \
 	-p 9000:9000 \
    -p 9001:9001 \
    --name minio \
    --restart=always \
    -v /opt/minio/data:/data \
    -v /opt/minio/config:/root/.minio \
	-e "MINIO_ROOT_USER=admin" \
	-e "MINIO_ROOT_PASSWORD=HBQ521521cf*" \
	minio/minio server /data --console-address ":9001" --address ":9000"
```

## 青龙5700

```
#脚本
docker run -dit \
    -v /opt/ql/config:/ql/config \
    -v /opt/ql/log:/ql/log \
    -v /opt/ql/scripts:/ql/scripts \
    -v /opt/ql/db:/ql/db \
    --net host \
    --name qinglong \
    --hostname qinglong \
    --restart always \ 
    whyour/qinglong:latest
#token
5112967514:AAFUKlk4o0BsrDMkYObWJV9fDvToKZxXGVk
#uid
1721031645
#脚本
ql repo https://github.com/KingRan/KR.git "jd_|jx_|jdCookie" "activity|backUp" "^jd[^_]|USER|utils|function|sign|sendNotify|ql|JDJR"
#账号配置
m.jd.com
JD_COOKIE
pt_key=AAJixPM2ADCFpLSE0IiXy0TPB_dqMkmf_NtkmAY4x7iQjGwlA4Yb2as26UQ_PUk8mXQRr4QisV0;pt_pin=jd_LUWkEsWClQXo;
```

![image-20220509181303263](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509181303263.png)

## frp内网穿透

```
#服务端
mkdir -p /opt/config&wget -O /opt/config/frps.ini https://alist.huijia.cf/d/hui/config/linux/frps.ini

docker run -d --restart always --network host --name frps -v /opt/config/frps.ini:/etc/frp/frps.ini snowdreamtech/frps
#本地下载启动
http://file.huijia.cf/file/frp.zip
```

## reclone

```
apt install rclone
rclone purge cch2:
#同步备份数据
rclone sync -P cch1:backup cch2:backup
```

## 极光中转面板8000

```
wget -O docker-compose.yml https://alist.huijia.cf/d/hui/config/linux/jiguang-docker-compose.yml
#启动
docker-compose up -d
#初始化
docker-compose exec backend python app/initial_data.py
#端口
HTTP端口是：80,8080,8880,2052,2082,2086,2095
HTTPs端口是：443,2053,2083,2087,2096,8443
```

## Gost中转脚本

```
wget --no-check-certificate -O gost.sh https://raw.githubusercontent.com/KANIKIG/Multi-EasyGost/master/gost.sh && chmod +x gost.sh && ./gost.sh
```

## 测速

```
docker run \
	--name speedtest \
	--restart=always \
	-p 84:80 \
	-dit stilleshan/speedtest-x
```

## ZPan

```
docker run \
    --name zpan \
    --restart=always \
    -p 8222:8222 \
    -v /o/zpan:/etc/zpan \
    -it saltbo/zpan
```

### Zfile

```
docker run -d --name=zfile --restart=always \
    -p 8099:8080 \
    -v /opt/zfile/db:/root/.zfile/db \
    -v /opt/zfile/logs:/root/.zfile/logs \
    zhaojun1998/zfile
```

## seafile

```
wget -O docker-compose.yml https://alist.huijia.cf/d/hui/config/linux/seafile-docker-compose.yml

# 配置webdav/opt/seafile-data/seafile/conf/seafdav.conf
[WEBDAV]
enabled = true
port = 85
share_name = /
show_repo_id=true
```

## cloudreve

```
docker run -d \
  --name cloudreve \
  -e PUID=0 \
  -e PGID=0 \
  -e TZ="Asia/Shanghai" \
  -p 5212:5212 \
  --restart=unless-stopped \
  -v /opt/cloudreve/uploads:/cloudreve/uploads \
  -v /opt/cloudreve/config:/cloudreve/config \
  -v /opt/cloudreve/db:/cloudreve/db \
  -v /opt/cloudreve/avatar:/cloudreve/avatar \
  xavierniu/cloudreve
#mysql配置
cat <(curl -Ls https://raw.githubusercontent.com/baoqihui/file/master/config/cloudreve-db) >> /opt/cloudreve/config/conf.ini
#查看首次账号密码
docker logs -f cloudreve
```

## Java项目

+ Dockerfile

```
FROM openjdk:11.0.4
ADD cms-0.0.1-SNAPSHOT.jar  /cms.jar
EXPOSE 8089
ENTRYPOINT ["java","-Xms1024m","-Xmx1024m","-jar","/cms.jar","--spring.profiles.active=dev","-c"]
```

+ 构建：

```
docker build -t cms:v1 .
docker run  -d --restart=always --name cms -p 8089:8089 -v /out/logs/cms:/out/logs/cms cms:v1
```

+ 上传自己的镜像到dockerhub

```
docker login
docker tag cms:v1 baoqihui/cms:v1
docker push baoqihui/cms:v1
```

+ 拉取自己的docker镜像

```
docker pull baoqihui/cms:v1
```

## 文件下载

```
mkdir -p /opt/config&wget -O /opt/config/nginx.conf https://alist.huijia.cf/d/hui/config/linux/nginx.conf
```

## rclone挂载

```
rclone co
#阿里
rclone mount ali:/ f: --cache-dir C:rclone --vfs-cache-mode writes
#
rclone mount cch1:/ f: --cache-dir C:rclone --vfs-cache-mode writes
#谷歌
rclone mount google:/ g: -- cache-dir C:\rclone --vfs-cache-mode writes &
```

mklink /d  "c:\Users\hui\OneDrive - isahk\BookMark" "D:\BookMark"

## Clickhouse

```
docker run --rm -d --name=ch-server --ulimit nofile=262144:262144 -p 8123:8123 -p 9009:9009 -p 9090:9000 yandex/clickhouse-server:22.1.2.2
```

## shardingwhere

```
docker run -d --name=sharding -v /Users/huibaoqi/opt/sharding/conf:/opt/shardingsphere-proxy/conf -v /Users/huibaoqi/opt/sharding/ext-lib:/opt/shardingsphere-proxy/ext-lib -e PORT=3308 -p13308:3308 apache/shardingsphere-proxy:latest
```

## 可道云

```
docker run -d -p 80:80 -v /data:/var/www/html kodcloud/kodbox
```

## hexo

```
docker run -d --name=hexo \
-e HEXO_SERVER_PORT=4000 \
-e GIT_USER="baoqi.hui@qq.com" \
-e GIT_EMAIL="HBQ521521cf*" \
-v /opt/blog:/app/blog \
-p 4000:4000 \
baoqihui/hexo

rclone sync ali:BookMark /opt/blog/source/_posts
```

![img](https://img-1256282866.cos.ap-beijing.myqcloud.com/50536515.png)
