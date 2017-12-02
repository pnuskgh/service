#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : 001_install.bash, Version 0.00.001
###     프로그램 설명   : Liferay Portal을 설치 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.12.04 ~ 2017.12.04
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
###     Liferay Portal 7.0.4 GA5 with Apache Tomcat 매뉴얼 배포
###     http://demo.obcon.co.kr/doc_liferay/
### ------------------------------------------------------------------------------------------------
cd ${DOCUMENT_ROOT}
unzip ${HOME_WORK}/install/liferay-ce-portal-doc-7.0-ga5-20171018150113838.zip
mv liferay-ce-portal-doc-7.0-ga5 doc_liferay
chown -R nginx:nginx doc_liferay
cp ${TEMPLATE_DIR}/index.html doc_liferay//index.html
chown nginx:nginx doc_liferay//index.html

### ------------------------------------------------------------------------------------------------
###     Liferay Portal 7.0.4 GA5 with Apache Tomcat 설치
### ------------------------------------------------------------------------------------------------
cd ${DOCUMENT_ROOT}
unzip ${HOME_WORK}/install/liferay-ce-portal-tomcat-7.0-ga5-20171018150113838.zip
mv liferay-ce-portal-7.0-ga5 liferay















### ================================================================================================

