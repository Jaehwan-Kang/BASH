#!/bin/sh
#
# Connect to check website all : apache
# Add to Delete ^M : perl -i -pe 's/\015//g'

# Update by 2014.03 mnnclub@x-y.com
#set -x

TIME=`date +%Y%m%d_%H%M`

[ ! -e "/usr/bin/curl" ] && yum -y install curl
[ ! -e "/usr/bin/curl" ] && exit

cd /www/logs/
find ./ -name "web_status_*" -mtime +1 -exec rm -f {} \;

## Read Domain list for last 10
for DOM in `egrep '^ServerName' /www/conf/httpd.conf|awk '{print $2}'|egrep -v 'webmail'|tail -10|perl -i -pe 's/\015//g'`;do
        curl --connect-timeout 2 -s "$DOM" >/dev/null && echo "$DOM : GOOD" || echo "$DOM : BAD"
done >> web_status_${TIME}

## If no exist for good status, apache restart
if [ `egrep ': GOOD' web_status_${TIME}|wc -l` -lt 2 ];then

        wall "[Apache_Failover] Try to fix Apache Problem"

        # apachectl configtest failed, cp backup httpd.conf
        /www/bin/apachectl configtest || wall "[Apache_Failover] Failed configtest, cp backup/httpd.conf"
        /www/bin/apachectl configtest || cp -Rfp /home/01/backup/httpd.conf /www/conf/httpd.conf

	# If failed restart, delete /www/logs/*
        /www/bin/apachectl restart && wall "[Apache_Failover] Restart OK" || rm -rf /www/logs/*log* /www/logs/cgisock.*
        sleep 5

#        /www/bin/apachectl restart && wall "[Apache_Failover] Restart OK" || wall "[Apache_Failover] Failed Restore, Check please!!"


	# If 3 times fail log exist in 3 min, kill each process
	if [ `find /www/logs/ -name "web_status_*" -cmin -3 |wc -l` -eq 3 ];then
		ps auxfw |grep http|grep -v grep|awk '{print $2}'|xargs kill -9 && wall "[Apache_Failover] Restore failed! kill apache process"
		rm -f web_status_${TIME}	
	fi
	

else
	# If stable, delete log file
        rm -f web_status_${TIME}
fi
