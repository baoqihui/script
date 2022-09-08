---
title: Spring Boot & Jenkins 实现自动化部署（centos7&windows，涵盖防jenkins杀死的脚本）
date: 2022-09-05 17:09:05
category_bar: true
categories: Spring Boot
tags:
- Spring Boot
- Jenkins
---
# Spring Boot & Jenkins 实现自动化部署（centos7&windows，涵盖防jenkins杀死的脚本）

---

[toc]

---

## 一、安装Jenkins
```
//下载安装
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install jenkins
```
## 二、修改配置
```
//修改配置1 找到 JENKINS_USER 和JENKINS_PORT ，修改为root和你需要的端口
vi /etc/sysconfig/jenkins
JENKINS_USER="root"
JENKINS_PORT="8001"
// 修改配置2 找到candidates后面改为你的jdk路径
vi /etc/rc.d/init.d/jenkins
```
![image-20220509153054848](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509153054848.png)

## 三、启动
```
service jenkins start
service jenkins stop
service jenkins restart
```
## 四、浏览器输入“ip+端口”，配置jenkins
1. 首页
![image-20220509153124740](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509153124740.png)
2. 复制提示路径寻找初始密码
 ```
 //复制密码输入
cat /var/lib/jenkins/secrets/initialAdminPassword
 ```
![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/8fdc63f79bded19d2952bef453ed831e.png)

3. 直接推荐安装，等待...
    ![image-20220509153135439](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509153135439.png)
4. 创建用户
    ![image-20220509153200202](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509153200202.png)

  + 成功安装
    ![image-20220509153207418](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509153207418.png)

 ## 五、Jenkins的maven，jdk环境配置
 1. 在 Manage Jenkins中配置jdk和maven以及系统环境变量
![image-20220509153354659](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509153354659.png)
+ JDK(取消自动安装填自己的路径)
 ![image-20220509153403549](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509153403549.png)
 + MAVEN(取消自动安装填自己的路径)
    ![image-20220509153413203](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509153413203.png)
 + 系统环境变量`echo $PATH`查看
    ![image-20220509153431736](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509153431736.png)
    复制到此
    ![image-20220509153438814](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509153438814.png)
  2. 安装maven插件，安装后重启

     ![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/78a3d58539672e782025185c7b77f24c.png)

     ![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/bff9c95900d6380b3340337da1aca328.png)

## 六、新建spring boot 项目
1. 新建一个spring boot的demo。
![image-20220509153516260](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509153516260.png)
2. 随便一个controller
 ```
package com.example.demo;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class HelloController {
    @RequestMapping("/")
    @ResponseBody
    public String hello() {
        return "Hello, SpringBoot 2";
    }
}
 ```
 ![image-20220509153528886](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509153528886.png)
 3. 上传到git仓库，我这里上传的是gitee。
    ![image-20220509153540595](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509153540595.png)
## 七、建立任务并运行
1. 新建任务
   ![image-20220509153554982](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509153554982.png)
2. 输入项目名称并选择maven项目
    ![image-20220509153604487](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509153604487.png)
3. General
    ![image-20220509153615406](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509153615406.png)
4. 源码管理，配置git并填写git账号密码。
    ![image-20220509153627114](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509153627114.png)
    ![image-20220509153800325](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509153800325.png)
 5. 构建触发器
    ![image-20220509153808812](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509153808812.png)
 6. Build高级中可以修改你的maven配置文件
 ```
clean install -Dmaven.test.skip -U
//如需要选择分支打包详情参照：https://blog.csdn.net/qq_39231769/article/details/109311606
clean package -P dev
 ```
![image-20220509153827729](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509153827729.png)
 7. post steps
   + 添加一个执行shell，注意修改你的jar包名以及保证路径存在
```
#!/bin/bash 

#export BUILD_ID=dontKillMe这一句很重要，这样指定了，项目启动之后才不会被Jenkins杀掉。
export BUILD_ID=dontKillMe

#指定最后编译好的jar存放的位置
www_path=/out

#Jenkins中编译好的jar位置
jar_path=/var/lib/jenkins/workspace/demo/target

#Jenkins中编译好的jar名称
jar_name=demo-0.0.1.jar

#获取运行编译好的进程ID，便于我们在重新部署项目的时候先杀掉以前的进程
pid=$(cat /out/demo.pid)

#进入指定的编译好的jar的位置
cd  ${jar_path}

#将编译好的jar复制到最后指定的位置
cp  ${jar_path}/${jar_name} ${www_path}

#进入最后指定存放jar的位置
cd  ${www_path}

#杀掉以前可能启动的项目进程
kill -9 ${pid}

#启动jar，指定SpringBoot后台启动
nohup java -jar  ${jar_name} &

#将进程ID存入到shaw-web.pid文件中
echo $! > /out/demo.pid
```
   ![image-20220509153835988](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509153835988.png)
8. 保存并构建项目
   + 构建项目
   ![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/0912e1966caa0b70fb7258d46452d6cd.png)
   + 点击构建历史可以看控制台输出
   ![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/1603876202494.png)
9. 访问项目，部署成功
    ![image-20220509154057961](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509154057961.png)

---
  + 附加内容：
  ## windows版安装
  + 步骤基本与centos相似，但有几个注意事项；
1.  [下载地址](https://www.jenkins.io/zh/download/)
    ![image-20220509154109937](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509154109937.png)
2. 安装、启动、修改密码过程省略。与centos相似。
3. 注意事项 一：配置shell路径为服务器上git目录下的sh.exe文件路径。
 ![image-20220509154123933](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509154123933.png)
    ![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/80d773a67b03f808f99e4a9153421458.png)
 4. 注意事项二：新增项目时，post steps需要设置为windows的batch
 ![image-20220509154216554](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220509154216554.png)
 5. 注意事项三：执行脚本的不同
 ```
@echo off
setlocal enabledelayedexpansion

::设置端口 
set PORT=8082

:: 设置生成路径
set OLD_PATH=C:\Windows\system32\config\systemprofile\AppData\Local\Jenkins\.jenkins\workspace\gtoa\target

:: 设置新的存放路径
set NEW_PATH=C:\out

:: 设置jar包名
set JAR_NAME=gtoa-0.0.1-SNAPSHOT.jar

::set /p port=Please enter the port ：
for /f "tokens=1-5" %%a in ('netstat -ano ^| find ":%PORT%"') do (
    if "%%e%" == "" (
        set pid=%%d
    ) else (
        set pid=%%e
    )
    echo !pid!
    taskkill /f /pid !pid!
)

::复制文件
XCOPY %OLD_PATH%\%JAR_NAME%  "%NEW_PATH%" /y

::防止启动后被杀死进程
set BUILD_ID=dontKillMe 

::启动jar包
start javaw -jar %NEW_PATH%\%JAR_NAME%
 ```
---