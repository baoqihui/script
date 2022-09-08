---
title: mac.md
date:  2022/9/7 10:39
category_bar: true
categories: 安装配置
tags:
- mac
---
# typora-picgo-minio

## Brew 安装：

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

+ 使用

```
brew install git
brew install npm
brew install iterm
```

代码高亮提示

```
//提示
brew install zsh-autosuggestions

echo "source /opt/homebrew/Cellar/zsh-autosuggestions/0.7.0/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >>~/.zshrc
//高亮
brew install zsh-syntax-highlighting

echo "source /opt/homebrew/Cellar/zsh-syntax-highlighting/0.7.1/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >>~/.zshrc
```

```
//忽略大小写
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:    ][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
```

## rclone

```
curl https://rclone.org/install.sh | sudo bash
brew install macfuse

mkdir -p .config/rclone&wget -O .config/rclone/rclone.conf https://alist.huijia.cf/d/hui/config/linux/rclone.conf

rclone mount ali: ali &
umount mac-ali
```

## picgo

```
npm install picgo -g
picgo install minio
vim .picgo/config.json
```

+ config.json

```
{
  "picBed": {
    "uploader": "minio",
    "minio": {
      "accessKey": "admin",
      "baseDir": "",
      "bucket": "img",
      "customDomain": "https://minio.service.cf",
      "endPoint": "minio.service.cf",
      "isAutoArchive": false,
      "port": "9000",
      "sameNameFileProcessingMode": "跳过",
      "secretKey": "HBQ521521cf*",
      "useSSL": false
    }
  },
  "picgoPlugins": {
    "picgo-plugin-minio": true,
    "picgo-plugin-gitee-uploader": true
  }
}
```

## JDK

1. 下载并安装安装包: [jdk11](https://alist.huijia.cf/d/hui/%E8%BD%AF%E4%BB%B6/mac/jdk-11.0.16.1_macos-aarch64_bin.dmg) [jdk17](https://alist.huijia.cf/d/hui/%E8%BD%AF%E4%BB%B6/mac/jdk-17_macos-aarch64_bin.dmg)

2. 查看已安装jdk `cd  /Library/Java/JavaVirtualMachines && ls`

   ![image-20220901135943190](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220901135943190.png)

3. 配置环境变量

   ```
   vi .zshrc
   export JAVA_11_HOME="$(/usr/libexec/java_home -v 11)"
   export JAVA_17_HOME="$(/usr/libexec/java_home -v 17)"
   #默认jdk11
   export JAVA_HOME=$JAVA_11_HOME
   source ~/.zshrc
   ```

4. 配置自动切换

   ```
   #alias命令动态切换JDK版本
   alias jdk11="export JAVA_HOME=$JAVA_11_HOME"
   alias jdk17='export JAVA_HOME=$JAVA_17_HOME'
   ```

5. 使用命令切换jdk版本`jdk11`或者`jdk17`

   ![image-20220901140954487](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220901140954487.png)

## 快捷键

c+h 隐藏

c+m 最小化

c+n 新建

c+o+c 复制路径

内置键盘配置：

![image-20220727114814557](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220727114814557.png)

外接键盘设置：

![image-20220727114758227](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220727114758227.png)

 

# 代理

## 代理http

export http_proxy="socks5://127.0.0.1:1080"

## 代理https

export https_proxy="socks5://127.0.0.1:1080"

## 代理所有协议，其中包括ftp等

export ALL_PROXY="socks5://127.0.0.1:7891"

curl -vv https://www.google.com

```shell
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
eval "$(/opt/homebrew/bin/brew shellenv)"
```



