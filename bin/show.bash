#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : show.bash, Version 0.00.007
###     프로그램 설명   : 사용자에게 여러가지 정보를 제공 합니다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 1995.02.20 ~ 2018.02.28
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2018 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     초기 환경을 설정 합니다.
### ------------------------------------------------------------------------------------------------
if [[ "z${HOME_SERVICE}z" == "zz" ]]; then
    export HOME_SERVICE="/service"
fi

source ${HOME_SERVICE}/bin/config.bash > /dev/null 2>&1

### ------------------------------------------------------------------------------------------------
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    echo "Using : show.bash [COMMAND]"
    echo "        COMMAND              : help, info, status, ..."
    echo " "
    exit 2
}

### ------------------------------------------------------------------------------------------------
###     Show 명령어를 실행 합니다.
### ------------------------------------------------------------------------------------------------
funcRunCmd() {
    local COMMAND

    COMMAND=$1
    CMD_FILE=${HOME_WORK}/bin/show_${COMMAND}.bash
    if [[ -f ${CMD_FILE} ]]; then
        exec bash ${CMD_FILE}
    else
        CMD_FILE=${HOME_SERVICE}/bin/show_${COMMAND}.bash
        if [[ -f ${CMD_FILE} ]]; then
            source ${CMD_FILE}
        fi
    fi
}

### ------------------------------------------------------------------------------------------------
###     Command Line Argument를 확인 합니다.
### ------------------------------------------------------------------------------------------------
if [[ $# == 1 ]]; then
    COMMAND=$1
    OPTIONS="null"
elif [[ $# == 2 ]]; then
    COMMAND=$1
    OPTIONS=$2
else
    COMMAND="default"
    OPTIONS="null"
    # funcUsing
fi

# while getopts "d:e:lh" flag; do
#     case $flag in
#         d)      CONTENT_DIR=$OPTARG         ;;
#         e)  EXT=$OPTARG                 ;;
#         l)  OPTION="-l"                 ;;
#         h)  funcUsing                   ;;
#         : | ? | *)  funcUsing           ;;
#     esac
# done
# shift $(($OPTIND - 1))
# 
# if [[ 0 < $# ]]; then
#     CONTENT=$1
# fi
# 
# if [[ "$CONTENT" = "" ]]; then
#         funcUsing
# fi

### ------------------------------------------------------------------------------------------------
###     Main process
### ------------------------------------------------------------------------------------------------
case ${COMMAND} in
    help)
        funcUsing
        ;;
    info)
        cat ~/README.md
        ;;
    default)
        clear
        if [[ -f README.md ]]; then
            cat README.md
        else
            cat ~/README.md
        fi
        ;;
    status)
        ls -alF ${WORK_HOME}/bin/show_*.bash > /dev/null 2>&1
        ls -alF ${SERVICE_HOME}/bin/show_*.bash > /dev/null 2>&1
        ;;
    *)
        funcRunCmd ${COMMAND}
        ;;
esac
echo " "

exit 0
### ================================================================================================

