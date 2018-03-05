#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : 001_dvr_init.bash, Version 0.00.002
###     프로그램 설명   : OpenStack DVR (Distribute VirtualRouter) Network : 초기 설정
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.05.16 ~ 2017.05.17
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

source ${HOME_SERVICE}/bin/config.bash > /dev/null 2>&1

### ------------------------------------------------------------------------------------------------
###     funcUsing()
###         사용법 표시
### ------------------------------------------------------------------------------------------------
funcUsing() {
    echo "Using : 001_dvr_init.bash PROJECT_NAME SERVER_NAME"
    echo "        PROJECT_NAME         : Project 이름"
    echo "        SERVER_NAME          : Server 이름"
    echo " "
    exit 1
}

###---  Command Line에서 입력된 인수를 검사한다.
if [[ $# = 2 ]]; then
    PROJECT_NAME=$1
    SERVER_NAME=$2
else
    funcUsing
fi

### ------------------------------------------------------------------------------------------------
###    Main process
### ------------------------------------------------------------------------------------------------
PUBLIC_NETEORK_NAME="admin_floating_net"
DOMAIN_NAME="daoucloud"

mkdir -p ${HOME_WORK}/OpenStack
cd ${HOME_WORK}/OpenStack

echo "PUBLIC_NETEORK_NAME=${PUBLIC_NETEORK_NAME}" > config.bash
echo "DOMAIN_NAME=${DOMAIN_NAME}" >> config.bash
echo " " >> config.bash

echo "PROJECT_NAME=${PROJECT_NAME}" >> config.bash
echo "SERVER_NAME=${SERVER_NAME}" >> config.bash
echo " " >> config.bash
chmod 755 config.bash

### ================================================================================================

