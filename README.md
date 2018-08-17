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



./configure --prefix=/usr/local/php7 --with-mysql-sock=/tmp --with-pdo-mysql=/usr/local/mysql --with-apxs2=/usr/local/apache/bin/apxs --with-config-file-path=/usr/local/apache/conf --with-pic --with-bz2 --enable-ftp --enable-sockets --with-gd --with-jpeg-dir=/usr/lib64 --with-freetype-dir=/usr/lib64 --with-png-dir=/usr/lib64 --with-zlib --with-iconv --enable-exif --enable-mbstring --with-mysqli=/usr/local/mysql/bin/mysql_config --with-openssl --with-libxml-dir=/usr/lib64 --enable-soap --with-curl --enable-mbregex --disable-debug --enable-sysvsem --enable-sysvshm --enable-sysvmsg --disable-inline-optimization --enable-bcmath --with-kerberos --with-gettext --with-gmp --enable-sigchild --enable-mbstring --with-pcre-regex --with-layout=GNU --enable-shmop --enable-calendar --with-kerberos --enable-inline-optimization --enable-dba --enable-zip --enable-maintainer-zts --enable-opcache			
make && make install			
cd /usr/local/src/php-5.6.36			
cp -ap php.ini-production /usr/local/apache/conf/php.ini			
vi /usr/local/apache/conf/php.ini			
			
		"AddType application/x-httpd-php .htm .html .php .ph .php3 .php4 .phtml .css .js
    AddType application/x-httpd-php-source .phps"	
			
      
