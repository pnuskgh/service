#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : dvr_server_info.bash, Version 0.00.002
###     프로그램 설명   : Server 정보 표시
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.05.16 ~ 2017.05.17
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

HOME_SERVICE="/service"
HOME_WORK="/work"

source ${HOME_WORK}/OpenStack/config.bash

### ------------------------------------------------------------------------------------------------
###     Main Process
### ------------------------------------------------------------------------------------------------
CONFIG_FILE="${HOME_WORK}/OpenStack/config_new.bash"
QUOTE='"'

#--- Server의 기본 정보 확인
source ~/openrc.v3
DOMAIN_ID=`openstack domain list | grep ${DOMAIN_NAME} | nawk '{ print $2 }'`
PROJECT_ID=`openstack project list --domain ${DOMAIN_ID} | grep ${PROJECT_NAME} | nawk '{ print $2 }'`
SERVER_ID=`openstack server list --project ${PROJECT_ID} | grep ${SERVER_NAME} | nawk '{ print $2 }'`
SERVER_NODE=`openstack server show ${SERVER_ID} | grep "OS-EXT-SRV-ATTR:host" | nawk '{ print $4 }'`
SERVER_ADDRESS=`openstack server show ${SERVER_ID} | grep addresses |  nawk '{ print $4, $5 }'`

cd ${HOME_WORK}/OpenStack
echo "PUBLIC_NETEORK_NAME=${PUBLIC_NETEORK_NAME}" > ${CONFIG_FILE}
echo " " >> ${CONFIG_FILE}
echo "DOMAIN_NAME=${DOMAIN_NAME}" >> ${CONFIG_FILE}
echo "DOMAIN_ID=${DOMAIN_ID}" >> ${CONFIG_FILE}
echo " " >> ${CONFIG_FILE}

echo "PROJECT_NAME=${PROJECT_NAME}" >> ${CONFIG_FILE}
echo "PROJECT_ID=${PROJECT_ID}" >> ${CONFIG_FILE}
echo " " >> ${CONFIG_FILE}
echo "SERVER_NAME=${SERVER_NAME}" >> ${CONFIG_FILE}
echo "SERVER_ID=${SERVER_ID}" >> ${CONFIG_FILE}
echo "SERVER_NODE=${SERVER_NODE}" >> ${CONFIG_FILE}
echo "SERVER_ADDRESS=${QUOTE}${SERVER_ADDRESS}${QUOTE}" >> ${CONFIG_FILE}
echo " " >> ${CONFIG_FILE}

#--- In controller001 : eth0 NIC의 Interface 확인
#---     PORT_KEY. 11자, IPTABLE_KEY. 10자
source ~/openrc
PORT_ID=`nova interface-list ${SERVER_ID} | grep ACTIVE | nawk '{ print $4 }'`
# PORT_KEY=`nova interface-list ${SERVER_ID} | grep ACTIVE | nawk '{ print substr($4, 0, 12) }'`
PORT_KEY=`echo ${PORT_ID} | nawk '{ print substr($1, 0, 12) }'`
# IPTABLE_KEY=`nova interface-list ${SERVER_ID} | grep ACTIVE | nawk '{ print substr($4, 0, 11) }'`
IPTABLE_KEY=`echo ${PORT_ID} | nawk '{ print substr($1, 0, 11) }'`

echo "PORT_ID=${PORT_ID}" >> ${CONFIG_FILE}
echo "PORT_KEY=${PORT_KEY}" >> ${CONFIG_FILE}
echo "IPTABLE_KEY=${IPTABLE_KEY}" >> ${CONFIG_FILE}
echo " " >> ${CONFIG_FILE}
chmod 755 ${CONFIG_FILE}

cat ${CONFIG_FILE}

### ================================================================================================

