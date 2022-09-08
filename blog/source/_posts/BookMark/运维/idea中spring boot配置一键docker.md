---
title: idea中spring boot配置一键docker.md
date:  2022/9/7 12:35
category_bar: true
categories: 运维
tags:
- docker
- Spring Boot
---
# idea中spring boot配置一键docker

---

[TOC]

## 一、远程连接

![image-20220429175358706](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220429175358706.png)

## 二、编写Dockerfile

```
FROM openjdk:11.0.4
ADD /target/cms-0.0.1-SNAPSHOT.jar  /cms.jar
EXPOSE 8089
ENTRYPOINT ["java","-Xms1024m","-Xmx1024m","-jar","/cms.jar","--spring.profiles.active=dev","-c"]
```

![image-20220328160515506](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220328160515506.png)

## 三、pom.xml添加依赖

```
<properties>
    <docker.image.prefix>baoqihui</docker.image.prefix>
</properties>
<build>
    <plugins>
        <plugin>
            <groupId>com.spotify</groupId>
            <artifactId>docker-maven-plugin</artifactId>
            <version>1.1.0</version>
            <configuration>
                <imageName>
                    ${docker.image.prefix}/${project.artifactId}
                </imageName>
                <dockerDirectory></dockerDirectory>
                <resources>
                    <resource>
                        <targetPath>/</targetPath>
                        <directory>${project.build.directory}</directory>
                        <include>${project.build.finalName}.jar</include>
                    </resource>
                </resources>
            </configuration>
        </plugin>
    </plugins>
</build>
```

## 四、配置构建信息（打包后构建）

![image-20220329153202494](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220329153202494.png)

## 五、重启idea-构建成功并自动部署

![image-20220328162039475](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220328162039475.png)

