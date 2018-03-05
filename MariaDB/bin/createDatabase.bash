#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : createDatabase.bash, Version 0.00.004
###     프로그램 설명   : Database 사용자를 생성 합니다.
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
    /bin/echo "Using : createDatabase.bash DATABASE USER PASSWORD [ROOTPASSWORD]"
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
/bin/echo "Create Database : " ${DATABASE}
mysql -uroot -p${ROOTPASSWORD} mysql <<+
create database ${DATABASE};
show databases;

grant all privileges on ${DATABASE}.* to ${USER}@localhost identified by '${PASSWORD}';
grant all privileges on ${DATABASE}.* to ${USER}@'%' identified by '${PASSWORD}';
flush privileges;

select Host, User, Password from user order by User, Host;
select Host, Db, User from db order by User, Db, Host;
exit

+

# insert into user (Host, User, Password)
#        values ('localhost', '${USER}', password('${PASSWORD}'));
# commit;

exit 0

### ================================================================================================

