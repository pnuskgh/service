#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : 001_install.bash, Version 0.00.003
###     프로그램 설명   : WordPress를 설치 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.03.28 ~ 2017.03.30
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
###     WordPress 설치
###         WordPress 4.7.3
### ------------------------------------------------------------------------------------------------
yum -y install wget unzip

mkdir -p ${HOME_WORK}/zzinstall
cd ${HOME_WORK}/zzinstall

if [[ ! -f wordpress-4.7.3-ko_KR.zip ]]; then
    # wget https://wordpress.org/latest.zip
    wget https://ko.wordpress.org/wordpress-4.7.3-ko_KR.zip
fi

rm -rf wordpress > /dev/null 2>&1
unzip wordpress-4.7.3-ko_KR.zip

backup ${DOCUMENT_ROOT} 404.html
backup ${DOCUMENT_ROOT} 50x.html
backup ${DOCUMENT_ROOT} index.html
backup ${DOCUMENT_ROOT} nginx-logo.png
backup ${DOCUMENT_ROOT} poweredby.png

/usr/bin/cp -rf ${HOME_WORK}/zzinstall/wordpress/* ${DOCUMENT_ROOT}
chown -R nginx:nginx ${DOCUMENT_ROOT}

cd ${HOME_WORK}
rm -rf zzinstall

systemctl restart nginx.service

### ------------------------------------------------------------------------------------------------
###     WordPress 환경 구성
### ------------------------------------------------------------------------------------------------
/usr/bin/cp -rf ${TEMPLATE_DIR}/wp-config.php ${DOCUMENT_ROOT}
chown nginx:nginx ${DOCUMENT_ROOT}/wp-config

### ================================================================================================

