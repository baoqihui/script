---
title: 服务器部署—《linux加载git仓库代码打包并运行》--菜鸟小回.md
date:  2022/9/8 17:59
category_bar: true
categories: 运维
tags:
- git
---
#服务器部署—《linux加载git仓库代码打包并运行》
---
汇总篇：
[服务器配置篇汇总（linux）+（jdk）+（tomcat）+（mysql）+（nginx）+（redis）+（fastDFS）+（mycat）](https://blog.huijia21.com/archives/fu-wu-qi-pei-zhi-pian-hui-zong-linuxjdktomcatmysqlnginxredisfastdfsmycatgitmaven)
接上篇：
[服务器部署---《mycat篇》](https://blog.huijia21.com/archives/fu-wu-qi-bu-shu-mycat-pian-)

---
## 八、git安装
```
# 安装git
yum install git
# 完成后查看git版本
git version
```
## 九、maven安装
1. 创建：`mkdir -p /opt/maven`
2. 进入：`cd /opt/maven`
3. 下载：`wget http://file.huijia.cf/file/apache-maven-3.6.1-bin.tar.gz`
4. 解压：`tar -zxvf apache-maven-3.6.1-bin.tar.gz`
5. 编辑：`vi /etc/profile`
6. 配置环境变量：
```
//进编辑模式
i 
//文档最后添加：
export MAVEN_HOME=/opt/maven/apache-maven-3.6.1
export PATH=$MAVEN_HOME/bin:$PATH
//保存退出
ESC
:wq
//更新配置
source /etc/profile
```

## 十、shell脚本
```
echo "=====================删除原代码====================="
rm -rf /root/teacher_plus/
rm -rf /out/teacher_plus/
## 从git拉取代码
echo "=====================拉取新代码====================="
git clone https://gitee.com/idse666666/teacher_plus.git

mv -f /root/teacher_plus/ /out/teacher_plus/
cd /out/teacher_plus/
## 构筑项目
echo "=====================正在打包====================="
mvn clean install

## 关闭服务
echo "=====================正在关闭jar服务====================="
pid=`ps ax | grep -i 'jar' |grep java | grep -v grep | awk '{print $1}'`
if [ -z "$pid" ] ; then
        echo "No $1 running."
else 
	echo "The $1(${pid}) is running..."
	kill ${pid}
	echo "Send shutdown request to $1(${pid}) OK"
fi

echo "=====================启动nginx==================="
/usr/local/nginx/sbin/nginx

echo "=====================启动ridis==================="
cd /opt/redis/redis-5.0.3/bin/
./redis-server redis.conf

## 启动服务
echo "=====================正在启动项目====================="
nohup java -jar /out/teacher_plus/target/teacher_plus-0.0.1-SNAPSHOT.jar >/out/project_log.out 2>&1 &
echo "=====================项目启动完毕====================="
```
