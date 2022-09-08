---
title: spring.md
date:  2022/9/8 18:02
category_bar: true
categories: 面试
tags:
- Spring
---
# Spring相关

[toc]

---

## 一、spring的循环依赖问题

### 1.两种循环依赖

+ 全构造器循环依赖，无法解决，建议更换为set。
+ 循环注入，a注入b，b注入a。

### 2.解决：

Spring 通过提前曝光机制，利用三级缓存解决循环依赖。

### 3. 为什么要三级缓存？二级缓存不能解决循环依赖吗？

二级缓存配合也可以解决循环依赖，但三级缓存的使用，是为了完成Spring AOP 中的后置处置功能而提出的。

## 二、如何引用配置文件中的值 

### 1. 注解形式：

+ @Configuration：声明类为配置文件
+ @ConfigurationProperties(prefix = "person")   //实现批量注入（set方法）
+ @value(" ${}")：引入配置文件中的值

### 2. xml形式中：

+ ${}：字符拼接
+ #{}：防注入

## 三、spring mvc组件

|       组件        |                             作用                             |
| :---------------: | :----------------------------------------------------------: |
| DispatcherServlet | 前端控制器，调用其他组件处理用户的请求，降低了组件之间的耦合性 |
|  HandlerMapping   |        处理器映射器，根据用户请求找到Handler即处理器         |
|  HandlerAdapter   |         处理器适配器，请求转发给Handler，执行handler         |
|   View Resolver   |           视图解析器，将modelAndView对象解析为view           |

## 四、什么是Spring Boot?

Spring Boot是Spring开源组织下的子项目，是Spring 组件一站式解决方案，主要是简化了使用Spring 的难度，简省了繁重的配置，提供了各种启动器，开发者能快速上手。

## 五、spring与spring boot关系

spring boot基于spring 4.0设计，支持省去applicationContext.xml;不仅继承了Spring框架原有的优秀特性，而且还通过简化配置来进一步简化了Spring应用的整个搭建和开发过程。另外SpringBoot通过集成大量的框架使得依赖包的版本冲突，以及引用的不稳定性等问题得到了很好的解决

## 六、常用springboot注解：

| 注解                     | 介绍                                                         |
| ------------------------ | ------------------------------------------------------------ |
| @SpringBootApplication   | 包含了@ComponentScan、@Configuration和@EnableAutoConfiguration注解 |
| @Configuration           | 等同于spring的XML配置文件；使用Java代码可以检查类型安全      |
| @EnableAutoConfiguration | 自动配置                                                     |
| @ComponentScan           | 组件扫描，可自动发现和装配一些Bean                           |
| @Component               | 可配合CommandLineRunner使用，在程序启动后执行一些基础任务    |
| @RestController          | @Controller和@ResponseBody的合集,表示这是个控制器bean,并且是将函数的返回值直 接填入HTTP响应体中,是REST风格的控制器 |
| @Autowired               | 自动导入                                                     |
| @PathVariable            | 获取参数                                                     |
| @ImportResource          | 加载xml配置文件                                              |
| @Import                  | 用来导入其他配置类                                           |
| @ControllerAdvice        | 包含@Component。可以被扫描到。统一处理异常                   |
| @ExceptionHandler        | 用在方法上面表示遇到这个异常就执行以下方法                   |
| @ConfigurationProperties | 批量注入配置文件中属性                                       |

## 七、Spring Boot有哪些优点?

1. 容易上手，提升开发效率，为Spring开发提供一个更快、更广泛的入门体验。

2. 开箱即用，远离繁琐的配置。
3. 提供了一系列大型项目通用的非业务性功能，例如:内嵌服务器、安全管理、运行数据监控、运行状况检查和外部化配置等。
4. 没有代码生成,也不需要XML配置。
5. 避免大量的Maven导入和各种版本冲突。

## 八、Spring Boot的SpringBootApplication注解

+ @SpringBootApplication：@SpringBootConfiguration、@EnableAutoConfiguration、@ComponentScan组合而成

+ @SpringBootConfiguration：SpringBoot 的配置类，标注在某个类上，表示这是一个 SpringBoot的配置类。

+ @EnableAutoConfiguration：Spring 中有很多以 Enable 开头的注解，其作用就是借助 @Import 来收集并注册特定场景相关的

  Bean ，并加载到 IOC 容器。

  + @Import：遍历各个组件META-INF目录中所有jar包下的spring.factories文件。收集需要配置的类，然后过滤或排除后装载到ioc容器中

+ @ComponentScan：主要是从定义的扫描路径中，找出标识了需要装配的类自动装配到spring 的bean容器中。

## 九、Spring Boot自动配置原理是什么?

+ 注解@EnableAutoConfiguration,@Configuration, @ConditionalOnClass 就是自动配置的核心，
+ EnableAutoConfiguration给容器导入META-INF/spring.factories里定义的自动配置类。筛选有效的自动配置类。
+ 每一个自动配置类结合对应的 xxxProperties.java读取配置文件进行自动配置功能

## 十、如何使用Spring Boot实现异常处理?

Spring 提供了一种使用ControllerAdvice处理异常的非常有用的方法。我们通过实现一个ControlerAdvice类，来处理控制器类抛出的所有异常。

## 十一、Spring Boot中如何实现定时任务?

使用Spring中的@Scheduled 注解

## 十二、 spring cloud

|  组件   |                             作用                             |
| :-----: | :----------------------------------------------------------: |
| Eureka  |      微服务架构中的注册中心，专门负责服务的注册与发现。      |
|  Feign  |                    动态代理，调取其他服务                    |
| Ribbon  |      客服端负载均衡，均匀分发feign的各项命令到多台主机       |
| Hystrix | 断路器，每个服务生成线程池，调取挂掉的服务熔断，记录降级信息 |
|  Zuul   |        服务网关，请求转发，并方便统一认证，限流，降级        |

## 十三、Spring事务失效场景及原理

+ 吃异常

+ 数据库引擎不支持事务

+ 非public方法
+ 调用同类的方法 等

## 十四、spring源码中总共用到了哪些设计模式，具体体现在哪？

1. 工厂模式: BeanFactory就是简单工厂模式的体现，用来创建对象的实例;
2. 单例模式:Bean默认为单例模式。
3. 代理模式:spring的AOP功能用到了JDK的动态代理和cGLIB字节码生成技术;
4. 模板方法:用来解决代码重复的问题。比如.RestTemplate, JmsTemplate,JpaTemplate。
5. 观察者模式:定义对象键一种一对多的依赖关系，当一个对象的状态发生改变时，所有依赖于它的对象都会得到通知被制动更新，如Spring 中 listener的实现-ApplicationListenero

## 十五、SpringBean的生命周期

![image-20220721150311224](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721150311224.png)
