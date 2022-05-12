#需要还原的文件列表
read -p " 请输入你要还原的文件绝对路径(多个空格隔开):" datas
datas=${datas:-'/backup/opt.zip /backup/mysql.zip /backup/mysql7.zip /backup/mysql8.zip'}
#还原位置
outDir="/out/recover"
mkdir -p $outDir

for i in $datas;  
do  
	nowTime=$(date "+%Y-%m %d-%H:%M:%S")
	#获取文件名字
	fileName=${i##*/}
	#最终的文件存放路径
	outFilePath=$outDir/$fileName
	#阿里云盘下载
	rclone sync cch2:$i $outDir
	echo -e "\033[32m 下载$i到$outFilePath完成... \033[0m"
	#zip解压
	unzip -o -d / $outFilePath 
	echo -e "\033[32m $nowTime: $i还原完成!!! \033[0m"
done 
