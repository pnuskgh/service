#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : install.bash, Version 0.00.001
###     프로그램 설명   : SuiteCRM을 설치 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.09.14 ~ 2017.09.14
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

RELATION_DIR="$(dirname $0)"
WORKING_DIR="$(cd -P ${RELATION_DIR}/.. && pwd)"
source ${WORKING_DIR}/bin/config.bash

### ------------------------------------------------------------------------------------------------
###     WordPress 설치
### ------------------------------------------------------------------------------------------------
yum -y install php-imap

vi /etc/php.ini
#    session.save_path = "/var/lib/php/session"
#    memory_limit = 128M
#    upload_max_filesize = 20M

mkdir -p /var/lib/php/session
chown nginx:nginx /var/lib/php/session

#--- 설치할 SuiteCRM 소스를 아래 폴더에 위치 한다.
cd /usr/share/nginx/html/suitecrm
# chown -R apache:apache /var/www/html
# chcon -R -t httpd_sys_content_rw_t /var/www/html 
setsebool httpd_can_network_connect_db=on 
setsebool httpd_can_network_connect=on 
setsebool httpd_can_sendmail=on 
setsebool httpd_unified=on

# crontab -e -u nginx
#     * * * * * cd /usr/share/nginx/html/suitecrm; php -f cron.php > /dev/null 2>&1 




### ================================================================================================

