#!/bin/sh
DATE=`date +%Y%m%d`
DELDATE=`date --date "30 day ago" +%Y%m%d`
mkdir /Backup/web/creditform/$DATE
mkdir /Backup/web/oco/$DATE
mkdir /Backup/web/pubso/$DATE
rsync -arlz 115.165.180.76::creditform /Backup/web/creditform/$DATE
rsync -arlz 115.165.180.76::oco /Backup/web/oco/$DATE
rsync -arlz 115.165.180.76::pubso /Backup/web/pubso/$DATE
rm -rf /Backup/web/creditform/${DELDATE}
rm -rf /Backup/web/oco/${DELDATE}
rm -rf /Backup/web/pubso/${DELDATE}
