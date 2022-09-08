---
title: 常用sql
date: 2022-09-05 17:09:05
category_bar: true
categories: Code Demo
tags:
- mysql
---
# 常用sql

---

[toc]

---

## 1.case when
```
SELECT
	 CASE WHEN k.num>0 THEN "大" ELSE "小" END AS SE
FROM
	dy_sku K
//作为条件时：
SELECT
		 CASE WHEN (ifnull(k.num,0)-ifnull(k.sale_num,0))>0 THEN "库存充足" ELSE "缺货中" END AS repertoryStatus
FROM
		dy_sku k
		LEFT JOIN dy_spu p ON k.spu_id = p.id
<where>
		<if test="repertoryStatus != null and repertoryStatus != ''">
				and CASE WHEN (ifnull(k.num,0)-ifnull(k.sale_num,0))>0 THEN "库存充足" ELSE "缺货中" END=#{repertoryStatus}
		</if>
</where>
ORDER BY k.sort ASC,k.update_time DESC,k.create_time DESC
limit #{pageNum},#{pageSize}
```
## 2. 某列分组并统计个数
```
SELECT
	sku_id,
	COUNT(sku_id) ,
	MAX(create_time)
FROM
	mall_user_care_log 
WHERE
	type = 1 
GROUP BY
	sku_id
```
## 3. 计算时间间隔
```
//1.间隔天数
datediff(NOW(),c.create_time)
CASE WHEN (datediff(NOW(),c.create_time)>=30) THEN "1" ELSE "0" END AS thirtyDayExceptStatus
//2.自定单位
FRAC_SECOND 表示间隔是毫秒
SECOND 秒
MINUTE 分钟
HOUR 小时
DAY 天
WEEK 星期
MONTH 月
QUARTER 季度
YEAR 年
select timestampdiff(week,'2019-07-30','2019-09-04');
3. 格式化时间只保留天与当前对比输出1即为过期（当前时间小于过期时间）
CASE WHEN (timestampdiff(DAY,DATE_FORMAT(t.expire_time,'%Y-%m-%d'),DATE_FORMAT(NOW(),'%Y-%m-%d') )>=0 ) THEN '1' ELSE '0' END AS preExpireStatus,
```
## 4.格式化时间
```
DATE_FORMAT(k.apply_time,'%Y年%m月')	AS 'applyTime'
```
## 5.mysql 触发器
```
-- ----------------------------
-- Triggers structure for table sku_tag
-- ----------------------------
#新增触发器
DROP TRIGGER IF EXISTS `tag_sku_insert`;
delimiter ;;
CREATE TRIGGER `tag_sku_insert` AFTER INSERT ON `sku_tag` FOR EACH ROW BEGIN
	UPDATE dy_sku SET is_has_tag = 1 WHERE id = NEW.sku_id;
END;;
delimiter ;


#更新触发器
DROP TRIGGER IF EXISTS `tag_sku_update`;
delimiter ;;
CREATE TRIGGER `tag_sku_update` AFTER UPDATE ON `sku_tag` FOR EACH ROW BEGIN
	IF NEW.one_tag_id IS NULL THEN	##去除标签
		UPDATE dy_sku SET is_has_tag = 0 WHERE id = NEW.sku_id;
	ELSE 
		UPDATE dy_sku SET is_has_tag = 1 WHERE id = NEW.sku_id;
	END IF;
END;;
delimiter ;

DROP TRIGGER IF EXISTS `tag_po_det_update`;
delimiter ;;
CREATE TRIGGER `tag_po_det_update` AFTER UPDATE ON `sms_wms_po_det` FOR EACH ROW BEGIN
	DECLARE  count int  DEFAULT 0;
	DECLARE  count2 int  DEFAULT 0;
	SELECT count(1) into count FROM sms_wms_po_det s WHERE s.twd_po_no = NEW.twd_po_no and s.twd_is_close ='Y';
	SELECT count(1) into count2 FROM sms_wms_po_det s WHERE s.twd_po_no = NEW.twd_po_no and s.twd_is_close ='N';
	IF count > 0 THEN	##存在关结
		UPDATE sms_wms_po SET po_state = '2' WHERE po_no = NEW.twd_po_no;
	END IF;
	IF count2<= 0 THEN  ##未关结数<=0,所有关结
		UPDATE sms_wms_po SET po_state = '4' WHERE po_no = NEW.twd_po_no;
	END IF;
END;;
delimiter ;

#删除触发器
DROP TRIGGER IF EXISTS `tag_sku_delete`;
delimiter ;;
CREATE TRIGGER `tag_sku_delete` AFTER DELETE ON `sku_tag` FOR EACH ROW BEGIN
		UPDATE dy_sku SET is_has_tag = 0 WHERE id = OLD.sku_id;
END;;
delimiter ;

#启动触发器
SET FOREIGN_KEY_CHECKS = 1;
  
#测试
SELECT is_has_tag FROM dy_sku WHERE id=13;
INSERT INTO `xmall`.`sku_tag`( `sku_id`, `one_tag_id`, `one_tag_name`, `two_tag_id`, `two_tag_name`) VALUES (13, 2, '测试22', NULL, NULL);
SELECT is_has_tag FROM dy_sku WHERE id=13;

SELECT is_has_tag FROM dy_sku WHERE id=13;
	UPDATE  SET `one_tag_id` = NULL WHERE sku_id=13;
SELECT is_has_tag FROM dy_sku WHERE id=13;

SELECT is_has_tag FROM dy_sku WHERE id=13;
	DELETE FROM `xmall`.`sku_tag` WHERE sku_id=13;
SELECT is_has_tag FROM dy_sku WHERE id=13;

```
## 6.连接两列数据（注意concat的NULL处理）
```
CONCAT(IFNULL(m.company_province,''),IFNULL(m.m.company_city,'')) as adress
```
## 7.查询有重复的某列数据
```
SELECT t.OQC_NO FROM t_oqa_bath t  group by t.OQC_NO having count(*)>1
```
## 8. 合并某一列数据并以逗号隔开
```
SELECT GROUP_CONCAT(DISTINCT m.project_id) FROM sms_wms_out_stock_pm_item m WHERE m.doc_no = t.doc_no GROUP BY m.doc_no
```
## 9.计算两列差
```
IFNULL(t.osd_amount_real,0)-IFNULL(t.osd_amount_plan,0) osdAmountRetired
```
## 10.根据某两列分组，其他列值相加
```
SELECT
	t.item_code itemCode,
	t.item_name itemName,
	SUM( IFNULL( t.osd_amount_plan, 0 ) ) osdAmountPlan,
	SUM( IFNULL( t.osd_amount_real, 0 ) ) osdAmountReal,
	SUM( IFNULL( t.osd_amount_real, 0 )- IFNULL( t.osd_amount_plan, 0 )) osdAmountRetired 
FROM
	sms_wms_out_stock_detail t 
GROUP BY
	t.item_code,
	t.item_name
```
## 11.根据两列计算百分比
```
concat ( left (t.err_qty / t.input_qty *100,5),'%') as errPercentage, -- 不良率
```
## 12. 截取字符串
```
//截取左边的4个字符
left（name,4）
//截取右边的2个字符
right（name,2）
//去除后四位
left(name,length(name)-4)
```
## 13. mybatis动态循环

