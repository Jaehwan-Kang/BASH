#!/bin/bash
#
# Default script Ver 1.0
#
# kjh@j2cns.com  2011-04-12
#
########################## ERROR LOG FILE ################################
#  1. 최초 입력된 값에 대한 로그   ->   /root/setting.log
#  2. mysql confiure error log     ->   /usr/local/src/mysql/mysql.err
#  3. apache confiure error log    ->   /usr/local/src/httpd/apache.err
#  4. php configure error log      ->   /usr/local/src/php/php.err
#
#
#
#
########################## Add setting ###################################
#  Ver 1.1  히스토리 사이즈 조정        1000 -> 100     	2011-04-13 
#  Ver 1.2  서버 타입에 따른 PHP 설치 수정              	2011-04-15   
#  Ver 1.3  Whistl 설치 여부 추가                       	2011-04-18
#  Ver 1.4  일반계정으로 Root 권한 취득하는 취약점 패치 	2011-05-31
#  Ver 1.5  GeoIP 설치여부                              	2011-06-03
#  Ver 1.6  error log 에 대한 주석설명 추가             	2011-06-05
#  Ver 1.7  명령어 추가 권한 조정                       	2011-06-20
#  Ver 1.8  CentOS 6.0 에서의 libmcrypt 소스설치로 변경 	2011-08-02
#  Ver 1.9  VIM 색상 설정                               	2011-08-02
#  Ver 2.0  CentOS 6.0 / VIM 부분 주석처리  		    	2011-10-28
#  Ver 2.1  php 설치위한 기본라이브러리 phpsetup.sh에 추가 


echo "=================S=T=A=R=T=================" | grep --color "[=]"
echo -n "   1. Mysql Password: "
        read DBPW
echo -n "   2. Mysql Charset(euckr/utf8): "
        read DBCHAR
echo -n "   3. Apache MPM type(prefork/worker): "
        read MPM
echo -n "   4. Php install bit?(32/64): "
        read BIT
echo -n "   5. Server Type?(total,web,db,img): "
        read TYPE
echo -n "   6. WHISTL setup?(y/n): "
        read WHI
echo -n "   7. GeoIP install?(y/n): "
        read GEO
echo "===========================================" | grep --color "[=]"
echo "   1. Mysql Password     :  $DBPW     " | grep --color "[:]"
echo "   2. Mysql Charset      :  $DBCHAR   " | grep --color "[:]"
echo "   3. Apache MPM type    :  $MPM      " | grep --color "[:]"
echo "   4. Php install BIT    :  $BIT      " | grep --color "[:]"
echo "   5. Server Type        :  $TYPE  " | grep --color "[:]"
echo "   6. WHISTL Setup       :  $WHI  " | grep --color "[:]"
echo "   7. GeoIP install      :  $GEO  " | grep --color "[:]"
echo "===========================================" | grep --color "[=]"
echo -n " Is that correct?(y/n): "
        read ANS

if [ "$ANS" = "y" -o "$ANS" = "Y" ]
        then
# recording options 
echo " $DBPW , $DBCHAR , $MPM , $BIT, $TYPE "  > /root/setting.log

# VSFTP setting
#cd /etc/vsftpd
#mv vsftpd.conf vsftpd.conf_old
#wget http://setting.j2.co.kr/setting/vsftpd.conf
#/etc/rc.d/init.d/vsftpd restart 2>/root/vsftp.err

# SSH setting
#cd /etc/ssh
#mv sshd_config sshd_config_old
#wget http://setting.j2.co.kr/setting/sshd_config
#/etc/rc.d/init.d/sshd restart

# Vim setting
#cd /usr/local/src
#wget http://setting.j2.co.kr/setting/vim-7.0.tar
#tar xvf vim-7.0.tar
#cd vim70
#./configure
#make
#make install
#cd src
#mv /bin/vi /bin/vi_old
#cp -Rfp vim /bin/vi
#cp -Rfp vim /usr/local/bin
yum -y install vim-enhanced
cd /root; mv .vimrc .vimrc_old
wget setting.j2.co.kr/setting/vimrc; mv vimrc .vimrc
mv /bin/vi /bin/vi_old; cp /usr/bin/vim /bin/vi

# Support package setting
#yum -y install kernel-devel
yum -y install gcc* cpp* compat-gcc* flex*
yum -y install libjpeg* libpng* freetype* gd-* libxml* zlib* libcrypt*
yum -y install libmcrypt libmcrypt-devel
yum -y install expect

# CentOS 6.0 에서의 libmcrypt 소스설치로 변경
#cd /usr/local/src
#wget setting.j2.co.kr/setting/libmcrypt-2.5.8.tar.gz
#tar zxvf libmcrypt-2.5.8.tar.gz
#cd libmcrypt-2.5.8
#./confgiure --prefix=/usr/local; make; make install
#cd libltd; ./configure --enable-ltdl-install; make; make install


# ROOT exploit patch
yum -y install yum-security
yum -y install glibc

