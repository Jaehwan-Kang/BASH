#!/bin/sh
#
# shortUrl database backup scripts. (jaehwan Kang)
# [CAUTION] 
# mysql     => MyISAM storage Engine
# shortUrl  => InnoDB storage Engine
#
#
#
#   v0.1(2019-01-09)    - default scripts
#   v0.2(2019-01-09)    - date +%d == 01  → monthly backup
#                       - date +%a == Fri → weekly backup
#                       - etc             → daily backup
#                       - 우선 순위 01 > Fri > etc
#
#

# DataBase Directory
_DBDIR="/Mysql_DATA"


# Backup Directory
_D_BackDIR="/Backup/daily"
_W_BackDIR="/Backup/weekly"
_M_BackDIR="/Backup/monthly"


# DB dump database Name
# 
# ex) "database name"
# ex) _DB_target="mysql,dasd,fhaujk.dweq"
_DB_target="mysql"

# DATABASE ROOT PassWORD
_DB_PW=""


# Backup DATE TIME  ( excute 15:00 -> DATE time is 14:00 )
_BackDATE="`date +%y%m%d"_"%H -d '1 hour ago'`"



# Storage Engine Dump query
_mYisam_q="/usr/local/mysql/bin/mysqldump"
_iNnodb_q="/usr/local/mysql/bin/mysqldump --single-transaction --routines"

# DB check
/usr/local/mysql/bin/mysqlcheck --auto-repair --extended --optimize -A -p$_DB_PW;

# FUNCTION
dbbackup () {
	# make backup directory
	/usr/bin/mkdir -p $1/$_BackDATE;
	
	# target database or table parsing
	_DB_target_NUM="`echo $_DB_target | awk -F, '{print NF}'`"

	# DUMP Backup
	for (( i=1; i<=$_DB_target_NUM; i++))
		do

        # dump backup targeting
		_DUMP_target="`echo $_DB_target | awk -F, '{ print $'$i' }'`"
		
		# dump backup table targeting
        /usr/local/mysql/bin/mysql -D$_DUMP_target -e "select TABLE_NAME, ENGINE from information_schema.TABLES where TABLE_SCHEMA='$_DUMP_target';" -p$_DB_PW | sed '1d' | awk '{print $1":"$2}'> $_DBDIR/temp.txt
                
        for _chk in `cat $_DBDIR/temp.txt`
            do
            _table=`echo $_chk|awk -F: '{print $1}'`;
            _engine=`echo $_chk|awk -F: '{print $2}'`;

            # engine by dump query
            if [ "$_engine" == "MyISAM" ]
                then
                    _query=$_mYisam_q;
                    $_query -B $_DUMP_target --tables $_table > $1/$_BackDATE/$_DUMP_target\.$_table.sql -p$_DB_PW;
                else
                    _query=$_iNnodb_q;
                    $_query -B $_DUMP_target --tables $_table > $1/$_BackDATE/$_DUMP_target\.$_table.sql -p$_DB_PW;
            fi
            done
		done
	}

# DB Backup
if [ "`date +%d`" = "01" ]
 	then
 	dbbackup $_M_BackDIR;
	
 	elif [ "`date +%a`" = "Fri" ]
 		then
 		dbbackup $_W_BackDIR;
 	else
 		dbbackup $_D_BackDIR;

fi	

# ## Old Backup Delete
/usr/bin/find $_D_BackDIR -type d -mtime +28 -exec rm -rf {} \;
