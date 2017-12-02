#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : initialize.bash, Version 0.00.001
###     프로그램 설명   : OS 이름과 버전을 확인 합니다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.12.04 ~ 2017.12.04
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

OS_NAME="unknown"
OS_VERSION="unknown"

### ------------------------------------------------------------------------------------------------
###     funcExit, 2017.12.04 ~ 2017.12.04, Version 0.00.001
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcExit() {
    echo ${OS_NAME} ${OS_VERSION}
    echo " "
    exit 0
}

### ------------------------------------------------------------------------------------------------
###     OS 이름과 버전을 확인 합니다.
### ------------------------------------------------------------------------------------------------
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    if [[ "${NAME}" == "CentOS Linux" ]]; then
        OS_NAME="centos"
        OS_VERSION=${VERSION_ID}
    fi
    if [[ "${DISTRIB_ID}" == "Ubuntu" ]]; then
        OS_NAME="ubuntu"
        OS_VERSION=${DISTRIB_RELEASE}
    fi
    funcExit
fi

if [[ -f /etc/centos-release ]]; then
    OS_NAME="centos"
    TMPSTR=`cat /etc/centos-release | grep 'release 7' | wc -l`
    if [[ "${TMPSTR}" == "1" ]]; then
        OS_VERSION="7"
    fi
    TMPSTR=`cat /etc/centos-release | grep 'release 6.5' | wc -l`
    if [[ "${TMPSTR}" == "1" ]]; then
        OS_VERSION="6.5"
    fi
    funcExit
fi

if [[ -f /etc/issue ]]; then
    TMPSTR=`cat /etc/issue | grep Ubuntu | wc -l`
    if [[ "${TMPSTR}" == "1" ]]; then
        OS_NAME="ubuntu"
        TMPSTR=`cat /etc/issue | grep Ubuntu | awk '{ print $2 }'`
        OS_VERSION=${TMPSTR}
    fi
    funcExit
fi

exit 1
### ================================================================================================

