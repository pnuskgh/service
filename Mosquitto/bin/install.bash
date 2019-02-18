#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : install.bash, Version 0.00.001
###     프로그램 설명   : Mosquitto를 설치 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2019.02.05 ~ 2019.02.05
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2019 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     실행 환경을 설정 한다.
### ------------------------------------------------------------------------------------------------
SOFTWARE="Mosquitto"

if [[ "z${HOME_SERVICE}z" == "zz" ]]; then
    export HOME_SERVICE="/service"
fi
WORKING_DIR="${HOME_SERVICE}/${SOFTWARE}"
source ${HOME_SERVICE}/bin/config.bash > /dev/null 2>&1

if [[ -f ${WORKING_DIR}/bin/config.php ]]; then
    source ${WORKING_DIR}/bin/config.php
else
    TIMESTAMP=`date +%Y%m%d_%H%M%S`
    BACKUP_DIR=${WORKING_DIR}/backup
    TEMPLATE_DIR=${WORKING_DIR}/template
fi

### ------------------------------------------------------------------------------------------------
###     Mosquitto 설치 : MQTT (Message Queue Telemetry Transport)
###         Mosquitto
###         Port : 1883
### ------------------------------------------------------------------------------------------------
yum -y install mosquitto

vi  /etc/mosquitto/mosquitto.conf
    allow_anonymous false
    password_file /etc/mosquitto/passwd

# cp ${TEMPLATE_DIR}/passwd /etc/mosquitto/passwd
touch  /etc/mosquitto/passwd
mosquitto_passwd -b /etc/mosquitto/passwd 아이디 비밀번호     #--- 사용자 추가/수정
mosquitto_passwd -D /etc/mosquitto/passwd 아이디              #--- 사용자 삭제

systemctl start  mosquitto.service
systemctl enable mosquitto.service
systemctl status mosquitto.service

netstat -an | grep 1883 | grep LISTEN

# mosquitto_pub –h localhost –t test –m “hello world”
# mosquitto_sub –h localhost –t test

### ================================================================================================

