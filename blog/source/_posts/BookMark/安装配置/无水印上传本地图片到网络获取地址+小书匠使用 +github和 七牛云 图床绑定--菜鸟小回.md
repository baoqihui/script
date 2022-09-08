---
title: 无水印上传本地图片到网络获取地址+小书匠使用 +github和 七牛云 图床绑定--菜鸟小回.md
date:  2022/9/7 10:43
category_bar: true
categories: 安装配置
tags:
- 编译器
- 文件服务
---
# 无水印上传本地图片到网络获取地址+小书匠使用 +github和 七牛云 图床绑定 

---

[toc]

---
前言：
最近开始写博客，缺少一个Markdown编辑器。寻找了两三天终于找到了这款《小书匠》，可复制粘图，可导出多种格式，导出.md文档可以直接导入博客，十分方便快捷。但是存在问题时图片转存的问题。本地图片在小书匠里可以使用，但导出好的小书匠.md文件想上传到csdn，是必须需要将图片上传到网络图床的。此处选择github图床储存仓库，当然此处也算是无水印将图片从本地上传到网络获取地址的一种方法了。


---
## 一、github图床绑定

1. 左侧菜单栏->"**绑定**"
     ![image-20220430161107724](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430161107724.png)

2. 选择github
     ![image-20220430161131277](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430161131277.png)

3. 选择下方申请“**token**"
     ![image-20220430161144278](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430161144278.png)

4. 进入github 登陆后 自己设置一个名字，选项勾选如下图，点击Generate
     ![image-20220430161204257](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430161204257.png)
     ![image-20220430161218609](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430161218609.png)

5. 得到“**token**”值填入小书匠下图位置：
     ![image-20220430161234225](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430161234225.png)
     ![image-20220430161244913](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430161244913.png)

6. github右上角点击**New repository**：
     ![image-20220430161309167](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430161309167.png)

7. 填写**name**，此处**仓库名**填到小书匠下图位置，**ur前缀**自动生成，确定：
     ![image-20220430161335578](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430161335578.png)
     ![image-20220430161404016](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430161404016.png)

8. 最后选择刚刚建好的图床即可：
     ![enter description here](https://img-1256282866.cos.ap-beijing.myqcloud.com/aHR0cHM6Ly9naXRodWIuY29tL215aHVpYmJhb3FpL2NjYy9yYXcvbWFzdGVyLyVFNSVCMCU4RiVFNCVCOSVBNiVFNSU4QyVBMC8xNTYzNjgzMjc3NjgzLnBuZw.png)

9. 完成图床绑定，截个图放入小书匠编辑框就可以发现github仓库中自动生成文件夹
   ![image-20220430161429950](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430161429950.png)
   ![image-20220430161441268](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430161441268.png)

10. 上传的图片都保存在这里：
    ![image-20220430161452488](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430161452488.png)

---

  <center><font color=red size=5>github图床绑定已经完成了</font>

  - 注意：但是我这边可能网络有问题，每次上传图片速度不是很好，同样感觉图片上传速度欠佳的小伙伴们可以尝试下方七牛云图床。

---

  ##  二、七牛云图床绑定（建议使用）
  - 小书匠中绑定位置与github绑定位置相同，此处不做介绍：

1. 先去申请并实名认证一个七牛云账户（需要身份证照片）；
2. 看到我们所需要填写的内容：共6个位置

![image-20220430161512113](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430161512113.png)

3. 左侧菜单栏选择对象存储-->**新建存储** -->填写下面内容；此处可以得到需填图的<font color=red>  4、1</font>
   ![image-20220430161521567](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430161521567.png)
4.  创建完成点击右上角 **个人中心**--> **秘钥管理**得到 <font color=red>  2、3</font>
   ![image-20220430161528002](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430161528002.png)![image-20220430161541983](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430161541983.png)
   5. 不要用汉字作为图片后缀，容易乱码，文件名生成规则-->“**小书匠**”三个字改为“**blog**” 得到 <font color=red>  5</font>
   6. 回到刚刚建好的储存空间中-->**内容管理**外联默认域名就是<font color=red>  6</font>
      ![image-20220430161556743](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430161556743.png)<center><font color=red size=5>七牛云图床绑定已经完成了</font>

  ## 三、无水印本地图片上传得到图片外联地址
1. 截图、复制、导入图片到小书匠编辑框自动生成图片外联，复制即可；

2. 也可去七牛云的存储空间找上传的图片：
   ![image-20220430161611268](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430161611268.png)
   ![image-20220430161624986](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220430161624986.png)
