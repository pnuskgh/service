#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : findContent.bash, Version 0.00.003
###     프로그램 설명   : VirtualBox 가상 서버의 Network를 초기화 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2012.10.15 ~ 2013.02.18
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     Include
### ------------------------------------------------------------------------------------------------
if [[ "z${HOME_SERVICE}z" == "zz" ]]; then
    export HOME_SERVICE="/service"
fi

source ${HOME_SERVICE}/bin/config.bash > /dev/null 2>&1

### ------------------------------------------------------------------------------------------------
###     funcUsing()
###         사용법 표시
### ------------------------------------------------------------------------------------------------
funcUsing() {
    /bin/echo "Using : findContent.bash [-d CONTENT_DIR] [-e EXT] [-l] CONTENT"
    /bin/echo "        CONTENT_DIR    : 검색할 폴더"
    /bin/echo "        EXT            : 검색할 파일의 확장자"
    /bin/echo "        OPTION         : 검색 옵션 (-l)"
    /bin/echo "        CONTENT        : 검색할 문자열"
    /bin/echo " "
    exit 1
}

###---  Default 환경변수를 설정한다.
CONTENT_DIR=`/bin/pwd`
EXT=""
OPTION=""
CONTENT=""

###---  Command Line에서 입력된 인수를 검사한다.
while getopts "d:e:lh" flag; do
    case $flag in
        d)  CONTENT_DIR=$OPTARG         ;;
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

### ------------------------------------------------------------------------------------------------
###     Main process
### ------------------------------------------------------------------------------------------------
if [[ "${EXT}" = "" ]]; then
    /usr/bin/find ${CONTENT_DIR} -name "*" -exec /bin/grep ${OPTION} "${CONTENT}" {} \;
else
    /usr/bin/find ${CONTENT_DIR} -name "*.${EXT}" -exec /bin/grep ${OPTION} "${CONTENT}" {} \;
fi
exit 0

### ================================================================================================

