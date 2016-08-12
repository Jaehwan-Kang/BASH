#!/bin/sh

#####################################################################################################
#												    #
# Main187 -> /dream170/data/  ->  /daybackup/Dream170 , /weekbackup/Dream170, /monthbackup/Dream170 #
# Main187 -> /dream171/data/  ->  /daybackup/Dream171 , /weekbackup/Dream171, /monthbackup/Dream171 #
# Main187 -> /dream173/data/  ->  /daybackup/Dream173 , /weekbackup/Dream173, /monthbackup/Dream173 #
# Main187 -> /dream174/data/  ->  /daybackup/Dream174 , /weekbackup/Dream174, /monthbackup/Dream174 #
#												    #
#####################################################################################################

# Backup date
TODAY=`date +%Y%m%d`

# Chaerset setting
LANG=C

# DB servers
DB1="Dream170"
DB2="Dream171"
DB3="Dream173"
DB4="Dream174"

# Backup Directory
D="daybackup"
W="weekbackup"
M="monthbackup"


## Rsync database Before Dump backup 

rsync -avPz --delete --stats -l -t -e "ssh -p 212" 59.18.102.187:/data/dream170/ /dream170/data;
rsync -avPz --delete --stats -l -t -e "ssh -p 212" 59.18.102.187:/data/dream171/ /dream171/data;
rsync -avPz --delete --stats -l -t -e "ssh -p 212" 59.18.102.187:/data/dream173/ /dream173/data;
rsync -avPz --delete --stats -l -t -e "ssh -p 212" 59.18.102.187:/data/dream174/ /dream174/data;

/dream170/bin/mysqlcheck --auto-repair --extended --optimize -A --socket=/tmp/dream170/mysql.sock -pemflaalwm;
/dream171/bin/mysqlcheck --auto-repair --extended --optimize -A --socket=/tmp/dream171/mysql.sock -pemflaalwm;
/dream173/bin/mysqlcheck --auto-repair --extended --optimize -A --socket=/tmp/dream173/mysql.sock -pemflaalwm;
/dream173/bin/mysqlcheck --auto-repair --extended --optimize -A --socket=/tmp/dream173/mysql.sock -pemflaalwm;
/dream174/bin/mysqlcheck --auto-repair --extended --optimize -A --socket=/tmp/dream174/mysql.sock -pemflaalwm;


####  D U M P (schema + data)  ##########################
# 							#
# Month backup) date +%d = "01"  �� ���� (�ſ� 1��)     #
# Week backup)  date +%a = "Sun" �� ���� (���� �Ͽ���)	#
# day backup)   ���� ���츦 ���� �� ���� 		#
#							#
#########################################################


# database list create
ls /dream170/data | egrep -v "mysql-bin|ib_logfile|ibdata|slow_query|err|db.opt|slow.log|upgrade" > /root/$DB1.txt;
ls /dream171/data | egrep -v "mysql-bin|ib_logfile|ibdata|slow_query|err|db.opt|slow.log|upgrade" > /root/$DB2.txt;
ls /dream173/data | egrep -v "mysql-bin|ib_logfile|ibdata|slow_query|err|db.opt|slow.log|upgrade|_100813_suksukchina" > /root/$DB3.txt;
ls /dream174/data | egrep -v "mysql-bin|ib_logfile|ibdata|slow_query|err|db.opt|slow.log|upgrade" > /root/$DB4.txt;


# Month Backup
if [ "`date +%d`" = "01" ]
	then
	mkdir /$M/$DB1/$TODAY
	mkdir /$M/$DB2/$TODAY
	mkdir /$M/$DB3/$TODAY
	mkdir /$M/$DB4/$TODAY
	
		## Dream170 monthbackup
		for NAME in `cat /root/$DB1.txt`
			do
			/dream170/bin/mysqldump --socket=/tmp/dream170/mysql.sock --default-character-set=euckr --no-data --quote-names --lock-all-tables $NAME > /$M/$DB1/$TODAY/"$NAME"_schema.sql -pemflaalwm 2>/root/"$DB1"_"$TODAY"_log;
			/dream170/bin/mysqldump --socket=/tmp/dream170/mysql.sock --default-character-set=euckr --no-create-info --quote-names --lock-all-tables $NAME > /$M/$DB1/$TODAY/"$NAME"_data.sql -pemflaalwm 2>>/root/"$DB1"_"$TODAY"_log;
			done
			

		## Dream171 monthbackup
		for NAME in `cat /root/$DB2.txt`
			do
			/dream171/bin/mysqldump --socket=/tmp/dream171/mysql.sock --default-character-set=euckr --no-data --quote-names --lock-all-tables $NAME > /$M/$DB2/$TODAY/"$NAME"_schema.sql -pemflaalwm 2>/root/"$DB2"_"$TODAY"_log;
			/dream171/bin/mysqldump --socket=/tmp/dream171/mysql.sock --default-character-set=euckr --no-create-info --quote-names --lock-all-tables $NAME > /$M/$DB2/$TODAY/"$NAME"_data.sql -pemflaalwm 2>>/root/"$DB2"_"$TODAY"_log;
			done
			

		## Dream173 monthbackup
		for NAME in `cat /root/$DB3.txt`
			do
			/dream173/bin/mysqldump --socket=/tmp/dream173/mysql.sock --default-character-set=euckr --no-data --quote-names --lock-all-tables $NAME > /$M/$DB3/$TODAY/"$NAME"_schema.sql -pemflaalwm 2>/root/"$DB3"_"$TODAY"_log;
			/dream173/bin/mysqldump --socket=/tmp/dream173/mysql.sock --default-character-set=euckr --no-create-info --quote-names --lock-all-tables $NAME > /$M/$DB3/$TODAY/"$NAME"_data.sql -pemflaalwm 2>/root/"$DB3"_"$TODAY"_log;
			done
		
		## Dream174 monthbackup
		for NAME in `cat /root/$DB4.txt`
			do
			/dream174/bin/mysqldump --socket=/tmp/dream174/mysql.sock --default-character-set=euckr --no-data --quote-names --lock-all-tables $NAME > /$M/$DB4/$TODAY/"$NAME"_schema.sql -pemflaalwm 2>/root/"$DB4"_"$TODAY"_log;
			/dream174/bin/mysqldump --socket=/tmp/dream174/mysql.sock --default-character-set=euckr --no-create-info --quote-names --lock-all-tables $NAME > /$M/$DB4/$TODAY/"$NAME"_data.sql -pemflaalwm 2>/root/"$DB4"_"$TODAY"_log;
			done
		
		exit;	

