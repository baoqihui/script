---
title: Spring Boot & 支付宝支付（手机端，web端）
date: 2022-09-05 17:09:05
category_bar: true
categories: Spring Boot
tags:
- Spring Boot
- 自定义注解
- redis
---
# Spring Boot & 自定义注解 实现从配置文件自选择redis db数据源

---

[toc]

---

### 一、 新建注解

```
@Target({ElementType.FIELD,ElementType.CONSTRUCTOR}) //声明应用在属性上
@Retention(RetentionPolicy.RUNTIME) //运行期生效
@Component
public @interface DB {
    String value() default "";
}
```

@Target：

+ 说明了Annotation所修饰的对象范围：Annotation可被用于 packages、types（类、接口、枚举、Annotation类型）、类型成员（方法、构造方法、成员变量、枚举值）、方法参数和本地变量（如循环变量、catch参数）。在Annotation类型的声明中使用了target可更加明晰其修饰的目标。

+ 作用：用于描述注解的使用范围（即：被描述的注解可以用在什么地方）

+ 取值(ElementType)有：
  1. CONSTRUCTOR:用于描述构造器
  2. FIELD:用于描述域
  3. LOCAL_VARIABLE:用于描述局部变量
  4. METHOD:用于描述方法
  5. PACKAGE:用于描述包
  6. PARAMETER:用于描述参数
  7. TYPE:用于描述类、接口(包括注解类型) 或enum声明

@Retention：

+ @Retention定义了该Annotation被保留的时间长短：某些Annotation仅出现在源代码中，而被编译器丢弃；而另一些却被编译在class文件中；编译在class文件中的Annotation可能会被虚拟机忽略，而另一些在class被装载时将被读取（请注意并不影响class的执行，因为Annotation与class在使用上是被分离的）。使用这个meta-Annotation可以对 Annotation的“生命周期”限制。
+ 作用：表示需要在什么级别保存该注释信息，用于描述注解的生命周期（即：被描述的注解在什么范围内有效）
+ 取值（RetentionPoicy）有：
  1. SOURCE:在源文件中有效（即源文件保留）
  2. CLASS:在class文件中有效（即class保留）
  3. RUNTIME:在运行时有效（即运行时保留）

### 二、通过Bean后置处理器自定义注解配置redis

```
@Component
public class RedisBeanPostProcessor implements BeanPostProcessor {
    @Resource
    Environment environment;
    @Value("${spring.redis.host}")
    private String host;
    @Value("${spring.redis.password}")
    private String password;
    @Value("${spring.redis.port}")
    private int port;

    @SneakyThrows
    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        /**
         * 利用Java反射机制注入属性
         */
        Field[] declaredFields = bean.getClass().getDeclaredFields();
        for (Field declaredField : declaredFields) {
            DB annotation = declaredField.getAnnotation(DB.class);
            if (null == annotation) {
                continue;
            }
            //从环境变量中获取值
            String dbKey = ObjectUtil.defaultIfEmpty(annotation.value(), "${spring.redis.database}");
            String dbIndex = environment.resolvePlaceholders(dbKey);
            RedisUtils redisUtils = new RedisUtils(host, password, port, dbIndex);
            try {
                declaredField.setAccessible(true);
                declaredField.set(bean, redisUtils);
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }
        return bean;
    }

    @Override
    public Object postProcessAfterInitialization(Object o, String s) throws BeansException {
        return o;
    }
}
```

![image-20220720104437102](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720104437102.png)

### 三、RedisUtil

