---
title: sql中上下移置顶置底置换的排序实现
date: 2022-09-05 17:09:05
category_bar: true
categories: Code Demo
tags:
- mysql
---
# sql中上下移置顶置底置换的排序实现

---

[toc]

---
## 一、 场景介绍
+ 某个需要排序的表格，按照组别进行上下移置顶置底置换操作。其中sort越小，优先级越高。

---
## 二、 实现思路
1. 上移：找到本组中本数据的上一条数据，如果没有说明已为顶部，无需上移。如果存在，二者交换sort
2. 下移：找到本组中本数据的下一条数据，如果没有说明已为底部，无需下移。如果存在，二者交换sort
3. 置顶：在确保非顶部时，找到该分组的最小sort，sort-1置给本数据
4. 置底：在确保非底部时，找到该分组的最大sort，sort+1置给本数据
5. 交换：传入两组数据交换sort即可

---

## 三、具体实现
```
// controller
    @ApiOperation(value = "上移 ")
    @PostMapping("/upper")
    public Result increase(@RequestBody Map<String,Object> map) {
        return pdtReplaceItemService.presentToBefore(map);
    }
    @ApiOperation(value = "下移 ")
    @PostMapping("/lower")
    public Result lower(@RequestBody Map<String,Object> map) {
        return pdtReplaceItemService.presentToAfter(map);
    }
    @ApiOperation(value = "置顶 ")
    @PostMapping("/top")
    public Result head(@RequestBody Map<String, Object> map) {
        return pdtReplaceItemService.head(map);
    }
    @ApiOperation(value = "置底 ")
    @PostMapping("/bottom")
    public Result tail(@RequestBody Map<String, Object> map) {
        return  pdtReplaceItemService.tail(map);
    }
    @ApiOperation(value = "互换 ")
    @PostMapping("/exchange")
    public Result exchange(@RequestBody  Map<String, Object> map) {
        return pdtReplaceItemService.exchange(map);
    }
```
```
//serviceImpl
 @Override
public Result presentToBefore(Map<String,Object> map){
	Long id = MapUtil.getLong(map,"id");
	PdtReplaceItem replaceItem = pdtReplaceItemMapper.selectById(id);
	String replaceGroup = replaceItem.getReplaceGroup();
	Long ownerSort = replaceItem.getSort();
	PdtReplaceItem beforeReplaceItem = pdtReplaceItemMapper.getBefore(ownerSort,replaceGroup);
	if (beforeReplaceItem == null) {
		return Result.failed("已为顶部，无需上移");
	}
	Long beforeSort = beforeReplaceItem.getSort();
	replaceItem.setSort(beforeSort);
	beforeReplaceItem.setSort(ownerSort);
	pdtReplaceItemMapper.updateById(replaceItem);
	pdtReplaceItemMapper.updateById(beforeReplaceItem);
	return Result.succeed("上移成功");
}
@Override
public Result presentToAfter(Map<String,Object> map){
	Long id = MapUtil.getLong(map,"id");
	PdtReplaceItem replaceItem = pdtReplaceItemMapper.selectById(id);
	String replaceGroup = replaceItem.getReplaceGroup();
	Long ownerSort = replaceItem.getSort();
	PdtReplaceItem afterReplaceItem = pdtReplaceItemMapper.getAfter(ownerSort,replaceGroup);
	if (afterReplaceItem == null) {
		return Result.failed("已为底部，无需下移");
	}
	Long afterSort = afterReplaceItem.getSort();
	replaceItem.setSort(afterSort);
	afterReplaceItem.setSort(ownerSort);
	pdtReplaceItemMapper.updateById(replaceItem);
	pdtReplaceItemMapper.updateById(afterReplaceItem);
	return Result.succeed("下移成功");
}
@Override
public Result head(Map<String, Object> map){
	Long id = MapUtil.getLong(map, "id");
	PdtReplaceItem replaceItem = pdtReplaceItemMapper.selectById(id);
	String replaceGroup = replaceItem.getReplaceGroup();
	Long ownerSort = replaceItem.getSort();
	PdtReplaceItem beforeReplaceItem = pdtReplaceItemMapper.getBefore(ownerSort,replaceGroup);
	if (beforeReplaceItem == null) {
		return Result.failed("已为顶部，无需上移");
	}
	Long minSort = pdtReplaceItemMapper.minSort(replaceGroup);
	replaceItem.setSort(minSort - 1);
	pdtReplaceItemMapper.updateById(replaceItem);
	return Result.succeed("置顶成功");
}
@Override
public Result tail(Map<String, Object> map){
	Long id = MapUtil.getLong(map, "id");
	PdtReplaceItem replaceItem = pdtReplaceItemMapper.selectById(id);
	String replaceGroup = replaceItem.getReplaceGroup();
	Long ownerSort = replaceItem.getSort();
	PdtReplaceItem afterReplaceItem = pdtReplaceItemMapper.getAfter(ownerSort,replaceGroup);
	if (afterReplaceItem == null) {
		return Result.failed("已为底部，无需下移");
	}
	Long maxSort = pdtReplaceItemMapper.maxSort(replaceGroup);
	replaceItem.setSort(maxSort + 1);
	pdtReplaceItemMapper.updateById(replaceItem);
	return Result.succeed("置底成功");
}
@Override
public Result exchange(Map<String, Object> map){
	Long ownerId = MapUtil.getLong(map,"ownerId");
	Long otherId = MapUtil.getLong(map,"otherId");
	PdtReplaceItem owner = pdtReplaceItemMapper.selectById(ownerId);
	PdtReplaceItem other = pdtReplaceItemMapper.selectById(otherId);
	long ownerSort = owner.getSort();
	long otherSort = other.getSort();
	owner.setSort(otherSort);
	other.setSort(ownerSort);
	pdtReplaceItemMapper.updateById(owner);
	pdtReplaceItemMapper.updateById(other);
	return Result.succeed("交换成功");
}
```
```
/**
 * @param ownerSort 自己的排序
 * @param replaceGroup  自己所在分组
 * @return  上一条记录，如果没有返回空
 */
PdtReplaceItem getBefore(@Param("ownerSort") Long ownerSort, @Param("replaceGroup") String replaceGroup);

/**
 * @param ownerSort 自己的排序
 * @param replaceGroup  自己所在分组
 * @return  下一条记录，如果没有返回空
 */
PdtReplaceItem getAfter(@Param("ownerSort") Long ownerSort, @Param("replaceGroup") String replaceGroup);

/**
 * @param replaceGroup 自己所在分组
 * @return 该分组最小的排序
 */
Long minSort(@Param("replaceGroup") String replaceGroup);

/**
 * @param replaceGroup 自己所在分组
 * @return 该分组最大的排序
 */
Long maxSort(@Param("replaceGroup") String replaceGroup);
```
```
//xml
<select id="getBefore" resultType="com.yk.i_wms.model.PdtReplaceItem">
	SELECT
		*
	FROM
		pdt_replace_item
	WHERE
		replace_group=#{replaceGroup}
	  AND #{ownerSort} > sort
	ORDER BY sort DESC,id DESC
	LIMIT 0,1;
</select>
<select id="getAfter" resultType="com.yk.i_wms.model.PdtReplaceItem">
	SELECT
		*
	FROM
		pdt_replace_item
	WHERE
		replace_group=#{replaceGroup}
	  AND sort > #{ownerSort}
	ORDER BY sort ASC,id ASC
	LIMIT 0,1;
</select>
<select id="minSort" resultType="java.lang.Long">
	select MIN(sort) from pdt_replace_item where replace_group=#{replaceGroup}
</select>
<select id="maxSort" resultType="java.lang.Long">
	select MAX(sort) from pdt_replace_item where replace_group=#{replaceGroup}
</select>
```
