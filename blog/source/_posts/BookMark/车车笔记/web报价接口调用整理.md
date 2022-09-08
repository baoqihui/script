
​	

|               操作               |                             接口                             |                   接口位置                    |
| :------------------------------: | :----------------------------------------------------------: | :-------------------------------------------: |
|             是否登录             |         https://cc.chetimes.com/v2.2/users/hasLogin          |            UsersResource#hasLogin             |
|         获取地区下拉列表         |           https://cc.chetimes.com/v2.2/areas/group           |          AreasResource#getGroupAreas          |
|           获取短信验证           | https://cc.chetimes.com/v2.2/sms/validation?mobile=15516045023&action=login |          SmsResource#sendValidation           |
|               登录               | https://cc.chetimes.com/v2.2/users/login?mobile=15516045023&validationCode=825234 |              UsersResource#login              |
|         按天买险订单详情         |     https://cc.chetimes.com/v2.2/dailyInsurances/detail      | DailyInsuranceResource#getDetailInfoByOrderNo |
| 查询当前用户是否有一键续保的订单 |         https://cc.chetimes.com/v2.2/module/renewal          |         ModuleResource#oneKeyRenewal          |
|          测试数据？？？          |   https://cc.chetimes.com/v2.2/dailyInsurances/trial/data    |       DailyInsuranceResource#trialData        |
|        根据地区获取banner        |        https://cc.chetimes.com/v2.2/module/basebanner        |           ModuleResource#baseBanner           |
|           自动获取执照           |          https://cc.chetimes.com/v2.2/autos/license          |        AutoResource#getVehicleLicense         |
|           自动获取车型           |        https://cc.chetimes.com/v2.2//autos/autoTypes         |           AutoResource#getAutoTypes           |
|          某地区保司资源          |     https://cc.chetimes.com/v2.2/packages/?areaId=110000     | InsurancePackageResource#getInsurancePackage  |
|             默认报价             |         https://cc.chetimes.com/v2.2/quotes/default          |          QuotesResource#defaultQuote          |
|          Websocket相关           |             https://cc.chetimes.com/sp/subscribe             | cheche.rest.serverpush.quote.SPQuotesService  |
|         获取允许协议资源         | https://cc.chetimes.com/v2.2/module/resource?keys=GRANT_INSURANCE |            ModuleResource#resource            |
|            授权？？？            |              https://cc.chetimes.com/v2.2/grant              |              GrantResource#grant              |
|     通过记录key保存报价信息      | https://cc.chetimes.com/v2.2/quotes/c68cc3d6646ab3244a4a8c4ec40d390e |          QuotesResource#saveQuote1_6          |
|         获取用户地址列表         |  https://cc.chetimes.com/v1.9/users/address?size=10&page=0   |      UsersAutoResource#addressListFor12       |
|             创建订单             |      https://cc.chetimes.com/v2.2/quotes/2688344/order       |           QuotesResource#placeOrder           |
|             查询订单             |             https://cc.chetimes.com/v2.2/orders              |         OrdersResource#getOrderList11         |

