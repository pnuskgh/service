#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : movePublicIp.bash, Version 0.00.001
###     프로그램 설명   : 하나의 서버에서 다른 서버로 공인 IP를 이동 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.04.07 ~ 2017.04.07
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     funcUsing()
###         사용법 표시
### ------------------------------------------------------------------------------------------------
funcUsing() {
    /bin/echo "Using : movePublicIp.bash SOURCE TARGET PUBLIC_IP"
    /bin/echo "        SOURCE 서버에서 TARGET 서버로 Public IP를 이동 한다"
    /bin/echo "        SOURCE         : 공인 IP를 넘겨줄 서버 ID"
    /bin/echo "        TARGET         : 공인 IP를 받을 서버 ID"
    /bin/echo "        PUBLIC_IP      : 공인 IP"
    /bin/echo " "
    exit 1
}

###---  Command Line에서 입력된 인수를 검사한다.
if [[ $# != 3 ]]; then
    funcUsing
fi

DOMAIN_NAME="daoucloud"
DOMAIN_ID="9793e618c40f4202958687e7d243ea41"
PROJECT_NAME="clouddev@daou.co.kr"
PROJECT_ID="1f91fe85b0b7461382c9c83064fef358"

SOURCE_SERVER_ID=$1
# SOURCE_SERVER_NAME="zzweb01"
# SOURCE_SERVER_IP="192.168.0.162"
# SOURCE_SERVER_ID="dedfdf37-4aa5-46bd-be60-e29d9365c222"

TARGET_SERVER_ID=$2
# TARGET_SERVER_NAME="zzweb02"
# TARGET_SERVER_IP="192.168.0.163"
# TARGET_SERVER_ID="7ddb9ffd-18d9-4291-81cb-69029da2d371"

PUBLIC_IP=$3
# PUBLIC_IP="203.217.215.39"

### ----------------------------------------------------------------------------
###     Main process
### ----------------------------------------------------------------------------
source /root/openrc.v3
# DOMAIN_ID=`openstack domain list | grep ${DOMAIN_NAME} | nawk '{ print $2 }'`
# PROJECT_ID=`openstack project list --domain ${DOMAIN_ID} | grep ${PROJECT_NAME} | nawk '{ print $2 }'`

# openstack server list --project ${PROJECT_ID}
FLAG_SOURCE_HAS_IP=`openstack server show ${SOURCE_SERVER_ID} | grep ${PUBLIC_IP} | wc -l`
if [[ "zz${FLAG_SOURCE_HAS_IP}zz" == "zz0zz" ]]; then
    exit 0
fi

# openstack ip floating list
openstack ip floating remove ${PUBLIC_IP} ${SOURCE_SERVER_ID}
sleep 1
openstack ip floating add ${PUBLIC_IP} ${TARGET_SERVER_ID}

exit 0
### ================================================================================================

