#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : centos.bash, Version 0.00.001
###     프로그램 설명   : CentOS를 관리 합니다.
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
###     초기 환경을 설정 합니다.
### ------------------------------------------------------------------------------------------------
if [[ "z${HOME_SERVICE}z" == "zz" ]]; then
    export HOME_SERVICE="/service"
fi

source ${HOME_SERVICE}/bin/config.bash > /dev/null 2>&1

SOFTWARE="CentOS7"
if [[ -f ${HOME_SERVICE}/${SOFTWARE}/bin/config.php ]]; then
    source ${HOME_SERVICE}/${SOFTWARE}/bin/config.php
fi

### ------------------------------------------------------------------------------------------------
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    echo "Using : centos.bash COMMAND [OPTIONS]"
    echo "        COMMAND              : help, init, status"
    echo "        OPTIONS              : ..."
    echo " "
    exit 2
}

### ------------------------------------------------------------------------------------------------
###     Status를 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcStatus() {
    echo "OS                  : ${OS_NAME} ${OS_VERSION}"
    echo '                     ' `cat /etc/*-release | grep release | uniq`

    echo 'Core                :' `cat /proc/cpuinfo | grep processor | /usr/bin/wc -l` Core
    ZZSTR=`cat /proc/cpuinfo | grep "model name" | head -1`
    echo "                      ${ZZSTR}"

    ZZSTR=`cat /proc/meminfo | grep MemTotal`
    # ZZSTR=${ZZSTR/MemTotal: /}
    echo "Memory (MB)         : ${ZZSTR}"
    # dmidecode -t 17 
    # free -m

    echo 'Storage             :' `df -h | grep "/dev/" | egrep -v "tmp|/boot"`
    # fdisk -l | grep 'Disk /'
    echo " "

    echo "HOME_SERVICE        : ${HOME_SERVICE}"
    echo "HOME_WORK           : ${HOME_WORK}"
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
    init)
        /bin/bash ${HOME_SERVICE}/${SOFTWARE}/bin/centos_init.bash
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

