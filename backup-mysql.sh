# 需要备份的数据库目录，多个空格隔开
datas="demo"
# 备份文件存放地址(根据实际情况填写)
outDir="/out/mysql"
# 是否删除过期数据
need_delete="ON"
#过期时长，单位 天
expire_days=2
#当前日期，用于生成目录
nowDate=$(date "+%Y%m%d")
#记录当前时间
nowTime=$(date "+%Y-%m %d-%H:%M:%S")
#mysql密码
password="123456"
# 创建目录
mkdir -p $outDir/$nowDate

#遍历数据库进行备份
for i in $datas;  
do  
	echo "$nowTime: 备份$i数据库到'$outDir/$nowDate/$i.sql'"
	docker exec -i mysql mysqldump -uroot -p$password -B $i > $outDir/$nowDate/$i.sql
done  

# 删除过期数据
if [ "$need_delete" == "ON" -a  "$outDir" != "" ];then
   find $outDir/* -type d -mtime +$expire_days | xargs rm -rf
   echo "$nowTime: Expired backup data delete complete!"
fi
