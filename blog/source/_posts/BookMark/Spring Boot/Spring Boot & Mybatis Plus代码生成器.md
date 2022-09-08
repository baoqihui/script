---
title: Spring Boot & Mybatis Plus代码生成器
date: 2022-09-05 17:09:05
category_bar: true
categories: Spring Boot
tags:
- Spring Boot
- Mybatis Plus
---
# Spring Boot & Mybatis Plus代码生成器

---

[toc]

---

<font color=red size=5>
前言：近期进入新公司以后抛弃了原有mybatis框架，使用了mybatis plus操作mysql，并设置了最基本的增删改查模板。极大程度减少了重复代码。此处单独拉出mybatis plus代码生成器以及最基础的分页配置，条件查询配置，swagger配置，sql日志打印的demo。 代码生成器不但可以生成后端Java代码，也可以经过模板配置生成前端代码。小回正在测试中....
</font> 

+ 涉及技术：mybatis plus、swagger 2、hutool、lombok、mysql....

+ 源码：
 [生成器源码](https://gitee.com/idse666666/code-generator.git)
  [配置模板源码](https://gitee.com/idse666666/code-demo.git)

---

## 一. 分别引入生成器和模板（如报错或有提示警告，请确保配置maven3.6.1和jdk1.8，其他版本自测）。
1. 从git创建文件： 

   ![image-20220721141903483](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721141903483.png)

2. 分别填写上方地址：

   ![image-20220721141924334](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721141924334.png)

3. 引入数据库
```
CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(30) DEFAULT NULL COMMENT '姓名',
  `age` int(11) DEFAULT NULL COMMENT '年龄',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `is_del` tinyint(2) DEFAULT NULL COMMENT '删除标志',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='user代码生成测试';
```
![image-20220721141932225](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721141932225.png)

4.  详细读一下README.md


## 二、基础配置
+ 分别配置两个application.properties中的数据源(配置后请重启idea)
![image-20220721141942523](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721141942523.png)


## 三、生成代码
1. 启动CodeGeneratorApp
2. postman生成所需user表所对应代码
```
//访问路径，多个用 , 分开；如：tables=user,user2
localhost:8081/generator/code?tables=user
```
![image-20220721142001181](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721142001181.png)
3. 解压代码并复制到demo项目中（复制后请重启idea）
+ 解压
![image-20220721142010077](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721142010077.png)
+ 复制java代码
![image-20220721142019534](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721142019534.png)
+ 复制xml
![image-20220721142028181](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721142028181.png)

## 四、 测试生成代码
1. swagger接口文档形式，浏览器访问http://localhost:8080/swagger-ui.html#/
![image-20220721142037784](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721142037784.png)
2. postman测试，略

## 五、附加使用：分页插件（默认集成），条件查询，逻辑删除，时间戳自动新增和更新
1. 分页条件查询
```
//xml中findList方法，添加你想要查询的条件
where t.is_del=0
<if test="p.name != null and p.name != ''">
	and t.name like '%${p.name}%'
</if>
//Controler的swagger参数配置
```
![image-20220721142048083](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721142048083.png)

![image-20220721142057826](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721142057826.png)
+ 测试：

  ![image-20220721142111831](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721142111831.png)

+ 观察到执行sql：select * from user t   where t.is_del=0   and t.name like '%bq%'   order by t.id desc LIMIT 0,2

2. 逻辑删除：删除标志上直接加 @TableLogic 注解即可
![image-20220721142122720](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721142122720.png)

3. 时间戳自动新增和更新
![image-20220721142142552](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721142142552.png)
