#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : initialize.bash, Version 0.00.002
###     프로그램 설명   : CentOS 기본 이미지를 작성 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.06 ~ 2017.03.27
### ----[History 관리]------------------------------------------------------------------------------
###     수정자         	:
###     수정일         	:
###     수정 내용      	:
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
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
###     CentOS 6을 업데이트 한다.
### ------------------------------------------------------------------------------------------------
yum -y update

### ------------------------------------------------------------------------------------------------
###     불필요한 패키지와 서비스를 제거 한다.
### ------------------------------------------------------------------------------------------------
yum -y remove NetworkManager

### ================================================================================================

