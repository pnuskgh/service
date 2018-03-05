#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : 001_install.bash, Version 0.00.004
###     프로그램 설명   : MySQL을 설치 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.19 ~ 2017.11.05
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
###     MySQL 설치
###         5.5.57 MySQL Community Server (GPL)
### ------------------------------------------------------------------------------------------------
yum -y install mysql mysql-server

service mysqld start
chkconfig mysqld on

systemctl enable mariadb.service
systemctl restart mariadb.service

# mysqladmin password
#     mysqladmin -u root password 'new-password'
#     mysqladmin -u root -h www.obcon.biz password 'new-password'
mysql_secure_installation

### ------------------------------------------------------------------------------------------------
###     설치 정보 확인
###         5.5.52-MySQL
### ------------------------------------------------------------------------------------------------
mysql -V

### ------------------------------------------------------------------------------------------------
###     UTF-8 설정
###        my.cnf 작성
### ------------------------------------------------------------------------------------------------
backup /etc my.cnf
/usr/bin/cp -f ${TEMPLATE_DIR}/my.cnf /etc
chmod 644 /etc/my.cnf

service mysqld restart
# systemctl restart mariadb.service

mysql -uroot -p mysql -e "show variables like 'c%'"

### ------------------------------------------------------------------------------------------------
###     방화벽 설정
### ------------------------------------------------------------------------------------------------
systemctl start firewalld.service
systemctl enable firewalld.service

firewall-cmd --permanent --add-service=mysql
firewall-cmd --reload
firewall-cmd --list-all

### ------------------------------------------------------------------------------------------------
###     PhpMyAdmin
###     HeidiSQL
### ------------------------------------------------------------------------------------------------

# Backup/Restore
# Master/Slave, Multi-Master, Master/Replica
# HA (MaraiDB/Galera)

### ================================================================================================