```
@Component
@Data
@Slf4j
@NoArgsConstructor
public class RedisUtils {
	@Value("${spring.redis.host}")
	private String host;

	@Value("${spring.redis.password}")
	private String password;

	@Value("${spring.redis.port}")
	private int port;

	@Value("${spring.redis.database}")
	private int database;

	@Resource
	private StringRedisTemplate stringRedisTemplate;

	public RedisUtils(String host, String password, int port, String database) {
		this.host = host;
		this.password = password;
		this.port = port;
		this.database = Convert.toInt(database);
		this.stringRedisTemplate = getTemTemplate();
	}
	/**
	 * 实现命令：TTL key，以秒为单位，返回给定 key的剩余生存时间(TTL, time to live)。
	 *
	 * @param key
	 * @return
	 */
	public long ttl(String key) {
		return stringRedisTemplate.getExpire(key);
	}

	/**
	 * 实现命令：expire 设置过期时间，单位秒
	 *
	 * @param key
	 * @return
	 */
	public void expire(String key, long timeout) {
		stringRedisTemplate.expire(key, timeout, TimeUnit.SECONDS);
	}

	/**
	 * 是否存在key
	 *
	 * @param key
	 */
	public Boolean hasKey(String key) {
		return stringRedisTemplate.hasKey(key);
	}

	/**
	 * 实现命令：INCR key，增加key一次
	 *
	 * @param key
	 * @return
	 */
	public long incr(String key, long delta) {
		return stringRedisTemplate.opsForValue().increment(key, delta);
	}

	/**
	 * 实现命令：KEYS pattern，查找所有符合给定模式 pattern的 key
	 */
	public Set<String> keys(String pattern) {
		return stringRedisTemplate.keys(pattern);
	}

	/**
	 * 实现命令：DEL key，删除一个key
	 *
	 * @param key
	 */
	public void del(String key) {
		stringRedisTemplate.delete(key);
	}

	// String（字符串）

	/**
	 * 实现命令：SET key value，设置一个key-value（将字符串值 value关联到 key）
	 *
	 * @param key
	 * @param value
	 */
	public void set(String key, String value) {
		stringRedisTemplate.opsForValue().set(key, value);
	}

	/**
	 * 实现命令：SET key value EX seconds，设置key-value和超时时间（秒）
	 *
	 * @param key
	 * @param value
	 * @param timeout （以秒为单位）
	 */
	public void set(String key, String value, long timeout) {
		stringRedisTemplate.opsForValue().set(key, value, timeout, TimeUnit.SECONDS);
	}

	/**
	 * 实现命令：GET key，返回 key所关联的字符串值。
	 *
	 * @param key
	 * @return value
	 */
	public String get(String key) {
		return (String) stringRedisTemplate.opsForValue().get(key);
	}

	/**
	 * 批量查询，对应mget
	 *
	 * @param keys
	 * @return
	 */
	public List<String> mget(List<String> keys) {
		return stringRedisTemplate.opsForValue().multiGet(keys);
	}

	/**
	 * 批量查询，管道pipeline
	 *
	 * @param keys
	 * @return
	 */
	public List<Object> batchGet(List<String> keys) {

		List<Object> result = stringRedisTemplate.executePipelined(new RedisCallback<String>() {
			@Override
			public String doInRedis(RedisConnection connection) throws DataAccessException {
				StringRedisConnection src = (StringRedisConnection) connection;

				for (String k : keys) {
					src.get(k);
				}
				return null;
			}
		});

		return result;
	}


	// Hash（哈希表）

	/**
	 * 实现命令：HSET key field value，将哈希表 key中的域 field的值设为 value
	 *
	 * @param key
	 * @param field
	 * @param value
	 */
	public void hset(String key, String field, Object value) {
		stringRedisTemplate.opsForHash().put(key, field, value);
	}

	/**
	 * 实现命令：HGET key field，返回哈希表 key中给定域 field的值
	 *
	 * @param key
	 * @param field
	 * @return
	 */
	public String hget(String key, String field) {
		return (String) stringRedisTemplate.opsForHash().get(key, field);
	}

	/**
	 * 实现命令：HDEL key field [field ...]，删除哈希表 key 中的一个或多个指定域，不存在的域将被忽略。
	 *
	 * @param key
	 * @param fields
	 */
	public void hdel(String key, Object... fields) {
		stringRedisTemplate.opsForHash().delete(key, fields);
	}

	/**
	 * 实现命令：HGETALL key，返回哈希表 key中，所有的域和值。
	 *
	 * @param key
	 * @return
	 */
	public Map<Object, Object> hgetall(String key) {
		return stringRedisTemplate.opsForHash().entries(key);
	}

	// List（列表）

	/**
	 * 实现命令：LPUSH key value，将一个值 value插入到列表 key的表头
	 *
	 * @param key
	 * @param value
	 * @return 执行 LPUSH命令后，列表的长度。
	 */
	public long lpush(String key, String value) {
		return stringRedisTemplate.opsForList().leftPush(key, value);
	}

	/**
	 * 实现命令：LPOP key，移除并返回列表 key的头元素。
	 *
	 * @param key
	 * @return 列表key的头元素。
	 */
	public String lpop(String key) {
		return (String) stringRedisTemplate.opsForList().leftPop(key);
	}

	/**
	 * 实现命令：RPUSH key value，将一个值 value插入到列表 key的表尾(最右边)。
	 *
	 * @param key
	 * @param value
	 * @return 执行 LPUSH命令后，列表的长度。
	 */
	public long rpush(String key, String value) {
		return stringRedisTemplate.opsForList().rightPush(key, value);
	}

	/**
	 * 实现命令：RPOP key，移除并返回列表最右边的元素。
	 *
	 * @param key
	 * @return 列表key的最右边元素。
	 */
	public String rpop(String key) {
		return (String) stringRedisTemplate.opsForList().rightPop(key);
	}

	/**
	 * 实现命令：LINDEX key index
	 *
	 * @return index对应的值
	 */
	public String lindex(String key, Integer index) {
		return stringRedisTemplate.opsForList().index(key, index);
	}

	/**
	 * 实现命令：LTRIM key start end 修剪list
	 * 清空list：ltrim key 1 0（ltrim key start end 中的start要比end大即可，数值且都为正数。）
	 */
	public void ltrim(String key, Long start, Long end) {
		stringRedisTemplate.opsForList().trim(key, start, end);
	}


	/**
	 * 实现命令：LLEN key 获取list长度
	 */
	public Long llen(String key) {
		return stringRedisTemplate.opsForList().size(key);
	}

	/**
	 * 如果key不存在那么放入value
	 *
	 * @param key
	 * @param value
	 * @param timeout
	 * @return boolean
	 * @return void
	 * @author yabin.zhang
	 * @date 2021/11/30 14:04
	 */
	public Boolean setnx(String key, String value, long timeout) {
		return stringRedisTemplate.opsForValue().setIfAbsent(key, value, timeout, TimeUnit.SECONDS);
	}

	/**
	 * 向set中添加元素
	 *
	 * @param key   set的key
	 * @param value set的value
	 */
	public void sAdd(String key, String value) {
		stringRedisTemplate.opsForSet().add(key, value);
	}

	/**
	 * set中所有数据
	 *
	 * @param key set的key
	 * @return set中所有数据
	 */
	public Set<String> sMembers(String key) {
		return stringRedisTemplate.opsForSet().members(key);
	}

	/**
	 * 删除并返回set中的一个元素
	 *
	 * @param key set的key
	 * @return set中的一个元素
	 */
	public String sPop(String key) {
		return stringRedisTemplate.opsForSet().pop(key);
	}

	/**
	 * 获取key的大小
	 *
	 * @param key set的key
	 * @return key的大小
	 */
	public Long sCard(String key) {
		return stringRedisTemplate.opsForSet().size(key);
	}

	public StringRedisTemplate getTemTemplate(){
		// 构建工厂对象
		RedisStandaloneConfiguration config = new RedisStandaloneConfiguration();
		config.setDatabase(this.database);
		config.setHostName(host);
		config.setPort(port);
		config.setPassword(RedisPassword.of(password));
		LettuceConnectionFactory factory = new LettuceConnectionFactory(config,
				LettucePoolingClientConfiguration.builder().build());
		// 重新初始化工厂
		factory.afterPropertiesSet();
		return new StringRedisTemplate(factory);
	}
}
```

![image-20220720104542631](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720104542631.png)

### 四、yml配置

```
spring:
  redis:
    host: localhost # Redis服务器地址
    database: 8 # Redis数据库索引（默认为0）
    database2: 9 # Redis数据库索引2（默认为0）
    port: 6379 # Redis服务器连接端口
    password: root # Redis服务器连接密码（默认为空）
    timeout: 3000ms # 连接超时时间（毫秒）
```

### 五、使用

```
@AllArgsConstructor
public class CommonTest {
    private RedisUtils redisUtils;
    @DB
    private RedisUtils redisUtils2;
    @DB("${spring.redis.database2}")
    private RedisUtils redisUtils3;

    @GetMapping("/redis")
    public Result test() {
        redisUtils.set("helloBoy1", "helloBoy");
        redisUtils2.set("helloBoy2", "helloBoy");
        redisUtils3.set("helloBoy3", "helloBoy");
        return Result.succeed("保存成功，请查看redis中的数据");
    }
}
```

![image-20220720104628655](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720104628655.png)
