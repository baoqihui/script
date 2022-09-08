---
title: 服务器部署---《mycat篇》 --菜鸟小回.md
date:  2022/9/8 17:57
category_bar: true
categories: 运维
tags:
- mycat
---
# 服务器部署---《mycat篇》
---
汇总篇：
[服务器配置篇汇总（linux）+（jdk）+（tomcat）+（mysql）+（nginx）+（redis）+（fastDFS）+（mycat）](https://blog.huijia21.com/archives/fu-wu-qi-pei-zhi-pian-hui-zong-linuxjdktomcatmysqlnginxredisfastdfsmycatgitmaven)
接上篇：
[服务器部署---《fastDFS篇》](https://blog.huijia21.com/archives/fu-wu-qi-bu-shu-fastdfs-pian-)

---
## 七、mycat用于mysql数据库（安全组开启8066端口）
1. 两个虚拟机分别建立两个数据库（版本5.7及以下，mycat5.8配置见文末连接）
![image-20220430210537471](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430210537471.png)
2. 创建：`mkdir /opt/mycat`
3. 进入：`cd /opt/mycat`
4. 上传：
![image-20220430210549179](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430210549179.png)
5. 解压：`tar -zxvf Mycat-server-1.6-RELEASE-20161028204710-linux.tar.gz`
6. 配置server.xml： 
```
vi /opt/mycat/mycat/conf/server.xml
//注释原有账号密码，添加自己账号密码
//配置示例代码如下：
<user name="root"><!--账号-->
	<property name="password">HBQ521521cf*</property><!--密码-->
	<property name="schemas">T_M</property> <!--mycat数据库名-->
	<property name="readOnly">false</property><!--非只读模式-->
</user>
```
7. 配置schema.xml
```
//建议新建该文件替换原有文件
<?xml version="1.0"?>
<!DOCTYPE mycat:schema SYSTEM "schema.dtd">
<mycat:schema xmlns:mycat="http://io.mycat/">

<!-- 数据库配置，与server.xml中的数据库对应，dataNode与分片配置name对应 -->
    <schema name="T_M" checkSQLschema="true" sqlMaxLimit="100">
        <table name="me" dataNode="dn1"  /><!--me为ip=192.168.80.128的数据源中独有的表-->
        <table name="do" dataNode="dn2"  /><!--do为ip=192.168.80.131的数据源中独有的表-->
        <table name="user" primaryKey="u_id" autoIncrement="true" dataNode="dn1,dn2"  rule="mod-long" />
        <!--user为公共主表-->
    </schema>

<!-- 分片配置dataHost与物理数库name对应，数据源为物理数据源 -->
    <dataNode name="dn1" dataHost="test1" database="T_M" />
    <dataNode name="dn2" dataHost="test2" database="T_M" />

<!-- 物理数据库配置；此处host的url与/etc/hosts中配置对应 -->
    <dataHost name="test1" maxCon="1000" minCon="10" balance="0"  writeType="0" dbType="mysql" dbDriver="native">
        <heartbeat>select user();</heartbeat>
        <writeHost host="hostM1"  url="192.168.80.128:3306" user="root" password="HBQ521521cf*">
        </writeHost>
    </dataHost>

    <dataHost name="test2" maxCon="1000" minCon="10" balance="0" writeType="0" dbType="mysql" dbDriver="native">
        <heartbeat>select user();</heartbeat>
        <writeHost host="hostM2"  url="192.168.80.131:3306" user="root" password="HBQ521521cf*">
        </writeHost>
    </dataHost>

</mycat:schema>

```
8. 配置rule.xml
```
//因为在schema.xml配置数据库rule="mod-long" 所以在此配置该函数的参数
<tableRule name="mod-long">
	<rule>
		<columns>u_id</columns><!--此处u_id为公共表user的主键-->
		<algorithm>mod-long</algorithm>
	</rule>
</tableRule>
<function name="mod-long" class="io.mycat.route.function.PartitionByMod">
	<!-- how many data nodes -->
	<property name="count">2</property><!--此处的2代表我们schema.xml配置的分片数-->
</function>
```
9.配置hosts
```
vi /etc/hosts
//添加
192.168.80.128 hostM1
192.168.80.131 hostM2
```
10. 启动mycat
```
cd /opt/mycat/mycat/bin/
//启动
./mycat start  
//关闭命令
./mycat stop
```
11. 使用navicat连接mycat
![image-20220430210648013](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430210648013.png)
![image-20220430210659404](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430210659404.png)

12. 可能报错，查看日志
```
vi /opt/mycat/mycat/logs/wrapper.log
//报错1：超时：
vi /opt/mycat/mycat/conf/wrapper.conf
//添加两句，保存重启
wrapper.startup.timeout=300000
wrapper.ping.timeout=300000
// 报错2：地址存在，端口占用
ps -ef|grep mycat
//找出占用端口
kill -9 占用端口
// 报错3.直接报错无法连接
mysql数据库版本高于5.7。请更换数据库或者参考下方链接mycat配置mysql5.8及以上版本
```

---

[mycat配置mysql8](https://blog.csdn.net/qq_39231769/article/details/102651593)

---

接下篇：
[服务器部署—《linux加载git仓库代码打包并运行》 ](https://blog.huijia21.com/archives/fu-wu-qi-bu-shu-linux-jia-zai-git-cang-ku-dai-ma-da-bao-bing-yun-xing-)

---
