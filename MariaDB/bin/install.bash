#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : install.bash, Version 0.00.003
###     프로그램 설명   : MariaDB를 설치 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.19 ~ 2017.10.07
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
SOFTWARE="MariaDB"

if [[ "z${HOME_SERVICE}z" == "zz" ]]; then
    export HOME_SERVICE="/service"
fi
WORKING_DIR="${HOME_SERVICE}/${SOFTWARE}"
source ${HOME_SERVICE}/bin/config.bash > /dev/null 2>&1
source ${UTIL_DIR}/common.bash > /dev/null 2>&1

if [[ -f ${WORKING_DIR}/bin/config.php ]]; then
    source ${WORKING_DIR}/bin/config.php
else
    TIMESTAMP=`date +%Y%m%d_%H%M%S`
    BACKUP_DIR=${WORKING_DIR}/backup
    TEMPLATE_DIR=${WORKING_DIR}/template
fi

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
###         mysql  Ver 15.1 Distrib 5.5.56-MariaDB
### ------------------------------------------------------------------------------------------------
mysql -V

### ------------------------------------------------------------------------------------------------
###     UTF-8 설정
### ------------------------------------------------------------------------------------------------
/usr/bin/cp ${TEMPLATE_DIR}/my.cnf               /etc
/usr/bin/cp ${TEMPLATE_DIR}/client.cnf           /etc/my.cnf.d
/usr/bin/cp ${TEMPLATE_DIR}/server.cnf           /etc/my.cnf.d
/usr/bin/cp ${TEMPLATE_DIR}/mysql-clients.cnf    /etc/my.cnf.d

systemctl restart mariadb.service

mysql -uroot -pdemo1234 mysql -e "show variables like 'c%'"

### ------------------------------------------------------------------------------------------------
###     방화벽 설정
### ------------------------------------------------------------------------------------------------
systemctl start firewalld.service
systemctl enable firewalld.service

firewall-cmd --permanent --add-service=mysql
firewall-cmd --reload
firewall-cmd --list-all

### ------------------------------------------------------------------------------------------------
###     Network로 Database 접속 허용
### ------------------------------------------------------------------------------------------------
# chcon -R -t httpd_sys_content_rw_t /var/www/html
setsebool httpd_can_network_connect_db=on
setsebool httpd_can_network_connect=on
setsebool httpd_can_sendmail=on
setsebool httpd_unified=on

### ------------------------------------------------------------------------------------------------
###     PhpMyAdmin
###     HeidiSQL
### ------------------------------------------------------------------------------------------------

# Backup/Restore
# Master/Slave, Multi-Master, Master/Replica
# HA (MaraiDB/Galera)

### ================================================================================================

