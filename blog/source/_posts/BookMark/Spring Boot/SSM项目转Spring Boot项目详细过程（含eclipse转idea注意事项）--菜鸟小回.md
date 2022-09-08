---
title: SSM项目转Spring Boot项目详细过程（含eclipse-->idea注意事项）
date: 2022-09-05 17:09:05
category_bar: true
categories: Spring Boot
tags:
- Spring Boot
- SSM
---
# SSM项目转Spring Boot项目详细过程（含eclipse-->idea注意事项）

---
[toc]

---

+ 本文主要记录SSM项目转移为Spring Boot项目中注意事项。包括SSM中主要配置文件的转移
相关博文：
+ Spring Boot常用pom依赖：[Spring Boot常用依赖汇总 ](https://blog.csdn.net/qq_39231769/article/details/103096352)
+ idea创建Spring Boot项目介绍：[idea新建一个Spring Boot项目+项目目录简单介绍+项目打包运行](https://blog.csdn.net/qq_39231769/article/details/103098524)
---
## 一、建立Spring Boot项目并导入依赖参考上方相关博文

## 二、静态页面转移
![image-20220720112322207](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720112322207.png)

## 三、后台代码
![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/aHR0cDovL2hicS5pZHNlLnRvcC9ibG9nLzE1NzM4NzI5MDY3NjEucG5n.png)

## 四、分离mapper文件
![image-20220720112332110](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720112332110.png)

## 五、运行方式的改（由于内置tomcat，直接运行main方法就可以运行项目）变和注解扫描的配置
![image-20220720112342369](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720112342369.png)

## 六、mysql以及mybatis的配置
1. mysql
![image-20220720112353247](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720112353247.png)
2. mybatis的mapper.xml文件位置更换并配置包路径。
    ![image-20220720112431444](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720112431444.png)
3. mybatis别名设置（直接设置pojo包，之后mapper.xml中就可以省略包名直接用类名） 
![image-20220720112441543](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720112441543.png)

## 七、拦截器和过滤器的配置（主要改变为其注册方式，从配置方式改为java类配置）
1. 拦截器
![image-20220720112449570](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720112449570.png)

2. 过滤器
![image-20220720112458305](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720112458305.png)

3. 附带拦截器、过滤器、注册代码：
[Spring Boot项目 过滤器，拦截器，及其注册](https://blog.huijia.cf/archives/springboot-xiang-mu-guo-lv-qi--lan-jie-qi--ji-qi-zhu-ce)

## 八、事务的配置（直接对ServiceImpl中所需类或方法使用@Transactional注解)
![image-20220720112507962](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720112507962.png)

## 九、项目默认跳转首页设置（新增Controller）
![image-20220720112530212](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720112530212.png)
```
/* **********************************直接访问首页************************************* */
@Configuration
public class WebConfigurer implements WebMvcConfigurer {
	@Override
	public void addViewControllers(ViewControllerRegistry registry) {
		registry.addViewController("/").setViewName("forward:/login.html");
		registry.setOrder(Ordered.HIGHEST_PRECEDENCE);
	}
}
```

## 十、其他
1. mapper自动注入报错可以忽略，或者在mapper接口上加@Component。
2. 图片验证码可能失效，参考博文第二种方法：[Java中使用图片验证码](https://blog.csdn.net/qq_39231769/article/details/102710427)
3. PageHelper分页需要更换spring boot类型pom依赖

