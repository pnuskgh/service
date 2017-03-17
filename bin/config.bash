#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : config.bash, Version 0.00.008
###     프로그램 설명   : Linux bash Script의 설정 파일
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2013.05.12 ~ 2017.03.17
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     Local 환경 변수 설정
### ------------------------------------------------------------------------------------------------
if [[ -f ${BIN_DIR}/config_pre_local.bash ]]; then
    source ${BIN_DIR}/config_pre_local.bash > /dev/null 2>&1
fi

### ------------------------------------------------------------------------------------------------
###     환경 변수 설정
### ------------------------------------------------------------------------------------------------
if [[ "z${HOME_SERVICE}z" == "zz" ]]; then
    export HOME_SERVICE="/service"
fi

BIN_DIR=${HOME_SERVICE}/bin
UTIL_DIR=${HOME_SERVICE}/util

if [[ "z${HOME_WORK}z" == "zz" ]]; then
    export HOME_WORK="/work"
fi
REPOSITORY_GIT=${HOME_WORK}/repo_git

TIMESTAMP=`date +%Y%m%d_%H%M%S`

### ------------------------------------------------------------------------------------------------
###     Local 환경 변수 설정
### ------------------------------------------------------------------------------------------------
if [[ -f ${BIN_DIR}/config_local.bash ]]; then
    source ${BIN_DIR}/config_local.bash > /dev/null 2>&1
fi

### ================================================================================================

