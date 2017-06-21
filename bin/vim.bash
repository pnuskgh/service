#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : vim.bash, Version 0.00.002
###     프로그램 설명   : Fuel에서 Remote로 접속하여 명령 실행
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2016.2.3 ~ 2017.6.21
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2016 산사랑, All rights reserved.
### ================================================================================================

if [[ "z${HOME_SERVICE}z" == "zz" ]]; then
    export HOME_SERVICE="/service"
fi

. ${HOME_SERVICE}/bin/config.bash > /dev/null 2>&1
. ${HOME_SERVICE}/bin/utilCommon.bash > /dev/null 2>&1

### ------------------------------------------------------------------------------------------------
###     funcUsing, 2016.2.3 ~ 2016.2.3, Version 0.00.001
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    echo "Using : vim.bash NODES FILES"
    echo "        NODES          : 실행할 nodes"
    echo "        FILES          : 수정할 파일"
    echo " "
    exit 2
}

### ------------------------------------------------------------------------------------------------
###     Main Process
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
