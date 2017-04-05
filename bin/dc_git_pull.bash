#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : dc_git_pull.bash, Version 0.00.001
###     프로그램 설명   : Git 저장소를 최신으로 설정 한다.
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2016.8.18 ~ 2016.8.18
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
###     funcUsing, 2016.8.18 ~ 2016.8.18, Version 0.00.001
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    info "Using : dc_git_pull.bash"
    info " "
    exit 2
}

### ------------------------------------------------------------------------------------------------
###     Main
### ------------------------------------------------------------------------------------------------
cd ${SERVER_FOLDER}/custom

for foldername in bier ceilometer console-user daoucloud fuel-plugin-neutron-lbaas fuel-plugin-openldap homepage neutron ; do
    echo "===================================="
    echo ${foldername}
    cd ${foldername}
    git pull
    cd ..
    echo " "
    echo " "
done

exit 0

### ================================================================================================

