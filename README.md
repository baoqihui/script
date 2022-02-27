# 此处存放个人编写的常用shell脚本，其中可能使用到其他项目源码，若侵权联系删除
## 一、一键修改Ubuntu系统root密码
目前测试系统：`arm/amd Ubuntu`
### 1.一键脚本
+ ```bash <(curl -Ls https://github.com/baoqihui/script/raw/main/root.sh)```

## 二、acme证书申请一键脚本
目前测试系统：`arm/amd Ubuntu`
### 1.用到的官仓：
+ Acme官方: https://github.com/acmesh-official/acme.sh 

### 2.功能
1. 全自动安装证书到指定文件夹
2. 批量安装
3. 自动续期
4. docker中nginx续费重启
### 3.一键脚本
+ ```bash <(curl -Ls https://github.com/baoqihui/script/raw/main/cert.sh)```
### 4.示例图
1. 信息定制
  + ![image](https://user-images.githubusercontent.com/50536515/154844456-c7b49470-323d-421b-8c8b-73f8ed29b1bb.png)
2. 结果生成
  + ![image](https://user-images.githubusercontent.com/50536515/154844580-602b13c4-255f-4b64-96ad-8f1601fd8fe4.png)

