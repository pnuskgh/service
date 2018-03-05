#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : restoreDatabase.bash, Version 0.00.003
###     프로그램 설명   : Database를 복구 합니다.
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
    /bin/echo "Using : restoreDatabase.bash DATABASE USER PASSWORD FILESQL"
    /bin/echo "        DATABASE       : Database"
    /bin/echo "        USER           : Database 사용자"
    /bin/echo "        PASSWORD       : Database 사용자의 암호"
    /bin/echo "        FILESQL        : SQL 파일 이름"
    /bin/echo " "
    exit 1
}

###---  Command Line에서 입력된 인수를 검사한다.
if [[ $# = 4 ]]; then
    FILESQL=$4
else
    funcUsing
fi
DATABASE=$1
USER=$2
PASSWORD=$3

### ------------------------------------------------------------------------------------------------
###     Main process
### ------------------------------------------------------------------------------------------------
/bin/echo "Restore Database : " ${DATABASE}
### /usr/bin/mysql -u${USER} -p${PASSWORD} -D ${DATABASE} < ${BACKUP_DIR}/${INSTANCE}/${INSTANCE}_${TIMESTAMP}.sql
/bin/mysql -u${USER} -p${PASSWORD} -D ${DATABASE} < ${HOME_WORK}/backup/${FILESQL}

exit 0
### ================================================================================================

