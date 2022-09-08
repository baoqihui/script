---
title: mes学习笔记.md
date:  2022/9/7 10:10
category_bar: true
categories: 学习笔记
tags:
- mes
---
# mes 学习笔记
1. 集合中不改变顺序，对重复对象保留一个去重。
`List list=(List) umsPermissionVOS.stream().distinct().collect(Collectors.toList());`
2. 保留四位补充0
`String.format("%4d",aLong+1).replace(" ","0")`
3. 异常处理
 ```
 @Transactional(rollbackFor = Exception.class)
try{
	//代码段
}
catch (Exception e){
	// 事务回滚
	log.error("异常：",e);
	TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
	return Result.failed( e,"保存失败,请联系管理员");
}
 ```
4. 集合中流过滤的使用
 ```
//过滤出不包含2的数据
list=list.stream().filter(v ->!v.toString().contains("2")).collect(Collectors.toList());
//过滤出小于15的数据
taskExecuteInfos=taskExecuteInfos.stream().filter(u->u.getTaskId()<=15L).collect(Collectors.toList());
//找出最大的state(max.orElse是当Optional为null时赋新值)
Optional<TaskExecuteInfo> max = taskExecuteInfos.stream().max(Comparator.comparing(u -> u.getState()));
TaskExecuteInfo maxTaskExecuteInfo = max.orElse(new TaskExecuteInfo());
//按照state分组
Map<Integer, List<TaskExecuteInfo>> collect = taskExecuteInfos.stream().collect(Collectors.groupingBy(u -> u.getState()));
//拼接流中的EcnNo（“，”为分割；“【”前缀；“】”后缀）
String s1 = taskExecuteInfos.stream().map(TaskExecuteInfo::getEcnNo).collect(Collectors.joining(",", "[", "]"));
//TaskExecuteInfo::getEcnNo与u->u.getEcnNo效果相同
//取出集合中的某字段作为新集合
List<String> tos=new ArrayList<>();
tos=depaUsers.stream().map(u->u.getEmail()).collect(Collectors.toList());
 ```
5. 集合中流遍历赋值
 ```
taskExecuteInfos.forEach(u->u.setCreateTime(new Date()));
 ```
6. 时间类型为空时的更新
```
@TableField(strategy = FieldStrategy.IGNORED)
```
7. 通过前缀+串号生成下一串号
 ```
/**
     * 根据单号前缀生成当前单号
     * @param prefix 前缀
     * @return
     */
private String getNewDocNum(String prefix){
	String newDocNum=prefix+"0001";
	SmsWmsReceiveDoc one = getOne(new QueryWrapper<SmsWmsReceiveDoc>()
			.last("where WR_DOC_NUM like '"+prefix+"%' order by WR_DOC_NUM desc limit 1"));
	if (one != null) {
		Long aLong = Convert.toLong(StrUtil.removePrefix(one.getWrDocNum(), prefix));
		newDocNum=prefix+String.format("%4d",aLong+1).replace(" ","0");
	}
	return newDocNum;
}
 ```
8. json_string转map
 ```
1. Map result =(Map) JSON.parse(mapString);
2. Map map = JSON.parseObject(result, Map.class);
//数据转小驼峰
Map map = MapUtil.toCamelCaseMap(parse);
 ```
9. json字符串转l对象集合
  ```
List<EccMaterialDetail> eccMaterialDetails = JSONArray.parseArray(result, EccMaterialDetail.class);
  ```
10. 对象为null时转换为某默认值
 `Objects.toString(boxInfo.getBatch(),"")`

11. List<Map<String, Object>> params数组转化为json数组
```
JSON.toJSONString(params);
```
---
12. 获取前后缀进行截断（可能存在多个"-"后缀，只获取最后一个）
  ```
String[] split = custFixNo.split("-");
String suffix = split[split.length - 1];
String prefix = StrUtil.removeSuffix(custFixNo, suffix);
  ```
13. 父子级类表格递归查询
 + 数据库设计
 ![image-20220628110059492](https://img-1256282866.cos.ap-beijing.myqcloud.com/image-20220628110059492.png)
 + 返回实体结构
```
@Data
public class PermissionTreeVO {
    /** 主键 */
    private Long id;
    /** 权限名 */
    private String perName;
    /** 权限路径 */
    private String perUrl;
    /** 权限类型 例如 0 菜单 1按钮 */
    private Integer perType;
    /** 父级权限 默认 0  */
    private Long parentId;
    /** 图标 */
    private String icon;
    /** 状态 0 禁用 1 启用 */
    private Boolean status;
    /** 描述 */
    private String remark;
    /** 子权限 */
    private List<PermissionTreeVO> childs;
}
```
 + 具体实现
```
//controller
    /**
     * 通过parentId递归查询权限树（查询全部传0）
     */
    @ApiOperation(value = "通过parentId递归查询权限树（查询全部传0）")
    @PostMapping("/umsPermission/selectPermissionTreeByParentId/{parentId}")
    public Result selectPermissionTreeByParentId(@PathVariable Long parentId) {
        List<PermissionTreeVO> permissionTreeVOS = umsPermissionService.selectPermissionTreeByParentId(parentId);
        return Result.succeed(permissionTreeVOS, "查询成功");
    }
	
// serviceImpl
    /**
     * @Description: 以输入的父级id寻找下级目录，只要下级目录不为空，就继续向下探寻，然后封装至上级的childs字段中
     * @param parentId
     * @return
     */
    @Override
    public List<PermissionTreeVO> selectPermissionTreeByParentId(Long parentId) {
        List<PermissionTreeVO> permissionList = umsPermissionMapper.selectPermissionTreeByParentId(parentId);
        if(permissionList!=null){
            for (PermissionTreeVO permission : permissionList) {
                permission.setChilds(selectPermissionTreeByParentId(permission.getId()));
            }
        }
        return permissionList;
    }
	
// mapper.xml
    <select id="selectPermissionTreeByParentId" resultType="com.yk.i_wms.vo.PermissionTreeVO" parameterType="long">
        SELECT DISTINCT
            t.id id,
            t.per_name perName,
            t.per_url perUrl,
            t.per_type perType,
            t.icon icon,
            t.status status,
            t.remark remark,
            t.parent_id parentId
        FROM
            ums_permission t
        WHERE
            t.parent_id = #{parentId}
        order by t.id
    </select>
```
14. 分页列表查询后的处理
```
    @ApiOperation(value = "查询列表")
    @PostMapping("/umsRole/list")
    public Result<PageResult> list(@RequestBody Map<String, Object> params) {
        Page<Map> list= umsRoleService.findList(params);
        List<Map> records = list.getRecords();
        List<Map> results = new ArrayList<>();
        for (Map record : records) {
            Long roleId = MapUtil.getLong(record, "id");
            List<UmsRolePer> umsRolePers = umsRolePerService.list(new LambdaQueryWrapper<UmsRolePer>()
                    .eq(UmsRolePer::getRoleId, roleId));
            List<Long> perIds=umsRolePers.stream().map(u->u.getPerId()).collect(Collectors.toList());
            record.put("perIds",perIds);
            results.add(record);
        }
        list.setRecords(results);
        return Result.succeed(PageResult.restPage(list),"查询成功");
    }
```

