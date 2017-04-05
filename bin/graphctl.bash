#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : graphctl.bash, Version 0.00.001
###     프로그램 설명   : Nagios 관리
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2016.4.1 ~ 2016.4.1
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2016 산사랑, All rights reserved.
### ================================================================================================

if [[ "${SERVER_FOLDER}" == "" ]]; then
    echo "SERVER_FOLDER 환경 변수를 설정 하세요."
    echo " "
    exit 1
fi

. ${SERVER_FOLDER}/bin/config.bash > /dev/null 2>&1
. ${SERVER_FOLDER}/bin/utilCommon.bash > /dev/null 2>&1

### ------------------------------------------------------------------------------------------------
###     funcUsing, 2016.4.1 ~ 2016.4.1, Version 0.00.001
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    info "Using : graphctl.bash GRAPH START END STEP"
    info "        GRAPH                : 그래프 파일"
    info "        START                : Start task"
    info "        END                  : End task"
    info "        STEP                 : 진행할 단계 수"
    info " "
    
    info "    Task"
    info "        pre_deployment_start"
    info "        pre_deployment_end"
    info "        deploy_start"
    info "        deploy_end"
    info "        post_deployment_start"
    info "        post_deployment_end"
    info " "
    exit 1
}

### ------------------------------------------------------------------------------------------------
###     funcPath, 2016.4.1 ~ 2016.4.1, Version 0.00.001
###     실행값 할당 aaa=$(~)
### ------------------------------------------------------------------------------------------------
funcPath() {
    local GRAPH=$1
    local START=$2
    local END=$3
    local STEP=$4
    local queue

    grep ${START} ${GRAPH} > /root/zztemp/zzout001.gv
    while read -u 11 from _ to; do
        to=${to/;/}
        to=${to/\"/}
        to=${to/\"/}
        echo "${from} -> ${to};"
    done 11< /root/zztemp/zzout001.gv
    echo " "
}

### ------------------------------------------------------------------------------------------------
###     Main, 2016.4.1 ~ 2016.4.1, Version 0.00.001
###     graphctl.bash /root/zztemp/graph.gv post_deployment_start post_deployment_end 1
### ------------------------------------------------------------------------------------------------
###---  Command Line에서 입력된 인수를 검사한다.
if [[ $# == 4 ]]; then
    GRAPH=$1
    START=$2
    END=$3
    STEP=$4
else
    funcUsing
fi

funcPath ${GRAPH} ${START} ${END} ${STEP}

exit 0

### ================================================================================================
