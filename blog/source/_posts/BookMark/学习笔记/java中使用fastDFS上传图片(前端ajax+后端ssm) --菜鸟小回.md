---
title: java中使用fastDFS上传图片(前端ajax+后端ssm)
date: 2022-09-05 17:09:05
category_bar: true
categories: 学习笔记
tags:
- Java
- fastDFS文件上传
---
# java中使用fastDFS上传图片(前端ajax+后端ssm)
---
+ 准备：下载jar包
链接: [fastDFS_client](https://pan.baidu.com/s/1-GGIE1lTqO5L1J4xfnwhIA&shfl=shareset) 
提取码: 63m7 

---
1. 配置maven环境变量，与jdk配置方法相同。不再赘述：[参考Windows中maven配置](https://jingyan.baidu.com/article/ce09321ba734f02bff858fcf.html)
2. 找到你下载的jar包，直接在该路径下输入cmd回车
![image-20220721145019137](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721145019137.png)
3. 打包
```
//打包命令
mvn install:install-file -DgroupId=org.csource.fastdfs -DartifactId=fastdfs  -Dversion=1.2 -Dpackaging=jar -Dfile=fastdfs_client_v1.20.jar
```
![image-20220721145026074](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721145026074.png)

4. 引入jar包
```
//maven项目jar包依赖
<!-- 文件服务器 -->
<dependency>
	<groupId>org.csource.fastdfs</groupId>
	<artifactId>fastdfs</artifactId>
	<version>1.2</version>
</dependency>
```
5. 加入配置文件，命名：“fastdfs.properties”，注意你的ip和端口
```
charset=UTF-8
tracker_server=120.27.244.176:22122
http.tracker_http_port=80
```
![image-20220721145036597](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220721145036597.png)

6. 项目加入上传图片工具类
```
public class UploadImg {
	public static String imgUpload(MultipartFile imgFile) throws FileNotFoundException, IOException, Exception{
		//1.加载配置文件ip端口
		String properties_path = Thread.currentThread().getContextClassLoader().getResource("fastdfs.properties").getPath();
		System.out.println(properties_path);
		ClientGlobal.init(properties_path);
		//2.创建管理端对象
		TrackerClient trackerClient=new TrackerClient();
		//3.获取连接
		TrackerServer trackerServer=trackerClient.getConnection();
		//4.创建储存端对象
		StorageClient1 storageClient1=new StorageClient1(trackerServer, null);
		//5.创建文件属性-对象数组
		NameValuePair[] meta_list=new NameValuePair[1];
		meta_list[0]=new NameValuePair("filename",imgFile.getOriginalFilename());
		//6.上传文件
		String path=storageClient1.upload_file1(imgFile.getBytes(), "jpg", meta_list);
		//拼接fastdfs的IP前缀得到图片真实地址，注意修改你的ip
		path="http://120.27.244.176/"+path;
		
		System.out.println(path);
		//返回一个真实地址			
		return path;
	}
}

```
7. 前端html
```
//ajax
//上传图片
 $("#m_image_addr").live("change",function(){
	    //注意这里不能写错。。。
	    var file=$("#m_image_addr")[0].files[0];
	    var formData = new FormData();
	    formData.append("m_image_addr",file);
	    //对文件类型进行判断
	    var index=file.name.lastIndexOf(".");
	    var type=file.name.substring(index);
	    if(type!=".jpg"&&type!=".png"){
	        alert("只能上传jpg和png格式的图片！！");
	        return;
	    }
	    $.ajax({
	        url:"../upload.do",
	        data:formData,
	        dataType:"text",
	        type:"post",
	        //这两个属性必须设置！！！！
	        contentType: false,
	        processData: false, //设置为true时，ajax提交的时候不会序列化data，而是直接使用data
	        success:function (path) {
	   			$("#yulan").attr("src",path);
	        }
	    })	
})
//form
<!--enctype="multipart/form-data"不可省略-->
<form id="fm1" class="definewidth m20" enctype="multipart/form-data">
    <table class="table table-bordered table-hover definewidth m10">
        <tr>
            <td width="10%" class="tableleft">图片</td>
            <td>
                <input type="file" id="m_image_addr"  name="file" />
                <image id="yulan" width="100px" height="80px" src=""></image>
            </td>
        </tr>
    </table>
</form>
    
```
8. 后端controller
```
@RequestMapping(value="/upload.do",method={RequestMethod.POST,RequestMethod.GET})
@ResponseBody
public String upload(MultipartFile m_image_addr) throws Exception{
	return UploadImg.imgUpload(m_image_addr);
}
```

9. 启动项目测试上传，图片自动显示到预览框
