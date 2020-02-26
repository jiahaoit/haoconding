#! /bin/sh
?
#�ȱ���Crontab����
crontab -l > /test/autoCheckIn/backCrontab/backCrontab-$(date +%Y-%m-%d).log
#֮��������Crontab����,��>���룬��;��������õ�ǩ��Crontab����
cat /test/autoCheckIn/importantCrontab.log > /var/spool/cron/root
?
#����ǩ��ʱ��д��lastDate.log�У�2020-02-24 11:50
signDate=$(date +%Y-%m-%d)' '$(date +%H:%M)
?
#��ȡ�ϴ�ִ��ʱ��
lastDate=$(cat /test/autoCheckIn/lastDate.log)
?
#�´�ִ�з���:1~30
nextMinute=`expr $(($RANDOM%30)) + 1`
#�´�ִ��Сʱ:1~2
nextHour=`expr $(($RANDOM%2)) + 1`
#�´�ִ��ʱ��
nextDate=$(date -d "$lastDate 1 days")
nextDate=$(date -d "$nextDate $nextHour hour")
nextDate=$(date -d "$nextDate $nextMinute minute" +"%Y%m%d%H%M")
#echo '�´�ִ��ʱ��nextDate='$nextDate
?
#�´�ǩ�������
#signYear=${nextDate: 0: 4}
#�´�ǩ�����·�
signMonth=${nextDate: 4: 2}
#�´�ǩ��������
signDay=${nextDate: 6: 2}
#�´�ǩ����Сʱ
signHour=${nextDate: 8: 2}
#�´�ǩ���ķ���
signMinute=${nextDate: 10: 2}
?
#�´�ǩ����־ʱ�� *��Ҫ���⴦������0-7��һ������˼
nextSignYear=$signMinute' '$signHour' '$signDay' '$signMonth' 0-7'
#echo 'nextSignYear='$nextSignYear
?
#��ʾ��ǰ��½���û�
user=root
#Crontab����·���൱��[crontab �Ce]
path=/var/spool/cron/
nextSignCrontab=' /test/autoCheckIn/autoCheckIn.sh'
#echo 'nextSignCrontab='$nextSignCrontab
#����crontab ���������ļ� >>��׷������
echo $nextSignYear$nextSignCrontab >> $path$user
?
#ǩ��ʧ�ܽ��
fail={"msg":"\u60a8\u4f3c\u4e4e\u5df2\u7ecf\u7b7e\u5230\u8fc7\u4e86...","ret":1}
#��ȡǩ�����+ִ��ǩ������
tmpResult=$(curl "http://f76c" -X POST -H "Connection: keep-alive" -H "Content-Length: 0" -H "Accept-Language: zh-CN,zh;q=0.9,en;q=0.8" -H "Cookie: yunsuo_session_verify=yunsuo_session; uid=12234; email=haocoding^%^net; key=lasd9yfnq2n2u9823h5nad" --compressed --insecure)
?
#ȡ��ǩ���ɹ�����У��ҵ��ĵ�һ��'MB'��������ַ�
tmpStr=${tmpResult%%MB*}
#ȡ����λ����MB[��������ĸ��ַ���ʼ��ȡ�����ַ�]
tmpStr2=${tmpStr: 0-4: 3}
#�ɹ�ǩ�����
successResult='����ǩ�������:'$tmpStr2'MB������'
?
if [ $fail = $tmpResult ]
then
  echo $signDate"��ǩ��ʧ�ܣ�" >> /test/autoCheckIn/autoCheckIn.log
else
  echo $signDate"��ǩ���ɹ���"$successResult >> /test/autoCheckIn/autoCheckIn.log
fi
?
#����ǩ���ɹ������ʱ�ȼ���ÿ�ζ�ǩ���ɹ�����Ȼ�´�ǩ��û������
echo $signDate > /test/autoCheckIn/lastDate.log
?
#����crontab����
sudo service crond restart