echo "==================== Default package setup Clear==============" | grep --color "[=]"

# 루트 패스워드 재지정
#pw() {
#       sleep 2;echo "$PW"
#       sleep 2;echo "$PW"
#       }
#       pw | passwd root

# 로그인시 확인 사항 출력

echo "# Check Size " >> /root/.bash_profile
echo "echo \"Filesystem            Size  Used Avail Use% Mounted on\"" >> /root/.bash_profile
echo "df -h | grep --color "[0-9]"" >> /root/.bash_profile

# Selinux

setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

# Service Stop
echo "==================== Service stop ============================" | grep --color "[=]"
service acpid stop
service anacron stop
service apmd stop
service atd stop 
service auditd stop
service autofs stop
service avahi-daemon stop
service avahi-dnsconfd stop
service bluetooth stop
service cpuspeed stop
service cups stop
service firstboot stop
service gpm stop
service hidd stop
service ip6tables stop
service lvm2-monitor stop
service mcstrans stop
service mdmonitor stop
service netfs stop
service nfslock stop
service portmap stop
service rawdevices stop
service restorecond stop
service rpcidmapd stop
service rpcgssd stop
service rpcsvcgssd stop
service setroubleshoot stop
service xfs stop 
service xinetd stop 
service httpd stop
service sendmail stop

echo "===================== service stop finish =====================" | grep --color "[=]"

echo "===================== service runlevel set ====================" | grep --color "[=]"
# not service daemon OFF 
chkconfig --level 2345 acpid off
chkconfig --level 2345 anacron off
chkconfig --level 2345 apmd off
chkconfig --level 2345 atd off
chkconfig --level 2345 auditd off
chkconfig --level 2345 autofs off
chkconfig --level 2345 avahi-daemon off
chkconfig --level 2345 avahi-dnsconfd off
chkconfig --level 2345 bluetooth off
chkconfig --level 2345 cpuspeed off
chkconfig --level 2345 cups off
chkconfig --level 2345 firstboot off
chkconfig --level 2345 gpm off
chkconfig --level 2345 hidd off
chkconfig --level 2345 ip6tables off
chkconfig --level 2345 lvm2-monitor off
chkconfig --level 2345 mcstrans off
chkconfig --level 2345 mdmonitor off
chkconfig --level 2345 netfs off
chkconfig --level 2345 nfslock off
chkconfig --level 2345 portmap off
chkconfig --level 2345 rawdevices off
chkconfig --level 2345 restorecond off
chkconfig --level 2345 rpcidmapd off 
chkconfig --level 2345 rpcgssd off
chkconfig --level 2345 rpcsvcgssd off
chkconfig --level 2345 setroubleshoot off
chkconfig --level 2345 xfs off
chkconfig --level 2345 xinetd off
chkconfig --level 35 vsftpd on
chkconfig --level 2345 sendmail off 
echo "===================== service runlevel set clear ==============" | grep --color "[=]"

# Time Set 

rdate -s time.bora.net
echo "===================== Time set clear =========================" | grep --color "[=]"
# Delete User & Group 

for A in adm lp news uucp operrator games gopher rpc dovecot rpcuser nfsnobody xfs
        do
        userdel $A
        done

for B in adm lp news uucp games dip
        do
        groupdel $B
        done

echo "==================== Delete user and group clear =============" | grep --color "[=]"

# Remove SUID

chmod u-s /bin/umount
chmod u-s /bin/ping6
chmod u-s /bin/mount
chmod u-s /bin/su

chmod u-s /sbin/umount.nfs4
chmod u-s /sbin/mount.ecryptfs_private
chmod u-s /sbin/mount.nfs
chmod u-s /sbin/unix_chkpwd
chmod u-s /sbin/mount.nfs4
chmod u-s /sbin/umount.nfs
chmod u-s /sbin/pam_timestamp_check

chmod u-s /usr/bin/passwd
chmod u-s /usr/bin/chfn
chmod u-s /usr/bin/chsh
chmod u-s /usr/bin/chage
chmod u-s /usr/bin/at  
chmod u-s /usr/bin/Xorg
chmod u-s /usr/bin/sudo 
chmod u-s /usr/bin/gpasswd
chmod u-s /usr/bin/rsh 
chmod u-s /usr/bin/crontab
chmod u-s /usr/bin/rlogin
chmod u-s /usr/bin/newgrp
chmod u-s /usr/bin/sudoedit
chmod u-s /usr/bin/staprun
chmod u-s /usr/bin/rcp

chmod u-s /usr/sbin/userhelper
chmod u-s /usr/sbin/ccreds_validate
chmod u-s /usr/sbin/suexec    
chmod u-s /usr/sbin/usernetctl

chmod u-s /usr/kerberos/bin/ksu

echo "==================== SUID Remove clear ======================" | grep --color "[=]"

