---
title: Spring Boot & 支付宝支付（手机端，web端）
date: 2022-09-05 17:09:05
category_bar: true
categories: Spring Boot
tags:
- Spring Boot
- 支付宝支付
---
# Spring Boot & 支付宝支付（手机端，web端）
---

[toc]

---

## 一、Spring boot项目代码
1. Controller
```
package com.hbq.teacher_plus.common.controller;

/**
 * @author hbq
 * @createTime 2020/3/19 23:29
 */
@Slf4j
@RestController
public class AlipayController {

    /**
     * 支付宝完成回调页面(不可信回调)
     */
    @GetMapping("/return")
    @ResponseBody
    private String alipayReturn(HttpServletRequest request) {

        Map<String, String[]> parameterMap = request.getParameterMap();
        Map<String, String> handleParams = AlipayUtil.handleParams(parameterMap);

        // 这里的校验没有多大的意思,不可信,直接获取out_trade_no跳转到对应的payed controller也可
        boolean rsaCheck = AlipayUtil.rsaCheck(handleParams);
        if (rsaCheck){
            System.out.println("验证通过");
        }else {
            System.out.println("验证失败");
        }

        // 获取订单号
        String out_trade_no = handleParams.get("out_trade_no");
        System.out.println("out_trade_no:" + out_trade_no);
        // 这里一般都是 重定向 payed的controller, 然后携带对应的信息如:return "redirect:/alipay/success?out_trade_no=" + out_trade_no;
        // payed的controller根据out_trade_no获取支付结果,并且给出页面提示

        return "支付完成";
    }


    /**
     * 支付宝完成结果异步的回调(可信回调)
     * @param request
     */
    @PostMapping("/notify")
    @ResponseBody
    private String alipayNotify(HttpServletRequest request) {

        Map<String, String[]> parameterMap = request.getParameterMap();
        Map<String, String> handleParams = AlipayUtil.handleParams(parameterMap);

        boolean rsaCheck = AlipayUtil.rsaCheck(handleParams);
        if (rsaCheck){
            System.out.println("验证通过");

            // 处理业务逻辑,更改支付状态等骚操作
            // ...
        }else {
            System.out.println("验证失败");
        }
        return rsaCheck ? "success" : "failure";
    }
    @RequestMapping("/pay/phone")
    public String pay() {

        AlipayVo alipayVo = new AlipayVo();
        // String out_trade_no = UUID.randomUUID().toString().replace("-", "");
        String out_trade_no = AlipayUtil.get().nextId() + "";
        System.out.println("out_trade_no:" + out_trade_no);
        // 设置订单单号,需要保证唯一性
        alipayVo.setOut_trade_no(out_trade_no);
        // 设置支付金额
        alipayVo.setTotal_amount("0.01");
        // 设置支付标题
        alipayVo.setSubject("houyu-test-title");
        // 设置订单有效时长(30分钟)
        alipayVo.setTimeout_express("30m");
        alipayVo.setProduct_code("QUICK_WAP_WAY");

        // 对象转为json字符串
        String json = JSONObject.toJSONString(alipayVo);

        // 建立连接
        AlipayClient client = new DefaultAlipayClient(AlipayConfig.URL, AlipayConfig.APPID, AlipayConfig.RSA_PRIVATE_KEY, AlipayConfig.FORMAT, AlipayConfig.CHARSET, AlipayConfig.ALIPAY_PUBLIC_KEY, AlipayConfig.SIGNTYPE);

        // 创建请求
        AlipayTradeWapPayRequest alipayTradeWapPayRequest = new AlipayTradeWapPayRequest();

        // 设置异步通知地址
        alipayTradeWapPayRequest.setNotifyUrl(AlipayConfig.notify_url);
        // 设置对调地址,就是说支付成功之后回调你的页面,你可以继续进行你的业务操作,但是这个是不可信任的,需要根据notify_url这边的回调确定支付是否成功
        alipayTradeWapPayRequest.setReturnUrl(AlipayConfig.return_url);

        // 封装请求支付信息
        alipayTradeWapPayRequest.setBizContent(json);

        String pageString;
        try {
            pageString = client.pageExecute(alipayTradeWapPayRequest).getBody();
        } catch (AlipayApiException e) {
            pageString = "request aliapy has error";
            e.printStackTrace();
        }
        return pageString;
    }
    @RequestMapping("/pay/web")
    public   void   doPost (HttpServletRequest httpRequest, HttpServletResponse httpResponse)   throws ServletException, IOException {
        AlipayClient client = new DefaultAlipayClient(AlipayConfig.URL, AlipayConfig.APPID, AlipayConfig.RSA_PRIVATE_KEY, AlipayConfig.FORMAT, AlipayConfig.CHARSET, AlipayConfig.ALIPAY_PUBLIC_KEY, AlipayConfig.SIGNTYPE);
        AlipayTradePagePayRequest alipayRequest =  new  AlipayTradePagePayRequest(); //创建API对应的request
        alipayRequest.setReturnUrl( AlipayConfig.return_url );
        alipayRequest.setNotifyUrl( AlipayConfig.notify_url ); //在公共参数中设置回跳和通知地址
        AlipayVo alipayVo = new AlipayVo();
        // String out_trade_no = UUID.randomUUID().toString().replace("-", "");
        String out_trade_no = AlipayUtil.get().nextId() + "";
        System.out.println("out_trade_no:" + out_trade_no);
        // 设置订单单号,需要保证唯一性
        alipayVo.setOut_trade_no(out_trade_no);
        // 设置支付金额
        alipayVo.setTotal_amount("0.01");
        // 设置支付标题
        alipayVo.setSubject("hbq-test-title");
        // 设置订单有效时长(30分钟)
        alipayVo.setTimeout_express("30m");
        alipayVo.setProduct_code("FAST_INSTANT_TRADE_PAY");
        //备注
        alipayVo.setBody("Iphone6 16G");

        alipayVo.setPassback_params("merchantBizType%3d3C%26merchantBizNo%3d2016010101111");
        // 对象转为json字符串
        String json = JSONObject.toJSONString(alipayVo);

        alipayRequest.setBizContent(json); //填充业务参数*/
        String form= "" ;
        try  {
            form = client.pageExecute(alipayRequest).getBody();  //调用SDK生成表单
        }  catch  (AlipayApiException e) {
            e.printStackTrace();
        }
        httpResponse.setContentType( "text/html;charset="  + AlipayConfig.CHARSET);
        httpResponse.getWriter().write(form); //直接将完整的表单html输出到页面
        httpResponse.getWriter().flush();
        httpResponse.getWriter().close();
    }
}
```
2. model
```
package com.hbq.teacher_plus.common.model;

import lombok.Data;

import java.io.Serializable;

/**
 * @author hbq
 * @createTime 2020/3/19 23:29
 */
@Data
public class AlipayVo implements Serializable {

    /**
     * 订单名称
     */
    private String subject;
    /**
     * 商户网站唯一订单号
     */
    private String out_trade_no;
    /**
     * 该笔订单允许的最晚付款时间
     */
    private String timeout_express;
    /**
     * 付款金额
     */
    private String total_amount;
    /**
     * 销售产品码，与支付宝签约的产品码名称
     */
    private String product_code;
    /**
     * 	具体描述信息。如果是多种商品，请将商品描述字符串累加传给body。
     * */
    private String body;
    /**
     *
     * */
    private String passback_params;
    private String extend_params;
    // getter and setter ....
}
```
3. util
```
package com.hbq.teacher_plus.util;

import com.alipay.api.AlipayApiException;
import com.alipay.api.internal.util.AlipaySignature;
import com.hbq.teacher_plus.config.AlipayConfig;

import java.lang.management.ManagementFactory;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.util.HashMap;
import java.util.Map;

/**
 * @author houyu
 * @createTime 2019/3/20 8:38
 */
public class AlipayUtil {

    /**
     * 处理请求参数
     * @param requestParams
     * @return
     */
    public static Map<String, String> handleParams(Map<String, String[]> requestParams){
        Map<String, String> handleMap = new HashMap<>(requestParams.size());
        for (Map.Entry<String, String[]> entry : requestParams.entrySet()) {
            String key = entry.getKey();
            String[] value = entry.getValue();
            handleMap.put(key, join(value, ","));
        }
        return handleMap;
    }

    /**
     * 数组转字符串  ["1", "2"]  ==> "1,2"
     * @param os
     * @param splitString
     * @return
     */
    public static String join(Object[] os, String splitString){
        String s = "";
        if (os != null) {
            StringBuilder sBuffer = new StringBuilder();
            for (int i = 0; i < os.length; i++) {
                sBuffer.append(os[i]).append(splitString);
            }
            s = sBuffer.deleteCharAt(sBuffer.length() - 1).toString();
        }
        return s;
    }

    /**
     * 校验是否支付成功
     * @param handleParams
     * @return
     */
    public static boolean rsaCheck(Map<String, String> handleParams) {
        boolean checkV1 = false;
        try {
            checkV1 = AlipaySignature.rsaCheckV1(handleParams, AlipayConfig.ALIPAY_PUBLIC_KEY, AlipayConfig.CHARSET, AlipayConfig.SIGNTYPE);
        } catch (AlipayApiException e) {
            e.printStackTrace();
        }
        return checkV1;
    }

    /** ---------------------------------------单例模式---------------------------------------*/
    private static class SingletonHolder {
        private static final AlipayUtil INSTANCE = new AlipayUtil();
    }
    public static AlipayUtil get() {
        return SingletonHolder.INSTANCE;
    }
    /** ---------------------------------------单例模式---------------------------------------*/

    /**  雪花算法生成ID,自带时间排序,一秒可以生成25万个ID左右 */

    // 时间起始标记点，作为基准，一般取系统的最近时间（一旦确定不能变动）
    private final static long twepoch = 1288834974657L;
    // 机器标识位数
    private final static long workerIdBits = 5L;
    // 数据中心标识位数
    private final static long datacenterIdBits = 5L;
    // 机器ID最大值
    private final static long maxWorkerId = -1L ^ (-1L << workerIdBits);
    // 数据中心ID最大值
    private final static long maxDatacenterId = -1L ^ (-1L << datacenterIdBits);
    // 毫秒内自增位
    private final static long sequenceBits = 12L;
    // 机器ID偏左移12位
    private final static long workerIdShift = sequenceBits;
    // 数据中心ID左移17位
    private final static long datacenterIdShift = sequenceBits + workerIdBits;
    // 时间毫秒左移22位
    private final static long timestampLeftShift = sequenceBits + workerIdBits + datacenterIdBits;

    private final static long sequenceMask = -1L ^ (-1L << sequenceBits);
    /* 上次生产id时间戳 */
    private static long lastTimestamp = -1L;
    // 0，并发控制
    private long sequence = 0L;

    private final long workerId;
    // 数据标识id部分
    private final long datacenterId;

    public AlipayUtil() {
        this.datacenterId = getDatacenterId(maxDatacenterId);
        this.workerId = getMaxWorkerId(datacenterId, maxWorkerId);
    }

    /**
     * @param workerId     工作机器ID
     * @param datacenterId 序列号
     */
    public AlipayUtil(long workerId, long datacenterId) {
        if (workerId > maxWorkerId || workerId < 0) {
            throw new IllegalArgumentException(String.format("worker Id can't be greater than %d or less than 0", maxWorkerId));
        }
        if (datacenterId > maxDatacenterId || datacenterId < 0) {
            throw new IllegalArgumentException(String.format("datacenter Id can't be greater than %d or less than 0", maxDatacenterId));
        }
        this.workerId = workerId;
        this.datacenterId = datacenterId;
    }

    /**
     * 获取下一个ID
     *
     * @return
     */
    public synchronized long nextId() {
        long timestamp = timeGen();
        if (timestamp < lastTimestamp) {
            throw new RuntimeException(String.format("Clock moved backwards.  Refusing to generate id for %d milliseconds", lastTimestamp - timestamp));
        }

        if (lastTimestamp == timestamp) {
            // 当前毫秒内，则+1
            sequence = (sequence + 1) & sequenceMask;
            if (sequence == 0) {
                // 当前毫秒内计数满了，则等待下一秒
                timestamp = tilNextMillis(lastTimestamp);
            }
        } else {
            sequence = 0L;
        }
        lastTimestamp = timestamp;
        // ID偏移组合生成最终的ID，并返回ID
        long nextId = ((timestamp - twepoch) << timestampLeftShift)
                | (datacenterId << datacenterIdShift)
                | (workerId << workerIdShift) | sequence;

        return nextId;
    }

    private long tilNextMillis(final long lastTimestamp) {
        long timestamp = this.timeGen();
        while (timestamp <= lastTimestamp) {
            timestamp = this.timeGen();
        }
        return timestamp;
    }

    private long timeGen() {
        return System.currentTimeMillis();
    }

    /**
     * <p>
     * 获取 maxWorkerId
     * </p>
     */
    protected static long getMaxWorkerId(long datacenterId, long maxWorkerId) {
        StringBuffer mpid = new StringBuffer();
        mpid.append(datacenterId);
        String name = ManagementFactory.getRuntimeMXBean().getName();
        if (!name.isEmpty()) {
            /*
             * GET jvmPid
             */
            mpid.append(name.split("@")[0]);
        }
        /*
         * MAC + PID 的 hashcode 获取16个低位
         */
        return (mpid.toString().hashCode() & 0xffff) % (maxWorkerId + 1);
    }

    /**
     * <p>
     * 数据标识id部分
     * </p>
     */
    protected static long getDatacenterId(long maxDatacenterId) {
        long id = 0L;
        try {
            InetAddress ip = InetAddress.getLocalHost();
            NetworkInterface network = NetworkInterface.getByInetAddress(ip);
            if (network == null) {
                id = 1L;
            } else {
                byte[] mac = network.getHardwareAddress();
                id = ((0x000000FF & (long) mac[mac.length - 1])
                        | (0x0000FF00 & (((long) mac[mac.length - 2]) << 8))) >> 6;
                id = id % (maxDatacenterId + 1);
            }
        } catch (Exception e) {
            System.out.println(" getDatacenterId: " + e.getMessage());
        }
        return id;
    }

    /**  雪花算法生成ID,自带时间排序,一秒可以生成25万个ID左右 */

}



```
3. config
```
package com.hbq.teacher_plus.config;
/**
 * @author hbq
 * @createTime 2020/3/19 23:29
 */
public class AlipayConfig {
    // 商户appid
    public static String APPID = "";
    public static String RSA_PRIVATE_KEY = " ";
    // 服务器异步通知页面路径 需http://或者https://格式的完整路径，不能加?id=123这类自定义参数，必须外网可以正常访问
    public static String notify_url = "";
    // 页面跳转同步通知页面路径 需http://或者https://格式的完整路径，不能加?id=123这类自定义参数，必须外网可以正常访问 商户可以自定义同步跳转地址
    public static String return_url = "";
    // 请求网关地址,沙箱是:https://openapi.alipaydev.com/gateway.do
    public static String URL = "https://openapi.alipaydev.com/gateway.do";
    // 编码
    public static String CHARSET = "UTF-8";
    // 返回格式
    public static String FORMAT = "json";
    // 支付宝公钥(在应用中可以获取)
    public static String ALIPAY_PUBLIC_KEY = "";
    // RSA2
    public static String SIGNTYPE = "RSA2";

}
```
## 二、支付宝沙箱环境配置
### 1. 因为上面config中我们的参数都还没进行配置，所以现在来配置参数。
![image-20220720153541257](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720153541257.png)
### 2. 打开支付宝官网的沙箱位置：https://openhome.alipay.com/platform/appDaily.htm?tab=info
### 3. 首先3和4的位置需要填写一个外网可以访问的网址如：`http://www.baidu.com`
### 4. APPID，如图复制到“1”位置
 ![image-20220720153633436](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720153633436.png)
 ### 5. RSA_PRIVATE_KEY，应用私钥
 + 下载[公钥私钥生成工具](https://docs.open.alipay.com/291/105971)
 + 直接点击生成秘钥，复制下方的应用公钥回到沙箱配置，保存，复制私钥到项目中配置到“2”位置
![image-20220720153643519](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720153643519.png)
 ![image-20220720153657035](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720153657035.png)

###  6. ALIPAY_PUBLIC_KEY，支付宝公钥
 + 经过第5步保存公钥后可以看到支付宝公钥：
![image-20220720153709137](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720153709137.png)

### 7. 五项配置完成，启动项目，访问`http://localhost:8080/pay/web`。
![image-20220720153721309](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720153721309.png)

### 8. 下载沙箱支付宝，并通过沙箱账号登录，支付完成。
![image-20220720153730304](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720153730304.png)
