#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : poedit.bash, Version 0.00.001
###     프로그램 설명   : ~.po 파일을 편집한 후 ~.mo 파일을 생성 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.03.21 ~ 2017.03.21
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
    /bin/echo "Using : poedit.bash PO_FILE"
    /bin/echo "        PO_FILE        : PO 파일 이름 (.po는 생략)"
    /bin/echo " "
    exit 1
}

if [[ $# == 1 ]]; then
    PO_FILE=${1%.po}
else
    funcUsing
fi

### ------------------------------------------------------------------------------------------------
###     Main process
### ------------------------------------------------------------------------------------------------
vi ${PO_FILE}.po
msgfmt ${PO_FILE}.po -o ${PO_FILE}.mo
exit 0

### ================================================================================================

