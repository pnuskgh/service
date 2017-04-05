#!/bin/bash
### ================================================================================================
###     프로그램 명              : init_cloudnas.bash, Version 0.00.002
###     프로그램 설명         	: /cloudnas/ 폴더 초기화
###     작성자                     : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일                     : 2015.8.3 ~ 2015.8.10
### --- [History 관리] -------------------------------------------------------------------------------
###     2015.08.03, 산사랑 : 초안 작성
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2015 산사랑, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###		Main process
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
###     /cloudnas/ 폴더를 초기화 합니다.
###         crudini : wget https://raw.githubusercontent.com/pixelb/crudini/master/crudini
### ------------------------------------------------------------------------------------------------
cd /cloudnas
mkdir backup >& /dev/null
mkdir appl >& /dev/null
mkdir bin >& /dev/null
mkdir conf >& /dev/null
mkdir custom >& /dev/null
mkdir database >& /dev/null
mkdir home >& /dev/null
mkdir install >& /dev/null
mkdir logs >& /dev/null
mkdir template >& /dev/null
mkdir www >& /dev/null

cp ~/repo_git/jopenbusiness/linux/cloudnas/bin/* /cloudnas/bin
cp ~/repo_git/jopenbusiness/linux/cloudnas/conf/* /cloudnas/conf

cd /cloudnas/bin
chmod 744 *
chmod 755 crudini
chmod 755 git_clone.bash
chmod 755 init_user.bash
chmod 755 install_maven.bash

cd /cloudnas/conf
chmod 755 bash_env.bash

### ================================================================================================

