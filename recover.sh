read -p " 起始根目录:" B1
B1=/${B1:-'Backup'}
read -p " 起始次级目录:" B2
B2=/${B2}
read -p " 目标路径:" B3
B3=${B3}
echo -e "\033[32m ${B1}${B2}->${B3} \033[0m"
./aliyunpan d ${B1}${B2} --saveto ${B3}
mv -f ${B3}${B1}${B2}/* ${B3} && rm -r ${B3}${B1} && rm -r ${B3}${B2}
