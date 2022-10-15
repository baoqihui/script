#15 3 * * * bash /root/sync.sh > /out/sync.log 2&1 &
#需要备份的目录，多个空格隔开
# 全量："备份 毕设 公司 面试简历 软件 学习 雪 影音 backup Desktop Documents Downloads Hexo uTools"
# 无需备份="备份 毕设 公司 面试简历 学习 影音 uTools"
datas="软件 雪 backup Desktop Documents Downloads Hexo"

#记录当前时间
nowTime=$(date "+%Y-%m %d-%H:%M:%S")

#遍历目录进行压缩备份
for i in $datas;
do
 	echo "$nowTime: $i开始备份..."
 	rclone sync -v onedrive:$i ali:$i --onedrive-chunk-size 100M --cache-chunk-size 50M --log-file=/out/sync.log
 	echo "$nowTime: $i备份完成..."
done

