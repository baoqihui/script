---
title: Stream&Lambda
date: 2022-09-05 17:09:05
category_bar: true
categories: Code Demo
tags:
- Stream
- Lambda
---
# Stream&Lambda

+ 测试实体

```
package com.hbq.codedemopersion.common.model;

@Data
@Builder
public class F {
    private String name;
    private String password;
    private Integer age;
    private List<S> s;

    public String fetchGroupKey(){
        return name+"#"+password;
    }

    @Data
    @Builder
    public static class S {
        public String name;
    }
}
```

+ stream流的测试

```
package com.hbq.codedemopersion.common.controller.test;

/**
 * @Author: huibq
 * @Description: 流和Lambda表达式测试
 * @Date: 2021/12/10 13:57
 */
@Slf4j
public class StreamAndLambdaTest {
    public static void main(String[] args) {
        log.info("-------------数组流------------");
        int[] array = new int[]{1, 2, 3};
        int first = Arrays.stream(array)
                .findFirst()
                .orElseThrow(); //取值失败报错
        log.info("[取第一项] array:{} -> first:{}", array, first);
        log.info("");

        log.info("-------------集合流------------");
        List<F> list = List.of(
                F.builder().age(1).name("f1").build(),
                F.builder().age(2).name("f2").build(),
                F.builder().age(3).name("f1").build());
        log.info("↓↓↓↓↓原集合:{}↓↓↓↓↓", list);
        list.forEach(e -> log.info("[遍历]{} {}", e.getAge(), e));

        F f = list.stream()
                .max(Comparator.comparing(F::getAge))
                .orElseThrow();
        log.info("[取Age最大项] maxModel:{}", f);

        List<String> nameList = list.stream()
                .map(F::getName)
                .collect(Collectors.toList());
        log.info("[取值转换] nameList:{}", nameList);

        String listString = list.stream()
                .map(F::getName)
                .collect(Collectors.joining(",", "[", "]"));
        log.info("[转换后数据处理] listString:{}", listString);

        List<F> filterList = list.stream()
                .filter(e -> e.getAge() != 2)
                .collect(Collectors.toList());
        log.info("[过滤出Age不等于2] filterList:{}", filterList);

        Map<String, List<F>> groupMap = list.stream()
                .collect(Collectors.groupingBy(F::getName));
        log.info("[分组] groupMap:{}", groupMap);
        log.info("");

        log.info("-------------map流------------");
        Map<Integer, String> map = new HashMap<>(8) {{
            put(1, "HUI");
            put(2, "XUE");
        }};
        Map<Integer, String> newMap = map.entrySet()
                .stream()
                .collect(Collectors.toMap(e -> e.getKey() + 1, e -> e.getValue() + 1));
        log.info("map:{} -> newMap:{}", map, newMap);
        String collect = map.entrySet().stream()
                .map(e -> new AutoModel(e.getKey(), e.getValue()))         //转换为实体类型
                .filter(e -> e.getId() < 100)               //过滤id小于100
                .limit(2)                               //过滤
                .distinct()                             //去重
                .sorted(Comparator.comparing(AutoModel::getId))         //按照id排序
                .max(Comparator.comparing(AutoModel::getId))            //找最大
                .stream().map(AutoModel::getName)
                .collect(Collectors.joining(",", "[", "]"));
        log.info("[组合转换]collect:{}", collect);
        log.info("");

        log.info("-------------对象list流按照(字段)字段去重并处理其他字段------------");
        List<F.S> s1 = new ArrayList<>();
        s1.add(F.S.builder().name("s1").build());
        s1.add(F.S.builder().name("s2").build());
        List<F.S> s2 = new ArrayList<>();
        s2.add(F.S.builder().name("s2").build());
        s2.add(F.S.builder().name("s3").build());
        List<F.S> s3 = new ArrayList<>();
        s3.add(F.S.builder().name("s2").build());
        s3.add(F.S.builder().name("s3").build());

        F f1 = F.builder().name("f1").password("p1").age(500).s(s1).build();
        F f2 = F.builder().name("f1").password("p1").age(600).s(s2).build();
        F f3 = F.builder().name("f2").age(500).s(s3).build();
        List<F> orgList = List.of(f1, f2, f3);
        log.info("[原集合orgList] {}", orgList);
        List<F> nowList = new ArrayList<>(new ArrayList<>(orgList.stream().collect(
                //获取重复的组合key，o1 o2
                Collectors.toMap(F::fetchGroupKey, Function.identity(), (o1, o2) -> {
                    //age属性求和, 赋值给o1，最后返回o1
                    o1.setAge(o1.getAge() + o2.getAge());
                    //合并子对象集合
                    CollUtil.addAll(o1.getS(), o2.getS());
                    //去重子对象集合
                    o1.setS(o1.getS().stream().distinct().collect(Collectors.toList()));
                    return o1;
                })).values()));
        log.info("[现集合nowList] {}", nowList);
        log.info("");

        log.info("-------------FlatMap双层遍历------------");
        String names = "f1,f2";
        String ages = "1,2";
        log.info("[原集合] names:{} ages:{}", names, ages);
        List<F> nowFlatList = Arrays.stream(names.split(","))  //拆分名字
                .map(name -> Arrays.stream(ages.split(",")) //拆分年龄
                        .map(Integer::valueOf)  //转换年龄为Integer
                        .map(age -> F.builder().age(age).name(name).build()) //构建对象
                        .collect(Collectors.toList()))  //内层转换为集合 
                .flatMap(Collection::stream)    //拆分内层集合
                .collect(Collectors.toList());  //外层转换为集合
        log.info("[新集合nowFlatList] {}", nowFlatList);
    }
}
```

+ 测试结果

  ![image-20220720170920523](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220720170920523.png)
