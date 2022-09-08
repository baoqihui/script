

[toc]

# Spring Data JPA 框架笔记

## 一、简介

Spring Data Jpa 是应⽤于Dao层的⼀个框架，简化数据库开发的，作⽤和Mybatis框架⼀样，但是在使

⽤⽅式和底层机制是有所不同的。最明显的⼀个特点，Spring Data Jpa 开发Dao的时候，很多场景我们

连sql语句都不需要开发。

JPA 是⼀套规范，内部是由接⼝和抽象类组成的，Hiberanate 是⼀套成熟的 ORM 框架，⽽且

Hiberanate 实现了 JPA 规范，所以可以称 Hiberanate 为 JPA 的⼀种实现⽅式，我们使⽤ JPA 的 API 编

程，意味着站在更⾼的⻆度去看待问题（⾯向接⼝编程）。

Spring Data JPA 是 Spring 提供的⼀套对 JPA 操作更加⾼级的封装，是在 JPA 规范下的专⻔⽤来进⾏数

据持久化的解决⽅案。

![image-20210915213027309](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20210915213027309.png)


## 二、JPA常用方法

### 1.更新或保存save

如果有id，先按照id查询，如果不存在，则存入除id外的对象，更新时空元素会覆盖原有信息，并不是不替换该字段

```
//更新或保存；如果有id，先按照id查询，如果不存在，则存入除id外的对象
//select age0_.id as id1_0_0_, age0_.age as age2_0_0_, age0_.name as name3_0_0_ from tb_age age0_ where age0_.id=?
//insert into tb_age (age, name) values (?, ?)
Age newAge=new Age();
newAge.setId(2L);
newAge.setAge(26);
//更新时空元素会覆盖原有信息，并不是不替换该字段
Age save = ageDao.save(newAge);
System.out.println("save:"+save);
//自写sql
@Transactional
@Modifying
@Query(value = "update suspend_record set status = ?1 where status=?2 and start_time<=?3 ", nativeQuery = true)
Integer updateWaitStatus(Integer status1,Integer status2,Date date);

@Transactional
@Modifying
@Query(value = "update suspend_auto set disable = :state WHERE  mobile = :mobile and activity_id = :activityId and license_plate_no = :licensePlateNo", nativeQuery = true)
Integer updateSuspendAutoState(@Param("mobile") String mobile, @Param("activityId") Long activityId,
@Param("licensePlateNo") String licensePlateNo, @Param("state") Integer state);
```

### 2.删除deleteById，delete

```
//删除
//delete from tb_age where id=?
//ageDao.deleteById(3L);
ageDao.delete(save);
```

### 3.简单查询findById，findOne，findAll

```
//通过id查询一个对象
//select age0_.id as id1_0_0_, age0_.age as age2_0_0_, age0_.name as name3_0_0_ from tb_age age0_ where age0_.id=?
Optional<Age> byId = ageDao.findById(1L);
System.out.println("findById:"+byId.get());

//通过条件查询一个对象
//select age0_.id as id1_0_, age0_.age as age2_0_, age0_.name as name3_0_ from tb_age age0_ where age0_.age=23
Age age=new Age();
age.setAge(20);
Example<Age> example = Example.of(age);
Optional<Age> one = ageDao.findOne(example);
System.out.println("findOne:"+one.get());


```

### 4.分页排序查询

```
//查询全部，分页并按照id逆序
//select age0_.id as id1_0_, age0_.age as age2_0_, age0_.name as name3_0_ from tb_age age0_
Sort sort = Sort.by(Sort.Direction.DESC,"id");
Pageable pageable = PageRequest.of(0, 10, sort);
Page<Age> all = ageDao.findAll(pageable);
System.out.println(all.getContent());
```

### 5.自定义查询

+ dao层

