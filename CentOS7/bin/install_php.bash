#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : install_php.bash, Version 0.00.004
###     프로그램 설명   : PHP를 설치하고 환경을 구성 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.03.24 ~ 2018.03.05
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
###     funcUsing()
###         사용법 표시
### ------------------------------------------------------------------------------------------------
funcUsing() {
    /bin/echo "Using : install_php.bash [VERSION]"
    /bin/echo "        VERSION        : 5, 72"
    /bin/echo " "
    exit 1
}

### ------------------------------------------------------------------------------------------------
###     Command Line에서 입력된 인수를 검사한다.
### ------------------------------------------------------------------------------------------------
if [[ $# = 1 ]]; then
    VERSION=$1
elif [[ $# = 0 ]]; then
    VERSION="default"
else
    funcUsing
fi

### ------------------------------------------------------------------------------------------------
###     PHP 설치
### ------------------------------------------------------------------------------------------------
if [[ "${VERSION}" == "72" ]]; then
    echo "wget -q http://rpms.remirepo.net/enterprise/remi-release-7.rpm"
    echo "rpm -Uvh remi-release-7.rpm"
    # yum -y install yum-utils
    # yum --enablerepo=remi update remi-release
    # yum-config-manager --enable remi-php72
    echo " "
fi

case ${VERSION} in
    default)
        echo "--- Install PHP"
        yum -y install php php-cli php-common php-mbstring php-gd php-xml php-soap php-xmlrpc php-mcrypt php-imap
        yum -y install php-mysql

        yum -y install php-fpm

        # yum -y install php-phpunit php-phpunit-* php-Smarty php-composer-* php-symfony php-symfony-*
        # yum -y install php-ZendFramework php-ZendFramework-*
        # yum -y install php-ZendFramework2 php-ZendFramework2-*
        # yum -y install php-pecl php-pecl-* php-pear php-pear-*
        ;;
    7)
        echo "--- Install PHP 7.1"
        # yum remove httpd httpd-*
        # yum -y install httpd24 httpd24-*

        yum -y install php71 php71-cli php71-common php71-mbstring php71-gd php71-xml php71-soap php71-xmlrpc php71-mcrypt php71-imap
        yum -y install php71-mysqlnd

        yum -y install php71-fpm
        ;;
    72)
        echo "--- Install PHP 7.2"
        yum -y install php72 php72-php php72-php-cli php72-php-common php72-php-mbstring php72-php-gd php72-php-xml php72-php-soap php72-php-xmlrpc php72-php-mcrypt php72-php-imap php72-php-pecl-zip
        yum -y install php72-php-mysqlnd

        yum -y install php72-php-fpm
        ;;
    *)
        funcUsing
        ;;
esac

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
# yum list | grep ~
# yum list installed | grep ~

yum -y install gcc make zlib-devel pcre-devel
yum -y install php7-pear
yum -y install php71-devel

#--- Install Cache
yum -y install php71-pecl-apcu php71-pecl-apcu-devel
# yum -y install php71-pecl-memcache php71-pecl-memcached
# yum -y install php71-pecl-redis

### ------------------------------------------------------------------------------------------------
###    php-fpm 실행
### ------------------------------------------------------------------------------------------------
systemctl restart php-fpm.service
# systemctl restart php72-php-fpm.service

### ------------------------------------------------------------------------------------------------
###     설치 정보 확인
###         PHP 5.4.16 
###         Zend Engine v2.4.0
### ------------------------------------------------------------------------------------------------
php -v
# php-fpm -v

# php72 -v
# php72-php-fpm -v

### ================================================================================================

