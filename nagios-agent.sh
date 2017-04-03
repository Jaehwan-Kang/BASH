#!/bin/sh

# 2016-03-23  changed


yum -y install xinetd gcc glibc.i686 openssl openssl-devel perl-Nagios-Plugin

sed -i 's/log_type/#log_type/g' /etc/xinetd.conf
sed -i 's/log_on_failure/#log_on_failure/g' /etc/xinetd.conf
sed -i 's/log_on_success/#log_on_success/g' /etc/xinetd.conf


SRCDIR=/usr/local/src/nagios
SRCDIR2=/usr/local/src/nagios/plugin
SRCDIR3=/usr/local/src/nagios/nrpe

mkdir $SRCDIR; cd $SRCDIR
echo $SRCDIR
wget manager.cyebiz.com/setting/nagios-plugins-2.1.1.tar.gz
wget manager.cyebiz.com/setting/nrpe-2.15.tar.gz


tar zxf nagios-plugins-2.1.1.tar.gz
tar zxf nrpe-2.15.tar.gz

ln -s nagios-plugins-2.1.1  plugin
ln -s nrpe-2.15 nrpe

useradd -r -d /usr/local/nagios nagios


cd $SRCDIR2
./configure && make && make install
chown -R nagios.nagios /usr/local/nagios

cd $SRCDIR3
./configure --enable-command-args 
make all && make install-plugin && make install-daemon && make install-daemon-config && make install-xinetd


echo "" >> /etc/services
echo "# ADD service" >> /etc/services
echo "nrpe            5666/tcp                #NRPE" >> /etc/services

sed -i 's/127.0.0.1/211.61.155.151/g' /etc/xinetd.d/nrpe



cd /usr/local/nagios/etc
mv nrpe.cfg nrpe.cfg_old
wget manager.cyebiz.com/setting/nrpe.cfg
chown nagios.nagios nrpe.cfg
cd /usr/local/nagios/libexec
wget manager.cyebiz.com/setting/addplug.tar.gz
tar zxvf addplug.tar.gz
rm -rf check_mem.sh
rm -rf check_ps.sh
wget manager.cyebiz.com/setting/check_ps.sh
wget manager.cyebiz.com/setting/check_mem.sh
chmod 755 check_ps.sh
chmod 755 check_mem.sh
chown -R nagios.nagios /usr/local/nagios;



#centos 6
#chkconfig --level 35 xinetd on
#/etc/init.d/xinetd restart

# centos7
systemctl start xinetd
systemctl enable xinetd

# cyebiz
# Manager Nagios
#-A INPUT -s 211.61.155.151 -p tcp --dport 5666 -j ACCEPT
# wget manager.cyebiz.com/setting/nagios-agent.sh && sh nagios-agent.sh