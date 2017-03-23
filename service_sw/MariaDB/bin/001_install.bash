#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : 001_install.bash, Version 0.00.001
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
. config.bash > /dev/null 2>&1

### ------------------------------------------------------------------------------------------------
###     MariaDB 설치
### ------------------------------------------------------------------------------------------------
yum -y install mariadb-server mariadb

systemctl restart mariadb.service
systemctl enable mariadb.service

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
cp /etc/my.cnf ${BASE_DIR}/backup/my.cnf_${TIMESTAMP}
/usr/bin/cp -f ${BASE_DIR}/files/my.cnf /etc/my.cnf
chmod 644 /etc/my.cnf

cp /etc/my.cnf.d/client.cnf ${BASE_DIR}/backup/client.cnf_${TIMESTAMP}
/usr/bin/cp -f ${BASE_DIR}/files/client.cnf /etc/my.cnf.d/client.cnf
chmod 644 /etc/my.cnf.d/client.cnf

cp /etc/my.cnf.d/mysql-clients.cnf ${BASE_DIR}/backup/mysql-clients.cnf_${TIMESTAMP}
/usr/bin/cp -f ${BASE_DIR}/files/mysql-clients.cnf /etc/my.cnf.d/mysql-clients.cnf
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

