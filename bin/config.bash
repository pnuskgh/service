#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : config.bash, Version 0.00.010
###     프로그램 설명   : Bash Shell 기본 환경을 설정 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 1995.02.20 ~ 2018.02.28
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2018 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     ~/.bash_profile 기본 설정
###         source ${HOME_SERVICE}/bin/config.bash
### ------------------------------------------------------------------------------------------------

### ------------------------------------------------------------------------------------------------
###     환경변수를 설정 합니다.
### ------------------------------------------------------------------------------------------------
if [[ "z${HOME_SERVICE}z" == "zz" ]]; then
    export HOME_SERVICE="/service"
fi

if [[ "z${HOME_WORK}z" == "zz" ]]; then
    export HOME_WORK="/work"
fi

### ------------------------------------------------------------------------------------------------
###     Linux 기본 설정을 한다.
### ------------------------------------------------------------------------------------------------
export LANG=ko_KR.utf8
export TZ='Asia/Seoul'

PATH=${PATH}:${HOME_WORK}/bin:${HOME_SERVICE}/bin
CDPATH=.:${HOME_SERVICE}:${HOME_WORK}

TIMESTAMP=`date +%Y%m%d_%H%M%S`

alias dir='ls -alF'
alias dird='ls -alF | grep /'
alias show=${HOME_SERVICE}/bin/show.bash

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

    #--- Amazon Linux AMI 2017.09 이미지는 CentOS 6.8을 기반으로 만들어진 OS 입니다.
    if [[ "${NAME}" == "Amazon Linux AMI" ]]; then
        OS_NAME="centos"
        if [[ "${VERSION}" == "2017.09" ]]; then
            OS_VERSION=6
        fi
    fi
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

    TMPSTR=`cat /etc/centos-release | grep 'release 6.9' | wc -l`
    if [[ "${TMPSTR}" == "1" ]]; then
        OS_VERSION="6.9"
    fi
fi

if [[ -f /etc/issue ]]; then
    TMPSTR=`cat /etc/issue | grep Ubuntu | wc -l`
    if [[ "${TMPSTR}" == "1" ]]; then
        OS_NAME="ubuntu"
        TMPSTR=`cat /etc/issue | grep Ubuntu | awk '{ print $2 }'`
        OS_VERSION=${TMPSTR}
    fi
fi

### ------------------------------------------------------------------------------------------------
###     Linux Local 설정을 한다.
### ------------------------------------------------------------------------------------------------
if [[ -f ${HOME_WORK}/bin/config.bash ]]; then
    source ${HOME_WORK}/bin/config.bash
fi

### ================================================================================================

