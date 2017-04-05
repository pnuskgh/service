#!/bin/bash
### ================================================================================================
###     프로그램 명          : dc_backup.bash, Version 0.00.005
###     프로그램 설명        : Jopenbusiness를 백업 합니다.
###     작성자               : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일               : 2013.02.16 ~ 2013.05.16
### ----[History 관리]------------------------------------------------------------------------------
###     수정자               :
###     수정일               :
###     수정 내용            :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2016 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

#--- 주의 : crontab에서 실행하기 위해서 환경변수를 추가 한다. 삭제하지 말 것
export SERVER_FOLDER=/data

if [[ "${SERVER_FOLDER}" == "" ]]; then
    echo "SERVER_FOLDER 환경 변수를 설정 하세요."
    echo " "
    exit 1
fi

. ${SERVER_FOLDER}/bin/config.bash > /dev/null 2>&1
. ${SERVER_FOLDER}/bin/utilCommon.bash > /dev/null 2>&1

### ------------------------------------------------------------------------------------------------
###     Main
### ------------------------------------------------------------------------------------------------
tar cvf ${BACKUP_DIR}/root/root_${TIMESTAMP}_data.tar /data/bin > /dev/null 2>&1

${BIN_DIR}/backupDatabase root wordpress wpuser none
${BIN_DIR}/backupSource root

echo " "
echo " "
echo " "
echo "Backup all"
echo "--------------------------------------------------"
ls -alF ${BACKUP_DIR}/root/root_${TIMESTAMP}*

### ============================================================================

