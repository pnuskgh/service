#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : findContent.bash, Version 0.00.003
###     프로그램 설명   : 파일을 검색하여 결과를 조회 합니다.
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2012.10.15 ~ 2013.02.18
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
###     funcUsing, 2012.10.15 ~ 2013.02.18, Version 0.00.003
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    echo "Using : findContent [-d CONTENT_DIR] [-e EXT] [-l] CONTENT"
    echo "        CONTENT_DIR    : 검색할 폴더"
    echo "        EXT            : 검색할 파일의 확장자"
    echo "        OPTION         : 검색 옵션 (-l)"
    echo "        CONTENT        : 검색할 문자열"
    echo " "
    exit 1
}

### ------------------------------------------------------------------------------------------------
###     Main
### ------------------------------------------------------------------------------------------------
###---  Default 환경변수를 설정한다.
CONTENT_DIR=`pwd`
EXT=""
OPTION=""
CONTENT=""

###---  Command Line에서 입력된 인수를 검사한다.
while getopts "d:e:lh" flag; do
    case $flag in
        d)	CONTENT_DIR=$OPTARG         ;;
        e)  EXT=$OPTARG                 ;;
        l)  OPTION="-l"                 ;;
        h)  funcUsing                   ;;
        : | ? | *)  funcUsing           ;;
    esac
done
shift $(($OPTIND - 1))

if [[ 0 < $# ]]; then
    CONTENT=$1
fi

if [[ "$CONTENT" = "" ]]; then
	funcUsing
fi

if [[ "${EXT}" = "" ]]; then
    find ${CONTENT_DIR} -name "*" -exec grep ${OPTION} "${CONTENT}" {} \; 2> /dev/null
else
    find ${CONTENT_DIR} -name "*.${EXT}" -exec grep ${OPTION} "${CONTENT}" {} \; 2> /dev/null
fi
exit 0

### ============================================================================

