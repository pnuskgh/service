#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : utilCommon.bash, Version 0.00.002
###     프로그램 설명   : Common library
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2002.7.15 ~ 2016.1.27
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2016 산사랑, All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     info(message), 2016.1.27 ~ 2016.1.27, Version 0.00.001
###     표준 출력에 메시지를 표시 합니다.
### ------------------------------------------------------------------------------------------------
info() {
    echo "$*"
}

### ------------------------------------------------------------------------------------------------
###     debug(message), 2016.1.27 ~ 2016.1.27, Version 0.00.001
###     flagDebug가 True일 경우, 메시지를 표시 합니다.
### ------------------------------------------------------------------------------------------------
flagDebug="False"
debug() {
    if [[ "${flagDebug}" == "True" ]]; then
        echo "$*"
    fi
}

### ------------------------------------------------------------------------------------------------
###     error(message), 2016.1.27 ~ 2016.1.27, Version 0.00.001
###     Error 메시지를 표시 합니다.
### ------------------------------------------------------------------------------------------------
error() {
    echo "Error : $*"
}

### ------------------------------------------------------------------------------------------------
###     funcGetLocalDir($0), 2016.1.27 ~ 2017.2.3, Version 0.00.002
###     PC 환경에서 daoucloud가 배포된 폴더를 반환 합니다.
### ------------------------------------------------------------------------------------------------
funcGetLocalDir() {
    local ZZTEMP001
    local ZZTEMP002
    local ZZTEMP003

    ZZTEMP001=`pwd`
    ZZTEMP002=`dirname $0`
    ZZTEMP003=${ZZTEMP002/${ZZTEMP001}/}
    
    pushd . > /dev/null 2>&1
    cd ${ZZTEMP001}/${ZZTEMP003}
    cd ..
    RTSTR=`pwd`
    popd > /dev/null 2>&1
}

funcGetLocalDir $0    
LOCAL_DIR=${RTSTR}

### ------------------------------------------------------------------------------------------------
###     funcStartWith, 2016.1.9 ~ 2016.2.3, Version 0.00.003
###     Using
###         funcStartWith 문자열 비교할_문자열_목록
###         funcStartWith ${NODE} controller
### ------------------------------------------------------------------------------------------------
funcStartWith() {
    local source=$1
    local match=$2
    local tmpstr

    tmpstr=`expr match ${source} "\(^${match}\).*"`
    if [[ "${match}" == "${tmpstr}" ]]; then
        return 1
    else
        return 0
    fi
}

### ------------------------------------------------------------------------------------------------
###     funcEndWith, 2016.2.3 ~ 2016.2.3, Version 0.00.001
###     Using
###         funcEndWith 문자열 비교할_문자열_목록
###         funcEndWith ${NODE} 001
### ------------------------------------------------------------------------------------------------
funcEndWith() {
    local source=$1
    local match=$2
    local tmpstr

    tmpstr=`expr match ${source} ".*\(${match}\$\)"`
    if [[ "${match}" == "${tmpstr}" ]]; then
        return 1
    else
        return 0
    fi
}

### ----------------------------------------------------------------------------
###     funcGetNodes(nodes), 2016.1.9 ~ 2016.4.6, Version 0.00.005
###     전체 node명을 반환 합니다.
### ----------------------------------------------------------------------------
funcGetNodes() {
    if [[ -f /usr/bin/fuel ]]; then
        funcGetNodesFuel $*
    else
        if [[ -f /etc/test_manage001 ]]; then
            funcGetNodesManualTest $*
        else
            funcGetNodesManual $*
        fi
    fi
}
funcGetNodesManualTest() {
    local ARGS=$*
    local ZZTEMP

    RTSTR=""
    for arg in ${ARGS}; do
        if [[ "${arg}" == "all" ]]; then
            ZZTEMP="controller001 controller002 controller003 compute001 compute002 storage001 storage002 telemetry001 telemetry002 monitoring001"
        elif [[ "${arg}" == "controller" ]]; then
            ZZTEMP="controller001 controller002 controller003"
        elif [[ "${arg}" == "compute" ]]; then
            ZZTEMP="compute001 compute002"
        elif [[ "${arg}" == "storage" ]]; then
            ZZTEMP="storage001 storage002"
        elif [[ "${arg}" == "telemetry" ]]; then
            ZZTEMP="telemetry001 telemetry002"
        elif [[ "${arg}" == "monitoring" ]]; then
            ZZTEMP="monitoring001"
        elif [[ "${arg}" == "manage" ]]; then
            ZZTEMP="manage001"
        else
            ZZTEMP=${arg}
        fi
        RTSTR="${RTSTR} ${ZZTEMP}"
    done
    return 0
}

