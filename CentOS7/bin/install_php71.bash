#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : install_php71.bash, Version 0.00.005
###     프로그램 설명   : PHP를 설치하고 환경을 구성 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.03.24 ~ 2018.06.08
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

# RELATION_DIR="$(dirname $0)"
# WORKING_DIR="$(cd -P ${RELATION_DIR}/.. && pwd)"
BASE_NAME="CentOS7"
WORKING_DIR="${HOME_SERVICE}/${BASE_NAME}"
source ${WORKING_DIR}/bin/config.bash

### ------------------------------------------------------------------------------------------------
###     PHP 설치
### ------------------------------------------------------------------------------------------------
yum -y install wget

#--- Remi repository 설치
mkdir -p /work/install
cd /work/install
wget -q http://rpms.remirepo.net/enterprise/remi-release-7.rpm
rpm -Uvh remi-release-7.rpm

#--- PHP 7.1 설치
yum -y install php71 php71-php php71-php-cli php71-php-common php71-php-fpm php71-php-gd php71-php-imap php71-php-json php71-php-mbstring php71-php-mysqlnd php71-php-opcache php71-php-pdo php71-php-pecl-crypto php71-php-mcrypt php71-php-pecl-zip php71-php-process php71-php-soap php71-php-xml php71-php-xmlrpc php71-runtime

#--- Cache 설치
yum -y install php71-php-pecl-apcu php71-php-pecl-apcu-devel
# yum -y install php71-pecl-memcache php71-pecl-memcached
# yum -y install php71-pecl-redis

#--- 환경 설정
yum -y install nginx nginx-*
mkdir -p /var/lib/php/session
mkdir -p /var/lib/php/upload
chown -R nginx:nginx /var/lib/php/session /var/lib/php/upload 

BASE_PHP71="/etc/opt/remi/php71"
/usr/bin/cp ${TEMPLATE_DIR}/php.ini ${BASE_PHP71}
/usr/bin/cp ${TEMPLATE_DIR}/10-opcache.ini     ${BASE_PHP71}/php.d
/usr/bin/cp ${TEMPLATE_DIR}/20-mbstring.ini    ${BASE_PHP71}/php.d
/usr/bin/cp ${TEMPLATE_DIR}/20-mcrypt.ini      ${BASE_PHP71}/php.d
/usr/bin/cp ${TEMPLATE_DIR}/www.conf           ${BASE_PHP71}/php-fpm.d

#--- PHP 7.1 기동
chkconfig php71-php-fpm on
systemctl restart php71-php-fpm.service

### ------------------------------------------------------------------------------------------------
###     설치 정보 확인
###         PHP 5.4.16 
###         Zend Engine v2.4.0
### ------------------------------------------------------------------------------------------------
php71 -v

### ================================================================================================

