# bashscripts

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
