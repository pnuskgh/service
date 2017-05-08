#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : install.bash, Version 0.00.001
###     프로그램 설명   : R Studio Server 환경을 구성 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.05.08 ~ 2017.05.08
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
###     R 설치
###         R version 3.3.3 (2017-03-06)
###         GNU GPL (General Public License) version 2 or 3
### ------------------------------------------------------------------------------------------------
# yum -y install R R-*
yum -y install R R-devel R-java
yum -y install libxml2-devel libxml2-static tcl tcl-devel tk tk-devel libtiff-static libtiff-devel libjpeg-turbo-devel libpng12-devel cairo-tools libicu-devel openssl-devel libcurl-devel freeglut readline-static readline-devel cyrus-sasl-devel

R --version
# R
#     q()

### ------------------------------------------------------------------------------------------------
###     R Studio Server 설치
###         Default port : 8787/tcp port 사용
###         http://bhjo0930.tistory.com/entry/RStudio-Server-%EC%84%9C%EB%B2%84-%EA%B5%AC%EC%84%B1%EA%B3%BC-%EA%B4%80%EB%A6%AC
### ------------------------------------------------------------------------------------------------
cd ${WORKING_DIR}/install

# wget https://download2.rstudio.org/rstudio-server-rhel-1.0.143-x86_64.rpm
yum -y install --nogpgcheck rstudio-server-rhel-1.0.143-x86_64.rpm

backup /etc/rstudio rserver.conf
/bin/cp -f ${TEMPLATE_DIR}/rserver.conf /etc/rstudio

systemctl enable  rstudio-server.service
systemctl restart rstudio-server.service
systemctl status  rstudio-server.service

# rstudio-server restart      #--- status, start, stop, restart, test-config, verify-installation

### ------------------------------------------------------------------------------------------------
###     R Studio Server 사이트에 접속할 사용자 생성
### ------------------------------------------------------------------------------------------------
#--- rstudio 사용자 생성
groupadd rstudio >& /etc/null
useradd  -d /home/rstudio -m -g rstudio rstudio >& /etc/null
passwd rstudio

cd /home/rstudio
/bin/cp -f ${TEMPLATE_DIR}/.Rprofile /home/rstudio
chown rstudio:rstudio .Rprofile

echo "http://공인IP/"

### ------------------------------------------------------------------------------------------------
###     R Studio Server 초기 설정
### ------------------------------------------------------------------------------------------------
# R CLI에서 template/initialize.R 파일 실행
# Rscript -e "명령어1; 명령어2"

### ================================================================================================

