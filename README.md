# bashscripts

yum -y install gcc gcc-devel gcc-c++ libtool libtool-ltdl libtool-ltdl-devel openssl openssl-devel vim make cmake net-tools htop chkconfig iptables iptables-* ntsysv epel-release bzip2 nmap java libxml2 libxml2-devel bzip2-dev curl-devel gd gd-devel gmp gmp-devel libmcrypt-devel
yum -y groupinstall "DevelopMent"
yum install -y rdate lrzsz ncurses-devel whois telnet bind-utils psmisc htop wget npm git lsof python-pip bc bzip2-devel libmcrypt-devel mcrypt perl-Crypt-MySQL


cd /usr/local/src
tar jxvf apr-1.6.3.tar.bz2
cd apr-1.6.3
cp -ap /usr/bin/libtool ./libtoolT
./configure --prefix=/usr/local/apr && make && make install

cd /usr/local/src
tar jxvf apr-util-1.6.1.tar.bz2
cd apr-util-1.6.1
./configure --prefix=/usr/local/apr --with-apr=/usr/local/apr && make && make install

cd /usr/local/src
tar jxvf apr-iconv-1.2.2.tar.bz2
cd apr-iconv-1.2.2
./configure --prefix=/usr/local/apr --with-apr=/usr/local/apr && make && make install

cd /usr/local/src
tar jxvf httpd-2.4.32.tar.bz2
cd httpd-2.4.32
./configure --prefix=/usr/local/apache --enable-mpms-shared='prefork worker event' \
--enable-mods-shared=all --enable-so --enable-module=so --enable-expires --enable-rewrite\
--enable-ssl --with-ssl --enable-deflate --enable-rule=SHARED_CORE --with-apr=/usr/local/apr --with-apr-utils=/usr/local/apr

make && make install