funcGetNodesManual() {
    local ARGS=$*
    local ZZTEMP

    RTSTR=""
    for arg in ${ARGS}; do
        if [[ "${arg}" == "all" ]]; then
            ZZTEMP="controller001 controller002 controller003 compute001 compute002 compute003 storage001 storage002 storage003 storage004 telemetry001 telemetry002 telemetry003 monitoring001"
        elif [[ "${arg}" == "controller" ]]; then
            ZZTEMP="controller001 controller002 controller003"
        elif [[ "${arg}" == "compute" ]]; then
            ZZTEMP="compute001 compute002 compute003"
        elif [[ "${arg}" == "storage" ]]; then
            ZZTEMP="storage001 storage002 storage003 storage004"
        elif [[ "${arg}" == "telemetry" ]]; then
            ZZTEMP="telemetry001 telemetry002 telemetry003"
        elif [[ "${arg}" == "monitoring" ]]; then
            ZZTEMP="monitoring001 monitoring002 monitoring003"
        elif [[ "${arg}" == "manage" ]]; then
            ZZTEMP="manage001"
        else
            ZZTEMP=${arg}
        fi
        RTSTR="${RTSTR} ${ZZTEMP}"
    done
    return 0
}

funcGetNodesFuel() {
    local ARGS=$*
    local ZZTEMP

    RTSTR=""
    for arg in ${ARGS}; do
        if [[ "${arg}" == "all" ]]; then
            ZZTEMP=`fuel2 node list | grep ready | sort -k 4 | awk '{printf "%s ", $4}'`
        elif [[ "${arg}" == "controller" ]]; then
            ZZTEMP=`fuel2 node list | grep ready | sort -k 4 | grep controller | awk '{printf "%s ", $4}'`
        elif [[ "${arg}" == "compute" ]]; then
            ZZTEMP=`fuel2 node list | grep ready | sort -k 4 | grep compute | awk '{printf "%s ", $4}'`
        elif [[ "${arg}" == "storage" ]]; then
            ZZTEMP=`fuel2 node list | grep ready | sort -k 4 | grep ceph-osd | awk '{printf "%s ", $4}'`
        elif [[ "${arg}" == "telemetry" ]]; then
            ZZTEMP=`fuel2 node list | grep ready | sort -k 4 | grep mongo | awk '{printf "%s ", $4}'`
        elif [[ "${arg}" == "monitoring" ]]; then
            ZZTEMP=`fuel2 node list | grep ready | sort -k 4 | grep elasticsearch_kibana | awk '{printf "%s ", $4}'`
        elif [[ "${arg}" == "manage" ]]; then
            ZZTEMP="manage001"
        else
            ZZTEMP=${arg}
        fi
        RTSTR="${RTSTR} ${ZZTEMP}"
    done
    return 0
}

### ------------------------------------------------------------------------------------------------
###     Main, 2016.2.3 ~ 2016.2.3, Version 0.00.001
### ------------------------------------------------------------------------------------------------
###---  Command Line에서 입력된 인수를 검사한다.
if [[ 0 < $# ]]; then
    COMMAND=$1
fi

case ${COMMAND} in
    testStartWith)
        shift
        funcStartWith $1 $2
        if [[ "$?" == "1" ]]; then
            echo true
        else
            echo false
        fi
        ;;
    testEndWith)
        shift
        funcEndWith $1 $2
        if [[ "$?" == "1" ]]; then
            echo true
        else
            echo false
        fi
        ;;
esac

### ================================================================================================
