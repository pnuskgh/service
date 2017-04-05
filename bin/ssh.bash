#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : ssh.bash, Version 0.00.006
###     프로그램 설명   : Remote로 접속하여 명령 실행
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2015.12.17 ~ 2016.1.23
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
###     funcUsing()
###     사용법 표시
### ------------------------------------------------------------------------------------------------
funcUsing() {
    echo "Using : ssh.bash NODES COMMAND"
    echo "        NODES          : 실행할 nodes"
    echo "        COMMAND        : 실행할 명령어"

    echo "    예약어"
    echo "        zzhostnamezz   : NODE로 대체됨"
    echo " "
    exit 2
}

### ------------------------------------------------------------------------------------------------
###     Main
### ------------------------------------------------------------------------------------------------
###---  Command Line에서 입력된 인수를 검사한다.
if [[ 1 < $# ]]; then
    ARGS=$1
    shift
    COMMAND=$*
else
    funcUsing
fi

funcGetNodes ${ARGS} 
NODES=${RTSTR}

date
for hostname in ${NODES}; do
    COMMAND01=${COMMAND/zzhostnamezz/${hostname}}
    echo "------------------------------------------------------------"
    echo "--- ${hostname}"
#    echo ${hostname} "${COMMAND01}"
    if [[ "${hostname}" == "ostf" ]]; then
        dockerctl shell ostf ${COMMAND01}
    else
        COMMAND02=`echo ${COMMAND01} | awk '{ print $1 }'`
        funcEndWith ${COMMAND02} "bash"
        if [[ "$?" == "1" ]]; then
            ssh ${hostname} "source ${BASE_DIR}/bin//bash_env.bash; ${COMMAND01}"
        else
            ssh ${hostname} ${COMMAND01}
        fi
    fi
    echo " "
    echo " "
    echo " "
done

exit 0

### ============================================================================
