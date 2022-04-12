#需要还原的文件列表
nowDate=$(date "+%Y%m%d")
read -p " 请输入你要还原的数据库容器中绝对路径(多个空格隔开):" datas
datas=${datas:-"/out/mysql/all-db-$nowDate.sql"}
#遍历数据库进行还原
for i in $datas;  
do  
	nowTime=$(date "+%Y-%m %d-%H:%M:%S")
	echo "$nowTime: 还原$i数据库"
	docker exec mysql sh -c "mysql -uroot -pHBQ521521cf* < $i";
done  
