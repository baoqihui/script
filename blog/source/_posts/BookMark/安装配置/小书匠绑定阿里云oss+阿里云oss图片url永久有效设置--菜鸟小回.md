---
title: 小书匠绑定阿里云oss+阿里云oss图片url永久有效设置--菜鸟小回.md
date:  2022/9/7 10:42
category_bar: true
categories: 安装配置
tags:
- 编译器
- 文件服务
---
# 小书匠绑定阿里云oss+阿里云oss图片url永久有效设置

---

[toc]

---

## 一、开通阿里云oss服务[阿里云oss服务](https://www.aliyun.com/minisite/goods?userCode=e3v6m6yo)
![image-20220430162853521](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430162853521.png)
## 二、创建Bucket
![image-20220430162859071](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430162859071.png)
## 三、文件管理创建image/ 目录
![image-20220430162928754](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430162928754.png)
## 四、进入小书匠绑定
![image-20220430162936781](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430162936781.png)
1. 访问入口：如图位置复制并加上前缀`https://`
  ![image-20220430162944011](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430162944011.png)

  3.两个key，点击头像AccessKey，如果没有就新增一个。
  ![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/aHR0cHM6Ly94c2otaW1nLm9zcy1jbi1iZWlqaW5nLmFsaXl1bmNzLmNvbS9pbWFnZS8xNTg0ODY1NjY3MTc1LnBuZw.png)![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/aHR0cHM6Ly94c2otaW1nLm9zcy1jbi1iZWlqaW5nLmFsaXl1bmNzLmNvbS9pbWFnZS8xNTg0ODY1NzQ4OTUyLnBuZw.png)
  4.文件目录：把`小书匠`三字改为`image`
  ![image-20220430163003822](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430163003822.png)
  5.图片前缀：上传一张图片到oss的image目录下在点击图片详情。复制前缀（一般与1相同）。
  ![image-20220430163021588](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430163021588.png)
  ![image-20220430163026296](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430163026296.png)
  6.保存完成。
  ![image-20220430163034046](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430163034046.png)
---

<font color=red size=5> 注：默认的bucket中的图片有url失效时间，建议将其设为永久有效。基础设置中Bucket ACL设为公共读写即可。</font>
![image-20220430163039134](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430163039134.png)
