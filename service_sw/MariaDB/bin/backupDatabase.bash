#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : backupDatabase.bash, Version 0.00.003
###     프로그램 설명   : Database를 백업 합니다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2002.07.15 ~ 2017.03.30
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
source ${WORKING_DIR}/bin/util.bash

### ------------------------------------------------------------------------------------------------
###     funcUsing()
###         사용법 표시
### ------------------------------------------------------------------------------------------------
funcUsing() {
    /bin/echo "Using : backupDatabase.bash DATABASE USER [PASSWORD] [OPTION]"
    /bin/echo "        DATABASE       : Database"
    /bin/echo "        USER           : Database 사용자"
    /bin/echo "        PASSWORD       : Database 사용자의 암호"
    /bin/echo "        OPTION         : Backup Option"
    /bin/echo " "
    exit 1
}

###---  Command Line에서 입력된 인수를 검사한다.
if [[ $# = 3 ]]; then
    PASSWORD=$3
elif [[ $# = 4 ]]; then
    PASSWORD=$3
    OPTION=ext
else
    funcUsing
fi
DATABASE=$1
USER=$2

### ------------------------------------------------------------------------------------------------
###     Main process
### ------------------------------------------------------------------------------------------------
/bin/echo "Backup Database : " ${DATABASE}
mkdir -p ${HOME_WORK}/backup > /dev/null 2>&1
if [[ ${OPTION} = "ext" ]]; then
    mysqldump -u${USER} -p${PASSWORD} --lock-tables=false ${DATABASE} > ${HOME_WORK}/backup/database_${DATABASE}_${TIMESTAMP}.sql
    ### mysqldump -u${USER} -p${PASSWORD} --single-transaction ${DATABASE} > ${HOME_WORK}/backup/database_${DATABASE}_${TIMESTAMP}.sql
else
    mysqldump -u${USER} -p${PASSWORD} ${DATABASE} > ${HOME_WORK}/backup/database_${DATABASE}_${TIMESTAMP}.sql
fi

if [[ "$?" -gt "0" ]]; then
    exit $?
fi

### /usr/bin/clear
/bin/echo "--------------------------------------------------"
/bin/echo "Backup folder : " ${HOME_WORK}/backup
/bin/echo "Backup datetime : " ${TIMESTAMP}
/bin/echo " "

/bin/ls -alF ${HOME_WORK}/backup/*${TIMESTAMP}.*

exit 0
### ================================================================================================

