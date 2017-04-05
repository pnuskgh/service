#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : scp.bash, Version 0.00.006
###     프로그램 설명   : Remote로 접속하여 명령 실행
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2015.12.17 ~ 2016.1.23
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

SETTING_DIR=${SERVER_FOLDER}/nodes

### ------------------------------------------------------------------------------------------------
###     funcUsing, 2015.12.17 ~ 2015.12.17, Version 0.00.001
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    info "Using : scp.bash NODES FROM [TO]"
    info "        NODES          : 실행할 nodes"
    info "        FROM           : 원본 파일"
    info "        TO             : 타겟 파일"

    info "    사용예"
    info "        scp.bash node001 /etc/hosts :/etc/hosts   #--- node001로 복사"
    info "        scp.bash node001 :/etc/hosts /etc/hosts   #--- node001에서 가져오기"
    info " "
    exit 2
}

### ------------------------------------------------------------------------------------------------
###     Main
### ------------------------------------------------------------------------------------------------
###---  Command Line에서 입력된 인수를 검사한다.
if [[ 3 == $# ]]; then
    ARGS=$1
    FROM=$2
    TO=$3
elif [[ 2 == $# ]]; then
    ARGS=$1
    FROM=$2
    #--- FROM에 :가 없을 경우 TO에 넣어주고
    #--- FROM에 :가 있을 경우 TO에서 @를 대신 넣어준다.
    FROM01=${FROM/:/zztemp:}
    if [[ "${FROM}" == "${FROM01}" ]]; then
        TO=:${FROM}
    else
        TO=${FROM/:/@}
    fi
else
    funcUsing
fi

funcGetNodes ${ARGS} 
NODES=${RTSTR}

date
for hostname in ${NODES}; do
    #--- :를 hostname:로 치환
    FROM01=${FROM/:/${hostname}:}
    TO01=${TO/:/${hostname}:}

    #--- @를 지정한 폴더로 치환
    FROM02=${FROM01/@/${SETTING_DIR}/${hostname}}
    TO02=${TO01/@/${SETTING_DIR}/${hostname}}

    if [[ "${TO}" == "${TO01}" ]]; then
        #--- Local 서버로 복사할 경우
        FILE=${TO02}
        FILENAME=`basename ${FILE}`
        FOLDER=${FILE/\/${FILENAME}/}
        mkdir -p ${FOLDER}
    else
        #--- Remote 서버로 복사할 경우
        FILE=${TO02/${hostname}:/}
        FILENAME=`basename ${FILE}`
        FOLDER=${FILE/\/${FILENAME}/}
        if [[ "${hostname}" == "ostf" ]]; then
            ssh fuel "dockerctl shell osft mkdir -p ${FOLDER}"
        else
            ssh ${hostname} "mkdir -p ${FOLDER}"
        fi
    fi

#    info "FROM : ${FROM}"
#    info "TO : ${TO}"
#    info "FROM01 : ${FROM01}"
#    info "TO01 : ${TO01}"
#    info "FROM02 : ${FROM02}"
#    info "TO02 : ${TO02}"
#    info "FOLDER : ${FOLDER}"

    info "------------------------------------------------------------"
    info "--- ${hostname}"
#    info scp ${FROM02} ${TO02}
    if [[ "${hostname}" == "ostf" ]]; then
        ssh fuel "dockerctl copy ${FROM02} ${TO02}"
    else
        scp ${FROM02} ${TO02}
    fi

    info " "
    info " "
    info " "
done

exit 0

### ============================================================================
