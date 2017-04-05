#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : servicectl.bash, Version 0.00.001
###     프로그램 설명   : Service 관리
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2016.2.3 ~ 2016.3.22
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
###     funcUsing, 2016.2.3 ~ 2016.2.3, Version 0.00.001
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    info "Using : servicectl.bash NODES COMMAND [OPTIONS]"
    info "        NODES                : 실행할 nodes"
    info "        COMMAND              : 실행할 명령"
    info "        OPTIONS              : 명령 옵션"

    info "    COMMAND"
    info "        info SERVICE         : Service 정보"
    info "            이 경우 NODES는 하나만 사용하고 대표 node 이름을 사용 한다"
    info "        start SERVICE        : Service 시작"
    info "        stop SERVICE         : Service 시작"
    info "        restart SERVICE      : Service 시작"
    info "        status SERVICE       : Service 시작"

    info " "
    exit 2
}

### ------------------------------------------------------------------------------------------------
###     funcInfo, 2016.2.3 ~ 2016.3.22, Version 0.00.002
###     Service 이름에 해당하는 정보를 표시 한다.
### ------------------------------------------------------------------------------------------------
funcInfo() {
    local SERVICE=$1
    local TMP_SERVICE

    if [[ $# == 0 ]]; then
        SERVICE="all"
    fi

    info "------------------------------------------------------------"
    info "--- Service list"
    mkdir -p /root/zztemp
    grep -v "#" ${SERVER_FOLDER}/conf/services | egrep -v '^#|^$' > /root/zztemp/zzservicectl.txt

    if [[ "${SERVICE}" == "all" ]]; then
        if [[ "${NODE}" == "all" ]]; then
            cat /root/zztemp/zzservicectl.txt | sort -k 3 -n
        else
            cat /root/zztemp/zzservicectl.txt | grep ${NODE} | sort -k 3 -n
        fi
        cat /root/zztemp/zzservicectl.txt > /root/zztemp/zzservicectl_out001.txt
    else
        rm -f /root/zztemp/zzservicectl_out001.txt
        while read -u 11 row; do
            read TMP_SERVICE _ <<< ${row}
            if [[ "${SERVICE}" == "${TMP_SERVICE}" ]]; then
                if [[ "${NODE}" == "all" ]]; then
                    echo "${row}" | sort -k 3 -n
                else
                    echo "${row}" | grep ${NODE} | sort -k 3 -n
                fi
                echo "${row}" >> /root/zztemp/zzservicectl_out001.txt
            fi
        done 11< /root/zztemp/zzservicectl.txt
    fi
    info " "
}

### ------------------------------------------------------------------------------------------------
###     funcCommand, 2016.3.22 ~ 2016.3.22, Version 0.00.001
###     To-Do : restart시 실행이 완전히 종료된 이후에 start
###     To-Do : target node에서만 실행할 것
### ------------------------------------------------------------------------------------------------
funcCommand() {
    local SUB_COMMAND=$1

    shift
    funcInfo $* > /dev/null 2>&1

    cat /root/zztemp/zzservicectl_out001.txt | sort -k 3 -n > /root/zztemp/zzservicectl_out002.txt
    if [[ "${SUB_COMMAND}" == "stop" ]]; then
        cat /root/zztemp/zzservicectl_out001.txt | sort -k 3 -n -r > /root/zztemp/zzservicectl_out002.txt
    fi

    info "------------------------------------------------------------"
    info "--- Service ${SUB_COMMAND}"
    while read -u 11 SERVICE NODE SEQ TYPE PROCESS OPT; do
        for hostname in ${NODES}; do
            funcStartWith ${hostname} ${NODE}
            if [[ "$?" != "1" ]]; then
                continue
            fi
       
            if [[ "${TYPE}" == "init.d" ]]; then
                if [[ "${OPT}" == "stop" ]]; then
                    info ssh ${hostname} "/etc/init.d/${PROCESS} stop" > /dev/null 2>&1
                    ssh ${hostname} "/etc/init.d/${PROCESS} stop" > /dev/null 2>&1
                else
                    info ssh ${hostname} "/etc/init.d/${PROCESS} ${SUB_COMMAND}"
                    ssh ${hostname} "/etc/init.d/${PROCESS} ${SUB_COMMAND}"
                    info " "
                fi
            elif [[ "${TYPE}" == "initctl" ]]; then
                if [[ "${OPT}" == "stop" ]]; then
                    info ssh ${hostname} "initctl stop ${PROCESS}" > /dev/null 2>&1
                    ssh ${hostname} "initctl stop ${PROCESS}" > /dev/null 2>&1
                else
                    info ssh ${hostname} "initctl ${SUB_COMMAND} ${PROCESS}"
                    ssh ${hostname} "initctl ${SUB_COMMAND} ${PROCESS}"
                    info " "
                fi
            elif [[ "${TYPE}" == "pcs" ]]; then
                if [[ "${SUB_COMMAND}" == "start" ]]; then
                    info ssh ${hostname} pcs resource enable ${PROCESS}
                    ssh ${hostname} "pcs resource enable ${PROCESS}"
                elif [[ "${SUB_COMMAND}" == "stop" ]]; then
                    info ssh ${hostname} pcs resource disable ${PROCESS}
                    ssh ${hostname} "pcs resource disable ${PROCESS}"
                elif [[ "${SUB_COMMAND}" == "restart" ]]; then
                    info ssh ${hostname} pcs resource disable ${PROCESS}
                    ssh ${hostname} "pcs resource disable ${PROCESS}"
                    sleep 10
                    info ssh ${hostname} pcs resource enable ${PROCESS}
                    ssh ${hostname} "pcs resource enable ${PROCESS}"
                elif [[ "${SUB_COMMAND}" == "status" ]]; then
                    info ssh ${hostname} crm resource status ${PROCESS}
                    ssh ${hostname} "crm resource status ${PROCESS}"
                fi
            else
                error "unknown - ${TYPE}"
            fi
        done
    done 11< /root/zztemp/zzservicectl_out002.txt
    info " "
}

### ------------------------------------------------------------------------------------------------
###     zzfuncRestart, 2016.2.3 ~ 2016.2.3, Version 0.00.001
###     To-Do : 한번 ssh가 호출되면 bash가 종료됨
### ------------------------------------------------------------------------------------------------
zzfuncRestart() {
    local SERVICE
    local NODE
    local TYPE
    local PROCESS

    if [[ $# == 0 ]]; then
        info "Please select service"
        info " "
        info "------------------------------------------------------------"
        info "--- Service list"
        grep -v "#" ${SERVER_FOLDER}/conf/services | awk '{ if (0 < NF) printf("%-20s %s\n", $1, $2) }' | uniq
    elif [[ 0 < $# ]]; then
        mkdir -p /root/zztemp
        grep -v "#" ${SERVER_FOLDER}/conf/services | grep $1 | awk '{
            if (0 < NF) {
                for (i = 4;i <= NF;i++) {
                    printf("%-20s %-20s %-10s %s\n", $1, $2, $3, $(i))
                }
            }
        }' > /root/zztemp/zzservicectl.txt

        date
        for hostname in ${NODES}; do
            info "------------------------------------------------------------"
            info "--- ${hostname}"
            while read -u 11 row; do
                SERVICE=`echo ${row} | awk '{ print $1 }'`
                NODE=`echo ${row} | awk '{ print $2 }'`
                TYPE=`echo ${row} | awk '{ print $3 }'`
                PROCESS=`echo ${row} | awk '{ print $4 }'`
                funcStartWith ${hostname} ${NODE}
                if [[ "$?" == "1" ]]; then
                    debug "Row : ${row}"
                    debug "Service : ${SERVICE}"
                    debug "Node : ${NODE}"
                    debug "Type : ${TYPE}"
                    debug "Process : ${PROCESS}"
                    debug " "
                   
                    if [[ "${TYPE}" == "init.d" ]]; then
                        info ssh ${hostname} "/etc/init.d/${PROCESS} restart"
                        # bash -c "ssh ${hostname} /etc/init.d/${PROCESS} restart"
                    elif [[ "${TYPE}" == "initctl" ]]; then
                        info ssh ${hostname} "initctl restart ${PROCESS}"
                        # bash -c "ssh ${hostname} initctl restart ${PROCESS}"
                    elif [[ "${TYPE}" == "pcs" ]]; then
                        info "Reserved : restart ${PROCESS}"
                    else
                        error "unknown - ${TYPE}"
                    fi
                fi
            done 11< /root/zztemp/zzservicectl.txt
            echo " "
        done
        info " "
    else
        funcUsing
    fi
    info " "
}


### ------------------------------------------------------------------------------------------------
###     Main
### ------------------------------------------------------------------------------------------------
###---  Command Line에서 입력된 인수를 검사한다.
if [[ 1 < $# ]]; then
    ARGS=$1
    shift
    COMMAND=$1
    shift
    OPTIONS=$*
else
    funcUsing
fi

NODE=${ARGS}
funcGetNodes ${ARGS}
NODES=${RTSTR}
debug "Nodes : ${NODES}"

case ${COMMAND} in
    info)
        funcInfo ${OPTIONS}
        ;;
    start)
        funcCommand start ${OPTIONS}
        ;;
    stop)
        funcCommand stop ${OPTIONS}
        ;;
    restart)
        funcCommand restart ${OPTIONS}
        ;;
    status)
        funcCommand status ${OPTIONS}
        ;;
    *)
        funcUsing
        ;;
esac
exit 0

### ================================================================================================

