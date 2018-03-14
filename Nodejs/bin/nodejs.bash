#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : nodejs.bash, Version 0.00.001
###     프로그램 설명   : Node.js를 관리 합니다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 1995.02.20 ~ 2018.03.09
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

SOFTWARE="Nodejs"
if [[ -f ${HOME_SERVICE}/${SOFTWARE}/bin/config.php ]]; then
    source ${HOME_SERVICE}/${SOFTWARE}/bin/config.php
fi

### ------------------------------------------------------------------------------------------------
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    echo "Using : nodejs.bash COMMAND [OPTIONS]"
    echo "        COMMAND              : help, install, status, ps, start, restart, stop"
    echo "        OPTIONS              : ..."
    echo " "
    exit 2
}

### ------------------------------------------------------------------------------------------------
###     Status를 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcStatus() {
    ZZTEMP=`node --version`
    echo "Node version : ${ZZTEMP}"
    ZZTEMP=`npm --version`
    echo "npm version  : ${ZZTEMP}"
    echo " "
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
        cd /work/install
        wget https://kojipkgs.fedoraproject.org//packages/http-parser/2.7.1/3.el7/x86_64/http-parser-2.7.1-3.el7.x86_64.rpm 
        rpm -ivh http-parser-2.7.1-3.el7.x86_64.rpm
        yum -y install nodejs
        ;;
    status)
        funcStatus
        ;;
    start)
        systemctl start nginx.service
        ;;
    restart)
        systemctl restart nginx.service
        ;;
    stop)
        systemctl stop nginx.service
        ;;
    ps)
        ps -ef | grep -v grep | grep node
        ;;
    *)
        funcUsing
        ;;
esac
echo " "

exit 0
### ================================================================================================

