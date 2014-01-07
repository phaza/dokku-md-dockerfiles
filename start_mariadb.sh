#!/bin/bash

if [[ ! -f /opt/mysql/initialized ]]; then
    mkdir -p /opt/mysql
    cp -a /var/lib/mysql/* /opt/mysql/
    chown -R mysql:mysql /opt/mysql
    chmod -R 755 /opt/mysql
fi
sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
sed -i -e"s/var\/lib/opt/g" /etc/mysql/my.cnf
mysqld_safe & sleep 5
if [[ ! -f /opt/mysql/initialized ]]; then
    echo "CREATE DATABASE db;" | mysql -u root --password=aesheoneikopuyif
    echo "UPDATE mysql.user SET Password=PASSWORD('$1') WHERE User='root'; FLUSH PRIVILEGES;" | mysql -u root --password=aesheoneikopuyif mysql
    echo "GRANT ALL ON *.* to root@'%' IDENTIFIED BY '$1'; FLUSH PRIVILEGES;" | mysql -u root --password="$1" mysql
    touch /opt/mysql/initialized
fi
tailf /var/log/mysql.log