# Week Backup
	elif [ "`date +%a`" = "Sun" ]
		then
		find /$W/$DB1 -type d -mtime +77 -exec rm -rf {} \;
		find /$W/$DB2 -type d -mtime +77 -exec rm -rf {} \;
		find /$W/$DB3 -type d -mtime +77 -exec rm -rf {} \;
		find /$W/$DB4 -type d -mtime +77 -exec rm -rf {} \;
		mkdir /$W/$DB1/$TODAY
		mkdir /$W/$DB2/$TODAY
		mkdir /$W/$DB3/$TODAY
		mkdir /$W/$DB4/$TODAY
			
		## Dream170 weekbackup
		for NAME in `cat /root/$DB1.txt`
			do
			/dream170/bin/mysqldump --socket=/tmp/dream170/mysql.sock --default-character-set=euckr --no-data --quote-names --lock-all-tables $NAME > /$W/$DB1/$TODAY/"$NAME"_schema.sql -pemflaalwm 2>/root/"$DB1"_"$TODAY"_log;
			/dream170/bin/mysqldump --socket=/tmp/dream170/mysql.sock --default-character-set=euckr --no-create-info --quote-names --lock-all-tables $NAME > /$W/$DB1/$TODAY/"$NAME"_data.sql -pemflaalwm 2>>/root/"$DB1"_"$TODAY"_log;
			done
			

		## Dream171 weekbackup
		for NAME in `cat /root/$DB2.txt`
			do
			/dream171/bin/mysqldump --socket=/tmp/dream171/mysql.sock --default-character-set=euckr --no-data --quote-names --lock-all-tables $NAME > /$W/$DB2/$TODAY/"$NAME"_schema.sql -pemflaalwm 2>/root/"$DB2"_"$TODAY"_log;
			/dream171/bin/mysqldump --socket=/tmp/dream171/mysql.sock --default-character-set=euckr --no-create-info --quote-names --lock-all-tables $NAME > /$W/$DB2/$TODAY/"$NAME"_data.sql -pemflaalwm 2>>/root/"$DB2"_"$TODAY"_log;
			done
			

		## Dream173 weekbackup
		for NAME in `cat /root/$DB3.txt`
			do
			/dream173/bin/mysqldump --socket=/tmp/dream173/mysql.sock --default-character-set=euckr --no-data --quote-names --lock-all-tables $NAME > /$W/$DB3/$TODAY/"$NAME"_schema.sql -pemflaalwm 2>/root/"$DB3"_"$TODAY"_log;
			/dream173/bin/mysqldump --socket=/tmp/dream173/mysql.sock --default-character-set=euckr --no-create-info --quote-names --lock-all-tables $NAME > /$W/$DB3/$TODAY/"$NAME"_data.sql -pemflaalwm 2>/root/"$DB3"_"$TODAY"_log;
			done
		
		## Dream174 weekbackup
		for NAME in `cat /root/$DB4.txt`
			do
			/dream174/bin/mysqldump --socket=/tmp/dream174/mysql.sock --default-character-set=euckr --no-data --quote-names --lock-all-tables $NAME > /$W/$DB4/$TODAY/"$NAME"_schema.sql -pemflaalwm 2>/root/"$DB4"_"$TODAY"_log;
			/dream174/bin/mysqldump --socket=/tmp/dream174/mysql.sock --default-character-set=euckr --no-create-info --quote-names --lock-all-tables $NAME > /$W/$DB4/$TODAY/"$NAME"_data.sql -pemflaalwm 2>/root/"$DB4"_"$TODAY"_log;
			done
		
		exit;	

