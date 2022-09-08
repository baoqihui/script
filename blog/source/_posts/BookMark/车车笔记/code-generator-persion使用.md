# code-generator-persion使用

#### 介绍
Mybatis plus的code-generator-persion代码生成器，自动生成车车项目基础代码

#### 软件架构
spring boot，mybatis plus，swagger2


#### 安装教程

1. 导入项目至idea

2. `application.yml`修改数据库信息

   ![image-20210930160141089](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20210930160141089.png)

3. `generator.properties`修改模块名，作者名

   ![image-20210930160345993](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20210930160345993.png)

#### 使用说明

1. 启动CodeGeneratorPeserionApp

2. postman中：保存`localhost:8081/generator/code?tables=auto`响应文件（压缩包）

   ![image-20210930160537298](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20210930160537298.png)

3.  将压缩包内文件依次移入到项目中使用：

    ![image-20210930161108467](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20210930161108467.png)

4.  测试生成代码接口

    ![image-20210930161328623](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20210930161328623.png)

#### 附加功能

1.  一次生成多表，表名参数之间使用英文“,”分割
2.  配置模板在resources中的template，可自行定义


#### 参与贡献

1.  huibq
2.  https://mybatis.plus/
