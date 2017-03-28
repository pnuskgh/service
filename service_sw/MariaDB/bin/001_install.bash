#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : 001_install.bash, Version 0.00.002
###     프로그램 설명   : MariaDB를 설치 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.19 ~ 2017.01.19
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

WORKING_DIR=`dirname $0`
WORKING_DIR=${WORKING_DIR}/..
source ${WORKING_DIR}/bin/config.bash

### ------------------------------------------------------------------------------------------------
###     MariaDB 설치
###         5.5.52-MariaDB MariaDB Server
### ------------------------------------------------------------------------------------------------
yum -y install mariadb mariadb-server

systemctl enable mariadb.service
systemctl restart mariadb.service

# mysqladmin password
mysql_secure_installation

### ------------------------------------------------------------------------------------------------
###     설치 정보 확인
###         5.5.52-MariaDB
### ------------------------------------------------------------------------------------------------
mysql -V

### ------------------------------------------------------------------------------------------------
###     UTF-8 설정
### ------------------------------------------------------------------------------------------------
backup /etc my.cnf
/usr/bin/cp -f ${TEMPLATE_DIR}/my.cnf /etc
chmod 644 /etc/my.cnf

backup /etc/my.cnf.d client.cnf
/usr/bin/cp -f ${TEMPLATE_DIR}/client.cnf /etc/my.cnf.d
chmod 644 /etc/my.cnf.d/client.cnf

backup /etc/my.cnf.d mysql-clients.cnf
/usr/bin/cp -f ${TEMPLATE_DIR}/mysql-clients.cnf /etc/my.cnf.d
chmod 644 /etc/my.cnf.d/mysql-clients.cnf

systemctl restart mariadb.service

mysql -uroot -pdemo1234 mysql -e "show variables like 'c%'"

### ------------------------------------------------------------------------------------------------
###     PhpMyAdmin
###     HeidiSQL
### ------------------------------------------------------------------------------------------------

# Backup/Restore
# Master/Slave, Multi-Master, Master/Replica
# HA (MaraiDB/Galera)

### ================================================================================================

