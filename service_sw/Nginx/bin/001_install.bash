#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : 001_install.bash, Version 0.00.002
###     프로그램 설명   : Nginx를 설치 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.03.23 ~ 2017.03.24
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

WORKING_DIR=`dirname $0`
WORKING_DIR=${WORKING_DIR}/..
source ${WORKING_DIR}/bin/config.bash

### ------------------------------------------------------------------------------------------------
###     Nginx 설치
### ------------------------------------------------------------------------------------------------
yum -y install nginx nginx-*

systemctl restart nginx.service
systemctl enable nginx.service

### ------------------------------------------------------------------------------------------------
###     방화벽 설정
### ------------------------------------------------------------------------------------------------
# systemctl stop firewalld.service
# systemctl disable firewalld.service

# firewall-cmd --permanent --zone=public --add-port=80/tcp
# firewall-cmd --reload
# firewall-cmd --list-all

### ------------------------------------------------------------------------------------------------
###     설치 정보 확인
###         nginx/1.10.2
### ------------------------------------------------------------------------------------------------
nginx -V

### ================================================================================================