# Day Backup
	else
		find /$D/$DB1 -type d -mtime +11 -exec rm -rf {} \;
		find /$D/$DB2 -type d -mtime +11 -exec rm -rf {} \;
		find /$D/$DB3 -type d -mtime +11 -exec rm -rf {} \;
		find /$D/$DB4 -type d -mtime +11 -exec rm -rf {} \;
		mkdir /$D/$DB1/$TODAY
		mkdir /$D/$DB2/$TODAY
		mkdir /$D/$DB3/$TODAY
		mkdir /$D/$DB4/$TODAY
			
		## Dream170 daybackup
		for NAME in `cat /root/$DB1.txt`
			do
			/dream170/bin/mysqldump --socket=/tmp/dream170/mysql.sock --default-character-set=euckr --no-data --quote-names --lock-all-tables $NAME > /$D/$DB1/$TODAY/"$NAME"_schema.sql -pemflaalwm 2>/root/"$DB1"_"$TODAY"_log;
			/dream170/bin/mysqldump --socket=/tmp/dream170/mysql.sock --default-character-set=euckr --no-create-info --quote-names --lock-all-tables $NAME > /$D/$DB1/$TODAY/"$NAME"_data.sql -pemflaalwm 2>>/root/"$DB1"_"$TODAY"_log;
			done
			

		## Dream171 daybackup
		for NAME in `cat /root/$DB2.txt`
			do
			/dream171/bin/mysqldump --socket=/tmp/dream171/mysql.sock --default-character-set=euckr --no-data --quote-names --lock-all-tables $NAME > /$D/$DB2/$TODAY/"$NAME"_schema.sql -pemflaalwm 2>/root/"$DB2"_"$TODAY"_log;
			/dream171/bin/mysqldump --socket=/tmp/dream171/mysql.sock --default-character-set=euckr --no-create-info --quote-names --lock-all-tables $NAME > /$D/$DB2/$TODAY/"$NAME"_data.sql -pemflaalwm 2>>/root/"$DB2"_"$TODAY"_log;
			done
			

		## Dream173 daybackup
		for NAME in `cat /root/$DB3.txt`
			do
			/dream173/bin/mysqldump --socket=/tmp/dream173/mysql.sock --default-character-set=euckr --no-data --quote-names --lock-all-tables $NAME > /$D/$DB3/$TODAY/"$NAME"_schema.sql -pemflaalwm 2>/root/"$DB3"_"$TODAY"_log;
			/dream173/bin/mysqldump --socket=/tmp/dream173/mysql.sock --default-character-set=euckr --no-create-info --quote-names --lock-all-tables $NAME > /$D/$DB3/$TODAY/"$NAME"_data.sql -pemflaalwm 2>/root/"$DB3"_"$TODAY"_log;
			done

		## Dream174 daybackup
		for NAME in `cat /root/$DB4.txt`
			do
			/dream174/bin/mysqldump --socket=/tmp/dream174/mysql.sock --default-character-set=euckr --no-data --quote-names --lock-all-tables $NAME > /$D/$DB4/$TODAY/"$NAME"_schema.sql -pemflaalwm 2>/root/"$DB4"_"$TODAY"_log;
			/dream174/bin/mysqldump --socket=/tmp/dream174/mysql.sock --default-character-set=euckr --no-create-info --quote-names --lock-all-tables $NAME > /$D/$DB4/$TODAY/"$NAME"_data.sql -pemflaalwm 2>/root/"$DB4"_"$TODAY"_log;
			done

fi

### ErrorLog Mailing ###

LOG=`cat /root/"$DB1"_"$TODAY"_log`
LOG2=`cat /root/"$DB2"_"$TODAY"_log`
LOG3=`cat /root/"$DB3"_"$TODAY"_log`
LOG4=`cat /root/"$DB4"_"$TODAY"_log`

if [ "$LOG" != "" -o "$LOG2" != "" -o "$LOG3" != "" -o "$LOG4" != "" ]
	then
	echo "=== $DB1 Dump error ==========================================================" > /root/total_"$TODAY"_log
	cat /root/"$DB1"_"$TODAY"_log >> /root/total_"$TODAY"_log
	echo "" >> /root/total_"$TODAY"_log
	echo "=== $DB2 Dump error ==========================================================" >> /root/total_"$TODAY"_log
	cat /root/"$DB2"_"$TODAY"_log >> /root/total_"$TODAY"_log
	echo "" >> /root/total_"$TODAY"_log
	echo "=== $DB3 Dump error ==========================================================" >> /root/total_"$TODAY"_log
	cat /root/"$DB3"_"$TODAY"_log >> /root/total_"$TODAY"_log
	echo "=== $DB4 Dump error ==========================================================" >> /root/total_"$TODAY"_log
	cat /root/"$DB4"_"$TODAY"_log >> /root/total_"$TODAY"_log
	echo ""

	mail -s DB_dump_backup -f /root/total_"$TODAY"_log system@dreammiz.com

fi

