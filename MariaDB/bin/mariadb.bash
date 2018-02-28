#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : mariadb.bash, Version 0.00.001
###     프로그램 설명   : MariaDB를 관리 합니다.
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

SOFTWARE="MariaDB"
if [[ -f ${HOME_SERVICE}/${SOFTWARE}/bin/config.php ]]; then
    source ${HOME_SERVICE}/${SOFTWARE}/bin/config.php
fi

### ------------------------------------------------------------------------------------------------
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    echo "Using : mariadb.bash COMMAND [OPTIONS]"
    echo "        COMMAND              : help, install, status, ps, start, restart, stop"
    echo "        OPTIONS              : ..."
    echo " "
    exit 2
}

### ------------------------------------------------------------------------------------------------
###     Status를 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcStatus() {
    mysql -V
    echo " "
    echo "Config"
    echo "    vi /etc/my.cnf"
    echo "    /etc/my.cnf.d/"
    echo "Data                : /var/lib/mysql/"
    echo "Socket              : /var/lib/mysql/mysql.sock"
    echo " "
    echo "tail -f /var/log/mariadb/mariadb.log"
    echo "mysql -uroot -p mysql -e \"show variables like 'c%'\""
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
        /bin/bash ${HOME_SERVICE}/${SOFTWARE}/bin/mariadb_install.bash
        ;;
    status)
        funcStatus
        ;;
    start)
        systemctl start mariadb.service
        ;;
    restart)
        systemctl restart mariadb.service
        ;;
    stop)
        systemctl stop mariadb.service
        ;;
    ps)
        ps -ef | grep -v grep | grep mysql
        ;;
    *)
        funcUsing
        ;;
esac
echo " "

exit 0
### ================================================================================================

