#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : vim.bash, Version 0.00.001
###     프로그램 설명   : Remote로 접속하여 명령 실행
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2016.2.3 ~ 2016.2.3
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2016 산사랑, All rights reserved.
### ================================================================================================

if [[ "${SERVER_FOLDER}" == "" ]]; then
    info "SERVER_FOLDER 환경 변수를 설정 하세요."
    info " "
    exit 1
fi

. ${SERVER_FOLDER}/bin/config.bash > /dev/null 2>&1
. ${SERVER_FOLDER}/bin/utilCommon.bash > /dev/null 2>&1

### ------------------------------------------------------------------------------------------------
###     funcUsing, 2016.2.3 ~ 2016.2.3, Version 0.00.001
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    info "Using : vim.bash NODES FILES"
    info "        NODES          : 실행할 nodes"
    info "        FILES          : 수정할 파일"
    info " "
    exit 2
}

### ------------------------------------------------------------------------------------------------
###     Main
### ------------------------------------------------------------------------------------------------
###---  Command Line에서 입력된 인수를 검사한다.
if [[ 1 < $# ]]; then
    ARGS=$1
    shift
    FILES=$*
else
    funcUsing
fi

funcGetNodes ${ARGS}
NODES=${RTSTR}

date
for hostname in ${NODES}; do
    info "------------------------------------------------------------"
    info "--- ${hostname}"
    TMPFILE=""
    for file in ${FILES}; do
        TMPFILE="${TMPFILE} scp://${hostname}/${file} "
    done
    echo vim ${TMPFILE}
    vim ${TMPFILE}
    info " "
done

exit 0

### ============================================================================
