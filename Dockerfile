FROM centos:7
MAINTAINER Yoshitaka Sasaki "yoshitaka.sasaki@asadigital.net"

RUN yum update -y
RUN yum install -y httpd rsyslog
RUN systemctl enable httpd rsyslog
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN usermod -u 1000 apache && groupmod -g 1000 apache

#php
RUN yum install -y epel-release
RUN rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN yum install -y --enablerepo=remi,remi-php70 php php-devel php-mbstring php-pdo php-gd php-mysql php-pear
RUN sed -ri "s/;date.timezone =/date.timezone = Asia\/Tokyo/g" /etc/php.ini

# mysql
RUN yum localinstall -y http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
RUN yum-config-manager --disable mysql57-community \
    && yum-config-manager --enable mysql56-community \
    && yum install -y mysql mysql-devel mysql-server mysql-utilities |
    && systemctl enable mysqld

WORKDIR /var/www/html
EXPOSE 80 3306
