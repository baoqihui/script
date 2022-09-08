# Gradle

## build.gradle

```text
// 配置运行构建脚本的要求
buildscript { 
    // 设置自定义属性
    ext {  
       springBootVersion = '2.1.6.RELEASE' 
    }  
    // 解决buildscript块中的依赖项时，检查Maven Central中的依赖项
    repositories {  
       mavenCentral()  
    }  
    // 我们需要spring boot插件来运行构建脚本
    dependencies {  
       classpath("org.springframework.boot:spring-boot-gradle-plugin:${springBootVersion}")  
    }  
}  
   
// 添加构建插件
apply plugin: 'java' 
apply plugin: 'org.springframework.boot' 
apply plugin: 'io.spring.dependency-management' 
   
// 设置全局变量
group = 'com.okta.springboottokenauth' 
version = '0.0.1-SNAPSHOT' 
sourceCompatibility = 1.8 
   
// 用于搜索以解决项目依赖关系的仓库地址
repositories {  
    mavenCentral()  
}  
 
// 项目依赖
dependencies {  
    implementation( 'com.okta.spring:okta-spring-boot-starter:1.2.1' )  
    implementation('org.springframework.boot:spring-boot-starter-security')  
    implementation('org.springframework.boot:spring-boot-starter-web')  
    testImplementation('org.springframework.boot:spring-boot-starter-test')  
    testImplementation('org.springframework.security:spring-security-test')  
}
```