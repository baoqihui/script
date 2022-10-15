#15 0 * * * bash /root/backup-rclone.sh > /out/backup-rclone.log 2&1 &
#需要备份的目录，多个空格隔开
datas="/opt /out/mysql /out/mysql7 /out/mysql8"
#备份文件生成路径
outdir="/opt/data/backup"

#记录当前时间
nowTime=$(date "+%Y-%m %d-%H:%M:%S")
# 删除原有内容并创建目录
rm -rf $outdir
mkdir -p $outdir

#遍历目录进行压缩备份
for i in $datas;
do
	fileName=${i##*/}
	outfilePath=$outdir/$fileName.zip
	zip -r $outfilePath $i
	echo "打包$fileName到$outfilePath完成..."
done
rclone sync -v $outdir onedrive:backup --onedrive-chunk-size 100M --cache-chunk-size 50M --log-file=/out/backup-rclone.log
echo "$nowTime: $outdir备份完成..."