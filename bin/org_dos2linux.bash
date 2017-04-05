#!/bin/bash
### ============================================================================
###     프로그램 명  			: dos2linux.bash, Version 0.00.001
###     프로그램 설명   		: Dos용 파일을 Linux 파일 형식으로 변환 합니다.
###     작성자          		: 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          		: 2013.04.03 ~ 2013.04.03
### ----[History 관리]----------------------------------------------------------
###     수정자          		:
###     수정일          		:
###     수정 내용       		:
### --- [Copyright] ------------------------------------------------------------
###     Copyright (c) 1995~2013 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ============================================================================

###---  Script 환경 설정
. ${CONFIG_DIR}/config.bash > /dev/null 2>&1

###---	CentOS에서 설치	: yum install dos2unix
for file in "$@"; do
	if [ -f $file ]; then
    	/usr/bin/dos2unix $file
	fi
done
