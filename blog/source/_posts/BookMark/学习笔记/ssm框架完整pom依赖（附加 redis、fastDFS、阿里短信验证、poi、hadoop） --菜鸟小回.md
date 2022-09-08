---
title: ssm框架完整pom依赖（附加 redis、fastDFS、阿里短信验证、poi、hadoop） --菜鸟小回.md
date:  2022/9/7 10:12
category_bar: true
categories: 学习笔记
tags:
- pom
---
# ssm框架完整pom依赖（附加 redis、fastDFS、阿里短信验证、poi、hadoop）
```
<?xml version="1.0" encoding="UTF-8"?><!--指定xml文档的版本和编码方式 -->
<!--project是所有pom.xml的根元素， 它还声明了一些POM相关的命名空间及xsd元素， 虽然这些属性不是必须的， 但使用这些属性能够让第三方工具 
	(如：IDE中的xml编辑器)帮助我们快速编辑POM -->
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
	<!--指定了当前POM模型的版本，对于maven2及maven3来说，它只能是4.0.0。 这段代码中最重要的是包含groupId,artifactId和version的三行。 
		这三个元素定义了一个项目基本的坐标，在maven的世界， 任何的jar,pom或者war都是以基于这些基本的坐标进行区分的。 -->
	<modelVersion>4.0.0</modelVersion>

	<groupId>com.yun</groupId><!--填写你的组织名例如 -->
	<artifactId>test</artifactId><!--项目名字 -->
	<version>1.0-SNAPSHOT</version><!--项目的版本 snapshot为快照意思，代表当前为测试版， 开发版，相对的为release，意味发行版本，代表稳定版 -->
	<packaging>war</packaging><!--问你项目需要打成什么包？pom jar war？一般javaWeb项目填war -->
	<name>ssm Maven Webapp</name>
	<!-- FIXME change it to the project's website -->
	<url>http://www.example.com</url>

	<!-- 集中定义常用依赖版本号 -->
	<properties>
		<junit.version>4.11</junit.version>
		<servlet-api.version>3.1</servlet-api.version>
		<jsp-api.version>2.2</jsp-api.version>
		<jstl.version>1.2</jstl.version>
		<mysql.version>8.0.17</mysql.version>
		<mybatis.version>3.2.7</mybatis.version>

		<spring.version>4.2.4.RELEASE</spring.version>
		<fastjson.version>1.2.56</fastjson.version>
		<c3p0.version>0.9.1.2</c3p0.version>
		<jedis.version>3.0.1</jedis.version>
		<commons-fileupload.version>1.3.3</commons-fileupload.version>

		<log4j.version>1.2.12</log4j.version>
		<mybatis-spring.version>1.2.2</mybatis-spring.version>
		<mybatis-ehcache.version>1.0.2</mybatis-ehcache.version>
		<jsqlparser>0.9.1</jsqlparser>
		<pagehelper.version>3.4.2</pagehelper.version>

		<validation-api.version>1.0.0.GA</validation-api.version>
		<tomcat-servlet-api.version>7.0.62</tomcat-servlet-api.version>
		<poi.version>3.17</poi.version>
		<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
		<hadoop.version>2.7.3</hadoop.version>
		<maven.compiler.source>1.7</maven.compiler.source>
		<maven.compiler.target>1.7</maven.compiler.target>
	</properties>
	<dependencies>

		<!-- ******************************************** spring *************************** -->
		<!--提供对AspectJ的支持 -->
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-aspects</artifactId>
			<version>${spring.version}</version>
		</dependency>
		<!--这个jar 文件包含在应用中使用Spring 的AOP 特性时所需的类和源码级元数据支持。使用基于AOP 的Spring特性， 如声明型事务管理（Declarative 
			Transaction Management），也要在应用里包含这个jar包。 -->
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-aop</artifactId>
			<version>${spring.version}</version>
		</dependency>
		<!--这个jar 文件包含对Spring 对JDBC 数据访问进行封装的所有类。 -->
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-jdbc</artifactId>
			<version>${spring.version}</version>
		</dependency>
		<!--基于tx的事务管理需要 -->
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-tx</artifactId>
			<version>${spring.version}</version>
		</dependency>
		<!--这个jar 文件是所有应用都要用到的，它包含访问配置文件、 创建和管理bean 以及进行Inversion of Control / 
			Dependency Injection（IoC/DI）操作相关的所有类。 如果应用只需基本的IoC/DI 支持，引入spring-core.jar 
			及spring-beans.jar 文件就可以了。 外部依赖spring-core -->
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-beans</artifactId>
			<version>${spring.version}</version>
		</dependency>
		<!--这个jar 文件包含支持UI模版（Velocity，FreeMarker，JasperReports）， 邮件服务，脚本服务(JRuby)，缓存Cache（EHCache）， 
			任务计划Scheduling（uartz）方面的类。 外部依赖spring-context, (spring-jdbc, Velocity, FreeMarker, 
			JasperReports, BSH, Groovy, JRuby, Quartz, EHCache) -->
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-context-support</artifactId>
			<version>${spring.version}</version>
		</dependency>
		<!--spring表达式语言 -->
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-expression</artifactId>
			<version>${spring.version}</version>
		</dependency>
		<!--基础web功能，如文件上传 -->
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-web</artifactId>
			<version>${spring.version}</version>
		</dependency>
		<!--spring测试，提供junit与mock测试功能 -->
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-test</artifactId>
			<version>${spring.version}</version>
			<scope>test</scope>
		</dependency>
		<!--commons-lang3 -->
		<dependency>
			<groupId>org.apache.commons</groupId>
			<artifactId>commons-lang3</artifactId>
			<version>3.4</version>
		</dependency>
		<!-- ****************************** 引入springmvc，mvc实现*************************************** -->
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-webmvc</artifactId>
			<version>${spring.version}</version>
		</dependency>

		<!-- ******************************* 引入junit，做单元测试用，@Test注解需要它 ********************** -->
		<dependency>
			<groupId>junit</groupId>
			<artifactId>junit</artifactId>
			<version>${junit.version}</version>
			<scope>test</scope>
		</dependency>

		<!-- ******************************* 引入mysql *********************************************** -->
		<dependency>
			<groupId>mysql</groupId>
			<artifactId>mysql-connector-java</artifactId>
			<version>${mysql.version}</version>
		</dependency>
		<!-- ******************************* 引入mybatis ********************************************* -->
		<dependency>
			<groupId>org.mybatis</groupId>
			<artifactId>mybatis</artifactId>
			<version>${mybatis.version}</version>
		</dependency>

		<!-- ****************************************** 分页 ******************************************** -->
		<dependency>
			<groupId>com.github.jsqlparser</groupId>
			<artifactId>jsqlparser</artifactId>
			<version>${jsqlparser}</version>
		</dependency>
		<dependency>
			<groupId>com.github.pagehelper</groupId>
			<artifactId>pagehelper</artifactId>
			<version>${pagehelper.version}</version>
		</dependency>
		<!-- ******************************* c3p0连接池 *************************************************** -->
		<dependency>
			<groupId>c3p0</groupId>
			<artifactId>c3p0</artifactId>
			<version>${c3p0.version}</version>
		</dependency>

		<!-- ******************************** jedis，Jedis是Redis官方推荐的Java连接开发工具。*********************** -->
		<dependency>
			<groupId>redis.clients</groupId>
			<artifactId>jedis</artifactId>
			<version>${jedis.version}</version>
		</dependency>

		<!-- ******************************* fastjson，把对象和json格式互转换时需要用到 ****************************** -->
		<dependency>
			<groupId>com.alibaba</groupId>
			<artifactId>fastjson</artifactId>
			<version>${fastjson.version}</version>
		</dependency>

		<!-- ***************************************** commons ************************************* -->
		<dependency>
			<groupId>commons-fileupload</groupId>
			<artifactId>commons-fileupload</artifactId>
			<version>${commons-fileupload.version}</version>
		</dependency>
		<dependency>
			<groupId>commons-io</groupId>
			<artifactId>commons-io</artifactId>
			<version>2.4</version>
		</dependency>

		<!-- ***************************** 引入log4j，生成日志需要这个，log for java ，4是 for的近音  ************************ -->
		<dependency>
			<groupId>log4j</groupId>
			<artifactId>log4j</artifactId>
			<version>${log4j.version}</version>
		</dependency>


		<!-- ****************************************** 引入mybatis和spring ***************************** -->
		<dependency>
			<groupId>org.mybatis</groupId>
			<artifactId>mybatis-spring</artifactId>
			<version>${mybatis-spring.version}</version>
		</dependency>
		<dependency>
			<groupId>org.mybatis.caches</groupId>
			<artifactId>mybatis-ehcache</artifactId>
			<version>${mybatis-ehcache.version}</version>
		</dependency>

		<!-- ****************************************** poi导出excel ************************************ -->
		<dependency>
			<groupId>org.apache.poi</groupId>
			<artifactId>poi</artifactId>
			<version>${poi.version}</version>
		</dependency>
		<dependency>
			<groupId>org.apache.poi</groupId>
			<artifactId>poi-ooxml</artifactId>
			<version>${poi.version}</version>
		</dependency>
		<dependency>
			<groupId>org.apache.poi</groupId>
			<artifactId>poi-ooxml-schemas</artifactId>
			<version>${poi.version}</version>
		</dependency>
		<!-- 防止 程序包javax.servlet.annotation不存在 -->
		<dependency>
			<groupId>org.apache.tomcat</groupId>
			<artifactId>tomcat-servlet-api</artifactId>
			<version>${tomcat-servlet-api.version}</version>
		</dependency>

		<!-- ******************************************* 校验器 ***************************************** -->
		<dependency>
			<groupId>javax.validation</groupId>
			<artifactId>validation-api</artifactId>
			<version>${validation-api.version}</version>
		</dependency>

		<!-- ******************************************* 文件服务器 ************************************** -->
		<dependency>
			<groupId>org.csource.fastdfs</groupId>
			<artifactId>fastdfs</artifactId>
			<version>1.2</version>
		</dependency>


		<!-- ********************************** 阿里短信依赖 ************************************** -->
		<dependency>
			<groupId>com.aliyun</groupId>
			<artifactId>aliyun-java-sdk-core</artifactId>
			<version>3.7.0</version>
		</dependency>
		<dependency>
			<groupId>com.aliyun</groupId>
			<artifactId>aliyun-java-sdk-ecs</artifactId>
			<version>4.11.0</version>
		</dependency>

		<!-- ********************************** hadoop **************************************** -->
		<dependency>
			<groupId>org.apache.hadoop</groupId>
			<artifactId>hadoop-common</artifactId>
			<version>${hadoop.version}</version>
		</dependency>

		<!-- https://mvnrepository.com/artifact/org.apache.hadoop/hadoop-client -->
		<dependency>
			<groupId>org.apache.hadoop</groupId>
			<artifactId>hadoop-client</artifactId>
			<version>${hadoop.version}</version>
		</dependency>

		<!-- https://mvnrepository.com/artifact/org.apache.hadoop/hadoop-hdfs -->
		<dependency>
			<groupId>org.apache.hadoop</groupId>
			<artifactId>hadoop-hdfs</artifactId>
			<version>${hadoop.version}</version>
		</dependency>
		<dependency>
			<groupId>jdk.tools</groupId>
			<artifactId>jdk.tools</artifactId>
			<version>1.8</version>
			<scope>system</scope>
			<systemPath>${JAVA_HOME}/lib/tools.jar</systemPath>
		</dependency>
		<!-- ******************************** servlet-api******************************************* -->
		<dependency>
			<groupId>javax.servlet</groupId>
			<artifactId>javax.servlet-api</artifactId>
			<version>3.0.1</version>
			<scope>provided</scope>
		</dependency>

		<!-- 暂时没用上 -->

		<!-- ******************************** jsp的依赖 ********************************************** -->
		<dependency>
			<groupId>javax.servlet.jsp</groupId>
			<artifactId>jsp-api</artifactId>
			<version>${jsp-api.version}</version>
			<scope>provided</scope>
		</dependency>

		
		<!-- ******************************** 引入jstl，书写jstl时要用到 ********************************* -->
		<dependency>
			<groupId>javax.servlet</groupId>
			<artifactId>jstl</artifactId>
			<version>${jstl.version}</version>
		</dependency>
		<!--ueditor，一个富文本编辑器 -->
		<dependency>
			<groupId>com.gitee.qdbp.thirdparty</groupId>
			<artifactId>ueditor</artifactId>
			<version>1.4.3.3</version>
		</dependency>
		<!--jackson，把对象和json格式互转换时需要用到 -->
		<dependency>
			<groupId>com.fasterxml.jackson.core</groupId>
			<artifactId>jackson-databind</artifactId>
			<version>2.9.7</version>
		</dependency>
		
		<!--dbcp，还记得数据库连接池么？？还有C3P0，druid这些 -->
		<dependency>
			<groupId>commons-dbcp</groupId>
			<artifactId>commons-dbcp</artifactId>
			<version>1.4</version>
		</dependency>
		<!--set get方法使用注解开发时需要它 -->
		<dependency>
			<groupId>org.projectlombok</groupId>
			<artifactId>lombok</artifactId>
			<version>1.18.4</version>
			<scope>provided</scope>
		</dependency>
		

	</dependencies>
	<build>
		<finalName>ssm</finalName><!--改项目名的时候改这里 -->

		<plugins>
			<!-- maven插件控制 -->
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-compiler-plugin</artifactId>
				<version>3.1</version>
				<configuration>
					<source>1.8</source>
					<target>1.8</target>
					<encoding>utf-8</encoding>
				</configuration>
			</plugin>
			<plugin>
				<groupId>org.apache.tomcat.maven</groupId>
				<artifactId>tomcat7-maven-plugin</artifactId>
				<version>2.2</version>
				<configuration>
					<!--端口控制 -->
					<port>8080</port>
					<!--项目路径控制意味着http://localhost:8080/abc -->
					<!-- <path>/abc</path> -->
					<!--编码 -->
					<uriEncoding>UTF-8</uriEncoding>
				</configuration>
			</plugin>
		</plugins>
		<resources>
			<resource>
				<directory>src/main/java</directory>
				<includes>
					<include>**/*.xml</include>
				</includes>
				<filtering>true</filtering>
			</resource>
			<resource>
				<directory>src/main/resources</directory>
				<includes>
					<include>**/*.xml</include>
					<include>**/*.properties</include>
				</includes>
			</resource>

		</resources>

	</build>

</project>
```
