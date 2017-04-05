#!/bin/bash
### ============================================================================
###     프로그램 명  			: utilCommon.bash, Version 0.00.001
###     프로그램 설명   		: Bash 공통 라이브러리
###     작성자          		: 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          		: 2002.07.15 ~ 2013.04.04
### ----[History 관리]----------------------------------------------------------
###     수정자          		:
###     수정일          		:
###     수정 내용       		:
### --- [Copyright] ------------------------------------------------------------
###     Copyright (c) 1995~2013 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ============================================================================

### ----------------------------------------------------------------------------
###     funcCheckServer(argServer)		: 특정 서버에서만 동작하도록 체크
###			$1, $2, ...					: Server
###			return value				: $? - 0. true, 1. false
### ----------------------------------------------------------------------------
funcCheckServer() {
	HOSTNAME=`/bin/hostname`
	
	for server in "$@"; do
		if [[ ${HOSTNAME} = ${server} ]]; then
		  	/bin/echo " "
		  	return 0
		fi
	done
	
  	/bin/echo "Error : 올바른 서버에서 작업을 하세요"
  	return 1
}

### ----------------------------------------------------------------------------
###     funcMysqlAllowAccess()          : Mysql Database에 접속 권한 부여
###			$DATABASE					: $1 - Database
###			$USER						: $2 - Database user
###			$PASSWORD					: $3 - Database user password
###			$HOST			    		: $4 - Hostname
###			$ROOTPASSWORD				: $5 - Database root user password
### ----------------------------------------------------------------------------
funcMysqlAllowAccess() {
    local DATABASE=$1
    local USER=$2
    local PASSWORD=$3
    local HOST=$4
    local ROOTPASSWORD=$5

### if [[ $MYSQL_VERSION = '5.1' ]]; then
if [[ $MYSQL_VERSION = '10.0.13-MariaDB' ]]; then
    /usr/bin/mysql -uroot -p${ROOTPASSWORD} mysql <<+
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
else
	/usr/bin/mysql -uroot -p${ROOTPASSWORD} mysql <<+
insert into db
       values ('${HOST}', '${DATABASE}', '${USER}', 
	   'Y','Y','Y','Y','Y','Y','Y','Y','Y','Y',
	   'Y','Y','Y','Y','Y','Y','Y');
commit;
flush privileges;

grant all privileges on ${DATABASE}.* to ${USER}@${HOST} identified by '${PASSWORD}';
flush privileges;
exit

+
fi

if [[ "$?" -gt "0" ]]; then
	return $?
fi
return 0;
}

### ============================================================================
