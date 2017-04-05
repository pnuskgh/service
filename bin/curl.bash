#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : curl.bash, Version 0.00.002
###     프로그램 설명   : curl로 OpenStack 관리
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2016.2.10 ~ 2016.3.17
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

###     curl options
###         -s, --silent               : Silent mode
###         -i, --include              : output에 HTTP-header 포함
###         -X, --request              : 전송 방식 (GET, POST, PUT, HEAD)
###         -H, --header               : 전송하는 Header 정보
###         -d, --data                 : POST 방식으로 전송하는 data
###         -g, --globoff              : switches  off  the "URL globbing parser
# CURL_OPTIONS='-si -H "Content-type: application/json"'
CURL_OPTIONS='-s -H "Content-type: application/json"'
SPECIAL="'"

### ------------------------------------------------------------------------------------------------
###     funcUsing, 2016.3.17 ~ 2016.3.17, Version 0.00.001
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    info "Using : curl.bash COMMAND [OPTIONS]"
    info "        COMMAND              : 실행할 명령"

    info "    COMMAND"
    info "        token                : TOKEN을 가져 온다"
    info "        test                 : Test용 명령어"

    info " "
    exit 2
}

### ------------------------------------------------------------------------------------------------
###     funcGetToken(), 2016.2.10 ~ 2016.2.10, Version 0.00.001
###     keystone/auth/controllers.py, AuthInfo._validate_and_normalize_scope_data
### ------------------------------------------------------------------------------------------------
funcGetToken() {
    funcEndWith ${OS_AUTH_URL} v3
    if [[ "$?" == "1" ]]; then
        funcGetToken_v3 $*
    else
        funcGetToken_v2 $*
    fi
}

funcGetToken_v3() {
    local SUBCOMMAND=$1

    local METHOD=POST
    local ACTION=auth/tokens
#   local DATA="${SPECIAL}{\"auth\": {\"scope\": {\"domain\": {\"id\": \"${OS_USER_DOMAIN_ID}\"}}, \"identity\": {\"password\": {\"user\": {\"domain\": {\"id\": \"${OS_USER_DOMAIN_ID}\"}, \"password\": \"${OS_PASSWORD}\", \"name\": \"${OS_USERNAME}\" }}, \"methods\": [\"password\"]}}}${SPECIAL}"
    local DATA="${SPECIAL}{\"auth\": {\"scope\": {\"project\": {\"name\": \"${OS_PROJECT_NAME}\", \"domain\": {\"id\": \"${OS_USER_DOMAIN_ID}\"}}}, \"identity\": {\"password\": {\"user\": {\"domain\": {\"id\": \"${OS_USER_DOMAIN_ID}\"}, \"password\": \"${OS_PASSWORD}\", \"name\": \"${OS_USERNAME}\" }}, \"methods\": [\"password\"]}}}${SPECIAL}"

    echo "#!/usr/bin/env bash" > /root/zztemp/zzcurl
    echo curl -i ${CURL_OPTIONS} -X ${METHOD} ${OS_AUTH_URL}/${ACTION} -d ${DATA} >> /root/zztemp/zzcurl
    chmod 755 /root/zztemp/zzcurl
    cat /root/zztemp/zzcurl
    echo " "
    echo " "

    if [[ "${SUBCOMMAND}" == "info" ]]; then
        DATA=${DATA/\'/}
        DATA=${DATA/\'/}
        echo ${DATA} | jq .
        exit 0
    elif [[ "${SUBCOMMAND}" == "debug" ]]; then
        /root/zztemp/zzcurl
        echo " "
        exit 0
    fi

    RTSTR=`/root/zztemp/zzcurl | awk '/X-Subject-Token/ {print $2}' | tr -d '\r'`
    rm -f /root/zztemp/zzcurl
}

funcGetToken_v2() {
    local SUBCOMMAND=$1

    local METHOD=POST
    local ACTION=tokens
    local DATA="${SPECIAL}{\"auth\": {\"passwordCredentials\": {\"username\":\"${OS_USERNAME}\", \"password\":\"${OS_PASSWORD}\"}, \"tenantName\":\"${OS_TENANT_NAME}\"}}${SPECIAL}"

    echo "#!/usr/bin/env bash" > /root/zztemp/zzcurl
    echo curl ${CURL_OPTIONS} -X ${METHOD} ${OS_AUTH_URL}/${ACTION} -d ${DATA} >> /root/zztemp/zzcurl
    chmod 755 /root/zztemp/zzcurl
    cat /root/zztemp/zzcurl
    echo " "
    echo " "

    if [[ "${SUBCOMMAND}" == "info" ]]; then
        DATA=${DATA/\'/}
        DATA=${DATA/\'/}
        echo ${DATA} | jq .
        exit 0
    elif [[ "${SUBCOMMAND}" == "debug" ]]; then
        /root/zztemp/zzcurl
        echo " "
        exit 0
    fi

    RTSTR=`/root/zztemp/zzcurl | jq .access.token.id`
    RTSTR=${RTSTR/\"/}
    RTSTR=${RTSTR/\"/}
    rm -f /root/zztemp/zzcurl
}

### ------------------------------------------------------------------------------------------------
###     funcTest(), 2016.2.10 ~ 2016.2.10, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcTest() {
    funcGetToken ${OPTIONS}

    local SUBCOMMAND=$1
    local CURL_OPTIONS="-s -H \"Content-type: application/json\" -H \"X-Auth-Token:${RTSTR}\""

    local METHOD=GET
    local ACTION

    ACTION=domains
    ACTION=users
    ACTION=users/411ffdc2fd004328984287708f40e006
    ACTION=projects?domain_id=${OS_USER_DOMAIN_ID}

    echo "#!/usr/bin/env bash" > /root/zztemp/zzcurl
    echo curl ${CURL_OPTIONS} -X ${METHOD} ${OS_AUTH_URL}/${ACTION} >> /root/zztemp/zzcurl
    chmod 755 /root/zztemp/zzcurl
    cat /root/zztemp/zzcurl
    echo " "
    echo " "

    if [[ "${SUBCOMMAND}" == "info" ]]; then
        DATA=${DATA/\'/}
        DATA=${DATA/\'/}
        echo ${DATA} | jq .
        exit 0
    elif [[ "${SUBCOMMAND}" == "debug" ]]; then
        /root/zztemp/zzcurl
        echo " "
        exit 0
    fi

    # /root/zztemp/zzcurl
    /root/zztemp/zzcurl | jq .
    rm -f /root/zztemp/zzcurl
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
    token)
        funcGetToken ${OPTIONS}
        TOKEN=${RTSTR}

        info " "
        info "------------------------------------------------------------"
        info "token = ${TOKEN}"
        info " "
        ;;
    test)
        funcTest ${OPTIONS}
        ;;
    *)
        funcUsing
        ;;
esac
exit 0

### ============================================================================
