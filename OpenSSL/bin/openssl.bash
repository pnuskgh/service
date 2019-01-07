#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : openssl.bash, Version 0.00.002
###     프로그램 설명   : OpenSSL를 관리 합니다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 1995.02.20 ~ 2019.01.07
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2018 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     초기 환경을 설정 합니다.
### ------------------------------------------------------------------------------------------------
if [[ "z${HOME_SERVICE}z" == "zz" ]]; then
    export HOME_SERVICE="/service"
fi

source ${HOME_SERVICE}/bin/config.bash > /dev/null 2>&1

SOFTWARE="OpenSSL"
if [[ -f ${HOME_SERVICE}/${SOFTWARE}/bin/config.php ]]; then
    source ${HOME_SERVICE}/${SOFTWARE}/bin/config.php
fi

### ------------------------------------------------------------------------------------------------
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    echo "Using : openssl.bash COMMAND [OPTIONS]"
    echo "        COMMAND              : help, install, status, ps, start, restart, stop"
    echo "        OPTIONS              : ..."
    echo " "
    exit 2
}

### ------------------------------------------------------------------------------------------------
###     Status를 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcStatus() {
    openssl version
    # yum list installed | grep openssl
    # yum info openssl
}

### ------------------------------------------------------------------------------------------------
###     Command Line Argument를 확인 합니다.
### ------------------------------------------------------------------------------------------------
if [[ $# == 1 ]]; then
    COMMAND=$1
    OPTIONS="null"
elif [[ $# == 2 ]]; then
    COMMAND=$1
    OPTIONS=$2
else
    funcUsing
fi

### ------------------------------------------------------------------------------------------------
###     Main process
### ------------------------------------------------------------------------------------------------
case ${COMMAND} in
    help)
        funcUsing
        ;;
    install)
        # mkdir -p ${HOME_WORK}/upload
        cd ${HOME_WORK}/upload
        # wget http://mirror.centos.org/centos/7/os/x86_64/Packages/openssl-1.0.2k-8.el7.x86_64.rpm
        # wget http://mirror.centos.org/centos/7/os/x86_64/Packages/openssl-libs-1.0.2k-8.el7.x86_64.rpm
        # rpm -Uvh openssl-1.0.2k-8.el7.x86_64.rpm openssl-libs-1.0.2k-8.el7.x86_64.rpm

        wget http://mirror.centos.org/centos/7/os/x86_64/Packages/openssl-1.0.2k-16.el7.x86_64.rpm
        wget http://mirror.centos.org/centos/7/os/x86_64/Packages/openssl-libs-1.0.2k-16.el7.x86_64.rpm
        rpm -Uvh openssl-*.rpm
        openssl version
        ;;
    status)
        funcStatus
        ;;
    *)
        funcUsing
        ;;
esac
echo " "

exit 0
### ================================================================================================

