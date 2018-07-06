#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : install_php54.bash, Version 0.00.005
###     프로그램 설명   : PHP를 설치하고 환경을 구성 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.03.24 ~ 2018.07.06
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2018 pnuskgh, 오픈소스 비즈니스 컨설팅
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
echo "--- Install PHP"
yum -y install php php-cli php-common php-mbstring php-gd php-xml php-soap php-xmlrpc php-mcrypt php-imap php-mysql php-fpm
# yum -y install php-posix

# service php72-php-fpm start
# chkconfig php72-php-fpm on

### ------------------------------------------------------------------------------------------------
###     PHP 환경 설정
###     /etc/php.ini
###     /etc/opt/remi/php72/php.ini
### ------------------------------------------------------------------------------------------------
backup /etc php.ini
crudini --set /etc/php.ini PHP date.timezone Asia/Seoul
crudini --set /etc/php.ini PHP upload_max_filesize 10M
crudini --set /etc/php.ini PHP post_max_size 10M
# crudini --set /etc/php.ini PHP cgi.fix_pathinfo 0

mkdir -p /var/lib/php/session
mkdir -p /var/lib/php/upload
cd /var/lib
chown -R nginx:nginx *

# session.save_path = "/var/lib/php/session"
# upload_tmp_dir    = "/var/lib/php/upload"
crudini --set /etc/php.ini Session session.save_path /var/lib/php/session
crudini --set /etc/php.ini PHP upload_tmp_dir /var/lib/php/upload

### ------------------------------------------------------------------------------------------------
###     PHP - MBString 설정
### ------------------------------------------------------------------------------------------------
echo ${TEMPLATE_DIR}/mbstring.ini >> /etc/php.d/mbstring.ini

### ------------------------------------------------------------------------------------------------
###     PHP-FPM 설정
### ------------------------------------------------------------------------------------------------
crudini --set /etc/php-fpm.d/www.conf www user nginx
crudini --set /etc/php-fpm.d/www.conf www group nginx
crudini --set /etc/php-fpm.d/www.conf www security.limit_extensions .php
# crudini --set /etc/php-fpm.d/www.conf www listen /var/run/php-fpm/php-fpm.sock
# crudini --set /etc/php-fpm.d/www.conf www listen /var/opt/remi/php72/run/php-fpm/www.sock
crudini --set /etc/php-fpm.d/www.conf www listen /var/run/php-fpm/www.sock
crudini --set /etc/php-fpm.d/www.conf www listen.owner nginx
crudini --set /etc/php-fpm.d/www.conf www listen.group nginx
crudini --set /etc/php-fpm.d/www.conf www listen.mode  0660

### ------------------------------------------------------------------------------------------------
###    PHP 성능 개선
### ------------------------------------------------------------------------------------------------
yum -y install gcc make zlib-devel pcre-devel
yum -y install php7-pear

### ------------------------------------------------------------------------------------------------
###    php-fpm 실행
### ------------------------------------------------------------------------------------------------
systemctl restart php-fpm.service

### ------------------------------------------------------------------------------------------------
###     설치 정보 확인
###         PHP 5.4.16 
###         Zend Engine v2.4.0
### ------------------------------------------------------------------------------------------------
php -v
# php-fpm -v

### ================================================================================================

