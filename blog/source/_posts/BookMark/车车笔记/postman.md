# Postman自动获取token并添加到请求头

1. 设置全局环境变量

![image-20220329135612832](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220329135612832.png)

2. 在登录接口Tests添加脚本

```
// 设置环境变量token，获取response中headler的token
pm.environment.set("token", pm.response.headers.get("token"));
```

![image-20220329135431008](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220329135431008.png)

3. 在目录中设置api key认证添加token到头部

![image-20220329135535100](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220329135535100.png)

# 分享文档

![image-20220329160120938](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220329160120938.png)