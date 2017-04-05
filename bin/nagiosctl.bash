#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : nagiosctl.bash, Version 0.00.002
###     프로그램 설명   : Nagios 관리
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2016.3.28 ~ 2016.3.29
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
###     funcUsing, 2016.3.28 ~ 2016.3.28, Version 0.00.001
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    info "Using : nagiosctl.bash COMMAND OPTIONS"
    info "        COMMAND              : 실행할 명령"
    info "        OPTIONS              : 명령 옵션"

    info "    COMMAND"
    info "        plugin               : 수작업으로 Heka Plugin 설정"

    info " "
    exit 1
}

### ------------------------------------------------------------------------------------------------
###     funcPlugin, 2016.3.28 ~ 2016.3.28, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcPlugin() {
    local SUBCOMMAND=$1
    local OPTIONS

    shift
    OPTIONS=$*

    case ${SUBCOMMAND} in
        backup)
            funcPluginBackup ${OPTIONS}
            ;;
        apply)
            funcPluginApply ${OPTIONS}
            ;;
        restore)
            funcPluginRestore ${OPTIONS}
            ;;
        all)
            funcUsingPlugin ${OPTIONS}
            ;;
        help)
            funcUsingPlugin ${OPTIONS}
            ;;
        *)
            funcUsingPlugin ${OPTIONS}
            ;;
    esac
}

funcUsingPlugin() {
    info "Using : nagiosctl.bash SUBCOMMAND OPTIONS"
    info "    SUBCOMMAND"
    info "        backup               : 백업"
    info "        apply                : 적용"
    info "        restore              : 복구"
    info " "
    exit 1
}

funcPluginBackup() {
    funcGetNodes controller
    NODES=${RTSTR}

    mkdir -p ${SERVER_FOLDER}/setting
    for hostname in ${NODES}; do
        funcPluginBackupFile ${hostname} /etc/lma_collector/encoder-smtp_alert.toml controller
        funcPluginBackupFile ${hostname} /etc/lma_collector/output-smtp_alert.toml controller
        info " "
    done
    ls -alF ${SERVER_FOLDER}/setting/controller/etc/lma_collector/*.toml_org
}

funcPluginBackupFile() {
    local HOSTNAME=$1
    local FILENAME=$2
    local NODE=${3:-${HOSTNAME}}
    local DIRNAME=`dirname ${FILENAME}`

    mkdir -p ${SERVER_FOLDER}/setting/${NODE}${DIRNAME}
    if [[ ! -e  ${SERVER_FOLDER}/setting/${NODE}${FILENAME}_org ]]; then
        scp ${HOSTNAME}:${FILENAME} ${SERVER_FOLDER}/setting/${NODE}${FILENAME}_org
    fi
}

funcPluginApply() {
    funcGetNodes controller
    NODES=${RTSTR}

    for hostname in ${NODES}; do
        ssh ${hostname} "rm -f /etc/lma_collector/encoder-smtp_alert.toml"
        ssh ${hostname} "rm -f /etc/lma_collector/output-smtp_alert.toml"

        scp ${SERVER_FOLDER}/setting/controller/etc/lma_collector/encoder-nagios_gse_node_clusters.toml   ${hostname}:/etc/lma_collector/encoder-nagios_gse_node_clusters.toml
        scp ${SERVER_FOLDER}/setting/controller/etc/lma_collector/output-nagios_gse_node_clusters.toml    ${hostname}:/etc/lma_collector/output-nagios_gse_node_clusters.toml
        scp ${SERVER_FOLDER}/setting/controller/etc/lma_collector/encoder-nagios_gse_global_clusters.toml ${hostname}:/etc/lma_collector/encoder-nagios_gse_global_clusters.toml
        scp ${SERVER_FOLDER}/setting/controller/etc/lma_collector/output-nagios_gse_global_clusters.toml  ${hostname}:/etc/lma_collector/output-nagios_gse_global_clusters.toml
        ssh ${hostname} "chown heka:heka /etc/lma_collector/*"
        info " "
    done

    funcGetNodes all
    NODES=${RTSTR}

    for hostname in ${NODES}; do
        scp ${SERVER_FOLDER}/setting/${hostname}/etc/lma_collector/encoder-nagios_afd_nodes.toml   ${hostname}:/etc/lma_collector/encoder-nagios_afd_nodes.toml
        
        scp ${SERVER_FOLDER}/setting/all/etc/lma_collector/output-nagios_afd_nodes.toml            ${hostname}:/etc/lma_collector/output-nagios_afd_nodes.toml
        ssh ${hostname} "chown heka:heka /etc/lma_collector/*"

        scp ${SERVER_FOLDER}/setting/all/usr/share/lma_collector/encoders/status_nagios.lua        ${hostname}:/usr/share/lma_collector/encoders/status_nagios.lua
    done
}

funcPluginRestore() {
    funcGetNodes controller
    NODES=${RTSTR}

    for hostname in ${NODES}; do
        scp ${SERVER_FOLDER}/setting/controller/etc/lma_collector/encoder-smtp_alert.toml_org ${hostname}:/etc/lma_collector/encoder-smtp_alert.toml
        scp ${SERVER_FOLDER}/setting/controller/etc/lma_collector/output-smtp_alert.toml_org  ${hostname}:/etc/lma_collector/output-smtp_alert.toml
        ssh ${hostname} "chown heka:heka /etc/lma_collector/*"

        ssh ${hostname} "rm -f /etc/lma_collector/encoder-nagios_gse_global_clusters.toml"
        ssh ${hostname} "rm -f /etc/lma_collector/encoder-nagios_gse_node_clusters.toml"
        ssh ${hostname} "rm -f /etc/lma_collector/output-nagios_gse_global_clusters.toml"
        ssh ${hostname} "rm -f /etc/lma_collector/output-nagios_gse_node_clusters.toml"
        info " "
    done

    funcGetNodes all
    NODES=${RTSTR}

    for hostname in ${NODES}; do
        ssh ${hostname} "rm -f /etc/lma_collector/encoder-nagios_afd_nodes.toml"
        ssh ${hostname} "rm -f /etc/lma_collector/output-nagios_afd_nodes.toml"

        ssh ${hostname} "rm -f /usr/share/lma_collector/encoders/status_nagios.lua"
    done
}

### ------------------------------------------------------------------------------------------------
###     Main, 2016.3.28 ~ 2016.3.28, Version 0.00.001
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
    plugin)
        funcPlugin ${OPTIONS}
        ;;
    *)
        funcUsing
        ;;
esac
exit 0

### ================================================================================================
