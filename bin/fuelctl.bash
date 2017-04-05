#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : fuelctl.bash, Version 0.00.001
###     프로그램 설명   : Fuel Master 관리
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
    info "Using : fuelctl.bash COMMAND OPTIONS"
    info "        COMMAND              : 실행할 명령"
    info "        OPTIONS              : 명령 옵션"

    info "    COMMAND"
    info "        make_plugin plugin_name        : Fuel Plugin 생성"

    info " "
    exit 1
}

### ------------------------------------------------------------------------------------------------
###     funcMakePlugin, 2016.3.4 ~ 2016.3.4, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcMakePlugin() {
    local SUBCOMMAND=$1
    local OPTIONS

    shift
    OPTIONS=$*

    case ${SUBCOMMAND} in
        init)
            funcMakePluginInit
            ;;
        lma-collector)
            funcMakePluginRPM ${SUBCOMMAND}
            ;;
        lma-infrastructure-alerting)
            funcMakePluginRPM ${SUBCOMMAND}
            ;;
        elasticsearch-kibana)
            funcMakePluginRPM ${SUBCOMMAND}
            ;;
        influxdb-grafana)
            funcMakePluginRPM ${SUBCOMMAND}
            ;;
        all)
            funcMakePluginRPM ${SUBCOMMAND}
            funcMakePluginRPM ${SUBCOMMAND}
            funcMakePluginRPM ${SUBCOMMAND}
            funcMakePluginRPM ${SUBCOMMAND}
            ;;
        help)
            funcUsingMakePlugin ${OPTIONS}
            ;;
        *)
            funcUsingMakePlugin ${OPTIONS}
            ;;
    esac
}

funcUsingMakePlugin() {
    info "Using : fuelctl.bash make_plugin PLUGIN"
    info "    PLUGIN"
    info "        init                           : Plugin 작성 환경 설정"
    info "        lma-collector                  : lma-collector"
    info "        lma-infrastructure-alerting    : lma-infrastructure-alerting"
    info "        elasticsearch-kibana           : elasticsearch-kibana"
    info "        influxdb-grafana               : influxdb-grafana"
    info " "
    exit 1
}

funcMakePluginInit() {
    mkdir -p /data/plugin

    yum -y install git
    yum -y install createrepo rpm rpm-build dpkg-devel
    yum -y install createrepo dpkg-devel dpkg-dev rpm rpm-build

    easy_install pip
    pip install fuel-plugin-builder
}

funcMakePluginRPM() {
    local PLUGIN=$1
    local FILE=${PLUGIN//-/_}

    info "------------------------------------------------------------"
    info "--- Make ${PLUGIN}"

    cd /data/plugin
    rm -rf fuel-plugin-${PLUGIN}
    rm -f ${FILE}.rpm

    git clone -b stable/0.9 https://github.com/openstack/fuel-plugin-${PLUGIN}

    fpb --check fuel-plugin-${PLUGIN}
    fpb --build fuel-plugin-${PLUGIN}

    cp fuel-plugin-${PLUGIN}/${FILE}-0.9-0.9.0-1.noarch.rpm ${FILE}.rpm
    
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
    make_plugin)
        funcMakePlugin ${OPTIONS}
        ;;
    *)
        funcUsing
        ;;
esac
exit 0

### ================================================================================================

