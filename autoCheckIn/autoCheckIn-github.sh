#! /bin/sh
?
#先备份Crontab命令
crontab -l > /test/autoCheckIn/backCrontab/backCrontab-$(date +%Y-%m-%d).log
#之后导入必需的Crontab命令,用>导入，用途是清空无用的签到Crontab命令
cat /test/autoCheckIn/importantCrontab.log > /var/spool/cron/root
?
#本次签到时间写到lastDate.log中：2020-02-24 11:50
signDate=$(date +%Y-%m-%d)' '$(date +%H:%M)
?
#获取上次执行时间
lastDate=$(cat /test/autoCheckIn/lastDate.log)
?
#下次执行分钟:1~30
nextMinute=`expr $(($RANDOM%30)) + 1`
#下次执行小时:1~2
nextHour=`expr $(($RANDOM%2)) + 1`
#下次执行时间
nextDate=$(date -d "$lastDate 1 days")
nextDate=$(date -d "$nextDate $nextHour hour")
nextDate=$(date -d "$nextDate $nextMinute minute" +"%Y%m%d%H%M")
#echo '下次执行时间nextDate='$nextDate
?
#下次签到的年份
#signYear=${nextDate: 0: 4}
#下次签到的月份
signMonth=${nextDate: 4: 2}
#下次签到的日期
signDay=${nextDate: 6: 2}
#下次签到的小时
signHour=${nextDate: 8: 2}
#下次签到的分钟
signMinute=${nextDate: 10: 2}
?
#下次签到日志时间 *需要特殊处理，换成0-7是一样的意思
nextSignYear=$signMinute' '$signHour' '$signDay' '$signMonth' 0-7'
#echo 'nextSignYear='$nextSignYear
?
#表示当前登陆的用户
user=root
#Crontab命令路径相当于[crontab –e]
path=/var/spool/cron/
nextSignCrontab=' /test/autoCheckIn/autoCheckIn.sh'
#echo 'nextSignCrontab='$nextSignCrontab
#生成crontab 任务配置文件 >>是追加内容
echo $nextSignYear$nextSignCrontab >> $path$user
?
#签到失败结果
fail={"msg":"\u60a8\u4f3c\u4e4e\u5df2\u7ecf\u7b7e\u5230\u8fc7\u4e86...","ret":1}
#读取签到结果+执行签到命令
tmpResult=$(curl "http://f76c" -X POST -H "Connection: keep-alive" -H "Content-Length: 0" -H "Accept-Language: zh-CN,zh;q=0.9,en;q=0.8" -H "Cookie: yunsuo_session_verify=yunsuo_session; uid=12234; email=haocoding^%^net; key=lasd9yfnq2n2u9823h5nad" --compressed --insecure)
?
#取得签到成功结果中：找到的第一个'MB'左边所有字符
tmpStr=${tmpResult%%MB*}
#取得三位数的MB[从右起第四个字符开始截取三个字符]
tmpStr2=${tmpStr: 0-4: 3}
#成功签到结果
successResult='本次签到获得了:'$tmpStr2'MB流量。'
?
if [ $fail = $tmpResult ]
then
  echo $signDate"：签到失败！" >> /test/autoCheckIn/autoCheckIn.log
else
  echo $signDate"：签到成功！"$successResult >> /test/autoCheckIn/autoCheckIn.log
fi
?
#不管签到成功与否，暂时先假设每次都签到成功，不然下次签到没法进行
echo $signDate > /test/autoCheckIn/lastDate.log
?
#重启crontab命令
sudo service crond restart