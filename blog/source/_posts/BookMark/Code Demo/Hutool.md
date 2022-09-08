---
title: Hutool工具类
date: 2022-09-05 17:09:05
category_bar: true
categories: Code Demo
tags:
- Hutool
---
# Hutool

整理部分常用Hutool工具类，简化代码同时保持代码风格相似；

官网：https://www.hutool.cn/
官网API：https://apidoc.gitee.com/dromara/hutool/

```
package com.hbq.codedemopersion.common.controller.test;

@Slf4j
public class HutoolTest {
    public static void main(String[] args) {
        log.info("-------------【新建】------------");
        List<Integer> l1 = ListUtil.of(1, 2);
        log.info("新建list并赋值:{}", l1);
        log.info("");

        log.info("-------------【判空】------------");
        String s = null;
        List list = null;
        Map map = null;
        Integer code = null;

        boolean b1 = StrUtil.isEmpty(s);
        log.info("字符串判空:{}", b1);
        boolean b2 = CollectionUtil.isEmpty(list);
        log.info("集合判空:{}", b2);
        boolean b3 = ObjectUtil.isEmpty(map);
        log.info("对象判空:{}", b3);
        Integer i1 = ObjectUtil.defaultIfNull(code, 2);
        log.info("如果为空替换为默认值:{}", i1);
        log.info("");

        log.info("-------------【复制】------------");
        F hui = F.builder().name("HUI").age(24).build();
        F xue = new F();
        BeanUtil.copyProperties(hui, xue);
        log.info("hui->xue:{}", xue);
        //集合中对象复制
        List<F> huis = ListUtil.of(hui);
        List<F> newHuis = BeanUtil.copyToList(huis, F.class);
        log.info("huis->newHuis:{}", newHuis);
        log.info("");

        log.info("-------------【时间】------------");
        DateTime t = DateUtil.date();
        String s1 = DateUtil.format(t, DatePattern.NORM_DATE_PATTERN);
        log.info("DateTime->String:{}", s1);
        DateTime t1 = DateUtil.parse("2021-11-10 12:59:59", DatePattern.NORM_DATE_PATTERN);
        log.info("String->DateTime:{}", t1);
        int c1 = DateUtil.compare(t, t1, DatePattern.NORM_DATE_PATTERN);
        log.info("按照指定格式对比两个时间t-t1：{}", c1);
        DateTime t2 = DateUtil.beginOfDay(t);
        DateTime t3 = DateUtil.endOfDay(t).offset(DateField.MILLISECOND, -999);
        log.info("每天开始时间：{}，每天结束时间（注意存入数据库应左偏以免毫秒大于500进位）：{}", t2, t3);
        boolean b = DateUtil.isSameDay(DateUtil.date(), DateUtil.endOfMonth(DateUtil.date()));
        log.info("今天是否为本月最后一天：{}", b);
        List<String> betweenDates = getBetweenDates(null, DateUtil.parse("2022-04-01 12:59:59", DatePattern.NORM_DATE_PATTERN), new Date(), new ArrayList<>(10));
        log.info("从2022-04-01到当前时间的日期列表：{}", betweenDates);
        log.info("");

        log.info("-------------【转换】------------");
        Long l = Convert.toLong(1);
        log.info("Object->Long：{}", l);
        Map<String, Object> params = new HashMap<>(8) {{
            put("name", "HUI");
            put("plate_type", 1);
        }};
        F mapF = BeanUtil.toBeanIgnoreCase(params, F.class, true);
        log.info("map转实体{}", mapF);
        log.info("实体转路径参数：{}", HttpUtil.toParams(params));
        log.info("实体转map参数：{}", Convert.toMap(String.class, String.class, mapF));
        log.info("");

        log.info("-------------【正则校验】------------");
        boolean m1 = ReUtil.isMatch("^142000.*", "142000123456");
        log.info("正则校验筛142000123456是否是142000开头{}", m1);
        log.info("");

        log.info("-------------【file】------------");
        String context = "132456";
        //保存文件到本地
        String fileName = String.format("%s.json", IdUtil.simpleUUID()
                + "-" + LocalDateTimeUtil.format(LocalDateTime.now(), DatePattern.PURE_DATETIME_PATTERN));
        File file = FileUtil.file("./", fileName);
        FileUtil.writeUtf8String(context, file);
        log.info("写入字符串到{}文件中！文件类型：{}", file.getPath(), FileUtil.getMimeType(file.getName()));
        log.info("");


        log.info("-------------【HTTP】------------");
        String url = "https://common.service.cf/file/random/love";
        String host = UrlBuilder.ofHttp(url).getHost();
        log.info("获取host:{}", host);
        String imgUrl = HttpUtil.get(url);
        log.info("HTTP GET Result:{}", imgUrl);

        //构建请求body
        JSONObject body = new JSONObject();
        body.set("bucketName", "love");
        //构建请求url
        String fileListUrl = UrlBuilder.create()
                .setScheme("https") //设置协议
                .setHost(host)  //设置主机
                .setPath(UrlPath.of("/file/list", StandardCharsets.UTF_8)) //设置路径
                .addQuery("token", "ognFF5W5JQiXx40TVPIKegfy8JLY")  //添加参数
                .build();
        String postResult = HttpUtil.post(fileListUrl, body);
        log.info("HTTP POST URL:{} postResult:{}", fileListUrl, postResult);
        log.info("");

        log.info("-------------【http file】------------");
        String fileUrl1 = "https://alist.huijia.cf/d/hui/config/linux/alist-config.json";
        String fileUrl2 = "https://alist.huijia.cf/d/hui/config/linux/backup-ali.sh";
        File httpFile1 = HttpUtil.downloadFileFromUrl(fileUrl1, FileUtil.mkdir(IdWorker.getId() + File.separator), 10000);
        log.info("从url1下载文件{}", httpFile1.getName());
        File httpFile2 = HttpUtil.downloadFileFromUrl(fileUrl2, FileUtil.file("./"), 10000);
        log.info("从url2下载文件{}", httpFile2.getName());
        File zip = ZipUtil.zip(FileUtil.file("./test.zip"), false, List.of(httpFile1, httpFile2).toArray(File[]::new));
        log.info("压缩文件，file1和file2：{}", zip.getName());
        //FileUtil.del(zip);
    }

    /**
     * 递归获取从开始时间到结束时间的所有日期
     *
     * @param nowDate     当前日期，初始为null
     * @param startDate   开始日期
     * @param endDate     结束日期
     * @param dateStrList 返回的日期列表
     * @return 返回的日期列表
     */
    private static List<String> getBetweenDates(Date nowDate, Date startDate, Date endDate, List<String> dateStrList) {
        nowDate = ObjectUtil.defaultIfNull(nowDate, startDate);
        if (DateUtil.isIn(nowDate, startDate, endDate)) {
            String format = DateUtil.format(nowDate, DatePattern.NORM_DATE_PATTERN);
            dateStrList.add(format);
            return getBetweenDates(DateUtil.offsetDay(nowDate, 1), startDate, endDate, dateStrList);
        } else {
            return dateStrList;
        }
    }
}
```

+ 测试结果

  ![image-20220720181405813](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720181405813.png)

![image-20220720181631750](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720181631750.png)

```
//LocalDate
u.getClaimDate().compareTo(LocalDate.now().minusYears(1)) >= 0
```
