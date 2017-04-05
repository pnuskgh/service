#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : lma_collector.bash, Version 0.00.001
###     프로그램 설명   : LMA Collector Plugin 관리
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2016.1.30 ~ 2016.1.30
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

PLUGIN_LMA_COLLECTOR=custom/lma_collector/plugin/lma_collector

### ------------------------------------------------------------------------------------------------
###     funcUsing, 2016.1.30 ~ 2016.1.30, Version 0.00.001
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    info "Using : lma_collector.bash COMMAND OPTIONS"
    info "        COMMAND              : 실행할 명령"
    info "        OPTIONS              : 명령 옵션"

    info "    COMMAND"
    info "        info                 : 정보 조회"
    info "        deploy               : 배포"
    info "        start                : 시작"
    info "        status               : 상태 확인"
    info "        stop                 : 종료"
    info "        vi [folder] [test]   : Plugin 편집"

    info " "
    exit 1
}

### ------------------------------------------------------------------------------------------------
###     funcDeploy, 2016.1.30 ~ 2016.1.30, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcDeploy() {
    scp -r ${SERVER_FOLDER}/${PLUGIN_LMA_COLLECTOR} controller001:/usr/share > /dev/null 2>&1
    scp -r ${SERVER_FOLDER}/${PLUGIN_LMA_COLLECTOR} controller002:/usr/share > /dev/null 2>&1
    scp -r ${SERVER_FOLDER}/${PLUGIN_LMA_COLLECTOR} controller003:/usr/share > /dev/null 2>&1
}

### ------------------------------------------------------------------------------------------------
###     funcStart, 2016.1.30 ~ 2016.1.30, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcStart() {
    ssh controller001 "pcs resource enable clone_lma_collector"
}

### ------------------------------------------------------------------------------------------------
###     funcStatus, 2016.1.30 ~ 2016.1.30, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcStatus() {
    ssh controller001 "pcs status"
}

### ------------------------------------------------------------------------------------------------
###     funcStop, 2016.1.30 ~ 2016.1.30, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcStop() {
    ssh controller001 "pcs resource disable clone_lma_collector"
}

### ------------------------------------------------------------------------------------------------
###     funcInfo, 2016.1.30 ~ 2016.1.30, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcInfo() {
    info "------------------------------------------------------------"
    info "--- Information"
    info "LMA Collector Plugin         : ${SERVER_FOLDER}/${PLUGIN_LMA_COLLECTOR}"
    info "LMA Collector Plugin         : controller:/usr/share/lma_collector"
    info "Pacemaker/Corosync resource  : clone_lma_collector"
    info " "
}

### ------------------------------------------------------------------------------------------------
###     funcVi, 2016.1.30 ~ 2016.1.30, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcVi() {
    if [[ 1 == $# ]]; then
        info "------------------------------------------------------------"
        info "--- $1 plugin list"
        ls ${SERVER_FOLDER}/${PLUGIN_LMA_COLLECTOR}/$1 | awk '{print $1}'
    elif [[ 2 == $# ]]; then
        vim ${SERVER_FOLDER}/${PLUGIN_LMA_COLLECTOR}/$1/$2
    else
        info "------------------------------------------------------------"
        info "--- Plugin folder list"
        ls ${SERVER_FOLDER}/${PLUGIN_LMA_COLLECTOR} | awk '{print $1}'
    fi
    info " "
}

### ------------------------------------------------------------------------------------------------
###     Main, 2016.1.30 ~ 2016.1.30, Version 0.00.001
### ------------------------------------------------------------------------------------------------
###---  Command Line에서 입력된 인수를 검사한다.
if [[ 0 < $# ]]; then
    COMMAND=$1
    shift
    OPTIONS=$*
else
    funcUsing
fi

case ${COMMAND} in
    deploy)
        funcDeploy ${OPTIONS}
        ;;
    start)
        funcStart ${OPTIONS}
        ;;
    status)
        funcStatus ${OPTIONS}
        ;;
    stop)
        funcStop ${OPTIONS}
        ;;
    info)
        funcInfo ${OPTIONS}
        ;;
    vi)
        funcVi ${OPTIONS}
        ;;
    *)
        funcUsing
        ;;
esac
exit 0

### ================================================================================================
