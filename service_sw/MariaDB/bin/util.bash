#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : util.bash, Version 0.00.001
###     프로그램 설명   : MariaDB 공통 라이브러리
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.03.30 ~ 2017.03.30
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     funcMysqlAllowAccess()          : Mysql Database에 접속 권한 부여
###         $DATABASE                   : $1 - Database
###         $USER                       : $2 - Database user
###         $PASSWORD                   : $3 - Database user password
###         $HOST                       : $4 - Hostname
###         $ROOTPASSWORD               : $5 - Database root user password
### ------------------------------------------------------------------------------------------------
funcMysqlAllowAccess() {
    local DATABASE=$1
    local USER=$2
    local PASSWORD=$3
    local HOST=$4
    local ROOTPASSWORD=$5

MARIADB_VERSION=`mysql --version | awk '{print $3}'`
mysql -uroot -p${ROOTPASSWORD} mysql <<+
insert into db
       values ('${HOST}', '${DATABASE}', '${USER}',
       'Y','Y','Y','Y','Y','Y','Y','Y','Y','Y',
       'Y','Y','Y','Y','Y','Y','Y','Y','Y');
commit;
flush privileges;

grant all privileges on ${DATABASE}.* to ${USER}@${HOST} identified by '${PASSWORD}';
flush privileges;

exit

+

if [[ "$?" -gt "0" ]]; then
    return $?
fi
return 0;
}

### ================================================================================================

