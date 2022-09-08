---
title: Spring Boot & Slf4j & logback 彩色日志打印（功能点：1、分运行环境生成日志文件 2、日志文件目录分类 3、日志文件按日输出）
date: 2022-09-05 17:09:05
category_bar: true
categories: Spring Boot
tags:
- Spring Boot
- 全局异常处理
- 统一结果返回
---
# Spring Boot & 拦截参数 & 全局异常处理 & 统一结果返回
---

[toc]

---

## 一、直接在实体类字段上加上注解以拦截

```
@NotBlank(message = "请输入密码")
@Pattern(regexp = "\\w{6,18}$",message = "账号应为6-18位字符,不含特殊符号，添加失败")
private String userAccount;
@NotBlank(message = "请输入密码")
@Pattern(regexp = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,18}$",message = "账号应为6-18位字符,包含数字和字母，不含特殊符号，添加失败")
private String userPwd;
```
+ 常用注解
| **注解**                                             | **适用的数据类型**                                           | **说明**                                                     |
| ---------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **@AssertFalse**                                     | [Boolean](https://so.csdn.net/so/search?q=Boolean&spm=1001.2101.3001.7020), boolean | 验证注解的元素值是false                                      |
| **@AssertTrue**                                      | Boolean, boolean                                             | 验证注解的元素值是true                                       |
| **@DecimalMax****（value=x）**                       | BigDecimal, BigInteger, String, byte,short, int, long and the respective wrappers of the primitive types. Additionally supported by HV: any sub-type of Number andCharSequence. | 验证注解的元素值小于等于@ DecimalMax指定的value值            |
| **@DecimalMin****（value=x）**                       | BigDecimal, BigInteger, String, byte,short, int, long and the respective wrappers of the primitive types. Additionally supported by HV: any sub-type of Number andCharSequence. | 验证注解的元素值小于等于@ DecimalMin指定的value值            |
| **@Digits(integer=****整数位数, fraction=小数位数)** | BigDecimal, BigInteger, String, byte,short, int, long and the respective wrappers of the primitive types. Additionally supported by HV: any sub-type of Number andCharSequence. | 验证注解的元素值的整数位数和小数位数上限                     |
| **@Future**                                          | java.util.Date, java.util.Calendar; Additionally supported by HV, if the[Joda Time](http://joda-time.sourceforge.net/) date/time API is on the class path: any implementations ofReadablePartial andReadableInstant. | 验证注解的元素值（日期类型）比当前时间晚                     |
| **@Max****（value=x）**                              | BigDecimal, BigInteger, byte, short,int, long and the respective wrappers of the primitive types. Additionally supported by HV: any sub-type ofCharSequence (the numeric value represented by the character sequence is evaluated), any sub-type of Number. | 验证注解的元素值小于等于@Max指定的value值                    |
| **@Min****（value=x）**                              | BigDecimal, BigInteger, byte, short,int, long and the respective wrappers of the primitive types. Additionally supported by HV: any sub-type of CharSequence (the numeric value represented by the char sequence is evaluated), any sub-type of Number. | 验证注解的元素值大于等于@Min指定的value值                    |
| **@NotNull**                                         | Any type                                                     | 验证注解的元素值不是null                                     |
| **@Null**                                            | Any type                                                     | 验证注解的元素值是null                                       |
| **@Past**                                            | java.util.Date, java.util.Calendar; Additionally supported by HV, if the[Joda Time](http://joda-time.sourceforge.net/) date/time API is on the class path: any implementations ofReadablePartial andReadableInstant. | 验证注解的元素值（日期类型）比当前时间早                     |
| **@Pattern(regex=****正则表达式, flag=)**            | String. Additionally supported by HV: any sub-type of CharSequence. | 验证注解的元素值与指定的正则表达式匹配                       |
| **@Size(min=****最小值, max=最大值)**                | String, Collection, Map and arrays. Additionally supported by HV: any sub-type of CharSequence. | 验证注解的元素值的在min和max（包含）指定区间之内，如字符长度、集合大小 |
| **@Valid**                                           | Any non-primitive type（引用类型）                           | 验证关联的对象，如账户对象里有一个订单对象，指定验证订单对象 |
| **@NotEmpty**                                        | `CharSequence`,`Collection`, `Map and Arrays`                | 验证注解的元素值不为null且不为空（字符串长度不为0、集合大小不为0） |
| **@Range(min=****最小值, max=最大值)**               | `CharSequence, Collection, Map and Arrays,BigDecimal, BigInteger, CharSequence, byte, short, int, long and the respective wrappers of the primitive types` | 验证注解的元素值在最小值和最大值之间                         |
| **@NotBlank**                                        | `CharSequence`                                               | 验证注解的元素值不为空（不为null、去除首位空格后长度为0），不同于@NotEmpty，@NotBlank只应用于字符串且在比较时会去除字符串的空格 |
| **@Length(min=****下限, max=上限)**                  | `CharSequence`                                               | 验证注解的元素值长度在min和max区间内                         |
| **@Email**                                           | `CharSequence`                                               | 验证注解的元素值是Email，也可以通过正则表达式和flag指定自定义的email格式 |

## 二、配置拦截成功时的返回信息

![image-20220720111716167](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720111716167.png)
+ @Valid：表示加入拦截

## 三、全局异常处理

```
package com.hbq.cms.config;

/**
 * @author: hbq
 * @description: 统一异常拦截
 * @date: 2017/10/24 10:31
 */
@ControllerAdvice
@ResponseBody
@Slf4j
public class GlobalExceptionHandler {
	/**
	 * 参数校验异常处理
	 */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Result handleMethodArgumentNotValid(MethodArgumentNotValidException e) {
        log.error("校验失败：{}\nat：{}", e.getMessage(), Arrays.toString(e.getStackTrace()).replaceAll(",", "\n   "));
        String message = e.getFieldError().getDefaultMessage();
        String errorDetail = message + "(" + e.getFieldError().getField() + ")";
        return Result.failed(errorDetail);
    }

    /**
     * 常规异常处理
     */
    @ExceptionHandler(Throwable.class)
    public Result handleGeneralException(Exception e) {
        log.error("未知异常：{}\nat：{}", e.getMessage(), Arrays.toString(e.getStackTrace()).replaceAll(",", "\n   "));
        return Result.failedWith("", ErrorEnum.E_500.getErrorCode(), ErrorEnum.E_500.getErrorMsg());
    }
}
```

## 四、统一异常返回

```
package com.hbq.cms.common.model;

/**
 * @Author: hbq
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Result<T> implements Serializable {

    private T datas;
    private Integer resp_code;
    private String resp_msg;

    public static <T> Result<T> succeed(String msg) {
        return succeedWith(null, CodeEnum.SUCCESS.getCode(), msg);
    }

    public static <T> Result<T> succeed(T model, String msg) {
        return succeedWith(model, CodeEnum.SUCCESS.getCode(), msg);
    }

    public static <T> Result<T> succeed(T model) {
        return succeedWith(model, CodeEnum.SUCCESS.getCode(), "");
    }

    public static <T> Result<T> succeedWith(T datas, Integer code, String msg) {
        return new Result<>(datas, code, msg);
    }

    public static <T> Result<T> failed(String msg) {
        return failedWith(null, CodeEnum.ERROR.getCode(), msg);
    }

    public static <T> Result<T> failed(T model, String msg) {
        return failedWith(model, CodeEnum.ERROR.getCode(), msg);
    }

    public static <T> Result<T> failedWith(T datas, Integer code, String msg) {
        return new Result<>(datas, code, msg);
    }

}
```