```
public interface AgeDao extends JpaRepository<Age,Long>, JpaSpecificationExecutor<Age> {
@Query("from Age where age=?1 and name=?2")
List<Age> findByjPQL(Integer age,String name);

@Query(value = "select * from tb_age where age=?1 and name like ?2",nativeQuery = true)
List<Age> findBySQL(Integer age,String name);

List<Age> findByAgeAndNameLike(Integer age,String name);
}
```

+ 使用

```
//通过jpql查询
//select age0_.id as id1_0_, age0_.age as age2_0_, age0_.name as name3_0_ from tb_age age0_ where age0_.age=? and age0_.name=?
List<Age> byjPQL = ageDao.findByjPQL(20,"张三");
byjPQL.forEach(System.out::println);

//通过sql查询
//select * from tb_age where age=? and name like ?
List<Age> bySQL = ageDao.findBySQL(20, "张%");
bySQL.forEach(System.out::println);

//通过方法命名规则查询
//select age0_.id as id1_0_, age0_.age as age2_0_, age0_.name as name3_0_ from tb_age age0_ where age0_.age=? and (age0_.name like ? escape ?)
List<Age> ages = ageDao.findByAgeAndNameLike(20, "张%");
ages.forEach(System.out::println);
```

### 6.动态查询，分页，排序

    Age age1=new Age();
    age1.setName("张%");
    //动态查询
    List<Age> dynamic = dynamicQuery(age1);
    dynamic.forEach(System.out::println);
    
    /**
     * 动态查询
     * @param age 通过传入对象值是否为空动态查询,并按照id排序
     * @return 查询到的集合
     */
    Page<Age> dynamicQuery(Age age){
        Specification<Age> specification = new Specification<Age>() {
            @Override
            public Predicate toPredicate(Root<Age> root, CriteriaQuery<?> query, CriteriaBuilder builder) {
                Path age1 = root.<Integer>get("age");
                Path name = root.<String>get("name");
                List<Predicate> predicates = new ArrayList<>();
                if (age.getAge()!=null){
                    predicates.add(builder.equal(age1, age.getAge()));
                }
                if (age.getName()!=null){
                    predicates.add(builder.like(name.as(String.class), age.getName()));
                }
                Order order = builder.desc(root.<Long>get("id"));
                Predicate where = builder.and(predicates.toArray(new Predicate[predicates.size()]));
                query.where(where);
                query.orderBy(order);
                return query.getRestriction();
            }
        };
        return ageDao.findAll(specification，PageRequest.of(0, 10, new Sort(Sort.Direction.DESC,"id")）);
    }

### 7.关联查询

+ 实体类

  ```
  //age
  @Entity
  @Table(name = "tb_age")
  public class Age implements Serializable {
      private static final long serialVersionUID=1L;
      @Id
      @GeneratedValue(strategy = GenerationType.IDENTITY)
      @Column(name = "id")
      private Long id;
      @Column(name = "name")
      private String name;
      @Column(name = "age")
      private Integer age;
  
      @OneToOne(fetch = FetchType.EAGER)
      @NotFound(action = NotFoundAction.IGNORE)
      @JoinColumn(name = "name", referencedColumnName = "name", insertable = false, updatable = false)
      private Resume resume;
  }
  //resume
  @Entity
  @Table(name = "tb_resume")
  public class Resume implements Serializable {
      private static final long serialVersionUID=1L;
      @Id
      @GeneratedValue(strategy = GenerationType.IDENTITY)
      @Column(name = "id")
      private Long id;
      @Column(name = "name")
      private String name;
      @Column(name = "address")
      private String address;
      @Column(name = "phone")
      private String phone;
  }
  ```

+ 用法

```
//关联查询
List<Age> ages1 = joinQuery(null,"张%" ,"1%");
ages1.forEach(System.out::println);

/**
 * 通过age表左连接resume表，关联字段为name
 * @param age age表年龄
 * @param name age表姓名
 * @param phone resume表电话
 * @return age实体
 */
List<Age> joinQuery(Integer age,String name,String phone){
    Specification<Age> specification = new Specification<Age>() {
        @Override
        public Predicate toPredicate(Root<Age> root, CriteriaQuery<?> query, CriteriaBuilder builder) {
            Path agePath = root.<Integer>get("age");
            Path namePath = root.<String>get("name");
            //先副表，再主表，左连接
            Join<Resume, Object> join = root.join("resume", JoinType.LEFT);
            Path phonePath = join.<String>get("phone");
            List<Predicate> predicates = new ArrayList<>();
            if (age!=null){
                predicates.add(builder.equal(agePath, age));
            }
            if (name!=null){
                predicates.add(builder.like(namePath.as(String.class), name));
            }
            if (phone!=null){
                predicates.add(builder.like(phonePath.as(String.class),phone));
            }
            Order order = builder.desc(root.<Long>get("id"));
            Predicate where = builder.and(predicates.toArray(new Predicate[predicates.size()]));
            query.where(where);
            query.orderBy(order);
            return query.getRestriction();
        }
    };
    return ageDao.findAll(specification);
}
```

## 三、解决Save方法null值覆盖

JPA原生Save方法会导致null属性覆盖到数据库,重写方法实现null属性不再覆盖

### 1. 新建类

```
package com.cheche365.ccgeneral.service.util;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.support.JpaEntityInformation;
import org.springframework.data.jpa.repository.support.SimpleJpaRepository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import javax.persistence.EntityManager;
import java.beans.PropertyDescriptor;
import java.util.HashSet;
import java.util.Optional;
import java.util.Set;

/**
 * @Author: hbq
 * @Description: JPA原生Save方法会导致null属性覆盖到数据库,重写方法实现null属性不再覆盖
 * @Date: 2021/10/21 14:24
 */
public class SimpleJpaRepositoryImpl<T, ID> extends SimpleJpaRepository<T, ID> {

    private final JpaEntityInformation<T, ?> entityInformation;
    private final EntityManager em;

    @Autowired
    public SimpleJpaRepositoryImpl(JpaEntityInformation<T, ?> entityInformation, EntityManager entityManager) {
        super(entityInformation, entityManager);
        this.entityInformation = entityInformation;
        this.em = entityManager;
    }

    /**
     * 通用save方法 ：新增/选择性更新
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public <S extends T> S save(S entity) {
        //获取ID
        ID entityId = (ID) entityInformation.getId(entity);
        Optional<T> optionalT;
        if (StringUtils.isEmpty(entityId)) {
            optionalT = Optional.empty();
        } else {
            //若ID非空 则查询最新数据
            optionalT = findById(entityId);
        }
        //获取空属性并处理成null
        String[] nullProperties = getNullProperties(entity);
        //若根据ID查询结果为空
        if (!optionalT.isPresent()) {
            //新增
            em.persist(entity);
            return entity;
        } else {
            //1.获取最新对象
            T target = optionalT.get();
            //2.将非空属性覆盖到最新对象
            BeanUtils.copyProperties(entity, target, nullProperties);
            //3.更新非空属性
            em.merge(target);
            return entity;
        }
    }

    /**
     * 获取对象的空属性
     */
    private static String[] getNullProperties(Object src) {
        //1.获取Bean
        BeanWrapper srcBean = new BeanWrapperImpl(src);
        //2.获取Bean的属性描述
        PropertyDescriptor[] pds = srcBean.getPropertyDescriptors();
        //3.获取Bean的空属性
        Set<String> properties = new HashSet<>();
        for (PropertyDescriptor propertyDescriptor : pds) {
            String propertyName = propertyDescriptor.getName();
            Object propertyValue = srcBean.getPropertyValue(propertyName);
            if (StringUtils.isEmpty(propertyValue)) {
                srcBean.setPropertyValue(propertyName, null);
                properties.add(propertyName);
            }
        }
        return properties.toArray(new String[0]);
    }
}
```

### 2. 启动类加注解

```typescript
@EnableJpaRepositories(repositoryBaseClass = SimpleJpaRepositoryImpl.class)
```

## 四、常用JPA方法命名规则

| 关键词                 | 样本                                                         | JPQL 片段                                                    |
| :--------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- |
| `Distinct`             | `findDistinctByLastnameAndFirstname`                         | `select distinct … where x.lastname = ?1 and x.firstname = ?2` |
| `And`                  | `findByLastnameAndFirstname`                                 | `… where x.lastname = ?1 and x.firstname = ?2`               |
| `Or`                   | `findByLastnameOrFirstname`                                  | `… where x.lastname = ?1 or x.firstname = ?2`                |
| `Is`, `Equals`         | `findByFirstname`, `findByFirstnameIs`,`findByFirstnameEquals` | `… where x.firstname = ?1`                                   |
| `Between`              | `findByStartDateBetween`                                     | `… where x.startDate between ?1 and ?2`                      |
| `LessThan`             | `findByAgeLessThan`                                          | `… where x.age < ?1`                                         |
| `LessThanEqual`        | `findByAgeLessThanEqual`                                     | `… where x.age <= ?1`                                        |
| `GreaterThan`          | `findByAgeGreaterThan`                                       | `… where x.age > ?1`                                         |
| `GreaterThanEqual`     | `findByAgeGreaterThanEqual`                                  | `… where x.age >= ?1`                                        |
| `After`                | `findByStartDateAfter`                                       | `… where x.startDate > ?1`                                   |
| `Before`               | `findByStartDateBefore`                                      | `… where x.startDate < ?1`                                   |
| `IsNull`, `Null`       | `findByAge(Is)Null`                                          | `… where x.age is null`                                      |
| `IsNotNull`, `NotNull` | `findByAge(Is)NotNull`                                       | `… where x.age not null`                                     |
| `Like`                 | `findByFirstnameLike`                                        | `… where x.firstname like ?1`                                |
| `NotLike`              | `findByFirstnameNotLike`                                     | `… where x.firstname not like ?1`                            |
| `StartingWith`         | `findByFirstnameStartingWith`                                | `… where x.firstname like ?1`（参数绑定了 append `%`）       |
| `EndingWith`           | `findByFirstnameEndingWith`                                  | `… where x.firstname like ?1`（参数绑定 prepended `%`）      |
| `Containing`           | `findByFirstnameContaining`                                  | `… where x.firstname like ?1`（参数绑定包裹在`%`）           |
| `OrderBy`              | `findByAgeOrderByLastnameDesc`                               | `… where x.age = ?1 order by x.lastname desc`                |
| `Not`                  | `findByLastnameNot`                                          | `… where x.lastname <> ?1`                                   |
| `In`                   | `findByAgeIn(Collection<Age> ages)`                          | `… where x.age in ?1`                                        |
| `NotIn`                | `findByAgeNotIn(Collection<Age> ages)`                       | `… where x.age not in ?1`                                    |
| `True`                 | `findByActiveTrue()`                                         | `… where x.active = true`                                    |
| `False`                | `findByActiveFalse()`                                        | `… where x.active = false`                                   |
| `IgnoreCase`           | `findByFirstnameIgnoreCase`                                  | `… where UPPER(x.firstname) = UPPER(?1)`                     |

```
docker run -d --name=webdav-aliyundriver --restart=always -p 8080:8080  -v /etc/localtime:/etc/localtime -v /etc/aliyun-driver/:/etc/aliyun-driver/ -e TZ="Asia/Shanghai" -e ALIYUNDRIVE_REFRESH_TOKEN="91dac35e525c47ebb2bc7d0753875c0e" -e ALIYUNDRIVE_AUTH_PASSWORD="HBQ521521cf*" -e JAVA_OPTS="-Xmx1g" zx5253/webdav-aliyundriver
```

http://my.huijia21.com/

