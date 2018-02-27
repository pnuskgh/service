#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : initialize.bash, Version 0.00.007
###     프로그램 설명   : CentOS를 초기화 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.04 ~ 2018.02.28
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2018 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     실행 환경을 설정 한다.
### ------------------------------------------------------------------------------------------------
source ${HOME_SERVICE}/bin/config.bash > /dev/null 2>&1

RELATION_DIR="$(dirname $0)"
WORKING_DIR="$(cd -P ${RELATION_DIR}/.. && pwd)"
source ${WORKING_DIR}/bin/config.bash

### ------------------------------------------------------------------------------------------------
###     EPEL 레파지토리를 추가 한다.
### ------------------------------------------------------------------------------------------------
yum -y install epel-release

### ------------------------------------------------------------------------------------------------
###     CentOS 7을 업데이트 한다.
### ------------------------------------------------------------------------------------------------
yum -y update

### ------------------------------------------------------------------------------------------------
###     불필요한 패키지와 서비스를 제거 한다.
### ------------------------------------------------------------------------------------------------
yum -y remove NetworkManager

### ------------------------------------------------------------------------------------------------
###     centos 사용자가 없을 경우 사용자를 추가 한다.
### ------------------------------------------------------------------------------------------------
# groupadd centos
# useradd -d /home/centos -s /usr/bin/bash -m -g centos centos

### ------------------------------------------------------------------------------------------------
###     Hostname을 설정 합니다.
### ------------------------------------------------------------------------------------------------
hostnamectl status
# hostnamectl set-hostname www.obcon.biz

### ================================================================================================

