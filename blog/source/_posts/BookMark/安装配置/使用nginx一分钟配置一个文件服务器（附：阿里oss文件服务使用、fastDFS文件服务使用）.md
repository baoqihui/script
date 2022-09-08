---
title: 使用nginx一分钟配置一个文件服务器（附：阿里oss文件服务使用、fastDFS文件服务使用）.md
date:  2022/9/7 10:42
category_bar: true
categories: 安装配置
tags:
- nginx
- 文件服务
---
# 使用nginx一分钟配置一个文件服务器（附：阿里oss文件服务使用、fastDFS文件服务使用）

---

[toc]

---
+ 前言：作为一名Java工程师，文件服务用的也不少。从最早的fastDFS轻量级图片服务器到第三方如阿里OSS；七牛云存储都用过。 新公司里一方面没有linux服务器，无法搭建fastDFS文件服务器。当然也没有打算买第三方存储。所以，之前使用过的文件服务器都无效。
+ 新的考虑：在windows上搭建文件服务器
+ 解决：nginx作为文件服务器，指定目录存放文件。利用java文件流写入指定文件并返回文件路径。
---
## 一、配置nginx
1. 打开nginx配置目录，找到nginx.config文件编辑
```
location /file {
	alias Z:\file/; 
	#如果目录在download下则强制浏览器下载
	if ($request_filename ~* ^.*?\/download\/.*$){
		add_header Content-Disposition: 'attachment;';
	}
	autoindex on;
}
```

![image-20220430160035229](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430160035229.png)

 ## 二、在所配置路径上放入一个文件。重启nginx尝试访问文件服务器
 +  重启nginx
 +  浏览器访问`http://localhost:80/file/`，实际访问地址按照自己配置路径访问
 +  ![image-20220430160102331](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430160102331.png)
+  看到如下目录，文件服务器配置完成
  ![image-20220430160237103](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430160237103.png)

---

 ## 三、附加Java上传文件并返回文件访问路径（Spring Boot）
 1. yml配置`nginxFilePath: Z:\file/`
![image-20220430160252681](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430160252681.png)
```
//Controller 其中modelName是想将文件放入的文件夹（不存在时自动生成）
@PostMapping("/uploadToNginx")
public String uploadToNginx(@RequestParam("file") MultipartFile file,String modelName) {
	if (file==null){
		return "文件上传失败，请重新选择文件";
	}
	return fileManageService.uploadToNginx(file,modelName);
}
//Service
String uploadToNginx(MultipartFile file, String modelName);
//ServiceImpl
@Override
    public String uploadToNginx(MultipartFile file, String modelName)  {
        try {
            String path=modelName+ "/"+ IdUtil.simpleUUID() +"-"+file.getOriginalFilename();
            File test = new File(nginxFilePath+path);
            if (!test.exists()){
                test.mkdirs();
            }
            file.transferTo(test);
            InetAddress address = InetAddress.getLocalHost();
            String ip=address.getHostAddress();
            String finalPath="http://"+ip+"/file/"+path;
            return finalPath;
        }catch (Exception e){
            log.error(file.getOriginalFilename()+"文件上传失败", e);
            return file.getOriginalFilename()+"文件上传失败";
        }
    }
```
---
<font color=red size=5> 附加文章参考：</font> 

[服务器部署—《fastDFS篇》](https://blog.csdn.net/qq_39231769/article/details/102650042)

[java中使用fastDFS上传图片(前端ajax+后端ssm) ](https://blog.huijia.cf/2022/09/05/BookMark/%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0/java%E4%B8%AD%E4%BD%BF%E7%94%A8fastDFS%E4%B8%8A%E4%BC%A0%E5%9B%BE%E7%89%87(%E5%89%8D%E7%AB%AFajax+%E5%90%8E%E7%AB%AFssm)%20--%E8%8F%9C%E9%B8%9F%E5%B0%8F%E5%9B%9E/)

[阿里云OSS使用——java中图片上传返回url（Spring Boot项目中详细使用）](https://blog.csdn.net/qq_39231769/article/details/105031064)