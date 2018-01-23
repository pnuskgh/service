#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : status.bash, Version 0.00.001
###     프로그램 설명   : SELinux 상태를 조회 합니다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2018.01.23 ~ 2018.01.23
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
# WORKING_DIR="/service/service_os/SELinux"
source ${WORKING_DIR}/bin/config.bash

### ------------------------------------------------------------------------------------------------
###     SELinux 상태를 조회 합니다.
### ------------------------------------------------------------------------------------------------
echo -n "SELinux 설정 : "
getenforce
# setenforce 0                          #--- Permissive
# setenforce 1                          #--- Enforcing
echo " "

echo "--- SELinux 상태 ---"
sestatus
echo " "

echo "--- /etc/selinux/config 파일 ---"
cat /etc/selinux/config
echo " "

echo "--- 보안 정책 확인 ---"
getsebool httpd_can_sendmail
# getsebool -a
# setsebool -P httpd_can_sendmail on
echo " "

# echo "--- 적용된 정책 모듈 확인 ---"
# semodule -l
# semodule -lfull
# echo " "

echo "SELinux Context : user, role, type"
echo -n "id의 권한 설정 : "
id -Z
# semanage login -l
echo " "

echo "ls -alZ"
ls -alZ
echo " "

echo "ps -efZ | grep nginx"
ps -efZ | grep nginx
echo " "

echo "tail -f /var/log/audit/audit.log"
echo " "

### ================================================================================================
