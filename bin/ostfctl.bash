#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : ostfctl.bash, Version 0.00.002
###     프로그램 설명   : OSTF (OpenStack Testing Framework) 관리
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2016.1.27 ~ 2016.1.29
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
###     funcUsing, 2016.1.27 ~ 2016.1.29, Version 0.00.002
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    info "Using : ostfctl.bash COMMAND OPTIONS"
    info "        COMMAND              : 실행할 명령"
    info "        OPTIONS              : 명령 옵션"

    info "    COMMAND"
    info "        info                 : OSTF 정보 조회"
    info "        deploy [restart]     : ostf 배포, ostf-server 재시작"
    info "        restart              : ostf-server 재시작"
    info "        vi [folder] [test]   : TestCase 편집"

    info " "
    exit 1
}

### ------------------------------------------------------------------------------------------------
###     funcDeploy, 2016.1.26 ~ 2016.1.29, Version 0.00.002
### ------------------------------------------------------------------------------------------------
funcDeploy() {
    ssh fuel "mkdir -p ${OSTF_ROOT}/${BASE_DIR}/bin"

    scp ${SERVER_FOLDER}/bin/config.bash fuel:${OSTF_ROOT}/${BASE_DIR}/bin > /dev/null 2>&1
    scp ${SERVER_FOLDER}/bin/utilCommon.bash fuel:${OSTF_ROOT}/${BASE_DIR}/bin > /dev/null 2>&1

    scp -r ${SERVER_FOLDER}/custom/ostf/bin fuel:${OSTF_ROOT}/${BASE_DIR} > /dev/null 2>&1
    scp -r ${SERVER_FOLDER}/custom/ostf/fuel_health fuel:${OSTF_ROOT}/usr/lib/python2.6/site-packages > /dev/null 2>&1

    if [[ 0 < $# ]]; then
        funcRestart $*
    fi
}

zzfuncDeployFile() {
    local FOLDER_FR=$1
    local FILE=$2
    local FOLDER_TO=$3
    
    dos2unix ${SERVER_FOLDER}/${FOLDER_FR}/${FILE} > /dev/null 2>&1
    
    ssh fuel "mkdir -p ${OSTF_ROOT}/${BASE_DIR}/${FOLDER_TO}"
    scp ${SERVER_FOLDER}/${FOLDER_FR}/${FILE} fuel:${OSTF_ROOT}/${BASE_DIR}/${FOLDER_TO} > /dev/null 2>&1
}

zzfuncDeployFile_org() {
    local FOLDER_FR=$1
    local FILE=$2
    local FOLDER_TO=$3
    
    dos2unix ${SERVER_FOLDER}/${FOLDER_FR}/${FILE} > /dev/null 2>&1

    ssh fuel mkdir -p ${TEMP_DIR}/${FOLDER_FR} > /dev/null 2>&1
    scp ${SERVER_FOLDER}/${FOLDER_FR}/${FILE} fuel:${TEMP_DIR}/${FOLDER_FR} > /dev/null 2>&1
    
    ssh fuel dockerctl shell ostf "mkdir -p ${BASE_DIR}/${FOLDER_TO}"
    ssh fuel dockerctl copy ${TEMP_DIR}/${FOLDER_FR}/${FILE} ostf:${BASE_DIR}/${FOLDER_TO} > /dev/null 2>&1
}

zzfuncDeployChmod() {
    local FILE=$1
    local FOLDER_TO=$2
    
    # ssh fuel dockerctl shell ostf "chmod 755 ${BASE_DIR}/${FOLDER_TO}/${FILE}" > /dev/null 2>&1
    ssh fuel "chmod 755 ${OSTF_ROOT}/${BASE_DIR}/${FOLDER_TO}/${FILE}"
}

### ------------------------------------------------------------------------------------------------
###     funcRestart, 2016.1.26 ~ 2016.1.26, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcRestart() {
    ssh fuel "dockerctl shell ostf /var/daoucloud/bin/ostfctl.bash restart"
    # ssh fuel "docker exec fuel-core-7.0-ostf /var/daoucloud/bin/ostfctl.bash restart"
}

### ------------------------------------------------------------------------------------------------
###     funcInfo, 2016.1.29 ~ 2016.1.29, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcInfo() {
    info "------------------------------------------------------------"
    info "--- Information"
    info "Test Case                    : ${SERVER_FOLDER}/custom/ostf/fuel_health/tests/"
    info " "
}

### ------------------------------------------------------------------------------------------------
###     funcVi, 2016.1.29 ~ 2016.1.29, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcVi() {
    if [[ 1 == $# ]]; then
        info "------------------------------------------------------------"
        info "--- $1 Scenario task list"
        ls ${SERVER_FOLDER}/custom/ostf/fuel_health/tests/$1 | awk '{print $1}'
    elif [[ 2 == $# ]]; then
        vim ${SERVER_FOLDER}/custom/ostf/fuel_health/tests/$1/$2
    else
        info "------------------------------------------------------------"
        info "--- Scenario folder list"
        ls ${SERVER_FOLDER}/custom/ostf/fuel_health/tests | awk '{print $1}'
    fi
    info " "
}

### ------------------------------------------------------------------------------------------------
###     Main, 2016.1.27 ~ 2016.1.27, Version 0.00.001
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
    restart)
        funcRestart ${OPTIONS}
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
