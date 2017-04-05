#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : mysqlctl.bash, Version 0.00.001
###     프로그램 설명   : MySQL 관리
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2016.3.24 ~ 2016.3.24
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
###     funcUsing, 2016.3.24 ~ 2016.3.24, Version 0.00.001
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    info "Using : mysqlctl.bash COMMAND OPTIONS"
    info "        COMMAND              : 실행할 명령"
    info "        OPTIONS              : 명령 옵션"

    info "    COMMAND"
    info "        ssl                  : SSL 설정"

    info " "
    exit 1
}

### ------------------------------------------------------------------------------------------------
###     funcSsl, 2016.3.24 ~ 2016.3.24, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcSsl() {
    local SUBCOMMAND=$1
    local OPTIONS

    shift
    OPTIONS=$*

    case ${SUBCOMMAND} in
        init)
            funcSslInit ${OPTIONS}
            ;;
        backup)
            funcSslBackup ${OPTIONS}
            ;;
        apply)
            funcSslApply ${OPTIONS}
            ;;
        restore)
            funcSslRestore ${OPTIONS}
            ;;
        check)
            funcSslCheck ${OPTIONS}
            ;;
        all)
            funcUsingSsl ${OPTIONS}
            ;;
        help)
            funcUsingSsl ${OPTIONS}
            ;;
        *)
            funcUsingSsl ${OPTIONS}
            ;;
    esac
}

funcUsingSsl() {
    info "Using : mysqlctl.bash ssl SUBCOMMAND OPTIONS"
    info "    SUBCOMMAND"
    info "        init                 : 인증서 배포"
    info "        backup               : 설정 파일 백업"
    info "        apply                : 설정 파일 적용"
    info "        restore              : 설정 파일 복구"
    info "        check                : SSL 적용 확인"
    info " "
    exit 1
}

funcSslInit() {
    funcSslInitNode controller
    funcSslInitNode monitoring
}

funcSslInitNode() {
    local NODE=$1

    funcGetNodes ${NODE}
    NODES=${RTSTR}

    for hostname in ${NODES}; do
        ssh ${hostname} "mkdir -p ${SERVER_FOLDER}/conf"
        ssh ${hostname} "rm -f ${SERVER_FOLDER}/conf/ca-cert.pem"
        ssh ${hostname} "rm -f ${SERVER_FOLDER}/conf/server-key.pem"
        ssh ${hostname} "rm -f ${SERVER_FOLDER}/conf/server-cert.pem"
        ssh ${hostname} "rm -f ${SERVER_FOLDER}/conf/server-all.pem"
        ssh ${hostname} "rm -f ${SERVER_FOLDER}/conf/client-key.pem"
        ssh ${hostname} "rm -f ${SERVER_FOLDER}/conf/client-cert.pem"
        ssh ${hostname} "rm -f ${SERVER_FOLDER}/conf/client-all.pem"

        cd ${SERVER_FOLDER}/conf
        scp ca-cert.pem ${hostname}:${SERVER_FOLDER}/conf > /dev/null 2>&1
        scp server-key.pem ${hostname}:${SERVER_FOLDER}/conf > /dev/null 2>&1
        scp server-cert.pem ${hostname}:${SERVER_FOLDER}/conf > /dev/null 2>&1
        scp server-all.pem ${hostname}:${SERVER_FOLDER}/conf > /dev/null 2>&1
        scp client-key.pem ${hostname}:${SERVER_FOLDER}/conf > /dev/null 2>&1
        scp client-cert.pem ${hostname}:${SERVER_FOLDER}/conf > /dev/null 2>&1
        scp client-all.pem ${hostname}:${SERVER_FOLDER}/conf > /dev/null 2>&1

        ssh ${hostname} "chmod 644 ${SERVER_FOLDER}/conf/*.pem"
    done
}

funcSslBackup() {
    funcGetNodes controller
    NODES=${RTSTR}

    mkdir -p ${SERVER_FOLDER}/setting
    for hostname in ${NODES}; do
        funcSslBackupFile ${hostname} /etc/mysql/conf.d/wsrep.cnf
        funcSslBackupFile ${hostname} /etc/mysql/conf.d/password.cnf

        funcSslBackupFile ${hostname} /usr/lib/ocf/resource.d/fuel/mysql-wss controller

        funcSslBackupFile ${hostname} /etc/haproxy/conf.d/110-mysqld.cfg controller

        funcSslBackupFile ${hostname} /etc/keystone/keystone.conf
        funcSslBackupFile ${hostname} /etc/nova/nova.conf
        funcSslBackupFile ${hostname} /etc/cinder/cinder.conf
        funcSslBackupFile ${hostname} /etc/glance/glance-api.conf
        funcSslBackupFile ${hostname} /etc/glance/glance-registry.conf
        funcSslBackupFile ${hostname} /etc/neutron/neutron.conf
        funcSslBackupFile ${hostname} /etc/heat/heat.conf
        funcSslBackupFile ${hostname} /etc/murano/murano.conf

        info " "
    done
    info "vi ${SERVER_FOLDER}/setting/*/etc/mysql/conf.d/wsrep.cnf ${SERVER_FOLDER}/setting/*/etc/mysql/conf.d/password.cnf"
    info "vi ${SERVER_FOLDER}/setting/controller/usr/lib/ocf/resource.d/fuel/mysql-wss"
    info "vi ${SERVER_FOLDER}/setting/controller/etc/haproxy/conf.d/110-mysqld.cfg"


    funcGetNodes monitoring
    NODES=${RTSTR}
    for hostname in ${NODES}; do
        funcSslBackupFile ${hostname} /etc/grafana/grafana.ini monitoring
    done
    info "vi ${SERVER_FOLDER}/setting/monitoring/etc/grafana/grafana.ini"
}

