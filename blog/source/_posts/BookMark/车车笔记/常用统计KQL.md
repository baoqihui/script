# 常用统计KQL

时间格式：`2022-03-04 00:00:00.000 - 2022-03-10 23:59:59.999`

## 一、统计消息订阅相关信息

|         模板         | 授权                                                         | 取消                                                         |                             发送                             |
| :------------------: | :----------------------------------------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------: |
|     奖励到账通知     | "WechatServiceFacade.subscribeMessageCallback req" and "SubscribeStatusString=accept, TemplateId=xpNegMVvwaRCSHGFOB7QUv9c1ak_B2NXBGlouOZClo0" | "WechatServiceFacade.subscribeMessageCallback req" and "SubscribeStatusString=reject, TemplateId=xpNegMVvwaRCSHGFOB7QUv9c1ak_B2NXBGlouOZClo0" | "WechatServiceFacade.subscribeMessageCallback req" and "Event=subscribe_msg_sent_event" and "ErrorStatus=success" and "TemplateId=xpNegMVvwaRCSHGFOB7QUv9c1ak_B2NXBGlouOZClo0" |
|     活动进度提醒     | "WechatServiceFacade.subscribeMessageCallback req" and "SubscribeStatusString=accept, TemplateId=sOgInDYlc3aZlOQwLPFeAz0HauCZ1paw02FMvbdXqB8" | "WechatServiceFacade.subscribeMessageCallback req" and "SubscribeStatusString=reject, TemplateId=sOgInDYlc3aZlOQwLPFeAz0HauCZ1paw02FMvbdXqB8" | "WechatServiceFacade.subscribeMessageCallback req" and "Event=subscribe_msg_sent_event" and "ErrorStatus=success" and "TemplateId=sOgInDYlc3aZlOQwLPFeAz0HauCZ1paw02FMvbdXqB8" |
|       活动通知       | "WechatServiceFacade.subscribeMessageCallback req" and "SubscribeStatusString=accept, TemplateId=QEZ8Tj79Jrh9B_LiltMGsr8pDs4mtyM0aUoShefElRQ" | "WechatServiceFacade.subscribeMessageCallback req" and "SubscribeStatusString=reject, TemplateId=QEZ8Tj79Jrh9B_LiltMGsr8pDs4mtyM0aUoShefElRQ" | "WechatServiceFacade.subscribeMessageCallback req" and "Event=subscribe_msg_sent_event" and "ErrorStatus=success" and "TemplateId=QEZ8Tj79Jrh9B_LiltMGsr8pDs4mtyM0aUoShefElRQ" |
| 下月停驶奖励活动提醒 | "WechatServiceFacade.subscribeMessageCallback req" and "SubscribeStatusString=accept, TemplateId=QEZ8Tj79Jrh9B_LiltMGsu_AKJeSWB2XvLLgTXgQOfI" | "WechatServiceFacade.subscribeMessageCallback req" and "SubscribeStatusString=reject, TemplateId=QEZ8Tj79Jrh9B_LiltMGsu_AKJeSWB2XvLLgTXgQOfI" | "WechatServiceFacade.subscribeMessageCallback req" and "Event=subscribe_msg_sent_event" and "ErrorStatus=success" and "TemplateId=QEZ8Tj79Jrh9B_LiltMGsu_AKJeSWB2XvLLgTXgQOfI" |

后续从控制台拿到json数据再通过编译器竖向处理

## 二、调取智车数据统计

### 查询后台信息

http://kibana.tinggeili.checheguanjia.com/ 
 用户名： `tinggeili` 
 密码：  `tinggeili`

### 查询关键字

|    查询次数    | 查询成功次数（付费） |                  校验所有人                  |       所有人+车辆       |
| :------------: | :------------------: | :------------------------------------------: | :---------------------: |
| "获取智车信息" | "获取到智车车辆信息" | "获取到智车车辆信息"  and "useProperty=null" | 付费次数-校验所有人次数 |

### 2022.3.4-2022.3.10汇总数据示例

![image-20220311174334595](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220311174334595.png)

### 渠道对应码

![image-20220311174228864](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220311174228864.png)

### ETC

("channelSourceId:28" or "channelSourceId:29" or "channelSourceId:30" or "channelSourceId:31" or "channelSourceId:32") and "获取智车信息"

("channelSourceId:28" or "channelSourceId:29" or "channelSourceId:30" or "channelSourceId:31" or "channelSourceId:32") and "获取到智车车辆信息"

("channelSourceId:28" or "channelSourceId:29" or "channelSourceId:30" or "channelSourceId:31" or "channelSourceId:32") and "获取到智车车辆信息"  and "useProperty=null"

---

### 速停车（编辑未完成）

("channelSourceId:28" or "channelSourceId:29" or "channelSourceId:30" or "channelSourceId:31" or "channelSourceId:32") and "获取智车信息"

("channelSourceId:28" or "channelSourceId:29" or "channelSourceId:30" or "channelSourceId:31" or "channelSourceId:32") and "获取到智车车辆信息"

("channelSourceId:28" or "channelSourceId:29" or "channelSourceId:30" or "channelSourceId:31" or "channelSourceId:32") and "获取到智车车辆信息"  and "useProperty=null"

## 查询示例

![image-20220311173035302](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220311173035302.png)



![image-20220311173155990](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220311173155990.png)





![image-20220311173421641](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220311173421641.png)

### 选择时间区间

![image-20220311173905471](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220311173905471.png)

## 三、风控相关统计

|  过车风控数量  |       过人风控数量        | 通过数量（留资） | 车属性不符未通过数量 |               人未通过数量                |
| :------------: | :-----------------------: | :--------------: | :------------------: | :---------------------------------------: |
| "调取天域风控" | 过车风控数量-人未通过数量 |    数据库查询    |  "查询车辆信息异常"  | "Risk user save suspend auto, risk level" |
