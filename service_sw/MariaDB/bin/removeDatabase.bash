#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : removeDatabase.bash, Version 0.00.003
###     프로그램 설명   : Database를 삭제 합니다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2002.09.27 ~ 2017.03.30
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

### ------------------------------------------------------------------------------------------------
###     funcUsing()
###         사용법 표시
### ------------------------------------------------------------------------------------------------
funcUsing() {
    /bin/echo "Using : removeDatabase.bash DATABASE USER PASSWORD [ROOTPASSWORD]"
    /bin/echo "        DATABASE       : Database"
    /bin/echo "        USER           : Database 사용자"
    /bin/echo "        PASSWORD       : Database 사용자의 암호"
    /bin/echo "        ROOTPSSWORD    : Database root 사용자의 암호"
    /bin/echo " "
    exit 1
}

###---  Command Line에서 입력된 인수를 검사한다.
if [[ $# = 3 ]]; then
    /bin/echo -n "Database root 사용자의 암호를 입력 하세요 : "
    read ROOTPASSWORD
elif [[ $# = 4 ]]; then
    ROOTPASSWORD=$4
else
    funcUsing
fi
DATABASE=$1
USER=$2
PASSWORD=$3

### ------------------------------------------------------------------------------------------------
###     Main process
### ------------------------------------------------------------------------------------------------
/bin/echo "Remove Database : " ${DATABASE}
mysql -uroot -p${ROOTPASSWORD} mysql <<+
delete from db
 where db = '${DATABASE}';
delete from user
 where user = '${USER}';
drop database ${DATABASE};
commit;
flush privileges;
exit

+

exit 0
### ================================================================================================

