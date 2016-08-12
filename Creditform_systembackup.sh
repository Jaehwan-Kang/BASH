#!/bin/sh
DATE=`date +%Y%m%d`
DELDATE=`date --date "30 day ago" +%Y%m%d`
mkdir /Backup/system/$DATE
rsync -arlz 115.165.180.68::system /Backup/system/$DATE
rm -rf /Backup/system/${DELDATE}
