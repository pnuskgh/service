#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : 002_dvr_server_info.bash, Version 0.00.002
###     프로그램 설명   : OpenStack DVR (Distribute VirtualRouter) Network : Server 정보 설정
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.05.16 ~ 2017.05.17
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

source ${HOME_SERVICE}/bin/config.bash > /dev/null 2>&1

### ------------------------------------------------------------------------------------------------
###    Main process
### ------------------------------------------------------------------------------------------------
CONTROLLER_NODE="controller001"

ssh ${CONTROLLER_NODE} mkdir -p ${HOME_WORK}/OpenStack
scp ${HOME_WORK}/OpenStack/config.bash ${CONTROLLER_NODE}:${HOME_WORK}/OpenStack > /dev/null 2>&1
scp ${TEMPLATE_DIR}/dvr_server_info.bash ${CONTROLLER_NODE}:${HOME_WORK}/OpenStack > /dev/null 2>&1

ssh ${CONTROLLER_NODE} ${HOME_WORK}/OpenStack/dvr_server_info.bash
scp ${CONTROLLER_NODE}:${HOME_WORK}/OpenStack/config_new.bash ${HOME_WORK}/OpenStack/config.bash > /dev/null 2>&1

### ================================================================================================

