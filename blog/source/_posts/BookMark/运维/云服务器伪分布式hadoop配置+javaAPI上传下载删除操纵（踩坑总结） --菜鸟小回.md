---
title: 云服务器伪分布式hadoop配置+javaAPI上传下载删除操纵（踩坑总结） --菜鸟小回.md
date:  2022/9/7 12:40
category_bar: true
categories: 运维
tags:
- hadoop
---
# 云服务器伪分布式hadoop配置+javaAPI上传下载删除操纵（踩坑总结）
---
<font color=red size=5>注：本博文主要针对单台云服务器hadoop安装配置。博主使用阿里云的ECS服务器,Centos7系统，公网ip：120.27.244.176 私网ip：172.16.236.135 安全组开放所有端口，即1/65535</font>

---
## 一、准备
1. 创建：`mkdir -p /opt/hadoop`
2. 进入：`cd -p /opt/hadoop`
3. 上传：
4. 解压：`tar -zxvf hadoop-2.7.3.tar.gz `
5. 配置hosts：
```
vi  /etc/hosts
//必须添加内网ip
172.16.236.135 hadoop.idse.top
```
6. 配置环境变量
```
vi /etc/profile
//添加环境变量
#配置hadoop
export HADOOP_HOME=/opt/hadoop/hadoop-2.7.3
export PATH=$PATH:$HADOOP_HOME/bin
//刷新配置
source /etc/profile
```
---
## 二、 配置hadoop
1. 修改hadoop-env.sh
```
cd /opt/hadoop/hadoop-2.7.3/etc/hadoop/
vi hadoop-env.sh
//找到并修改
export JAVA_HOME=/opt/java/jdk1.8.0_141
```
![image-20220721144649332](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721144649332.png)

2. 修改core-site.xml
```
vi core-site.xml
//注意域名端口改为自己的hosts中设置
<property>
	<name>fs.defaultFS</name>
	<value>hdfs://hadoop.idse.top:9000</value>
</property>
<!-- 指定hadoop运行时产生文件的存储目录 -->
<property>
	<name>hadoop.tmp.dir</name>
	<value>/zhiyou/hadoop/tmp</value>
</property>
```
![image-20220721144658404](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721144658404.png)

3. 配置hdfs-site.xml
```
vi hdfs-site.xml
<property>
	<name>dfs.replication</name>
	<value>1</value>
</property>
```
4. 配置yarn-site.xml
```
vi yarn-site.xml
//注意修改域名配置
<property>
	<name>yarn.resourcemanager.hostname</name>
	<value>hadoop.idse.top</value>
</property>
<!-- reducer获取数据的方式 -->
<property>
	<name>yarn.nodemanager.aux-services</name>
	<value>mapreduce_shuffle</value>
</property>
```
![image-20220721144706165](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721144706165.png)

5. 配置mapred-site.xml
```
mv mapred-site.xml.template mapred-site.xml
vi mapred-site.xml
<property>
	<name>mapreduce.framework.name</name>
	<value>yarn</value>
</property>
```
6. 启动
```
cd /opt/hadoop/hadoop-2.7.3/sbin/
./start-all.sh 
```
7. 查看进程：`jps`
![image-20220721144715625](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721144715625.png)
8. 浏览器访问（公网ip+端口）：`120.27.244.176:50070`
![image-20220721144724721](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721144724721.png)

<font color=red size=5>坑1：未成功访问请去安全组开放端口，自行百度hadoop所需端口，博主全开。 </font>
---
## 三、javaAPI上传下载文件测试
```
@Test//上传
public void upload() throws IOException, InterruptedException, URISyntaxException{
	//1.实例化configuration
	Configuration conf = new Configuration();
	/*云服务器必须配置*/
	conf.set("dfs.replication", "1");
	conf.set("dfs.client.use.datanode.hostname", "true");
	//2.获取文件系统
	FileSystem fs = FileSystem.get(new URI("hdfs://120.27.244.176:9000/"), conf, "root");
	//3.上传fs.copyFromLocalFile(本地文件,目标地址)
	fs.copyFromLocalFile(new Path("C:\\Users\\NEVER\\Desktop\\day04-06\\day04_05fastJson的使用.avi"),new Path("/day04_05fastJson的使用.avi"));
	//4.关闭连接
	fs.close();
}
@Test//下载
public void download() throws IOException, InterruptedException, URISyntaxException{
	//1.实例化configuration
	Configuration conf = new Configuration();
	conf.set("dfs.replication", "1");
	conf.set("dfs.client.use.datanode.hostname","true");
	//2.获取文件系统
	FileSystem fs = FileSystem.get(new URI("hdfs://120.27.244.176:9000/"), conf, "root");
	//3.下载
	//fs.copyToLocalFile(目标文件,本地地址)
	fs.copyToLocalFile(false,new Path("/c.jpg"), new Path("E:/d.jpg"),true);
	//4.关闭连接
	fs.close();
}
@Test//删除
public void remove() throws IOException, InterruptedException, URISyntaxException{
	//1.实例化configuration
	Configuration conf = new Configuration();
	//2.获取文件系统
	FileSystem fs = FileSystem.get(new URI("hdfs://120.27.244.176:9000/"), conf, "root");
	//fs.delete(要删除的文件，boolean true false-只能删除空的文件夹)
	fs.delete(new Path("/dow3.txt"),true);
	
	fs.close();
	
}
```
<font color=red size=5>坑2：必须加上 conf.set("dfs.replication", "1");
		conf.set("dfs.client.use.datanode.hostname", "true");不然上传会为空文件</font>
