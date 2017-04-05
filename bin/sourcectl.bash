#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : sourcectl.bash, Version 0.00.001
###     프로그램 설명   : Source를 수집하여 Eclipse용 OpenStack Project를 생성 한다.
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2016.3.4 ~ 2016.3.4
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
###     funcUsing, 2016.3.4 ~ 2016.3.4, Version 0.00.001
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    info "Using : sourcectl.bash COMMAND OPTIONS"
    info "        COMMAND              : 실행할 명령"
    info "        OPTIONS              : 명령 옵션"

    info "    COMMAND"
    info "        OpenStack            : OpenStack Eclipse Project 생성"

    info " "
    exit 1
}

### ------------------------------------------------------------------------------------------------
###     funcOpenStack, 2016.3.4 ~ 2016.3.4, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcOpenStack() {
    info "------------------------------------------------------------"
    info "--- Make OpenStack Eclipse Project"

    cd /data/source

    rm -rf OpenStack
    rm -f OpenStack.tar

    unzip OpenStack.zip

    cd OpenStack

    scp -r controller001:/usr/lib/python2.7/dist-packages/* controller

    scp -r controller001:/usr/share/openstack-dashboard/* dashboard
    scp -r controller001:/usr/lib/cgi-bin/*  dashboard

    scp -r controller001://usr/lib/collectd/* collectd

    scp -r compute001:/usr/lib/python2.7/dist-packages/*  compute

    find . -name '*.pyc' -delete
    find . -name '*.so' -delete

    mkdir others
    scp controller001:/usr/lib/cgi-bin/keystone/admin others
    scp controller001:/usr/lib/cgi-bin/keystone/main others

    cd ..
    tar cvf OpenStack.tar OpenStack

    info " "
    info " "
    info " "
    ls -alF /data/source/OpenStack.tar
    info " "
}

### ------------------------------------------------------------------------------------------------
###     Main
### ------------------------------------------------------------------------------------------------
###---  Command Line에서 입력된 인수를 검사한다.
if [[ 0 < $# ]]; then
    COMMAND=$1
    shift
    OPTIONS=$*
else
    funcUsing
fi

case ${COMMAND} in
    OpenStack)
        funcOpenStack ${OPTIONS}
        ;;
    *)
        funcUsing
        ;;
esac
exit 0

### ================================================================================================

