#需要还原的文件列表
nowDate=$(date "+%Y%m%d")
read -p " 请输入你要还原的数据库容器中绝对路径(多个空格隔开):" datas
datas=${datas:-"/out/mysql8/all-db-$nowDate.sql"}
read -p " 数据库密码(脚本不记录):" password
password=${password:-"HBQ521521cf*"}
#遍历数据库进行还原
for i in $datas;  
do  
	nowTime=$(date "+%Y-%m %d-%H:%M:%S")
	echo "$nowTime: 还原$i数据库"
	docker exec mysql8 sh -c "mysql -uroot -p$password < $i";
done  
