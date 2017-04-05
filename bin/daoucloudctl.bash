#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : daoucloud.bash, Version 0.00.004
###     프로그램 설명   : Manage001 노드 관리
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2016.1.27 ~ 2016.3.24
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

DEFAULT_TARGET_NODE=test

### ------------------------------------------------------------------------------------------------
###     funcUsing, 2016.1.27 ~ 2016.1.27, Version 0.00.001
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    info "Using : daoucloudctl.bash COMMAND OPTIONS"
    info "        COMMAND              : 실행할 명령"
    info "        OPTIONS              : 명령 옵션"

    info "    COMMAND"
    info "        deploy               : 배포"
    info "        backup               : Backup daoucloud in manage001 node"
    info "        sync [target]        : Make ${SERVER_FOLDER} in target node"

    info " "
    exit 1
}

### ------------------------------------------------------------------------------------------------
###     funcDeploy, 2016.3.24 ~ 2016.3.24, Version 0.00.002
### ------------------------------------------------------------------------------------------------
funcSync() {
    local TARGET_NODE=${DEFAULT_TARGET_NODE}

    if [[ 0 < $# ]]; then
        TARGET_NODE=$1
    fi

    info "------------------------------------------------------------"
    info "--- Sync to ${TARGET_NODE}"
    cd ${SERVER_FOLDER}
    ssh ${TARGET_NODE} "mkdir -p ${SERVER_FOLDER}"

    scp README.md ${TARGET_NODE}:${SERVER_FOLDER} > /dev/null 2>&1
    scp gitignore_sample ${TARGET_NODE}:${SERVER_FOLDER} > /dev/null 2>&1

    scp -r bin ${TARGET_NODE}:${SERVER_FOLDER} > /dev/null 2>&1
    scp -r conf ${TARGET_NODE}:${SERVER_FOLDER} > /dev/null 2>&1
    scp -r custom ${TARGET_NODE}:${SERVER_FOLDER} > /dev/null 2>&1

    info " "
}

### ------------------------------------------------------------------------------------------------
###     funcDeploy, 2016.1.26 ~ 2016.2.3, Version 0.00.002
### ------------------------------------------------------------------------------------------------
funcDeploy() {
    local SUBCOMMAND=$1
    local OPTIONS

    shift
    OPTIONS=$*
    case ${SUBCOMMAND} in
        bash)
            funcDeployBash ${OPTIONS}
            ;;
        ostf)
            funcDeployOstf ${OPTIONS}
            ;;
        all)
            funcDeployAll ${OPTIONS}
            ;;
        help)
            funcUsingDeploy
            ;;
        *)
            funcUsingDeploy
            ;;
    esac
}

funcUsingDeploy() {
    info "Using : daoucloud.bash deploy SUBCOMMAND OPTIONS"
    info "    SUBCOMMAND"
    info "        bash NODES FILE [OPTION]  : 실행 파일 deploy [실행]"
    info "        ostf                 : manage001에서 OSTF deploy"
    info "        all                  : manage001 node로 전체 deploy"
    info "        help                 : 도움말 화면 (현재 화면) 표시"

    info " "
    exit 1
}

funcDeployBash() {
    local ARGS
    local FILE
    local OPTION
    local NODES

    ###---  Command Line에서 입력된 인수를 검사한다.
    if [[ 1 < $# ]]; then
        ARGS=$1
        shift
        FILE=$1
        shift
        OPTION=$*
    else
        funcUsingDeploy
    fi

    funcGetNodes ${ARGS}
    NODES=${RTSTR}
    
    date
    for hostname in ${NODES}; do
        echo "------------------------------------------------------------"
        echo "--- ${hostname} : deploy ${FILE} file"

        ssh ${hostname} "mkdir -p ${BASE_DIR}/bin" > /dev/null 2>&1
        scp ${SERVER_FOLDER}/bin/bash_env.bash_nodes ${hostname}:${BASE_DIR}/bin/bash_env.bash > /dev/null 2>&1
        scp ${SERVER_FOLDER}/bin/config.bash ${hostname}:${BASE_DIR}/bin > /dev/null 2>&1
        scp ${SERVER_FOLDER}/bin/utilCommon.bash ${hostname}:${BASE_DIR}/bin > /dev/null 2>&1
        scp ${SERVER_FOLDER}/bin/${FILE} ${hostname}:${BASE_DIR}/bin > /dev/null 2>&1

        if [[ "${OPTION}" != "" ]]; then
            ssh ${hostname} "source ${BASE_DIR}/bin//bash_env.bash; ${BASE_DIR}/bin/${FILE} ${OPTION}"
        fi

        # ssh ${hostname} "ls -alF ${BASE_DIR}/bin"
        echo " "
        echo " "
    done

}

funcDeployAll() {
    info "Reserved"
    exit 0

    ssh root@manage001 mkdir -p ${SERVER_FOLDER}
    ssh root@manage001 mkdir -p ${TEMP_DIR}
    
    cd ${SERVER_FOLDER}
    rm -f ../daoucloud.tar > /dev/null 2>&1
    tar cvf ../daoucloud.tar * > /dev/null 2>&1
    
    scp ../daoucloud.tar root@manage001:${TEMP_DIR} > /dev/null 2>&1
    
    ssh root@manage001 "cd ${SERVER_FOLDER}; tar xvf ${TEMP_DIR}/daoucloud.tar" > /dev/null 2>&1
    ssh root@manage001 dos2unix ${SERVER_FOLDER}/bin/dos2linux.bash > /dev/null 2>&1
    ssh root@manage001 "cd ${SERVER_FOLDER}/bin;${SERVER_FOLDER}/bin/dos2linux.bash *" > /dev/null 2>&1
    
    ssh root@manage001 "cd ${SERVER_FOLDER}/custom/ostf/bin;${SERVER_FOLDER}/bin/dos2linux.bash *" > /dev/null 2>&1
}

funcDeployOstf() {
    ssh root@manage001 "cd  ${SERVER_FOLDER}/bin; ${SERVER_FOLDER}/bin/ostfctl.bash deploy"
}

### ------------------------------------------------------------------------------------------------
###     funcBackup, 2016.1.26 ~ 2016.1.26, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcBackup() {
    ssh root@manage001 "rm -f ${MANAGE_DIR}/../daoucloud_${TIMESTAMP}.tar" > /dev/null 2>&1
    ssh root@manage001 "cd ${MANAGE_DIR}; tar cvf ../daoucloud_${TIMESTAMP}.tar *" > /dev/null 2>&1
    scp root@manage001:${MANAGE_DIR}/../daoucloud_${TIMESTAMP}.tar ${SERVER_FOLDER}/..
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

if [[ "${HOSTNAME}" == "" ]]; then
    error "Notebook에서만 작업 가능 합니다."
    exit 1
fi

case ${COMMAND} in
    deploy)
        funcDeploy ${OPTIONS}
        ;;
    backup)
        funcBackup ${OPTIONS}
        ;;
    sync)
        funcSync ${OPTIONS}
        ;;
    *)
        funcSync ${OPTIONS}
        # funcUsing
        ;;
esac
exit 0

### ================================================================================================

