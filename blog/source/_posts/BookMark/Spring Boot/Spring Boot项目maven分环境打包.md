---
title: Spring Boot项目maven分环境打包
date: 2022-09-05 17:09:05
category_bar: true
categories: Spring Boot
tags:
- Spring Boot
- maven
---
# Spring Boot项目maven分环境打包

---

[toc]

---

## 一、环境配置
![image-20220720100426358](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720100426358.png)
## 二、pom添加“repackage”打包插件和“profiles”配置
```
//添加插件
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <executions>
                <execution>
                    <goals>
                        <goal>repackage</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
//添加profiles
 <profiles>
        <profile>
            <id>local</id>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
            <properties>
                <spring.profiles.active>local</spring.profiles.active>
                <profileActive>local</profileActive>
            </properties>
        </profile>
        <profile>
            <id>dev</id>
            <properties>
                <spring.profiles.active>dev</spring.profiles.active>
                <profileActive>dev</profileActive>
            </properties>
        </profile>
        <profile>
            <id>pro</id>
            <properties>
                <spring.profiles.active>pro</spring.profiles.active>
                <profileActive>pro</profileActive>
            </properties>
        </profile>
    </profiles>
```
## 三、application.yml配置
```
spring:
  profiles:
    active: @profileActive@
```
## 四、打包
```
//默认local
mvn clean package
//dev环境
mvn clean package -P dev
//pro环境
mvn clean package -P pro
```

