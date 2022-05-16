#备份数据库名字
name="all-db"
# 备份文件存放地址(根据实际情况填写)
outDir="/out/mysql8"
# 是否删除过期数据
need_delete="ON"
#过期时长，单位 天
expire_days=7
#记录当前时间
nowTime=$(date "+%Y%m%d")
#最终文件名
finalName=$name-$nowTime.sql
#最终文件路径
finalPath=$outDir/$finalName

# 创建目录
mkdir -p $outDir

#进行备份
echo "$nowTime: 备份所有数据库到：$finalPath"
#docker exec -i mysql8 mysqldump -A > $finalPath


# 删除过期数据
if [ "$need_delete" == "ON" -a  "$outDir" != "" ];then
   find $outDir -type f -mtime +$[expire_days-2] | xargs rm -rf
   echo "$nowTime: Expired backup data delete complete!"
fi