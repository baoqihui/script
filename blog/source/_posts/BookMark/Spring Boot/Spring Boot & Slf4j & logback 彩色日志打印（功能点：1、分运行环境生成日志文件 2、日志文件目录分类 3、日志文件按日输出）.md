---
title: Spring Boot & Slf4j & logback 彩色日志打印（功能点：1、分运行环境生成日志文件 2、日志文件目录分类 3、日志文件按日输出）
date: 2022-09-05 17:09:05
category_bar: true
categories: Spring Boot
tags:
- Spring Boot
- Slf4j
- logback
---
# Spring Boot & Slf4j & logback 彩色日志打印（功能点：1、分运行环境生成日志文件 2、日志文件目录分类 3、日志文件按日输出）
---
 需求概述：
 + spring boot 项目需要分环境运行。在local环境，也就是本地开发，只需要控制台打印，无需输出日志文件。
 + 相关文章：
   [spring boot项目分环境打包教程](https://blog.huijia.cf/archives/springboot-xiang-mu-maven-fen-huan-jing-da-bao)
   [slf4j、log4j、logback的关系](https://blog.csdn.net/u012894692/article/details/80308826)

---

## 一、项目目录，分dev，local，pro
![image-20220720100649778](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720100649778.png)

---

## 二、logback-spring.xml文件及其注释
```
<configuration scan="true" scanPeriod="10 seconds">
    <contextName>logback</contextName>

    <!--配置日志文件输出路径，下面用${path}占位使用}-->
    <springProperty scope="context" name="LOG_URL" source="log.url" />
    <property name="path" value="${LOG_URL}" />

    <!--0. 日志格式和颜色渲染 -->
    <!-- 彩色日志依赖的渲染类 -->
    <conversionRule conversionWord="clr" converterClass="org.springframework.boot.logging.logback.ColorConverter" />
    <conversionRule conversionWord="wex" converterClass="org.springframework.boot.logging.logback.WhitespaceThrowableProxyConverter" />
    <conversionRule conversionWord="wEx" converterClass="org.springframework.boot.logging.logback.ExtendedWhitespaceThrowableProxyConverter" />
    <!-- 彩色日志格式 -->
    <property name="local_pattern" value="${CONSOLE_LOG_PATTERN:-%clr(%d{yyyy-MM-dd HH:mm:ss.SSS}){faint} %clr(${LOG_LEVEL_PATTERN:-%5p}) %clr(${PID:- }){magenta} %clr(---){faint} %clr([%15.15t]){faint} %clr(%-40.40logger{39}){cyan} %clr(:){faint} %m%n${LOG_EXCEPTION_CONVERSION_WORD:-%wEx}}"/>

    <!--文件日志格式-->
    <property name="file_pattern" value="%d - %msg%n"/>


    <!--输出日志格式-->
    <appender name="consoleLog" class="ch.qos.logback.core.ConsoleAppender">
        <!--此日志appender是为开发使用，只配置最底级别，控制台输出的日志级别是大于或等于此级别的日志信息-->
        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <level>debug</level>
        </filter>
        <encoder>
            <Pattern>
                ${local_pattern}
            </Pattern>
            <!-- 设置字符集 -->
            <charset>UTF-8</charset>
        </encoder>
    </appender>
    <!--只保存info日志-->
    <appender name="fileInfoLog" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <level>INFO</level>
            <onMatch>ACCEPT</onMatch>
            <onMismatch>DENY</onMismatch>
        </filter>
        <encoder>
            <pattern>
                ${file_pattern}
            </pattern>
            <charset>UTF-8</charset>
        </encoder>
        <!--滚动输出策略-->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!--路径-->
            <fileNamePattern>${path}/info/info-%d{yyyy-MM-dd}-%i.log</fileNamePattern>
            <!-- 文件大小分割，超过配置大小就建当天新的日志文件 -->
            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <maxFileSize>50MB</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
            <!-- 保存7天 -->
            <MaxHistory>7</MaxHistory>
            <!-- 总日志大小 -->
            <totalSizeCap>10GB</totalSizeCap>
        </rollingPolicy>
    </appender>

    <!--只保存warn日志-->


    <appender name="fileWarnLog" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <filter class="ch.qos.logback.classic.filter.LevelFilter">
            <level>WARN</level>
            <onMatch>ACCEPT</onMatch>
            <onMismatch>DENY</onMismatch>
        </filter>
        <encoder>
            <pattern>
                ${file_pattern}
            </pattern>
            <charset>UTF-8</charset>
        </encoder>
        <!--滚动输出策略-->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!--路径-->
            <fileNamePattern>${path}/warn/warn-%d{yyyy-MM-dd}-%i.log</fileNamePattern>
            <!-- 文件大小分割，超过配置大小就建当天新的日志文件 -->
            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <maxFileSize>50MB</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
            <!-- 保存30天 -->
            <MaxHistory>30</MaxHistory>
            <!-- 总日志大小 -->
            <totalSizeCap>10GB</totalSizeCap>
        </rollingPolicy>
    </appender>

    <!--只保存error日志-->
    <appender name="fileErrorLog" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <level>ERROR</level>
        </filter>
        <encoder>
            <pattern>
                ${file_pattern}
            </pattern>
            <charset>UTF-8</charset>
        </encoder>
        <!--滚动输出策略-->
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!--路径-->
            <fileNamePattern>${path}/error/error-%d{yyyy-MM-dd}-%i.log</fileNamePattern>
            <!-- 文件大小分割，超过配置大小就建当天新的日志文件 -->
            <timeBasedFileNamingAndTriggeringPolicy class="ch.qos.logback.core.rolling.SizeAndTimeBasedFNATP">
                <maxFileSize>50MB</maxFileSize>
            </timeBasedFileNamingAndTriggeringPolicy>
            <!-- 保存30天 -->
            <MaxHistory>30</MaxHistory>
            <!-- 总日志大小 -->
            <totalSizeCap>10GB</totalSizeCap>
        </rollingPolicy>
    </appender>

    <!--local环境下，仅控制台打印，配置为彩色-->
    <springProfile name="local">
        <root level="info">
            <appender-ref ref="consoleLog"/>
        </root>
    </springProfile>

    <!--dev环境输出到文件-->
    <springProfile name="dev">
        <root level="info">
            <appender-ref ref="consoleLog"/>
            <appender-ref ref="fileInfoLog"/>
            <appender-ref ref="fileWarnLog"/>
            <appender-ref ref="fileErrorLog"/>
        </root>
    </springProfile>

    <!--pro环境输出到文件-->
    <springProfile name="pro">
        <root level="info">
            <appender-ref ref="consoleLog"/>
            <appender-ref ref="fileInfoLog"/>
            <appender-ref ref="fileWarnLog"/>
            <appender-ref ref="fileErrorLog"/>
        </root>
    </springProfile>
</configuration>
```
---

## 三、效果
1. local开发环境，直接输出到打印区

![image-20220720100801731](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720100801731.png)

2. dev和pro环境，输出到文件中。
 + 生成文件路径在配置文件中配置

  ![image-20220720100811808](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720101815814.png)

  ![image-20220720102028014](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720102028014.png)

 + 日志文件名设置
    ![image-20220720100819690](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720100819690.png)

 + 生成文件夹分三个，分别在配置文件里分为三个等级‘info’，‘error’，‘warn’
    ![image-20220720101120238](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720101120238.png)

 + 生成日志文件以天为单位分文件
![image-20220720101620589](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720101620589.png)
