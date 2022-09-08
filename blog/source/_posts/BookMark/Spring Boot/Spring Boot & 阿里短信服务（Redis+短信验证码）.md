---
title: Spring Boot & 阿里短信服务（Redis+短信验证码）
date: 2022-09-05 17:09:05
category_bar: true
categories: Spring Boot
tags:
- Spring Boot
- 阿里短信服务
---
# Spring Boot & 阿里短信服务（Redis+短信验证码）
---

[toc]

---

## 1. 创建签名
+ 如下位置创建签名，等待审核通过
![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/aHR0cDovL2hicS5pZHNlLnRvcC9ibG9nLzE1NzE3NTAxMzI2MjkucG5n.png)
![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/aHR0cDovL2hicS5pZHNlLnRvcC9ibG9nLzE1NzE3NTAyMDA0NzMucG5n.png)
## 2. 创建模板
+ 如下位置创建模板，等待审核通过
![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/aHR0cDovL2hicS5pZHNlLnRvcC9ibG9nLzE1NzE3NTAzNjcyNjUucG5n-20220901181234093.png)
![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/aHR0cDovL2hicS5pZHNlLnRvcC9ibG9nLzE1NzE3NTA1NDEwODMucG5n-20220901181239935.png)
## 3. 测试验证码功能
+ 填写相关信息，测试发送
![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/aHR0cDovL2hicS5pZHNlLnRvcC9ibG9nLzE1NzE3NTA4MDM4ODAucG5n-20220901181246773.png)
![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/format,png-20220901181259065.png)
<font color=red size=5>注：发送失败可能因为你余额不足。可以选择购买套餐。新号可去尝试下图位置领取免费短信。</font>
+ 官网主页下拉最后
+ ![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/aHR0cDovL2hicS5pZHNlLnRvcC9ibG9nLzE1NzE3NTExNzEyMjAucG5n-20220901181307940.png)
+ ![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/aHR0cDovL2hicS5pZHNlLnRvcC9ibG9nLzE1NzE3NTExOTY4NjgucG5n-20220901181315014.png)
## 4. 查看Api Demo
+ ![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/aHR0cDovL2hicS5pZHNlLnRvcC9ibG9nLzE1NzE3NTEyMzUxNjUucG5n-20220901181320964.png)
+ ![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/aHR0cDovL2hicS5pZHNlLnRvcC9ibG9nLzE1NzE3NTE0Mjc5MzkucG5n-20220901181328073.png)
## 5. 获取AK信息
+ ![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/aHR0cDovL2hicS5pZHNlLnRvcC9ibG9nLzE1NzE3NTE1MDAyMjYucG5n-20220901181333245.png)
+ 创建AccessKey
+ ![enter description here](https://imgconvert.csdnimg.cn/aHR0cDovL2hicS5pZHNlLnRvcC9ibG9nLzE1NzE3NTE1NTQ4NTUucG5n?x-oss-process=image/format,png)
+ 保存一下AccessKeyId和AccessKeySecret
+ ![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/aHR0cDovL2hicS5pZHNlLnRvcC9ibG9nLzE1NzE3NTE2MDQ5NjIucG5n-20220901181338869.png)
+ 将其复制分别填到AccessKeyId和AccessKeySecret的位置
+ ![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/aHR0cDovL2hicS5pZHNlLnRvcC9ibG9nLzE1NzE3NTE5MjQ2NjcucG5n-20220901181342922.png)
## 6. pom.xml
```
<!-- 短信服务-->
<dependency>
    <groupId>com.aliyun</groupId>
    <artifactId>dysmsapi20170525</artifactId>
    <version>2.0.9</version>
</dependency>
```

## 7.yml配置

```
#阿里短息配置
ali:
  endpoint: dysmsapi.aliyuncs.com
  accessKey: LT***C4
  secretKey: BQ***1M
  signName: IDSE
  templateCode: SMS_***75
  expireTime: 300
```

## 8.自建工具类

```
package com.hbq.cms.util;

/**
 * @Author: huibq
 * @Date: 2022/5/6 15:33
 * @Description: 短信发送工具类
 */
@Slf4j
@Component
public class MessageUtil {
    private static Client messageClient;

    @Resource
    private RedisUtils redisUtils;

    @Value("${ali.endpoint}")
    private String endpoint;
    @Value("${ali.accessKey}")
    private String accessKey;
    @Value("${ali.secretKey}")
    private String secretKey;
    @Value("${ali.signName}")
    private String signName;
    @Value("${ali.templateCode}")
    private String templateCode;
    @Value("${ali.expireTime}")
    private Long expireTime;

    @PostConstruct
    public void init() {
        try {
            Config config = new Config()
                    // 您的AccessKey ID
                    .setAccessKeyId(accessKey)
                    // 您的AccessKey Secret
                    .setAccessKeySecret(secretKey);
            // 访问的域名
            config.endpoint = endpoint;
            messageClient = new Client(config);
        } catch (Exception e) {
            e.printStackTrace();
            log.error("初始化messageClient配置异常: 【{}】", e.fillInStackTrace());
        }
    }

    /**
     * 发送短信
     *
     * @param tel 手机号
     */
    public void sendMessage(String tel) {
        String code = RandomUtil.randomNumbers(6);
        SendSmsRequest sendSmsRequest = new SendSmsRequest()
                .setSignName(signName)
                .setTemplateCode(templateCode)
                .setPhoneNumbers(tel)
                .setTemplateParam("{\"code\":\"" + code + "\"}");
        try {
            SendSmsResponse sendSmsResponse = messageClient.sendSms(sendSmsRequest);
            String result = sendSmsResponse.getBody().getCode();
            if ("OK".equals(result)) {
                redisUtils.set(String.format(RedisKey.MESSAGE_KEY,tel), code, expireTime);
            }
        } catch (Exception e) {
            log.error("发送短信异常:{}", e.fillInStackTrace());
        }
    }

    /**
     * 验证短信验证码
     * @param tel 手机号
     * @param code 验证码
     * @return 验证结果
     */
    public boolean isCode(String tel, String code) {
        String resultCode = redisUtils.get(String.format(RedisKey.MESSAGE_KEY,tel));
        if (resultCode != null && resultCode.equals(code)) {
            return true;
        }
        return false;
    }

    /**
     * 不是正确的验证码
     * @param tel 手机号
     * @param code 验证码
     * @return 验证结果
     */
    public boolean isNotCode(String tel, String code) {
        return !isCode(tel, code);
    }
}
```

