---
title: windows安装mysql5.7.md
date:  2022/9/7 10:41
category_bar: true
categories: 安装配置
tags:
- mysql
---
# windows安装mysql5.7
## 一、下载mysql安装包
[下载地址](https://downloads.mysql.com/archives/community/)
![image-20220509173918892](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509173918892.png)

## 二、解压到任意盘并重命名文件夹
![image-20220509173930499](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509173930499.png)
## 三、配置环境变量
变量名：`MYSQL_HOME`
变量值：`Z:\MySQL\mysql-5.7.29`
path里添加：`%MYSQL_HOME%\bin`
![image-20220509173939042](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509173939042.png)
![image-20220509173948602](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509173948602.png)

## 四、创建目录和配置文件
+ 在mysql-5.7.29目录下创建“data”文件夹和“my.ini”文件
![image-20220509173959974](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509173959974.png)
+ 编辑“my.ini”文件内容如下（注意修改basedir，datadir的路径为你的解压盘符目录）
 ```
[mysqld]
port=3306
character_set_server=utf8
basedir=Z:\MySQL\mysql-5.7.29
datadir=Z:\MySQL\mysql-5.7.29\data
server-id=1
sql_mode=NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION
lower_case_table_names=1
innodb_file_per_table = 1
log_timestamps=SYSTEM

log-error	= error.log
slow_query_log = 1
slow_query_log_file = slow.log
long_query_time = 5
log-bin = binlog
binlog_format = row
expire_logs_days = 15
log_bin_trust_function_creators = 1

max_allowed_packet = 32M
binlog_cache_size = 4M
sort_buffer_size = 2M
read_buffer_size = 4M
join_buffer_size = 4M
tmp_table_size = 96M
max_heap_table_size = 96M
lower_case_table_names=1
innodb_file_per_table = 1


[client]   
default-character-set=utf8
 ```
## 五、初始化数据库
 ```
// 管理员打开cmd命令，到bin目录下
cd Z:\MySQL\mysql-5.7.29\bin
//初始化
mysqld --initialize-insecure
 ```
+ 完成后data文件夹内会产生很多文件
![image-20220509174011124](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509174011124.png)
+ 可能报错找不到"MSVCR120.dll"
![image-20220509174029462](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509174029462.png)
[下载安装即可解决](https://www.microsoft.com/zh-CN/download/details.aspx?id=40784)

## 六、注册并启动mysql服务
```
//cmd命令继续执行
mysqld –install
//启动mysql服务
net start mysql
```
![image-20220509174037248](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509174037248.png)

## 七、登录mysql并修改密码
```
//登录mysql
mysql -uroot
//修改密码
alter user 'root'@'localhost' identified by '你的密码'；
 //配置root用户远程连接。（无此需求可以不执行）
 GRANT ALL PRIVILEGES ON *.* TO 'ROOT'@'%' IDENTIFIED BY 'HBQ521521CF*' WITH GRANT OPTION;
 //刷新权限
 flush privileges;
```
![image-20220509174045490](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509174045490.png)
## 八、重新连接数据库或使用navicat连接
`mysql -uroot -p你的新密码`
![image-20220509174053979](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509174053979.png)
![image-20220509174101579](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509174101579.png)