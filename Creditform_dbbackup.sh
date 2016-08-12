#!/bin/sh
#
# CreditFORM database backup scripts.  (Jaehwan. Kang)
# [CAUTION] MyISAM storage Engine BACKUP
#
#   v0.1(2016-04-21)  default scripts
#   v0.2(2016-04-22)  add database,table naming logic
#                     monthly, weekly, hourly backup 
#
#
#

# DataBase Directory
_DBDIR="/DATA/mysql_data"

# Backup Directory
_M_BackDIR="/DATA/backup/monthly"
_W_BackDIR="/DATA/backup/weekly"
_H_BackDIR="/DATA/backup/hourly"

# Backup DATE TIME  ( excute 15:00 -> DATE time is 14:00 )
_BackDATE="`date +%y%m%d"_"%H -d '1 hour ago'`"

# DATABASE PassWORD
_DB_PW="inity)(*&"


# DB dump target 
#
# ex) "database name"
#     "database name.table name"
#     "database name,database name,database name.table name" 
#    
#_DB_target="mysql.user,crediftorm,dasd,fhaujk.dweq"
_DB_target="mysql,crediftorm,crediftorm_push"

# DB stop
/usr/bin/systemctl stop mariadb;sleep 2;

# DB DATA SYNC (option -P  =  progress)
/usr/bin/rsync -az --delete 115.165.180.85::DB $_DBDIR

# DB start
/usr/bin/systemctl start mariadb;sleep 2;

# DB check
/usr/bin/mysqlcheck --auto-repair --extended --optimize -A -p$_DB_PW;



# FUNCTION
dbbackup () {
	# make backup directory
	/usr/bin/mkdir -p $1/$_BackDATE;
	
	# target database or table parsing
	_DB_target_NUM="`echo $_DB_target | awk -F, '{print NF}'`"

	# DUMP Backup
	for (( i=1; i<=$_DB_target_NUM; i++))
		do
		_DUMP_target="`echo $_DB_target | awk -F, '{ print $'$i' }'`"
		
		# tables backup
		if [ "`echo $_DUMP_target | grep "\."`" != "" ]
			then
			_database="`echo $_DUMP_target | awk -F. '{print $1}'`"
			_table="`echo $_DUMP_target | awk -F. '{print $2}'`"
			/usr/bin/mysqldump -B $_database --tables $_table > $1/$_BackDATE/$_DUMP_target\.sql -p$_DB_PW;
			else
				# database backup
				for S in `/usr/bin/mysql -e "use $_DUMP_target;show tables;" -p$_DB_PW | tail -n +2`
				do
				/usr/bin/mysqldump -B $_DUMP_target --tables $S > $1/$_BackDATE/$_DUMP_target\.$S\.sql -p$_DB_PW;
				done

		fi
		done
	}

# DB Backup
if [ "`date +%d`" = "01" -a "`date +%H`" = "06" ]
	then
	dbbackup $_M_BackDIR;
	
	elif [ "`date +%a`" = "Tue" -a "`date +%H`" = "06" ]
		then
		dbbackup $_W_BackDIR;
	else
		dbbackup $_H_BackDIR;

fi	

## Old Backup Delete
/usr/bin/find $_H_BackDIR -type d -mtime +6 -exec rm -rf {} \;
