#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : install_php.bash, Version 0.00.003
###     프로그램 설명   : Nginx에 PHP 개발 환경을 구성 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.03.24 ~ 2017.11.21
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
# WORKING_DIR="/service/service_sw/Nginx"
source ${WORKING_DIR}/bin/config.bash

### ------------------------------------------------------------------------------------------------
###     Nginx와 php-fpm 환경 설정
### ------------------------------------------------------------------------------------------------
backup /etc/php-fpm.d www.conf
crudini --set /etc/php-fpm.d/www.conf www user nginx
crudini --set /etc/php-fpm.d/www.conf www group nginx
crudini --set /etc/php-fpm.d/www.conf www security.limit_extensions .php
crudini --set /etc/php-fpm.d/www.conf www listen /var/run/php-fpm/php-fpm.sock
crudini --set /etc/php-fpm.d/www.conf www listen.owner nginx
crudini --set /etc/php-fpm.d/www.conf www listen.group nginx
crudini --set /etc/php-fpm.d/www.conf www listen.mode  0660

# vi /etc/nginx/nginx.conf  파일에 아래 내용을 추가 한다.
#        location / {
#            index index.php index.html;
#        }
#
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
###    xDebug 환경 구성
### ------------------------------------------------------------------------------------------------
yum -y install php-xdebug

### ================================================================================================

