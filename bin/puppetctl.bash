#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : puppetctl.bash, Version 0.00.001
###     프로그램 설명   : Puppet 배포 및 실행 관리
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2016.3.29 ~ 2016.3.29
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
###     funcUsing, 2016.3.29 ~ 2016.3.29, Version 0.00.001
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    info "Using : puppetctl.bash COMMAND OPTIONS"
    info "        COMMAND              : 실행할 명령"
    info "        OPTIONS              : 명령 옵션"

    info "    COMMAND"
    info "        info                 : Puppet 관련 정보 표시"
    info "        deploy node file     : Puppet 배포"
    info "        apply node file      : Puppet 배포 및 실행"
    info "        show config          : hiera에 등록된 config 정보 조회"

    info " "
    exit 1
}

### ------------------------------------------------------------------------------------------------
###     funcInfo, 2016.3.29 ~ 2016.3.29, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcInfo() {
    info "------------------------------------------------------------"
    info "--- Puppet information"
    info "Version                      : `ssh controller001 puppet -V`"
    info "Modules                      : /etc/puppet/modules/, /etc/puppet/modules/osnailyfacter/modular/"
    info "Log file                     : /var/log/puppet.log"
    info "Configuration                : /etc/puppet/hiera.yaml"
    info "                               /etc/hiera/globals.yaml, /etc/hiera/nodes.yaml, ..."
    info "Ruby library                 : /usr/lib/ruby/vendor_ruby/puppet/"
    info " "
}

### ------------------------------------------------------------------------------------------------
###     funcPuppet, 2016.4.1 ~ 2016.4.1, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcPuppet() {
    info "------------------------------------------------------------"
    info "--- Make Puppet geppetto Project"

    cd /data/source

    rm -rf Puppet
    rm -f Puppet

    unzip Puppet > /dev/null 2>&1

    cd Puppet > /dev/null 2>&1
    mkdir -p hiera
    mkdir manifests
    mkdir modules

    for hostname in fuel controller001 compute001 storage001 telemetry001 monitoring001 ; do
        info "${hostname} processing ..."

        scp ${hostname}:/etc/hiera.yaml hiera.yaml > /dev/null 2>&1
        scp -r ${hostname}:/etc/hiera/* hiera      > /dev/null 2>&1

        scp ${hostname}:/etc/puppet/*.conf . > /dev/null 2>&1
        scp ${hostname}:/etc/puppet/*.yaml . > /dev/null 2>&1
        scp ${hostname}:/etc/puppet/*-pre .  > /dev/null 2>&1
        scp ${hostname}:/etc/puppet/*-post . > /dev/null 2>&1

        if [[ "${hostname}" == "fuel" ]]; then
            scp -r ${hostname}:/etc/puppet/liberty-8.0/manifests/* manifests > /dev/null 2>&1
            scp -r ${hostname}:/etc/puppet/liberty-8.0/modules/*   modules   > /dev/null 2>&1
        else
            scp -r ${hostname}:/etc/puppet/manifests/* manifests > /dev/null 2>&1
            scp -r ${hostname}:/etc/puppet/modules/*   modules   > /dev/null 2>&1
        fi
    done

    cd ..
    tar cvf Puppet.tar Puppet > /dev/null 2>&1

    info " "
    info " "
    info " "
    ls -alF /data/source/Puppet.tar
    ls -alF /data/source/Puppet
    info " "
}

### ------------------------------------------------------------------------------------------------
###     funcDeploy, 2016.3.29 ~ 2016.3.29, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcDeploy() {
    local ARGS
    local FILE
    local NODES

    if [[ $# == 2 ]]; then
        ARGS=$1
        FILE=$2
    else
        funcUsing
    fi

    funcGetNodes ${ARGS}
    NODES=${RTSTR}

    date
    info "------------------------------------------------------------"
    info "--- Puppet deploy"
    for hostname in ${NODES}; do
        if [[ "${FILE}" == "all" ]]; then
            scp -r /data/custom/puppet/* ${hostname}:/etc/puppet
        else
            FILENAME=${FILE/.\//\/etc\/puppet\/}
            FILENAME=${FILENAME/\/data\/custom\/puppet\//\/etc\/puppet\/}
            FOLDER=`dirname ${FILENAME}`

            cd /data/custom/puppet
            ssh ${hostname} "mkdir -p ${FOLDER}"
            scp ${FILE} ${hostname}:${FILENAME}
        fi
    done
    info " "
}

### ------------------------------------------------------------------------------------------------
###     funcApply, 2016.3.29 ~ 2016.3.29, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcApply() {
    local ARGS
    local FILE
    local NODES

    if [[ $# == 2 ]]; then
        ARGS=$1
        FILE=$2
    else
        funcUsing
    fi

    funcGetNodes ${ARGS}
    NODES=${RTSTR}

    date
    info "------------------------------------------------------------"
    info "--- Puppet apply"
    for hostname in ${NODES}; do
        FILENAME=${FILE/.\//\/etc\/puppet\/}
        FILENAME=${FILENAME/\/data\/custom\/puppet\//\/etc\/puppet\/}
        FOLDER=`dirname ${FILENAME}`

        cd /data/custom/puppet
        ssh ${hostname} "mkdir -p ${FOLDER}"
        scp ${FILE} ${hostname}:${FILENAME} > /dev/null 2>&1

        # info "puppet apply ${FILENAME} --modulepath=/etc/puppet/modules --logdest syslog --trace --no-report --debug --evaltrace --logdest /var/log/puppet.log"
        ssh ${hostname} "puppet apply ${FILENAME} --modulepath=/etc/puppet/modules --logdest syslog --trace --no-report --debug --evaltrace --logdest /var/log/puppet.log"
    done
    info " "
}

### ------------------------------------------------------------------------------------------------
###     funcShow, 2016.4.8 ~ 2016.4.8, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcShow() {
    local CONFIG

    if [[ $# == 1 ]]; then
        CONFIG=$1
    else
        funcUsing
    fi

    cat > /root/zztemp/puppetctl.pp <<EOF
\$node_name = hiera('node_name')
\$override_configuration = hiera_hash('configuration', {})
\$keystone_hash          = hiera_hash('keystone', {})

\$access_hash    = hiera_hash('access',{})
\$admin_tenant   = \$access_hash['tenant']

\$config = hiera("${CONFIG}")

\$config_all = "


--------------------------------------------------------------------------------
--- Configuration
node_name                              : \$node_name
tenant                                 : \$admin_tenant
override_configuration                 : \$override_configuration
keystone_hash                          : \$keystone_hash

${CONFIG} : \$config
"

file { '/root/zztemp/puppetctl.out':
    content => "\$config_all"
}
EOF
    scp /root/zztemp/puppetctl.pp controller001:/root/zztemp/puppetctl.pp
    ssh controller001 "puppet apply --modulepath=/etc/puppet/modules /root/zztemp/puppetctl.pp"
    ssh controller001 "cat /root/zztemp/puppetctl.out"
}

### ------------------------------------------------------------------------------------------------
###     Main, 2016.3.29 ~ 2016.3.29, Version 0.00.001
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
    info)
        funcInfo ${OPTIONS}
        ;;
    deploy)
        funcDeploy ${OPTIONS}
        ;;
    apply)
        funcApply ${OPTIONS}
        ;;
    puppet)
        funcPuppet ${OPTIONS}
        ;;
    show)
        funcShow ${OPTIONS}
        ;;
    *)
        funcUsing
        ;;
esac
exit 0

### ================================================================================================
