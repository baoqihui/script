---
title: Mybatis Plus
date: 2022-09-05 17:09:05
category_bar: true
categories: Code Demo
tags:
- Mybatis Plus
---
# Mybatis Plus

---

[toc]

---

## 一、基础BaseService常用方法

```
User user1 = new User();
user1.setId(1L);
user1.setName("hbq");
User user2 = new User();
user2.setId(1L);
user2.setName("hbq");
List<User> users = List.of(user1, user2);

userService.save(user1);        //新增
userService.saveBatch(users);    //批量新增
userService.getById(1L);         //根据id查询
userService.getOne(new LambdaQueryWrapper<User>()
        .eq(User::getId, 1L)
        .like(User::getName, "hbq"));   //根据条件查询一条数据
userService.list(new LambdaQueryWrapper<User>()
        .like(User::getName, "hbq"));   //根据条件查询多条数据
userService.saveOrUpdate(user2); //若id存在则更新，不存在则新增
userService.updateById(user1);   //更新
userService.removeById(1L);     //删除
userService.removeByIds(List.of(1L, 2L)); //批量删除
userService.removeByMap(Map.of("id", 1L)); //根据map删除
userService.removeByMap(Map.of("id", 1L, "name", "hbq")); //根据map删除
```
+ 常用条件构造器方法

![](https://img-1256282866.cos.ap-beijing.myqcloud.com/20181001202710403)

## 二、单搜索框查询多字段

```
<select id="selectAuditList" resultType="com.dy.pojo.vo.AuditMallVO" parameterType="map">
        SELECT
        i.id id,
        i.user_id userId,
        i.phone phone,
        i.user_name userName,
        i.create_time createTime,
        i.mall_type mallType,
        i.store_type storeType,
        d.`name` name,
        i.company_name companyName,
        i.business_license_city businessLicenseCity,
        i.business_license_number businessLicenseNumber,
        i.audit_status auditStatus
        FROM
        dy_mall_info i
        LEFT JOIN mall_category c ON i.id = c.mall_id
        LEFT JOIN dy_category d ON c.category_id=d.id
        <where>
            <if test="startTime != null and startTime != ''">
                and i.create_time>=#{startTime}
            </if>
            <if test="endTime != null and endTime != ''">
                and #{endTime}>=i.create_time
            </if>
            <if test="businessLicenseCity != null and businessLicenseCity != ''">
                and i.business_license_city LIKE '%${businessLicenseCity}%'
            </if>
            <if test="search != null and search != ''">
                and (
                i.phone LIKE '%${search}%' or
                i.user_name LIKE '%${search}%' or
                d.name LIKE '%${search}%' or
                i.company_name LIKE '%${search}%' or
                i.business_license_number LIKE '%${search}%'
                )
            </if>
            <if test="auditStatus != null ">
                and i.audit_status= #{auditStatus}
            </if>
        </where>
        limit #{pageNum},#{pageSize}
    </select>
```
## 三、事务无法使用
```
try {

}
catch (Exception e) {
		e.printStackTrace();
		TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		return new ResultObject(StatusCode.ERROR, "添加失败");
}
```
## 四、resultMap嵌套结构
```
//
//xml
<resultMap id="CategoryOneMap" type="com.dy.pojo.vo.CategoryOneVO">
        <id column="idOne" property="idOne"/>
        <result column="nameOne" property="nameOne"/>
        <result column="codeOne" property="codeOne"/>
        <collection property="categoryTwoVOS" ofType="com.dy.pojo.vo.CategoryTwoVO">
            <id column="idTwo" property="idTwo"/>
            <result column="nameTwo" property="nameTwo"/>
            <result column="codeTwo" property="codeTwo"/>
            <collection property="categoryThrVOS" ofType="com.dy.pojo.vo.CategoryThrVO">
                <id column="idThr" property="idThr"/>
                <result column="nameThr" property="nameThr"/>
                <result column="codeThr" property="codeThr"/>
           </collection>
      </collection>
  </resultMap>
```
## 五、子查询时，将子查询作为条件
```
select
		t.id id,  -- ID
		(SELECT GROUP_CONCAT(DISTINCT m.project_id) FROM sms_wms_out_stock_pm_item m WHERE m.doc_no = t.doc_no GROUP BY m.doc_no) allProject, -- 工单
		t.doc_remark docRemark,  -- 备注
from sms_wms_out_stock_doc t
        LEFT JOIN sms_wms_io_type A on t.DT_CODE=A.TWT_CODE
        WHERE
        1=1
		<if test="p.allProject != null and p.allProject != ''">
            and (SELECT GROUP_CONCAT(DISTINCT m.project_id) FROM sms_wms_out_stock_pm_item m WHERE m.doc_no = t.doc_no GROUP BY m.doc_no) LIKE '%${p.pickupType}%'
        </if>
```