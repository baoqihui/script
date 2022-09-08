---
title: Spring Boot & RabbitMq 延迟消息队列死信队列实现定时任务
date: 2022-09-05 17:09:05
category_bar: true
categories: Spring Boot
tags:
- Spring Boot
- RabbitMq
---
# Spring Boot & RabbitMq 延迟消息队列死信队列实现定时任务
1. TradeProcess
```
@Service
public class TradeProcess {

    @Autowired
    private AmqpTemplate amqpTemplate;

    @RabbitListener(queues= MqConstant.MY_TRANS_QUEUE)
    @RabbitHandler
    public void process(String content) {
        String msg = content.split(":")[0];
        String delayQueueName = content.split(":")[1];
        amqpTemplate.convertAndSend(MqConstant.MY_EXCHANGE, delayQueueName, msg);
//        System.out.println("进行转发 {}"+ new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
    }
}
```
2. MqConstant
```
public class MqConstant {

    public static final String MY_EXCHANGE = "dy_order_delay_exchange";

    public static final String MY_QUEUE_ONE = "my_queue_one";

    public static final String Order_DENLY_QUEQE = "my_queue_two";

    public static final String DEAD_LETTER_QUEUE = "dead_letter_queue";

    public static final String MY_TRANS_QUEUE = "my_trans_queue";

}
```
3. RabbitMqConfig
```

@Configuration
public class RabbitMqConfig {



    @Bean
    public DirectExchange myExchange() {
        return new DirectExchange(MqConstant.MY_EXCHANGE, true, false);
    }

    @Bean
    public Queue myQueueOne() {
        return new Queue(MqConstant.MY_QUEUE_ONE, true, false, false);
    }

    @Bean
    public Queue myQueueTwo() {
        return new Queue(MqConstant.Order_DENLY_QUEQE, true, false, false);
    }
    @Bean
    public Queue myTransQueue() {
        return new Queue(MqConstant.MY_TRANS_QUEUE, true, false, false);
    }

    @Bean
    public Queue deadLetterQueue() {
        Map<String, Object> map = new HashMap<>();
        map.put("x-dead-letter-exchange", MqConstant.MY_EXCHANGE);
        map.put("x-dead-letter-routing-key", MqConstant.MY_TRANS_QUEUE);
        Queue queue = new Queue(MqConstant.DEAD_LETTER_QUEUE, true, false, false, map);
        System.out.println("arguments :" + queue.getArguments());
        return queue;
    }

    @Bean
    public Binding queueOneBinding() {
        return BindingBuilder.bind(myQueueOne()).to(myExchange()).with(MqConstant.MY_QUEUE_ONE);
    }

    @Bean
    public Binding queueTwoBinding() {
        return BindingBuilder.bind(myQueueTwo()).to(myExchange()).with(MqConstant.Order_DENLY_QUEQE);
    }

    @Bean
    public Binding queueDeadBinding() {
        return BindingBuilder.bind(deadLetterQueue()).to(myExchange()).with(MqConstant.DEAD_LETTER_QUEUE);
    }

    @Bean
    public Binding queueTransBinding() {
        return BindingBuilder.bind(myTransQueue()).to(myExchange()).with(MqConstant.MY_TRANS_QUEUE);
    }

```
4.RabbitQueueService
```
public interface RabbitQueueService {

    /**
     * 发布到延时队列
     * @param msg 消息内容
     * @param time 时间/秒
     * @param delayQueueName 延时队列名称
     */
    void send(String msg,long time,String delayQueueName);


}
```
5. RabbitQueueServiceImpl
```
@Service
public class RabbitQueueServiceImpl implements RabbitQueueService {

    //@Resource
    //DyOrderService dyOrderService;

    @Resource
    AmqpTemplate amqpTemplate;

    @Autowired
    ApplicationContext context;


    class SendEvent{
        String msg ;
        long time;
        String delayQueueName;
    }


    @Override
    public void send(String msg, long time, String delayQueueName) {
        //rabbit默认为毫秒级

        SendEvent event = new SendEvent();
        event.delayQueueName = delayQueueName;
        event.msg = msg;
        event.time = time;
        context.publishEvent(event);

    }


    @EventListener
    public void publish(SendEvent event){
        long times = event.time*1000;
        MessagePostProcessor processor = new MessagePostProcessor() {
            @Override
            public Message postProcessMessage(Message message) throws AmqpException {
                message.getMessageProperties().setExpiration(String.valueOf(times));
                return message;
            }
        };
        // 拼装msg
        String msg = StringUtils.join(event.msg, ":", event.delayQueueName);
        amqpTemplate.convertAndSend(MqConstant.MY_EXCHANGE, MqConstant.DEAD_LETTER_QUEUE, msg, processor);
    }

    @RabbitListener(queues = MqConstant.MY_QUEUE_ONE)
    public void receiveA(Message message, Channel channel) throws IOException {
        String msg = new String(message.getBody());
        System.out.println("当前时间：{},死信队列A收到消息：{}"+new Date().toString()+ msg);
        /*channel.basicAck(message.getMessageProperties().getDeliveryTag(), false);
        Map<String,Long> map = new HashedMap();
        map.put("id",Long.valueOf(msg));
        dyOrderService.cancleOrder(map);*/
    }

}
```
6. 测试
```
@RestController
@RequestMapping("/delayQueue")
public class TestController {

    @Resource
    RabbitQueueService rabbitQueueService;

    @GetMapping("/send/{time}")
    public String send(@PathVariable("time") int time){
        System.out.println("{}秒后, 发送延迟消息，当前时间{}"+time+":"+ new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        rabbitQueueService.send("我是延时消息...", time, MqConstant.MY_QUEUE_ONE);
        return "ok";

    }

}
```

<font color=red size=5> 最后：如果你需要实现定时在xxxx-xx-xx时间点，只需要拿该时间计算出与当前时间的时间差，设为定时的time即可</font>
```
        Date timingOnTime = DateUtil.parse(MapUtil.getStr(map, "timingOnTime"));

        Date nowTime= DateUtil.date();
        DySku dySku = iDySkuService.selectById(id);
		
        //使用hutool计算时间差，非绝对值
        long betweenSecond = DateUtil.between(nowTime,timingOnTime, DateUnit.SECOND,false);
        logger.info("商品 {} 在 {} 定时上架消息发出,将在 {} 定时上架；距离当前时间{}s",dySku.getName(),DateUtil.now(),timingOnTime,betweenSecond+1);
        rabbitQueueService.sendSkuMakeTable(String.valueOf(dySku.getId()), betweenSecond+1, MqConstant.SKU_MAKETABLE_QUEUE);

```