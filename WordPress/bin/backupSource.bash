#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명                     : backupSource.bash, Version 0.00.005
###     프로그램 설명                   : Instance의 Source를 백업 합니다.
###     작성자                          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일                          : 2002.07.15 ~ 2017.11.01
### ----[History 관리]------------------------------------------------------------------------------
###     수정자                          :
###     수정일                          :
###     수정 내용                       :
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
###     funcUsing()
###                     사용법 표시
### ------------------------------------------------------------------------------------------------
funcUsing() {
    /bin/echo "Using : backupSource.bash INSTANCE"
    /bin/echo "        INSTANCE       : Instance"
    /bin/echo " "
        exit 1
}

###---  Command Line에서 입력된 인수를 검사한다.
if [[ $# = 1 ]]; then
        INSTANCE=$1
else
        funcUsing
fi

### ------------------------------------------------------------------------------------------------
###     Main process
### ------------------------------------------------------------------------------------------------
/bin/echo "Backup Source : " ${INSTANCE}
/bin/mkdir ${BACKUP_DIR} > /dev/null 2>&1

cd ${DOCUMENT_ROOT}
/bin/tar cvf ${BACKUP_DIR}/${INSTANCE}_${TIMESTAMP}.tar ${INSTANCE} > /dev/null 2>&1

if [[ "$?" -gt "0" ]]; then
        exit $?
fi

### /usr/bin/clear
/bin/echo "--------------------------------------------------"
/bin/echo "Backup folder : " ${BACKUP_DIR}
/bin/echo "Backup datetime : " ${TIMESTAMP}
/bin/echo " "

/bin/ls -alF ${BACKUP_DIR}/${INSTANCE}_${TIMESTAMP}.*
exit 0

### ================================================================================================

