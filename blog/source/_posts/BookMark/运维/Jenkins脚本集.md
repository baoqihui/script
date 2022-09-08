---
title: Jenkins脚本集.md
date:  2022/9/7 12:35
category_bar: true
categories: 运维
tags:
- Jenkins
---
# Jenkins脚本集
---

## windows常用
### 1. 后台运行指令
```
// 1.后台运行bat
start ./a.bat
// 2.后接运行指令
if "%1" == "h" goto begin 
	mshta vbscript:createobject("wscript.shell").run("%~nx0 h",0)(window.close)&&exit 
::begin 后跟指令
//3.以管理员运行bat
%1 start "" mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c ""%~s0"" ::","","runas",1)(window.close)&&exit
::begin 后跟指令
```
### 2.复制
```
XCOPY "C:\JavaBarTenderPrint\jacob\jacob-1.19-x86.dll"  "C:\Program Files\Java\jdk1.8.0_261\bin" /y
```
### 3.关闭某端口进程
```
@echo off
setlocal enabledelayedexpansion
::set port=8082
set /p port=Please enter the port :
for /f "tokens=1-5" %%a in ('netstat -ano ^| find ":%port%"') do (
    if "%%e%" == "" (
        set pid=%%d
    ) else (
        set pid=%%e
    )
    echo !pid!
    taskkill /f /pid !pid!
)
pause

```
---
## jenkis-windows
### 一、nginx、redis重启
```
::设置启动后不杀死
set BUILD_ID=dontKillMe 

taskkill -f -t -im redis-server.exe
ping -n 3 127.0.0.1>nul

taskkill -f -t -im nginx.exe
ping -n 3 127.0.0.1>nul

::=========================nginx===============================
echo now run the nginx...
cd C:\opt\nginx\nginx-1.12.2
start nginx
ping -n 3 127.0.0.1>nul

::=========================redis===============================
echo now run the redis...
cd C:\opt\redis
start .\redis-server.exe .\redis.windows.conf
ping -n 3 127.0.0.1>nul
```

### 二、gtoa-jar

```
::防止启动后被杀死进程
set BUILD_ID=dontKillMe 

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

::启动jar包
start javaw -jar %NEW_PATH%\%JAR_NAME%
```
### 三、gtoa-ui
```
//************************************************************1********************************************************
::防止启动后被杀死进程
set BUILD_ID=dontKillMe 

:: 设置生成路径
set OLD_PATH=C:\Windows\System32\config\systemprofile\AppData\Local\Jenkins\.jenkins\workspace\gtoa-ui

cd %OLD_PATH%
npm install

//************************************************************2********************************************************
::防止启动后被杀死进程
set BUILD_ID=dontKillMe 

:: 设置生成路径
set OLD_PATH=C:\Windows\System32\config\systemprofile\AppData\Local\Jenkins\.jenkins\workspace\gtoa-ui

rd /s /q %OLD_PATH%\dist
:: 编译
npm run build

//************************************************************3********************************************************
:: 设置新的存放路径
set NEW_PATH=C:\out\gtoa\dist\

:: 设置生成路径
set OLD_PATH=C:\Windows\System32\config\systemprofile\AppData\Local\Jenkins\.jenkins\workspace\gtoa-ui

rd /s /q %NEW_PATH%

xcopy %OLD_PATH%\dist "%NEW_PATH%" /e /y
```
## jenkins-centos
### 一、gtoa
```
#export BUILD_ID=dontKillMe这一句很重要，这样指定了，项目启动之后才不会被Jenkins杀掉。
export BUILD_ID=dontKillMe

#指定最后编译好的jar存放的位置
www_path=/out

#Jenkins中编译好的jar位置
jar_path=/var/lib/jenkins/workspace/gtoa/target

#Jenkins中编译好的jar名称
jar_name=gtoa-0.0.1-SNAPSHOT.jar

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

#启动jar，指定SpringBoot的profiles为test,后台启动
nohup java -jar ${jar_name} &


#将进程ID存入到shaw-web.pid文件中
echo $! > /out/demo.pid
```
## java-ui-windows
```
//1start-server.bat
taskkill -f -t -im redis-server.exe
ping -n 3 127.0.0.1>nul
taskkill -f -t -im nginx.exe
ping -n 3 127.0.0.1>nul
taskkill -f -t -im java.exe
ping -n 5 127.0.0.1>nul

::=========================nginx===============================
echo now run the nginx...
cd C:\opt\nginx\nginx-1.12.2
start nginx
ping -n 3 127.0.0.1>nul

::=========================redis===============================
echo now run the redis...
cd C:\opt\redis
.\redis-server.exe .\redis.windows.conf &
ping -n 3 127.0.0.1>nul

//2start-download-ui.bat
::=========================download new i-mes ui===============================
rd /s /q C:\out\ui-front-end
rd /s /q C:\out\dist
cd C:\out
git clone https://gitee.com/henan_ruihong_information/ui-front-end.git
ping -n 5 127.0.0.1>nul
cd C:\out\ui-front-end
npm install

//3start-dowmload-jar.bat
::=========================download new i-mes jar===============================
rd /s /q c:\out\back-end-warehouse
cd C:\out
git clone https://gitee.com/henan_ruihong_information/back-end-warehouse.git --branch dev
cd c:\out\back-end-warehouse
mvn clean package -P dev
ping -n 5 127.0.0.1>nul

//4.4start-jar.bat
echo now run the i-mes jar...
cd C:\out\back-end-warehouse\target
java -jar -Dspring.profiles.active=dev i_mes-0.0.1-SNAPSHOT.jar > C:\out/project_log.log

//5start-ui-build.bat
cd C:\out\ui-front-end
npm run build

//start-server.vbs
Set Ws = CreateObject("Wscript.Shell")
Ws.Run("1start-server.bat"),0
wscript.sleep 10000
Ws.Run("2start-download-ui.bat"),0
wscript.sleep 30000
Ws.Run("3start-dowmload-jar.bat"),0
wscript.sleep 30000
Ws.Run("4start-jar.bat"),0
wscript.sleep 30000
Ws.Run("5start-ui-build.bat"),0
```