# APM setting

        if [ "$TYPE" = "total" ]
                then
                cd /root
                wget http://setting.j2.co.kr/setting/mysqlsetup.sh
                chmod 700 /root/mysqlsetup.sh
                sh mysqlsetup.sh $DBPW $DBCHAR; 

                cd /root
                wget http://setting.j2.co.kr/setting/apachesetup.sh
                chmod 700 /root/apachesetup.sh
                sh /root/apachesetup.sh $MPM;

                cd /root
                wget http://setting.j2.co.kr/setting/phpsetup.sh
                chmod 700 /root/phpsetup.sh
                sh /root/phpsetup.sh $BIT $MPM $TYPE;
        elif [ "$TYPE" = "web" -o "$TYPE" = "img" ]
                        then
                                #cd /root
                                #wget http://setting.j2.co.kr/setting/mysqlsetup.sh
                                #chmod 700 /root/mysqlsetup.sh
                                #sh mysqlsetup.sh $DBPW $DBCHAR; 

                                cd /root
                                wget http://setting.j2.co.kr/setting/apachesetup.sh
                                chmod 700 /root/apachesetup.sh
                                sh /root/apachesetup.sh $MPM

                                cd /root
                                wget http://setting.j2.co.kr/setting/phpsetup.sh
                                chmod 700 /root/phpsetup.sh
                                sh /root/phpsetup.sh $BIT $MPM $TYPE;
        elif [ "$TYPE" = "db" ]
                        then
                                cd /root
                                wget http://setting.j2.co.kr/setting/mysqlsetup.sh
                                chmod 700 /root/mysqlsetup.sh
                                sh mysqlsetup.sh $DBPW $DBCHAR; 
        fi

# Change Permision

chmod -R 700 /etc/rc.d/init.d/*

chmod 700 /bin/*
chmod 700 /sbin/*
chmod 700 /usr/bin/*
chmod 700 /usr/sbin/*

chmod 711 /bin/awk
chmod 711 /bin/bash
chmod 711 /bin/cat
chmod 711 /bin/cp
chmod 711 /bin/date
chmod 711 /bin/grep
chmod 711 /bin/echo
chmod 711 /bin/ed
chmod 711 /bin/gunzip
chmod 711 /bin/gzip
chmod 711 /bin/hostname
chmod 711 /bin/ls
chmod 711 /bin/mkdir
chmod 711 /bin/mv
chmod 711 /bin/pwd
chmod 711 /bin/rm
chmod 711 /bin/rmdir
chmod 711 /bin/su
chmod 711 /bin/tar
chmod 711 /bin/tcsh
chmod 711 /bin/touch
chmod 711 /bin/vi
chmod 711 /bin/zsh
chmod 711 /bin/cut
chmod 711 /bin/sed
chmod 4711 /bin/ping

chmod 711 /usr/bin/awk
chmod 711 /usr/bin/bzip2
chmod 711 /usr/bin/clear
chmod 711 /usr/bin/chsh
chmod 711 /usr/bin/cal
chmod 711 /usr/bin/dir
chmod 711 /usr/bin/expr
chmod 711 /usr/bin/find
chmod 711 /usr/bin/file
chmod 711 /usr/bin/ftp
chmod 711 /usr/bin/gunzip
chmod 711 /usr/bin/gzip
chmod 711 /usr/bin/id
chmod 711 /usr/bin/nano
chmod 711 /usr/bin/nslookup
chmod 711 /usr/bin/python
chmod 711 /usr/bin/perlbug
chmod 711 /usr/bin/printf
chmod 711 /usr/bin/procmail
chmod 711 /usr/bin/perl
chmod 711 /usr/bin/scp
chmod 711 /usr/bin/ssh-agent
chmod 711 /usr/bin/sftp
chmod 711 /usr/bin/ssh
chmod 711 /usr/bin/sudo
chmod 711 /usr/bin/sudoedit
chmod 711 /usr/bin/telnet
chmod 711 /usr/bin/unzip
chmod 711 /usr/bin/vim
chmod 711 /usr/bin/wall
chmod 711 /usr/bin/zip
chmod 711 /usr/bin/wget
chmod 711 /usr/bin/wc
chmod 711 /usr/bin/tail

echo "==================== Change Permision Clear=================" | grep --color "[=]"

# whistl setting
if [ "$WHI" = "y" -a "$WHI" = "Y" ]
        then
        cd /root;wget setting.j2.co.kr/setting/whistlsetup.sh
        chmod 700 whistlsetup.sh;/root/whistlsetup.sh
        rm -rf /root/whistlsetup.sh
fi


# History size 
sed -i "s/HISTSIZE=1000/HISTSIZE=100/g" /etc/profile
source /etc/profile

# GeoIP install

if [ "$GEO" = "y" -o "$GEO" = "Y" ]
        then
        cd /root;wget setting.j2.co.kr/setting/geoip.sh
        chmod 700 geoip.sh;sh /root/geoip.sh
        rm -rf /root/geoip.sh
fi

# Language setting
#cd /etc/sysconfig
#rm -rf i18n
#wget http://setting.j2.co.kr/setting/i18n
#source /etc/sysconfig/i18n


fi

rm -rf /root/centos5.sh
