#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : rallyctl.bash, Version 0.00.005
###     프로그램 설명   : Rally 관리
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2016.1.25 ~ 2016.2.2
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

flagDebug="False"

DOCUMENT_ROOT=/usr/share/nginx/html
DOCUMENT_REPORTS=${DOCUMENT_ROOT}/reports
IMSI_FILE=/root/zztemp/zzrally.html

FOLDER_SCENARIOS=${SERVER_FOLDER}/custom/rally/scenarios

### ------------------------------------------------------------------------------------------------
###     funcUsing, 2016.1.26 ~ 2016.1.29, Version 0.00.002
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    info "Using : rallyctl.bash COMMAND OPTIONS"
    info "        COMMAND              : 실행할 명령"
    info "        OPTIONS              : 명령 옵션"

    info "    COMMAND"
    info "        info                 : Rally 정보 조회"
    info "        vi [folder] [task]   : test 편집"
    info "        start folder [task]  : test 시작"

    info " "
    exit 1
}

### ------------------------------------------------------------------------------------------------
###     funcStart, 2016.1.26 ~ 2016.2.1, Version 0.00.003
### ------------------------------------------------------------------------------------------------
funcStart() {
    local SUBCOMMAND=$1
    local OPTIONS

    shift
    OPTIONS=$*
    debug "------------------------------------------------------------"
    debug "--- Function Arguments"
    debug "SUBCOMMAND      : ${SUBCOMMAND}"
    debug "OPTIONS         : ${OPTIONS}"
    debug " "

    mkdir -p `dirname ${IMSI_FILE}` > /dev/null 2>&1
    # echo " " > ${IMSI_FILE}
    case ${SUBCOMMAND} in
        authenticate)
            funcStartTasks authenticate ${OPTIONS}
            ;;
        ceilometer)
            funcStartTasks ceilometer ${OPTIONS}
            ;;
        cinder)
            funcStartTasks cinder ${OPTIONS}
            ;;
        glance)
            funcStartTasks glance ${OPTIONS}
            ;;
        heat)
            funcStartTasks heat ${OPTIONS}
            ;;
        keystone)
            funcStartTasks keystone ${OPTIONS}
            ;;
        neutron)
            funcStartTasks neutron ${OPTIONS}
            ;;
        nova)
            funcStartTasks nova ${OPTIONS}
            ;;
        quotas)
            funcStartTasks quotas ${OPTIONS}
            ;;
        swift)
            funcStartTasks swift ${OPTIONS}
            ;;
        all)
            funcStartTasks authenticate ${OPTIONS}
            funcStartTasks quotas ${OPTIONS}
            funcStartTasks keystone ${OPTIONS}
            funcStartTasks cinder ${OPTIONS}
            funcStartTasks glance ${OPTIONS}
            funcStartTasks swift ${OPTIONS}
            funcStartTasks neutron ${OPTIONS}
            funcStartTasks ceilometer ${OPTIONS}
            funcStartTasks heat ${OPTIONS}

            funcStartTasks nova ${OPTIONS}
            ;;
        help)
            funcUsingStart ${OPTIONS}
            ;;
        *)
            funcUsingStart ${OPTIONS}
            ;;
    esac
}

funcUsingStart() {
    info "Using : rallyctl.bash start SUBCOMMAND OPTIONS"
    info "    SUBCOMMAND"
    info "        authenticate         #--- Start authenticate scenarios"
    info "        ceilometer"
    info "        cinder"
    info "        glance"
    info "        heat"
    info "        keystone"
    info "        neutron"
    info "        nova"
    info "        quotas"
    info "        swift"
    info " "
    exit 1
}

funcStartTasks() {
    local FOLDER=$1
    local FILE=$2
    local FILES

    mkdir -p ${SERVER_FOLDER}/setting/manage001${DOCUMENT_ROOT}
    cp -f ${DOCUMENT_ROOT}/index.html ${SERVER_FOLDER}/custom/rally/html > /dev/null 2>&1
    cp -f ${DOCUMENT_ROOT}/rally.html ${SERVER_FOLDER}/custom/rally/html > /dev/null 2>&1

    if [[ 1 < $# ]]; then
        funcStartScenario ${FOLDER} ${FILE}
        return
    fi

    rally task delete --force --uuid `rally task list | grep DaouCloud | awk '{print $2}'` > /dev/null 2>&1

    echo " " >> ${IMSI_FILE}
    FILES=`ls ${FOLDER_SCENARIOS}/${FOLDER}`
    for filename in ${FILES}; do
        funcStartScenario ${FOLDER} ${filename}
    done

    rally task report --out=${DOCUMENT_REPORTS}/${FOLDER}.html --tasks `rally task list | grep finished | awk '{print $2}'`
    info " "
    info "Result check : ${MANAGE_URL}/reports/${FOLDER}.html"
    info " "
}

#--- rallyctl.bash start ${FOLDER} ${FILE}
funcStartScenario() {
    local FOLDER=$1
    local FILE=$2

    FILE=${FILE/.json/}
    info "------------------------------------------------------------"
    info "--- Start rally ${FOLDER}/${FILE}"
    
    rally task start ${FOLDER_SCENARIOS}/${FOLDER}/${FILE}.json --task-args-file ${SERVER_FOLDER}/custom/rally/conf/args.json

    mkdir -p ${DOCUMENT_REPORTS}/${FOLDER}
    rally task report --out=${DOCUMENT_REPORTS}/${FOLDER}/${FILE}.html --open
    info " "
    info "Result check : ${MANAGE_URL}/reports/${FOLDER}/${FILE}.html"
    info " "
    # rally task sla_check

    echo "${MANAGE_URL}/reports/${FOLDER}/${FILE}.html" >> ${IMSI_FILE}
}

### ------------------------------------------------------------------------------------------------
###     funcInfo, 2016.1.29 ~ 2016.1.29, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcInfo() {
    info "------------------------------------------------------------"
    info "--- Information"
    info "Rally                        : ${SERVER_FOLDER}/appl/rally/"
    info "Scenario                     : ${SERVER_FOLDER}/custom/rally/scenarios"
    info "Scenario Plugin              : ${SERVER_FOLDER}/appl/rally/src/rally/plugins/openstack/scenarios"
    info " "
}

### ------------------------------------------------------------------------------------------------
###     funcVi, 2016.1.29 ~ 2016.1.29, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcVi() {
    if [[ 1 == $# ]]; then
        info "------------------------------------------------------------"
        info "--- $1 Scenario task list"
        ls ${SERVER_FOLDER}/custom/rally/scenarios/$1 | awk '{print $1}'
    elif [[ 2 == $# ]]; then
        vim ${SERVER_FOLDER}/custom/rally/scenarios/$1/$2
    else
        info "------------------------------------------------------------"
        info "--- Scenario folder list"
        ls ${SERVER_FOLDER}/custom/rally/scenarios | awk '{print $1}'
    fi
    info " "

}

### ------------------------------------------------------------------------------------------------
###     Main
### ------------------------------------------------------------------------------------------------
###---  Command Line에서 입력된 인수를 검사한다.
if [[ 0 < $# ]]; then
    COMMAND=$1
    shift
    OPTIONS=$*
else
    funcUsing
fi
debug "------------------------------------------------------------"
debug "--- Arguments"
debug "Argument number : $(($# + 2))"
debug "COMMAND         : ${COMMAND}"
debug "OPTIONS         : ${OPTIONS}"
debug " "

case ${COMMAND} in
    start)
        funcStart ${OPTIONS}
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