funcSslBackupFile() {
    local HOSTNAME=$1
    local FILENAME=$2
    local NODE=${3:-${HOSTNAME}}
    local DIRNAME=`dirname ${FILENAME}`

    mkdir -p ${SERVER_FOLDER}/setting/${NODE}${DIRNAME}
    if [[ ! -e  ${SERVER_FOLDER}/setting/${NODE}${FILENAME}_org ]]; then
        scp ${HOSTNAME}:${FILENAME} ${SERVER_FOLDER}/setting/${NODE}${FILENAME}_org
    fi
   
    if [[ ! -e  ${SERVER_FOLDER}/setting/${NODE}${FILENAME} ]]; then
        cp ${SERVER_FOLDER}/setting/${NODE}${FILENAME}_org ${SERVER_FOLDER}/setting/${NODE}${FILENAME}
    fi
}

funcSslApply() {
    funcGetNodes controller
    NODES=${RTSTR}

    for hostname in ${NODES}; do
        scp ${SERVER_FOLDER}/setting/${hostname}/etc/mysql/conf.d/wsrep.cnf    ${hostname}:/etc/mysql/conf.d/wsrep.cnf
        scp ${SERVER_FOLDER}/setting/${hostname}/etc/mysql/conf.d/password.cnf ${hostname}:/etc/mysql/conf.d/password.cnf

        scp ${SERVER_FOLDER}/setting/controller/usr/lib/ocf/resource.d/fuel/mysql-wss ${hostname}:/usr/lib/ocf/resource.d/fuel/mysql-wss

        scp ${SERVER_FOLDER}/setting/controller/etc/haproxy/conf.d/110-mysqld.cfg ${hostname}:/etc/haproxy/conf.d/110-mysqld.cfg
        info " "
    done
    info "vim.bash controller001 /etc/mysql/conf.d/wsrep.cnf"
    info "vim.bash controller001 /etc/mysql/conf.d/password.cnf"
    info "vim.bash controller001 /usr/lib/ocf/resource.d/fuel/mysql-wss"
    info "vim.bash controller001 /etc/haproxy/conf.d/110-mysqld.cfg"


    funcGetNodes monitoring
    NODES=${RTSTR}
    for hostname in ${NODES}; do
        scp ${SERVER_FOLDER}/setting/monitoring/etc/grafana/grafana.ini ${hostname}:/etc/grafana/grafana.ini
    done
    info "vim.bash monitoring001 /etc/grafana/grafana.ini"
}

funcSslRestore() {
    funcGetNodes controller
    NODES=${RTSTR}

    for hostname in ${NODES}; do
        scp ${SERVER_FOLDER}/setting/${hostname}/etc/mysql/conf.d/wsrep.cnf_org    ${hostname}:/etc/mysql/conf.d/wsrep.cnf
        scp ${SERVER_FOLDER}/setting/${hostname}/etc/mysql/conf.d/password.cnf_org ${hostname}:/etc/mysql/conf.d/password.cnf

        scp ${SERVER_FOLDER}/setting/controller/usr/lib/ocf/resource.d/fuel/mysql-wss_org ${hostname}:/usr/lib/ocf/resource.d/fuel/mysql-wss

        scp ${SERVER_FOLDER}/setting/controller/etc/haproxy/conf.d/110-mysqld.cfg_org ${hostname}:/etc/haproxy/conf.d/110-mysqld.cfg
        info " "
    done

    funcGetNodes monitoring
    NODES=${RTSTR}
    for hostname in ${NODES}; do
        scp ${SERVER_FOLDER}/setting/monitoring/etc/grafana/grafana.ini_org ${hostname}:/etc/grafana/grafana.ini
    done
}

funcSslCheck() {
    local IP
    local PASSWD
    local CMD

    funcGetNodes controller
    NODES=${RTSTR}

    for hostname in ${NODES}; do
        : ${IP=`ssh ${hostname} "grep bind-address /etc/mysql/conf.d/wsrep.cnf"`}
        IP=${IP/bind-address=/}
        : ${PASSWD=`ssh ${hostname} "grep password /etc/mysql/conf.d/password.cnf"`}
        PASSWD=${PASSWD/password=/}
        CMD="ssh ${hostname} mysql -h ${IP} -P3307 -uroot -p${PASSWD} mysql --ssl=1 --ssl-cert=/data/conf/server-cert.pem --ssl-key=/data/conf/server-key.pem --ssl-ca=/data/conf/ca-cert.pem"

        info "------------------------------------------------------------"
        info "--- Host : ${hostname}"
        ssh ${hostname} "${CMD} -e 'status'" 2> /dev/null | grep SSL

        CMD="ssh ${hostname} mysql -h 10.10.10.2 -P3306 -uroot -p${PASSWD} mysql --ssl=1 --ssl-cert=/data/conf/server-cert.pem --ssl-key=/data/conf/server-key.pem --ssl-ca=/data/conf/ca-cert.pem"
        ssh ${hostname} "${CMD} -e 'status'" 2> /dev/null | grep SSL
        info " "
    done
}

### ------------------------------------------------------------------------------------------------
###     Main, 2016.3.24 ~ 2016.3.24, Version 0.00.001
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
    ssl)
        funcSsl ${OPTIONS}
        ;;
    *)
        funcUsing
        ;;
esac
exit 0

### ================================================================================================
