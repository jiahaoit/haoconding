【Shell脚本实现随机时间内签到】
基本思路：
①CRUL命令自动签到，记录签到结果到autoCheckIn.log。
②签到成功与否都要记录下签到时间，写入lastDate.log。
③根据lastDate.log取出上次签到的时间，加上($RANDOM%)随机函数生成下次签到时间。
④根据下次签到时间生成Crontab命令并写入。
⑤【视情况决定是否启用】备份Crontab命令，之后导入必需的Crontab命令,用>导入，用途是清空无用的每次签Crontab命令。
如果大家有不懂的地方可以看这篇文章，里面有这个Shell脚本的所有知识点：【程序猿硬核科普】Linux下Shell编程杂记
