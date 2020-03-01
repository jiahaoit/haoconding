记得chmod a+x haoCodingService给予权限。
好的，我们现在测试下，输入service haoCodingService start命令试试【注意：我的service脚本文件名称是haoCodingService，所以服务名就是文件名】

下面是微信公众号“浩Coding”的教程【Linux命令之Service —— 管理系统服务】内容：
service命令用于对系统服务进行管理，比如启动（start）、停止（stop）、重启（restart）、查看状态（status）等。
相关的命令还包括chkconfig、ntsysv等，chkconfig用于查看、设置服务的运行级别，ntsysv用于直观方便的设置各个服务是否自动启动。
service命令本身是一个shell脚本，它在/etc/init.d/目录查找指定的服务脚本，然后调用该服务脚本来完成任务。
这个命令不是在所有的linux发行版本中都有。主要是在redhat、fedora、mandriva和centos中。
常用的service命令：

重启MySQL：service mysqld restart

启动：service mysqld start

停止：service mysqld stop

查看状态：service mysqld status

查看所有服务的状态：service --status-all

重载配置：service mysqld reload【不同于重启，restart是重启了整个mysql服务，而reload则是重新加载了my.conf配置，也并不是每一个应用程序都有所谓的 reload 和 restart】



有兴趣的童鞋可以看下service脚本的源码：
tail /sbin/service


其实这个脚本service主要做了如下两点：
1.初始化执行环境变量PATH和TERM
PATH=/sbin:/usr/sbin:/bin:/usr/bin
TERM，为显示外设的值，一般为xterm
2.调用/etc/init.d/文件夹下的相应脚本，脚本的参数为service命令第二个及之后的参数
以service mysqld restart命令为例，其中restart为参数，将传递给mysqld脚本，这个命令在service执行到后面最终调用的是：
env -i PATH="$PATH" TERM="$TERM" "${SERVICEDIR}/${SERVICE}" ${OPTIONS}
 就相当于执行了：/etc/init.d/mysqld restart

最后附上超实用的Linux系统信息查看命令：

系统

# uname -a               # 查看内核/操作系统/CPU信息
# head -n 1 /etc/issue   # 查看操作系统版本
# cat /proc/cpuinfo      # 查看CPU信息
# hostname               # 查看计算机名
# lspci -tv              # 列出所有PCI设备
# lsusb -tv              # 列出所有USB设备
# lsmod                  # 列出加载的内核模块
# env                    # 查看环境变量
资源

# free -m                # 查看内存使用量和交换区使用量
# df -h                  # 查看各分区使用情况
# du -sh <目录名>        # 查看指定目录的大小
# grep MemTotal /proc/meminfo   # 查看内存总量
# grep MemFree /proc/meminfo    # 查看空闲内存量
# uptime                 # 查看系统运行时间、用户数、负载
# cat /proc/loadavg      # 查看系统负载
磁盘和分区

# mount | column -t      # 查看挂接的分区状态
# fdisk -l               # 查看所有分区
# swapon -s              # 查看所有交换分区
# hdparm -i /dev/hda     # 查看磁盘参数(仅适用于IDE设备)
# dmesg | grep IDE       # 查看启动时IDE设备检测状况
网络

# ifconfig               # 查看所有网络接口的属性
# iptables -L            # 查看防火墙设置
# route -n               # 查看路由表
# netstat -lntp          # 查看所有监听端口
# netstat -antp          # 查看所有已经建立的连接
# netstat -s             # 查看网络统计信息
进程

# ps -ef                 # 查看所有进程
# top                    # 实时显示进程状态
用户

# w                      # 查看活动用户
# id <用户名>            # 查看指定用户信息
# last                   # 查看用户登录日志
# cut -d: -f1 /etc/passwd   # 查看系统所有用户
# cut -d: -f1 /etc/group    # 查看系统所有组
# crontab -l             # 查看当前用户的计划任务
服务

# chkconfig --list       # 列出所有系统服务
# chkconfig --list | grep on    # 列出所有启动的系统服务
程序

# rpm -qa                # 查看所有安装的软件包

参考文章：
自定义Linux Service：
https://www.iteye.com/blog/momodog-286047

service命令：
https://www.cnblogs.com/wuheng1991/p/7064067.html

linux service命令解析（重要）：
https://www.cnblogs.com/qlqwjy/p/7746890.html
