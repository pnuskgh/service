#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : 001_install.bash, Version 0.00.004
###     프로그램 설명   : Nginx를 설치 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.03.23 ~ 2018.01.23
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
###     Nginx 설치
### ------------------------------------------------------------------------------------------------
yum -y install nginx nginx-*

systemctl restart nginx.service
systemctl enable nginx.service

### ------------------------------------------------------------------------------------------------
###     방화벽 설정
###     https://www.lesstif.com/pages/viewpage.action?pageId=22053128
###     Conf : /usr/lib/firewalld/ 
### ------------------------------------------------------------------------------------------------
systemctl start firewalld.service
systemctl enable firewalld.service

firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --reload
firewall-cmd --list-all

### ------------------------------------------------------------------------------------------------
###     설치 정보 확인
###         nginx/1.10.2
### ------------------------------------------------------------------------------------------------
nginx -V

### ------------------------------------------------------------------------------------------------
###     SELinux 권한 설정
### ------------------------------------------------------------------------------------------------
SELINUX_TYPE=`getenforce`
if [[ "${SELINUX_TYPE}" = "Enforcing" ]]; then
    cd ${DOCUMENT_ROOT}
    # ps -efZ | grep nginx
    # ls -alZ *
    chcon -R -t httpd_sys_rw_content_t *
fi 

### ================================================================================================
