#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : git.bash, Version 0.00.001
###     프로그램 설명   : Git을 관리 합니다.
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

SOFTWARE="Git"
if [[ -f ${HOME_SERVICE}/${SOFTWARE}/bin/config.php ]]; then
    source ${HOME_SERVICE}/${SOFTWARE}/bin/config.php
fi

### ------------------------------------------------------------------------------------------------
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    echo "Using : git.bash COMMAND [OPTIONS]"
    echo "        COMMAND              : help, install, status"
    echo "        OPTIONS              : ..."
    echo " "
    exit 2
}

### ------------------------------------------------------------------------------------------------
###     Git을 설치 합니다.
### ------------------------------------------------------------------------------------------------
funcInstall() {
    yum -y install git

    git config --global user.name "Mountain Lover"
    git config --global user.email consult@jopenbusiness.com
    git config --global push.default simple

    git config --global --list
    git config --list

    # cd /
    # git clone https://github.com/pnuskgh/service.git
    # cd /service
    # git checkout develop
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
        funcInstall
        ;;
    status)
        git --version
        echo " "

        git config --global --list
        # git config --list
        ;;
    *)
        funcUsing
        ;;
esac
echo " "

exit 0
### ================================================================================================