```
where 1=1
<if test="ids != null and ids.size()>0">
	and t.id IN
	<foreach collection="ids" separator="," close=")" open="(" item="item" index="index">
		#{item}
	</foreach>
</if>
```

## 14. 某字段去重并保留一条

```
DELETE FROM auto WHERE id in(
    SELECT a.id FROM
    (
        ##通过user_id,disable查询重复记录，并保留一条
        SELECT b.* FROM auto b
        WHERE b.user_id IN (SELECT user_id FROM auto GROUP BY license_plate_no, `owner`, user_id, `disable` HAVING count(*)>1)
          AND b.`disable` IN (SELECT `disable` FROM auto GROUP BY license_plate_no, `owner`, user_id, `disable` HAVING count(*)>1)
          AND b.id NOT IN (SELECT MIN(id) FROM auto GROUP BY license_plate_no, `owner`, user_id, `disable` HAVING count(*)>1)
    ) a
);
```

## 15. 一对多时分组或查询最大值

```
订单，支付 一对多取出最大支付时间
select
    (select MAX(p.pay_time) from payment p where p.parent_order_no=t.parent_order_no) payTime,
    t.parent_order_no parentOrderNo
from sub_purchase_order t
```

## 16. 查重

```
SELECT  Name FROM  dbo.Member t WHERE Name IN (SELECT Name FROM dbo.Member GROUP BY Name HAVING COUNT(Name)>1 ) ORDER BY t.Name
```

