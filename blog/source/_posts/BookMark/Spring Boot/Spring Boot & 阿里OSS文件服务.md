---
title: Spring Boot & 阿里OSS文件服务
date: 2022-09-05 17:09:05
category_bar: true
categories: Spring Boot
tags:
- Spring Boot
- 文件服务
---
# Spring Boot & 阿里OSS文件服务

---

[toc]

---

首先去阿里云官网获取`accessKeyId` ,`accessKeySecret`

![image-20220721135147850](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721135147850.png)

然后新建oss仓库，获取`bucketName` `endpoint`

![image-20220721135321071](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721135321071.png)

---

## 一、application.yml

```
OSS:
  accessKeyId: LTAI5tRbCbT6gBMVburLDkC4
  accessKeySecret: BQsHbBTpPkjSFQdCg1N3h9Q2cbTl1M
  bucketName: idse
  endpoint: oss-cn-hangzhou.aliyuncs.com
```

## 二、pom.xml

```
<dependency>
    <groupId>com.aliyun.oss</groupId>
    <artifactId>aliyun-sdk-oss</artifactId>
    <version>3.14.0</version>
</dependency>
```

## 三、controller
```
@PostMapping(value = "/uploadToOSS")
public String uploadToOSS(String bucketName, MultipartFile imgFile) {
    return ossUtil1.uploadPreview(bucketName,imgFile);
}
```
## 二、工具类
```
@Component
@Slf4j
public class OssUtil {
    private static OSS ossClient;
    @Value("${OSS.endpoint}")
    private String endpoint;
    @Value("${OSS.accessKeyId}")
    private String accessKeyId;
    @Value("${OSS.accessKeySecret}")
    private String accessKeySecret;
    @Value("${OSS.bucketName}")
    private String bucketName;

    @PostConstruct
    public void init() {
        try {
            ossClient = new OSSClientBuilder().build(endpoint, accessKeyId, accessKeySecret);
            ossClient.createBucket(bucketName);
        } catch (Exception e) {
            log.error("初始化oss配置异常: 【{}】", e.getMessage());
        }
    }

    /**
     * 上传图片
     *
     * @param file
     * @return
     */
    public String uploadPreview(String bucketName, MultipartFile file) {
        String originalFilename = file.getOriginalFilename();
        String newFileName = String.format("%s-%s.%s", FileUtil.mainName(originalFilename), IdUtil.simpleUUID(), FileUtil.extName(originalFilename));
        try {
            upload(bucketName, file, newFileName);
            return preview(newFileName);
        } catch (Exception e) {
            return "上传失败";
        }
    }

    public static String getContentType(String FilenameExtension) {
        if (FilenameExtension.equalsIgnoreCase(".bmp")) {
            return "image/bmp";
        }
        if (FilenameExtension.equalsIgnoreCase(".gif")) {
            return "image/gif";
        }
        if (FilenameExtension.equalsIgnoreCase(".jpeg") ||
                FilenameExtension.equalsIgnoreCase(".jpg") ||
                FilenameExtension.equalsIgnoreCase(".png")) {
            return "image/jpg";
        }
        if (FilenameExtension.equalsIgnoreCase(".html")) {
            return "text/html";
        }
        if (FilenameExtension.equalsIgnoreCase(".txt")) {
            return "text/plain";
        }
        if (FilenameExtension.equalsIgnoreCase(".vsd")) {
            return "application/vnd.visio";
        }
        if (FilenameExtension.equalsIgnoreCase(".pptx") ||
                FilenameExtension.equalsIgnoreCase(".ppt")) {
            return "application/vnd.ms-powerpoint";
        }
        if (FilenameExtension.equalsIgnoreCase(".xls") ||
                FilenameExtension.equalsIgnoreCase(".xlsx")) {
            return "application/vnd.ms-excel";
        }
        if (FilenameExtension.equalsIgnoreCase(".docx") ||
                FilenameExtension.equalsIgnoreCase(".doc")) {
            return "application/msword";
        }
        if (FilenameExtension.equalsIgnoreCase(".xml")) {
            return "text/xml";
        }
        return "image/jpg";
    }
    /**
     * 上传图片获取fileUrl
     *
     * @param file
     * @param fileName
     * @return
     */
    private Boolean upload(String bucketName, MultipartFile file, String fileName) throws IOException {
        try {
            //创建上传Object的Metadata
            ObjectMetadata objectMetadata = new ObjectMetadata();
            objectMetadata.setContentLength(file.getSize());
            objectMetadata.setCacheControl("no-cache");
            objectMetadata.setHeader("Pragma", "no-cache");
            objectMetadata.setContentType(getContentType(fileName.substring(fileName.lastIndexOf("."))));
            objectMetadata.setContentDisposition("inline;filename=" + fileName);
            //上传文件
            ossClient.putObject(bucketName, fileName, file.getInputStream(), objectMetadata);
        } catch (Exception e) {
            log.error("上传文件异常: 【{}】", e.getMessage());
            return false;
        }
        return true;
    }

    /**
     * 获得url链接
     *
     * @return
     */
    public String preview(String fileName) {
        // 生成URL
        URL url = ossClient.generatePresignedUrl(bucketName, fileName, DateUtil.parse("2099-01-01", "yyyy-MM-dd"));
        String finalUrl = StrUtil.subBefore(url.toString(), "?", false);
        log.info("文件路径预览：{}", finalUrl);
        return finalUrl;
    }
}
```
