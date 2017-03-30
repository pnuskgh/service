#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : create_image.bash, Version 0.00.001
###     프로그램 설명   : 이미지를 최종 정리 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.06 ~ 2017.01.06
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
###     이미지를 최종 정리 한다.
### ------------------------------------------------------------------------------------------------
rm -rf /var/cache/yum/*

history -c
rm -f ~root/.bash_history
rm -f ~root/.ssh/authorized_keys
rm -f ~root/.gitconfig
rm -f ~centos/.bash_history
rm -f ~centos/.ssh/authorized_keys

rm -fr /var/lib/cloud/*

#--- 사용자의 비밀번호를 제거 한다.
passwd -d root
passwd -d centos

rm -rf /service
#--- shutdown -h now

echo " "
echo " "
echo "shutdown -h now 명령을 사용하여 종료 하세요."
echo " "

### ================================================================================================

