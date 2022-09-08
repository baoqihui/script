---
title: MySQL免安装版配置 dos基础命令创建MySQL Navicat编辑器破解--菜鸟小回.md
date:  2022/9/7 10:40
category_bar: true
categories: 安装配置
tags:
- MySQL
---
# MySQL免安装版配置 dos基础命令创建MySQL Navicat编辑器破解--菜鸟小回

---

[toc]

[MySQL8.0.13免安装版](https://pan.baidu.com/s/1UFhPSIWF2hSJotbjl1xZvg)

---

## 1.安装

1. 解压文件
2. 打开my.ini文件，设置你的安装路径。
    + 我的安装路径为：D:\mysql\mysql-8.0.13-winx64
    + 设置mysql的安装目录： 
    basedir=D:\mysql\mysql-8.0.13-winx64
    + 设置mysql数据库的数据的存放目录 
    datadir=D:\mysql\mysql-8.0.13-winx64\data 
    ![image-20220430165913787](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430165913787.png)
+ 如果没有my.ini自行创建，内容如下
	```
	[mysql]
	#设置mysql客户端默认字符集
	default-character-set=utf8
	[mysqld]
	#设置3306端口
	port=3306
	# 设置mysql的安装目录
	basedir=D:\mysql\mysql-8.0.13-winx64
	# 设置mysql数据库的数据的存放目录
	datadir=D:\mysql\mysql-8.0.13-winx64\data
	# 允许最大连接数
	max_connections=200
	# 服务端使用的字符集默认为8比特编码的latin1字符集
	character-set-server=utf8
	# 创建新表时将使用的默认存储引擎
	default-storage-engine=INNODB
	```

3. 配置环境变量：
    + 右键此电脑->属性->高级系统设置->环境变量
    ![image-20220430165921872](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430165921872.png)
    + 新建->输入你的bin路径->应用
    + 我的bin路径：D:\mysql\mysql-8.0.13-winx64\bin
    + ![image-20220430165931178](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430165931178.png)
    + ![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430165936823.png)

4. 以管理员身份运行cmd，进入到你的安装路径中，
	 `d:`
     `cd D:\mysql\mysql-8.0.13-winx64`
     输入命令：
    ` bin\mysqld --defaults-file=my.ini --initialize-insecure `
6. 安装mysql的服务
     `bin\mysqld --install`
7. 进入bin文件夹。启动mysql服务
     `net start mysql`  
8. 登录mysql：
     `mysql -uroot -p`
9. 查询用户名密码:
    `select host,user,authentication_string from mysql.user;`
10. 如果root对应的authentication_string不是空值，把root对应的密码设置为空
    `use mysql; update user set authentication_string='' where user='root'`
11.	修改密码,后面引号root替换为你想要设置的密码，完成。
    `ALTER user 'root'@'localhost' IDENTIFIED BY 'root';`	

## 2.使用
1. 登录,-u账号 -p密码
    `mysql -uroot -p521521`
2. 查看数据库：
    `show databases;`
3. 创建数据库:
    `create database abc;`
    应用创建：
    `use abc;`
4. 查看表：
    `show tables;`
5. 创建表:
    ```
    create table student(
     id int,
     name varchar(4),
     birthday date,
     sex char(2)
     );
    ```
+ 加主键设置：alter table score add constraint pk_scid primary key(scid);
+ 加非空约束：alter table score modify column score double not null;
+ 加唯一约束：alter table score add constraint uk_score unique(score);
+ 加外键约束：alter table score add constraint fk_sid foreign key(sid) references student(sid);
6. 插入数据：
    `insert into 表名 values(101,'如花','2019-1-5','女');`
7. 查询表中数据：
    `select * from student;`
8. 删除表
    `drop table student;`
9. 添加字段
    `alter table 表名 add column 列名 类型 [first /after/before 列名];`
10. 删除字段：
    `alter table 表名 drop column 列名`
11. 表描述
    `desc student;`
12. 数据库约束:
	+ 主键:`primary key`
	+ 自动增长:`auto_increment`
	    例:`tid int primary key auto_increment`
	    主键自增的列可以不用添加数据，数据库来维护唯一约束
	+ 唯一约束:`unique`
	+ 非空约束:`not null`
	+ 外键约束:`foreign key` 
	    例:`foreign key(tid) references teacher(tid)`
	+ 检查约束
---
+ 创建student
  ![image-20220430170003320](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430170003320.png)
  
    ```
     create table student(
     sid int primary key auto_increment,
     sname varchar(5) not null default '张三', 
     ssex char(2) not null,
     sclassname char(5) not null,
     sage int not null,
     saddr varchar(100) not null
     );
    ```
  
  
    + 插入数据：
      ![image-20220430170011118](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430170011118.png)
    ```
        insert into student(sname,ssex,sclassname,sage,saddr)values('回宝旗','男','水浒班',18,'河南省郑州市'),('哈哈','女','国威班',18,'河南省平顶山市'),('嘿嘿','女','励志班',19,'河南省郑州市'),('呵呵','男','加强班',20,'美国')；
    ```
  
    
---
+ 创建teacher表
  ![image-20220430170019572](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430170019572.png)
  
    ```
     create table teacher(
     tid int primary key auto_increment,
     tname varchar(5) null,
     tsex char(2) not null,
     tage int not null,
     tphone char(11) unique
     );
    ```
  
+ 插入数据
  ![image-20220430170030476](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430170030476.png)
```
insert into teacher(tname,tsex,tage,tphone)values('王','男',28,'15516055456'),('光','女',19,'16816055447'),('辉','男',35,'15516055555');
```


---
+ 创建timeable

![image-20220430170037869](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430170037869.png)
```
 create table timetable(
 kid int primary key auto_increment,
 kname varchar(50) unique,
 tid int,
 foreign key(tid) references teacher(tid)
 );
```


+ 插入数据
 ![image-20220430170046892](C:\Users\hui\AppData\Roaming\Typora\typora-user-images\image-20220430170046892.png)
```
insert into timetable(kname,tid)values('物理',1),('数学',2),('化学',3);
```

---
+ 创建gradetable表

![image-20220430170211238](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430170211238.png)

```
create table gradetable(
     gid int primary key auto_increment,
     grade int not null,
     sid int,
     kid int,
     foreign key(sid) references student(sid),
     foreign key(kid) references timetable(kid)
);
```

+ 插入数据:
  ![image-20220430170222388](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430170222388.png)

```
 insert into gradetable(grade,sid,kid)values(98,2,1),(93,3,2),(50,4,3);
```


---
 总：![image-20220430170236623](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430170236623.png)
