#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : install.bash, Version 0.00.002
###     프로그램 설명   : Liferay Portal을 설치 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.12.04 ~ 2017.12.05
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
# WORKING_DIR="/service/service_sw/Liferay_Portal"
source ${WORKING_DIR}/bin/config.bash

### ------------------------------------------------------------------------------------------------
###     funcUsing()
###         사용법 표시
### ------------------------------------------------------------------------------------------------
funcUsing() {
    /bin/echo "Using : install.bash DATABASE USER PASSWORD [ROOTPASSWORD]"
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
###     Liferay Portal 7.0.4 GA5 with Apache Tomcat 설치
### ------------------------------------------------------------------------------------------------
yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-*

cd ${DOCUMENT_ROOT}
unzip ${HOME_WORK}/install/liferay-ce-portal-tomcat-7.0-ga5-20171018150113838.zip
mv liferay-ce-portal-7.0-ga5 liferay

# systemctl restart firewalld.service
firewall-cmd --permanent --zone=public --add-port=8080/tcp
firewall-cmd --reload
firewall-cmd --list-all

### ------------------------------------------------------------------------------------------------
###     MariaDB 구성
### ------------------------------------------------------------------------------------------------
${HOME_SERVICE}/service_sw/MariaDB/bin/createDatabase.bash ${DATABASE} ${USER} ${PASSWORD} ${ROOTPASSWORD}

TMPFILE=${DOCUMENT_ROOT}/liferay/portal-ext.properties
echo "jdbc.default.driverClassName=org.mariadb.jdbc.Driver" >> ${TMPFILE}
echo "jdbc.default.url=jdbc:mariadb://localhost/${DATABASE}?useUnicode=true&characterEncoding=UTF-8&useFastDateParsing=false" >> ${TMPFILE}
echo "jdbc.default.username=${USER}" >> ${TMPFILE}
echo "jdbc.default.password=${PASSWORD}" >> ${TMPFILE}

cat ${TMPFILE}
echo " "

### ------------------------------------------------------------------------------------------------
###     Liferay Portal 기동/종료
### ------------------------------------------------------------------------------------------------
cd ${DOCUMENT_ROOT}
cd liferay/tomcat-8.0.32/bin
./startup.sh

# tail -f ${DOCUMENT_ROOT}/liferay/tomcat-8.0.32/logs/catalina.out
# tail -f /usr/share/nginx/html/liferay/tomcat-8.0.32/logs/catalina.out
# http://demo.obcon.co.kr:8080/

# ./shutdown.sh

### ================================================================================================

