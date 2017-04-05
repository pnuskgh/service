#!/bin/bash
### ================================================================================================
###     프로그램 명              : install_mariadb.bash, Version 0.00.002
###     프로그램 설명         	: MariaDB 설치 Script
###     작성자                     : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일                     : 2015.7.31 ~ 2015.8.4
### --- [History 관리] -------------------------------------------------------------------------------
###     2015.07.31, 산사랑 : 초안 작성
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2015 산사랑, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     root 사용자로 작업을 하고 있는지 확인 합니다.
### ------------------------------------------------------------------------------------------------
TMPSTR=`env | grep USER`
if [ "${TMPSTR}" = "USER=root" ]; then
    echo " "
else
    echo "root 사용자로 작업 하세요."
    exit 1
fi

### ------------------------------------------------------------------------------------------------
###     MariaDB 설치 및 환경 설정
### ------------------------------------------------------------------------------------------------
yum install -y mariadb mariadb-devel mariadb-server
yum install -y mysql-connector-odbc

service mariadb start

TMPSTR=`grep "SET NAMES utf8" /etc/my.cnf | wc -l`
if [ "${TMPSTR}" = "0" ]; then
    TMPSTR=`which mysql_secure_installation | grep ' no ' | wc -l` >& /etc/null
    if [ "${TMPSTR}" = "1" ]; then
        mysql_secure_installation
    else
        echo " "
        echo "아래 명령을 사용하여 비밀번호를 설정 하세요."
        echo "    mysqladmin -u root password 'new-password'"
        ### mysql -u root -p mysql
        echo " "
    fi

    ### MySQL UTF-8 설정
    sed -i -e 's/!includedir \/etc\/my.cnf.d/ppp=qqq/g' /etc/my.cnf
    crudini --set /etc/my.cnf mysql default-character-set utf8
    crudini --set /etc/my.cnf mysqld character-set-client-handshake FALSE
    crudini --set /etc/my.cnf mysqld init_connect '"SET collation_connection=utf8_general_ci"'
    crudini --set /etc/my.cnf mysqld init_connect '"SET NAMES utf8"'
    # crudini --set /etc/my.cnf mysqld default-character-set utf8
    crudini --set /etc/my.cnf mysqld character_set_client utf8
    crudini --set /etc/my.cnf mysqld character-set-server utf8
    crudini --set /etc/my.cnf mysqld collation-server utf8_general_ci
    crudini --set /etc/my.cnf client default-character-set utf8
    crudini --set /etc/my.cnf mysqldump default-character-set utf8
    sed -i -e 's/ppp=qqq/!includedir \/etc\/my.cnf.d/g' /etc/my.cnf
fi

service mariadb restart

### ================================================================================================
