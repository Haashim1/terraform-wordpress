#!/bin/bash

set -e

apt-get update

apt-get install -y \
  apache2 \
  php \
  php-mysql \
  php-curl \
  php-gd \
  php-mbstring \
  php-xml \
  php-zip \
  mysql-server \
  curl \
  unzip

systemctl enable apache2
systemctl start apache2

systemctl enable mysql
systemctl start mysql

mysql -e "CREATE DATABASE wordpress;"
mysql -e "CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'wordpress123';"
mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';"

cd /tmp

curl -O https://wordpress.org/latest.tar.gz

tar -xzf latest.tar.gz

rm -rf /var/www/html/*

cp -R /tmp/wordpress/* /var/www/html/

