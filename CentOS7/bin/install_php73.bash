#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : install_php73.bash, Version 0.00.007
###     프로그램 설명   : PHP를 설치하고 환경을 구성 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.03.24 ~ 2019.06.14
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2019 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     실행 환경을 설정 한다.
### ------------------------------------------------------------------------------------------------
SOFTWARE="CentOS7"

if [[ "z${HOME_SERVICE}z" == "zz" ]]; then
    export HOME_SERVICE="/service"
fi
WORKING_DIR="${HOME_SERVICE}/${SOFTWARE}"
source ${HOME_SERVICE}/bin/config.bash > /dev/null 2>&1

if [[ -f ${WORKING_DIR}/bin/config.php ]]; then
    source ${WORKING_DIR}/bin/config.php
else
    TIMESTAMP=`date +%Y%m%d_%H%M%S`
    BACKUP_DIR=${WORKING_DIR}/backup
    TEMPLATE_DIR=${WORKING_DIR}/template
fi

### ------------------------------------------------------------------------------------------------
###     PHP 설치
### ------------------------------------------------------------------------------------------------
/bin/yum -y install wget

#--- Remi repository 설치
# cd /work/install
# /bin/wget -q http://rpms.remirepo.net/enterprise/remi-release-7.rpm
# /bin/rpm -Uvh remi-release-7.rpm
/bin/yum  install  http://rpms.remirepo.net/enterprise/remi-release-7.rpm
/bin/yum  install  yum-utils
/bin/yum  repolist

/bin/yum-config-manager --disable remi-php54
/bin/yum-config-manager --enable remi-php73

#--- PHP 7.3 설치
/bin/yum -y install php73 php73-php php73-php-cli php73-php-common php73-php-fpm php73-php-gd php73-php-imap php73-php-json php73-php-mbstring php73-php-mysqlnd php73-php-opcache php73-php-pdo php73-php-pecl-crypto php73-php-mcrypt php73-php-pecl-zip php73-php-process php73-php-soap php73-php-xml php73-php-xmlrpc php73-runtime

#--- Cache 설치
#---    apcu가 설치 오류가 나서 사용하지 않는다.
# /bin/yum -y install php73-php-pecl-apcu php73-php-pecl-apcu-devel
# /bin/yum -y install php73-pecl-memcache php73-pecl-memcached
# /bin/yum -y install php73-pecl-redis

#--- 환경 설정
/bin/yum -y install nginx nginx-*
mkdir -p /var/lib/php/session
mkdir -p /var/lib/php/upload
chown -R nginx:nginx /var/lib/php
chown -R nginx:nginx /var/opt/remi/php73/lib/php

BASE_PHP73="/etc/opt/remi/php73"
/usr/bin/cp ${TEMPLATE_DIR}/php.ini ${BASE_PHP73}
# post_max_size = 20M
# upload_max_filesize = 20M
# date.timezone = Asia/Seoul
# upload_tmp_dir = "/var/lib/php/upload"
# session.save_path = "/var/lib/php/session"
/usr/bin/cp ${TEMPLATE_DIR}/php73_10-opcache.ini     ${BASE_PHP73}/php.d
/usr/bin/cp ${TEMPLATE_DIR}/20-mbstring.ini    ${BASE_PHP73}/php.d
/usr/bin/cp ${TEMPLATE_DIR}/20-mcrypt.ini      ${BASE_PHP73}/php.d
/usr/bin/cp ${TEMPLATE_DIR}/www.conf           ${BASE_PHP73}/php-fpm.d
# user = nginx
# group = nginx
# listen.owner = nginx
# listen.group = nginx
# listen.mode = 0660
# security.limit_extensions = .php

#--- PHP 7.3 기동
chkconfig php73-php-fpm on
systemctl restart php73-php-fpm.service

### ------------------------------------------------------------------------------------------------
###     설치 정보 확인
###         PHP 7.3.6
###         Zend Engine v3.3.6
### ------------------------------------------------------------------------------------------------
php73 -v

### ================================================================================================

