#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : install.bash, Version 0.00.003
###     프로그램 설명   : SuiteCRM을 설치 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.09.14 ~ 2018.06.12
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
# WORKING_DIR="/service/service_sw/SuiteCRM"
source ${WORKING_DIR}/bin/config.bash

### ------------------------------------------------------------------------------------------------
###     사전 설치
###     PHP 7.1 설치
###     Nginx 설치
###     MariaDB 설치
###     SuiteCRM 지원 플랫폼 : https://docs.suitecrm.com/admin/compatibility-matrix/
### ------------------------------------------------------------------------------------------------
/service/CentOS7/bin/install_php71.bash
/service/Nginx/bin/install.bash
/service/MariaDB/bin/install.bash

### ------------------------------------------------------------------------------------------------
###     SuiteCRM 설치
###     https://suitecrm.com/download
### ------------------------------------------------------------------------------------------------
yum -y install unzip

#--- 설치할 SuiteCRM 소스를 아래 폴더에 위치 한다.
#---     SuiteCRM-7.8.6.zip 파일을 notebook에서 업로드 한다.
cd /usr/share/nginx/html
unzip /work/install/SuiteCRM-7.10.6.zip
mv SuiteCRM-7.10.6 suitecrm
chown -R nginx:nginx suitecrm

# crontab -e -u nginx
#     * * * * * cd /usr/share/nginx/html/suitecrm; php -f cron.php > /dev/null 2>&1 

#--- http://demo.obcon.biz/suitecrm

### ================================================================================================

