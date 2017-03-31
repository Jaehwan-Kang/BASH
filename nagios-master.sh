#!/bin/sh
# source down

SRCDIR=/usr/local/src/nagios
SRCDIR2=/usr/local/src/nagios/nagios
SRCDIR3=/usr/local/src/nagios/plugin
SRCDIR4=/usr/local/src/nagios/nrpe

mkdir $SRCDIR; cd $SRCDIR
echo $SRCDIR

wget manager.cyebiz.com/setting/nagios-3.5.0.tar.gz
wget manager.cyebiz.com/setting/nagios-plugins-1.4.16.tar.gz
wget manager.cyebiz.com/setting/nrpe-2.14.tar.gz

tar zxvf nagios-3.5.0.tar.gz
tar zxvf nagios-plugins-1.4.16.tar.gz
tar zxvf nrpe-2.14.tar.gz


ln -s nagios-3.5.0.tar.gz nagios
ln -s nagios-plugins-1.4.16 plugin
ln -s nrpe-2.14 nrpe

# Ready to install
echo "==========================================="  | grep --color "[=]"
echo ""
echo -n " 1. Insert Nagios password : " 
read Pass
echo -n " 2. Apache Daemon User: "
read Apauser
echo -n " 3. Apache Conf Dir: "
read Apaconf
echo ""
echo "===========================================" | grep --color "[=]"

# Nagios install

useradd -r -d /usr/local/nagios nagios

pw() {
       sleep 2;echo "$Pass"
       sleep 2;echo "$Pass"
       }
       pw | passwd nagios


groupadd -r nagcmd	
usermod -a -G nagcmd nagios
usermod -a -G nagcmd $Apauser

cd $SRCDIR2
./configure --with-command-group=nagcmd --with-httpd-conf=$Apaconf
make all && make install && make install-init && make install-config && make install-commandmode && make install-webconf
/usr/local/apache/bin/htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin $Pass

# Nagios plugin install

cd $SRCDIR3
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make && make install

# Nagios default setting

chkconfig --add nagios
chkconfig --level 35 nagios on
echo "export PATH=$PATH:/usr/local/nagios/bin" >> /etc/profile

# NRPE install

cd $SRCDIR4
./configure && make all && make install-plugin


# ETC setting

echo "" >> /usr/local/apache/conf/httpd.conf
echo "# Nagios" >> /usr/local/apache/conf/httpd.conf
echo "Include conf/nagios.conf" >> /usr/local/apache/conf/httpd.conf

cd /usr/local/nagios/etc
mv nagios.cfg nagios.cfg_old
mv cgi.cfg cgi.cfg_old
wget setting.dreammiz.com/setting/nagios.cfg
wget setting.dreammiz.com/setting/cgi.cfg

cd /usr/local/nagios/etc/objects
mv commands.cfg commands.cfg_old
mv timeperiods.cfg timeperiods.cfg_old
mv templates.cfg templates.cfg_old
wget setting.dreammiz.com/setting/commands.cfg
wget setting.dreammiz.com/setting/templates.cfg
wget setting.dreammiz.com/setting/timeperiods.cfg
wget setting.dreammiz.com/setting/hosts.cfg
wget setting.dreammiz.com/setting/groups.cfg
wget setting.dreammiz.com/setting/services.cfg

cd /usr/local/nagios/libexec
ln -s check_nrpe check_nrpe_disk
ln -s check_nrpe check_nrpe_ftp
ln -s check_nrpe check_nrpe_iostat
ln -s check_nrpe check_nrpe_mem
ln -s check_nrpe check_nrpe_proc
ln -s check_nrpe check_nrpe_tcp
ln -s check_nrpe check_nrpe_cpu
ln -s check_nrpe check_nrpe_file
ln -s check_nrpe check_nrpe_http
ln -s check_nrpe check_nrpe_load
ln -s check_nrpe check_nrpe_mysql
ln -s check_nrpe check_nrpe_proccpu
ln -s check_nrpe check_nrpe_ps
