read -r " 请输入你要还原的数据库容器名:" name
name=${name:-"mysql"}
#需要还原的文件列表
nowDate=$(date "+%Y%m%d")
read -r " 请输入你要还原的数据库容器中绝对路径(多个空格隔开):" datas
datas=${datas:-"/out/mysql/all-db-$nowDate.sql"}
read -r " 请输入数据库密码(脚本不记录):" password
password=${password:-"HBQ521521cf*"}
#遍历数据库进行还原
for i in $datas;
do  
	nowTime=$(date "+%Y-%m %d-%H:%M:%S")
	echo "$nowTime: 还原 $i 数据库到 $name 容器中"
	docker exec "$name" sh -c "mysql -uroot -p$password < $i";
done  
