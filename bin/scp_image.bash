#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : scp_image.bash, Version 0.00.002
###     프로그램 설명   : Image 파일을 복사 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.03.10 ~ 2017.04.06
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

TIMESTAMP=`date +%Y%m%d_%H%M%S`

TARGET_SERVER=$1
TARGET_FOLDER=$2

for FILE_NAME in `ls *.qcow2`; do
    scp ${FILE_NAME} ${TARGET_SERVER}:${TARGET_FOLDER}
    mv ${FILE_NAME} ${FILE_NAME}_${TIMESTAMP}
done

for FILE_NAME in `ls *.raw`; do
    scp ${FILE_NAME} ${TARGET_SERVER}:${TARGET_FOLDER}
    mv ${FILE_NAME} ${FILE_NAME}_${TIMESTAMP}
done

### ================================================================================================

