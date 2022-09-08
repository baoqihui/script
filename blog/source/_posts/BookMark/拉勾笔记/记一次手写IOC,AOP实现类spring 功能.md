---
title: 记一次手写IOC,AOP实现类spring 功能.md
date:  2022/9/7 10:48
category_bar: true
categories: 拉勾笔记
tags:
- 自定义注解
---
# 手写XML或自定义注解IOC,AOP实现类spring功能
---
前言：spring手写之路上，为了充分了解IOC和AOP特性以及实现过程。手写实现spring的ioc和aop功能。
+ 两种形式：
	+ 1.基于xml：使用dom4j技术，解析xml文件。获取全类名，反射获取类并实例化。同时以无参构造形式注入依赖。
	+ 2.基于注解：解析到注解类后，使用reflections.getTypesAnnotatedWith方法获取类集合，然后实例化并注入依赖。

---

+ IOC：控制反转；将bean的实例化交给容器。
+ AOP：面向切面；补充oop面向对象，解决横向切入问题。
+ DI：依赖注入：与IOC实现功能类似；不同在于站在容器的角度，如果A对象实例化过程中因为声明了一个B类型的属性，那么就需要容器把B对象注入给A
---
## 一、下载源码
源码地址：[ lagou-transfer ](https://gitee.com/idse666666/my_spring/tree/master/lagou-transfer)
## 二、beans.xml编写xml
![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/1628254605637.png)
## 三、BeanFactory解析xml
+ 任务一：扫描包，通过反射技术实例化对象并且存储待用（map集合）
+ 任务二：对外提供获取实例对象的接口（根据id获取）
+ 解析bean并实例化
![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/1628254732278.png)
+ “set方法”.invoke(“父级对象”,“实例化后对象”）使用set方法注入实例化后的对象
![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/1628254964125.png)

## 四、下载源码
源码地址：[lagou-transfer-work](https://gitee.com/idse666666/lagou-work/tree/master/%E9%98%B6%E6%AE%B5%E4%B8%80%E6%A8%A1%E5%9D%97%E4%BA%8C%E4%BD%9C%E4%B8%9A/code/)
## 五、注解的定义
+ @Target：
@Target说明了Annotation所修饰的对象范围：Annotation可被用于 packages、types（类、接口、枚举、Annotation类型）、类型成员（方法、构造方法、成员变量、枚举值）、方法参数和本地变量（如循环变量、catch参数）。在Annotation类型的声明中使用了target可更加明晰其修饰的目标。

作用：用于描述注解的使用范围（即：被描述的注解可以用在什么地方）

取值(ElementType)有：
1. CONSTRUCTOR:用于描述构造器
2. FIELD:用于描述域
3. LOCAL_VARIABLE:用于描述局部变量
4. METHOD:用于描述方法
5. PACKAGE:用于描述包
6. PARAMETER:用于描述参数
7. TYPE:用于描述类、接口(包括注解类型) 或enum声明

+ @Retention：

@Retention定义了该Annotation被保留的时间长短：某些Annotation仅出现在源代码中，而被编译器丢弃；而另一些却被编译在class文件中；编译在class文件中的Annotation可能会被虚拟机忽略，而另一些在class被装载时将被读取（请注意并不影响class的执行，因为Annotation与class在使用上是被分离的）。使用这个meta-Annotation可以对 Annotation的“生命周期”限制。
　　
作用：表示需要在什么级别保存该注释信息，用于描述注解的生命周期（即：被描述的注解在什么范围内有效）

取值（RetentionPoicy）有：
1. SOURCE:在源文件中有效（即源文件保留）
2. CLASS:在class文件中有效（即class保留）
3. RUNTIME:在运行时有效（即运行时保留）

说明：Column注解的的RetentionPolicy的属性值是RUTIME,这样注解处理器可以通过反射，获取到该注解的属性值，从而去做一些运行时的逻辑处理

源码：myAnno
@Service
```
//用在描述类
@Target(ElementType.TYPE)
//运行时有效
@Retention(RetentionPolicy.RUNTIME)
public @interface Service {
    String value() default "";
}
```
@Autowired
```
//用在字段上
@Target(ElementType.FIELD)
//运行时有效
@Retention(RetentionPolicy.RUNTIME)
public @interface Autowired {
    boolean required() default true;
}
```
@Transactional
```
//用在描述类
@Target(ElementType.TYPE)
//运行时有效
@Retention(RetentionPolicy.RUNTIME)
public @interface Transactional {
    String value() default "";
}
```
## 六、工厂类AnnoBeanFactory（扫描注解，利用反射技术和动态代理技术实现类实例化和事务控制）
![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/1628252560478.png)
+ 任务一：扫描包，通过反射技术实例化对象并且存储待用（map集合）
+ 任务二：对外提供获取实例对象的接口（根据id获取）
+ 解析@Service注解：只需要获取其类实例化，然后放入map集合中
![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/1628252306337.png)
+ 解析@Autowired注解：注解用在字段上，用于注入实例化后的值。
![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/1628253372265.png)
+ 解析@Transactional注解
 ![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/1628253843196.png)

 ## 七、AOP的实现（ProxyFactory）
 利用JDK动态代理或者CGLIB动态代理
 关于动态代理的知识可以参考我的另一篇博文：[通过房屋租赁流程理解设计模式](https://blog.csdn.net/qq_39231769/article/details/119317869?spm=1001.2014.3001.5501)
 ```
    public Object getJdkProxy(Object o){
        return Proxy.newProxyInstance(o.getClass().getClassLoader(), o.getClass().getInterfaces(), new InvocationHandler() {
            @Override
            public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
                Object result=null;
                try {
                    //开启事务（关闭事务自动提交）
                    transactionManager.beginTransaction();
                    result = method.invoke(o, args);
                    //提交事务
                    transactionManager.commit();
                }catch (Exception e){
                    e.printStackTrace();
                    //回滚
                    transactionManager.rollback();
                    //抛出异常以便于上层servlet获取
                    throw e;
                }
                return result;
            }
        });
    }
    /**
     * 使用cglib动态代理生成代理对象
     * @param obj 委托对象
     * @return
     */
    public Object getCglibProxy(Object obj) {
        return  Enhancer.create(obj.getClass(), new MethodInterceptor() {
            @Override
            public Object intercept(Object o, Method method, Object[] objects, MethodProxy methodProxy) throws Throwable {
                Object result = null;
                try{
                    // 开启事务(关闭事务的自动提交)
                    transactionManager.beginTransaction();

                    result = method.invoke(obj,objects);

                    // 提交事务

                    transactionManager.commit();
                }catch (Exception e) {
                    e.printStackTrace();
                    // 回滚事务
                    transactionManager.rollback();

                    // 抛出异常便于上层servlet捕获
                    throw e;

                }
                return result;
            }
        });
    }
}
 ```
blog.huijia.cf