#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : firewall.bash, Version 0.00.001
###     프로그램 설명   : CentOS 7의 방화벽 설정을 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.10.07 ~ 2017.10.07
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
# WORKING_DIR="/service/service_os/CentOS7"
source ${WORKING_DIR}/bin/config.bash

### ------------------------------------------------------------------------------------------------
###     방화벽 활성화
###     https://www.lesstif.com/pages/viewpage.action?pageId=22053128
### ------------------------------------------------------------------------------------------------
systemctl start firewalld.service
systemctl enable firewalld.service

### ------------------------------------------------------------------------------------------------
###     방화벽 정보 조회
### ------------------------------------------------------------------------------------------------
ls -alF /usr/lib/firewalld/ 
# ls -alF /usr/lib/firewalld/zones
# ls -alF /usr/lib/firewalld/services

#--- Zone 정보 조회
firewall-cmd --get-zones                                    #--- Zone
firewall-cmd --list-all-zones                               #--- Zone 상세
firewall-cmd --get-default-zone                             #--- Default Zone
firewall-cmd --list-all                                     #--- Default Zone 상세
firewall-cmd --get-active-zone                              #--- 활성화된 Zone

#--- Service 정보 조회
firewall-cmd --get-services                                 #--- Service
firewall-cmd --list-services --zone=public                  #--- 적용된 Service
firewall-cmd --permanent --list-all --zone=public           #--- 적용된 Service 상세

#--- 방화벽 내부 설정
# firewall-cmd  --direct --get-all-rules
# firewall-cmd --direct --add-rule ipv4 nat POSTROUTING 0 -o eth_ext -j MASQUERADE

### ------------------------------------------------------------------------------------------------
###     허용 IP 설정
### ------------------------------------------------------------------------------------------------
# firewall-cmd --permanent --zone=public --add-source=192.168.1.0/24 --add-port=22/tcp

### ------------------------------------------------------------------------------------------------
###     Web Server 방화벽 설정
### ------------------------------------------------------------------------------------------------
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
# firewall-cmd --permanent --zone=public --remove-service=http

# firewall-cmd --permanent --zone=public --add-port=80/tcp
# firewall-cmd --permanent --zone=public --add-port=4000-4100/tcp
# firewall-cmd --permanent --zone=public --remove-port=80/tcp
firewall-cmd --reload
firewall-cmd --list-all

### ------------------------------------------------------------------------------------------------
###     Database Server 방화벽 설정
### ------------------------------------------------------------------------------------------------
firewall-cmd --permanent --zone=public --add-service=mysql
firewall-cmd --reload
firewall-cmd --list-all

### ================================================================================================

