#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : 001_install_php.bash, Version 0.00.001
###     프로그램 설명   : Nginx에 PHP 개발 환경을 구성 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.03.24 ~ 2017.03.24
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     실행 환경을 설정 한다.
### ------------------------------------------------------------------------------------------------
source ${HOME_SERVICE}/bin/config.bash > /dev/null 2>&1
source ${UTIL_DIR}/common.bash > /dev/null 2>&1

RELATION_DIR="$(dirname $0)"
WORKING_DIR="$(cd -P ${RELATION_DIR}/.. && pwd)"
source ${WORKING_DIR}/bin/config.bash

### ------------------------------------------------------------------------------------------------
###     PHP 설치
### ------------------------------------------------------------------------------------------------
yum -y install php php-cli php-common php-mbstring php-gd php-xml php-soap php-xmlrpc php-mcrypt
yum -y remove php-mysqlnd
yum -y install php-mysql

# yum -y install php-phpunit php-phpunit-* php-Smarty php-composer-* php-symfony php-symfony-*
# yum -y install php-ZendFramework php-ZendFramework-*
# yum -y install php-ZendFramework2 php-ZendFramework2-*
# yum -y install php-pecl php-pecl-* php-pear php-pear-*

yum -y install php-fpm
systemctl enable php-fpm.service

### ------------------------------------------------------------------------------------------------
###     crudini를 설치 한다.
### ------------------------------------------------------------------------------------------------
yum -y install crudini

### ------------------------------------------------------------------------------------------------
###     PHP 환경 설정
### ------------------------------------------------------------------------------------------------
backup /etc php.ini
crudini --set /etc/php.ini PHP date.timezone Asia/Seoul
crudini --set /etc/php.ini PHP upload_max_filesize 20M
crudini --set /etc/php.ini PHP post_max_size 30M
# crudini --set /etc/php.ini PHP cgi.fix_pathinfo 0

backup /etc/php-fpm.d www.conf
crudini --set /etc/php-fpm.d/www.conf www user nginx
crudini --set /etc/php-fpm.d/www.conf www group nginx
crudini --set /etc/php-fpm.d/www.conf www security.limit_extensions .php
crudini --set /etc/php-fpm.d/www.conf www listen /var/run/php-fpm/php-fpm.sock
crudini --set /etc/php-fpm.d/www.conf www listen.owner nginx
crudini --set /etc/php-fpm.d/www.conf www listen.group nginx
crudini --set /etc/php-fpm.d/www.conf www listen.mode  0660

# /etc/nginx/nginx.conf  파일에 아래 내용을 추가 한다.
#        location ~ \.(php)$ {
#            root /usr/share/nginx/html;
#            try_files $uri =404;
#            fastcgi_pass unix:/var/run/php-fpm/php-fpm.sock;
#            fastcgi_index index.php;
#            fastcgi_read_timeout 10;
#
#            include fastcgi.conf;
#        }
backup /etc/nginx nginx.conf
/usr/bin/cp -f ${TEMPLATE_DIR}/nginx.conf /etc/nginx

#--- Nginx 설정 테스트
nginx -t

/usr/bin/cp -f ${TEMPLATE_DIR}/phpinfo.php /usr/share/nginx/html
echo " "
echo "http://공인IP/phpinfo.php 사이트로 접속하여 확인 하세요."
echo " "

### ------------------------------------------------------------------------------------------------
###    php-fpm 실행
### ------------------------------------------------------------------------------------------------
systemctl restart php-fpm.service
systemctl restart nginx.service

### ------------------------------------------------------------------------------------------------
###     설치 정보 확인
###         PHP 5.4.16 
###         Zend Engine v2.4.0
### ------------------------------------------------------------------------------------------------
php -v
# php-fpm -v

### ================================================================================================

