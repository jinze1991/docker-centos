FROM centos:6
MAINTAINER Kimtaek <jinze1991@icloud.com>

# Install base tool
RUN yum -y install vim wget tar nginx vixie-cron crontabs

# Install php71
RUN curl 'https://setup.ius.io/' -o setup-ius.sh && bash setup-ius.sh
RUN yum install -y php71u-bcmath php71u-cli php71u-common php71u-dba php71u-devel php71u-embedded php71u-enchant php71u-fpm php71u-fpm-nginx php71u-gd php71u-gmp php71u-imap php71u-intl php71u-json php71u-mbstring php71u-mcrypt php71u-mysqlnd php71u-odbc php71u-opcache php71u-pdo php71u-pecl-redis php71u-pecl-xdebug php71u-process php71u-snmp php71u-soap php71u-tidy php71u-xml php71u-xmlrpc

#RUN ln -s /usr/bin/php71 /usr/bin/php
RUN curl -O -L https://phar.phpunit.de/phpunit-5.5.4.phar \
    && chmod +x phpunit-5.5.4.phar \
    && mv phpunit-5.5.4.phar /usr/local/bin/phpunit

# install composer
RUN curl -O -L https://getcomposer.org/download/1.4.1/composer.phar \
    && chmod +x composer.phar \
    && mv composer.phar /usr/local/bin/composer

# Setting DateTime Zone
RUN cp -p /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# Install MariaDB
RUN echo "[mariadb]" >> /etc/yum.repos.d/MariaDB.repo; \
    echo "name = MariaDB" >> /etc/yum.repos.d/MariaDB.repo; \
    echo "baseurl = http://yum.mariadb.org/10.0/centos6-x86" >> /etc/yum.repos.d/MariaDB.repo; \
    echo "gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB" >> /etc/yum.repos.d/MariaDB.repo; \
    echo "gpgcheck=1" >> /etc/yum.repos.d/MariaDB.repo;

RUN yum clean all
RUN yum install -y MariaDB-server MariaDB-client git supervisor

#RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN yum --enablerepo=epel,remi install redis -y

RUN echo -e "[server]\ncharacter-set-server=utf8\n[mysqld]\ncharacter-set-client-handshake=FALSE\ncollation-server=utf8_general_ci\n" >> /etc/my.cnf.d/server.cnf; \
  echo -e "xdebug.idekey=1\nxdebug.auto_trace=1\nxdebug.remote_host=eims.local\nxdebug.remote_port=9001\nxdebug.remote_enable=1\nxdebug.remote_connectback=0\nxdebug.remote_autostart=1\nxdebug.remote_log=/var/log/nginx/access.log" >> /etc/php.d/20-xdebug.ini;

# Setup default path
WORKDIR /www

# Private expose
EXPOSE 80 6379 9001
