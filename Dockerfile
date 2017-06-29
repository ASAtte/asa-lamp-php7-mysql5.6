FROM centos:7
MAINTAINER Yoshitaka Sasaki "yoshitaka.sasaki@asadigital.net"

RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN yum update -y
RUN yum install -y httpd rsyslog
RUN usermod -u 1000 apache && groupmod -g 1000 apache

# php
RUN yum install -y epel-release \
    && rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm \
    && yum install -y --enablerepo=remi,remi-php70 php php-devel php-mbstring php-pdo php-gd php-mysql php-pear \
    && sed -ri "s/;date.timezone =/date.timezone = Asia\/Tokyo/g" /etc/php.ini \
    && echo '<?php phpinfo();' > /var/www/html/info.php

# mysql
RUN yum localinstall -y http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
RUN yum-config-manager --disable mysql57-community \
    && yum-config-manager --enable mysql56-community \
    && yum install -y mysql mysql-server

# supervisor
RUN yum install -y supervisor
COPY ./supervisord.conf /etc/supervisord.conf

RUN mkdir /docker-entrypoint-initdb.d
COPY ./docker-entrypoint.sh /usr/local/bin/

VOLUME /var/lib/mysql

EXPOSE 80 3306

CMD ["/usr/bin/supervisord"]
