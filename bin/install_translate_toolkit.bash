#!/bin/bash
### ================================================================================================
###     프로그램 명              : install_translate_toolkit.bash, Version 0.00.001
###     프로그램 설명         	: Ant 설치 Script
###     작성자                     : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일                     : 2015.8.27 ~ 2015.8.27
### --- [History 관리] -------------------------------------------------------------------------------
###     2015.08.27, 산사랑 : 초안 작성
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2015 산사랑, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###             Main process
### ------------------------------------------------------------------------------------------------

### ------------------------------------------------------------------------------------------------
###     root 사용자로 작업을 하고 있는지 확인 합니다.
### ------------------------------------------------------------------------------------------------
TMPSTR=`env | grep USER`
if [ "${TMPSTR}" = "USER=root" ]; then
    echo ""
else
    echo "root 사용자로 작업 하세요."
    exit 1
fi

### ------------------------------------------------------------------------------------------------
###     Translate toolkit 설치
### ------------------------------------------------------------------------------------------------
# yum -y install python27 python27-*
# easy_install pip

cd /cloudnas/install
if [ ! -e /cloudnas/install/translate-toolkit-1.13.0.tar.bz2 ]; then
    wget https://github.com/translate/translate/releases/download/1.13.0/translate-toolkit-1.13.0.tar.bz2
    tar jxvf translate-toolkit-1.13.0.tar.bz2

    cd translate-toolkit-1.13.0
    ./setup.py install
    cd ..
    rm -rf translate-toolkit-1.13.0
fi

### ================================================================================================
