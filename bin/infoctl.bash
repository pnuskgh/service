#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : infoctl.bash, Version 0.00.001
###     프로그램 설명   : Linux 정보 관리
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2016.2.3 ~ 2016.2.3
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
    info "Using : infoctl.bash COMMAND OPTIONS"
    info "        COMMAND              : 실행할 명령"
    info "        OPTIONS              : 명령 옵션"

    info "    COMMAND"
    info "        ps                   : Process"
    info "        port                 : Process가 사용중인 LISTEN port"
#--- ss -nlp | grep LISTEN

    info " "
    exit 1
}

### ------------------------------------------------------------------------------------------------
###     funcPs, 2016.2.3 ~ 2016.2.3, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcPs() {
    info "------------------------------------------------------------"
    info "--- Process"
    ps -ef | awk '{printf("%10s %10s %10s  %s %s\n", $1, $2, $3, $8, $9)}' | egrep -v '  \[|/sbin/getty|inet_gethost|/sbin/init| tagtd|  cron|  sshd|  -bash|  tgtd|  arping|  ps |  awk |  egrep |  more | postfix |  su |  sh |/usr/bin/atop|  PPID  |  sort |  CRON|  sudo |  ping |  grep |  cut |  tee ' | sort -k 3
    info " "
}

### ------------------------------------------------------------------------------------------------
###     funcPort, 2016.2.3 ~ 2016.2.3, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcPort() {
    mkdir -p /root/zztemp
    ps -ef | awk '{printf("%10s %10s %10s  %s %s\n", $1, $2, $3, $8, $9)}' | egrep -v '  \[|/sbin/getty|inet_gethost|/sbin/init| tagtd|  cron|  sshd|  -bash|  tgtd|  arping|  ps |  awk |  egrep |  more | postfix |  su |  sh |/usr/bin/atop|  PPID  |  sort |  CRON|  sudo |  ping |  grep |  cut |  tee ' | sort -k 3 > /root/zztemp/ps.txt

    rm -f /root/zztemp/port.txt
    while read line; do
       # info "------------------------------------------------------------"
       # info "--- ${line}"
       PID=`echo ${line} | awk '{print $2}'`
       # lsof -p ${PID} | awk '/LISTEN/{printf("%10s %10s  %s %s\n", $1, $3, $9, $10)}'
       lsof -p ${PID} | awk '/LISTEN/{printf("%10s %10s  %s %s\n", $1, $3, $9, $10)}' >> /root/zztemp/port.txt
       # info " "
    done < /root/zztemp/ps.txt

    # info " "
    info "------------------------------------------------------------"
    info "--- Listen port"
    cat /root/zztemp/port.txt | uniq
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
    ps)
        funcPs ${OPTIONS}
        ;;
    port)
        funcPort ${OPTIONS}
        ;;
    *)
        funcUsing
        ;;
esac
exit 0

### ================================================================================================

