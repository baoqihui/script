# 数据库
datas="admin alist backend cms cms-plus demo student teacher wms"
# 备份文件存放地址(根据实际情况填写)
backup_location="/out/mysql"
# 是否删除过期数据
expire_backup_delete="ON"
expire_days=2
nowDate=$(date +%Y%m%d)

# 创建目录
mkdir -p $backup_location/$nowDate
for i in $datas;  
do  
	echo -e "备份$i数据库到'$backup_location/$nowDate/$i.sql'"
	docker exec -i mysql mysqldump -B $i > $backup_location/$nowDate/$i.sql
done  

# 删除过期数据
if [ "$expire_backup_delete" == "ON" -a  "$backup_location" != "" ];then
   find $backup_location/* -type d -mtime +1 | xargs rm -rf
   echo "Expired backup data delete complete!"
fi