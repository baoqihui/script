#需要还原的文件列表
read -p " 请输入你要还原的数据库(多个空格隔开):" datas
datas=${datas:-'admin alist backend cms cms-plus demo student teacher wms'}
#遍历数据库进行还原
for i in $datas;  
do  
	echo "$nowTime: 还原$i数据库"
	docker exec mysql sh -c 'mysql -uroot -pHBQ521521cf* < /out/mysql/20220412/$i.sql';
done  
