#!/bin/bash
### ================================================================================================
###     프로그램 명              : mount_cloudnas.bash, Version 0.00.001
###     프로그램 설명         	: /cloudnas/ 폴더 mount
###     작성자                     : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일                     : 2015.8.3 ~ 2015.8.3
### --- [History 관리] -------------------------------------------------------------------------------
###     2015.08.03, 산사랑 : 초안 작성
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2015 산사랑, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     funcCloudnasAWS()
###         AWS에서 /cloudnas disk mount
### ------------------------------------------------------------------------------------------------
funcCloudnasAWS() {
    mkfs.ext4 ${DISK_NAME}
    mkdir /cloudnas
    mount ${DISK_NAME}  /cloudnas

    cat >> /etc/fstab <<+

${DISK_NAME}  /cloudnas  ext4  defaults  1  2

+
}

### ------------------------------------------------------------------------------------------------
###     funcCloudnasCentOS()
###         CentOS에서 /cloudnas disk mount
### ------------------------------------------------------------------------------------------------
### To-Do : fdisk ${DISK_NAME} 명령을 사용하여 partition을 만드는 부분을 추가 합니다.
funcCloudnasCentOS() {
    mkfs.ext4 ${DISK_NAME}
    mkdir /cloudnas
    mount ${DISK_NAME}  /cloudnas

    cat >> /etc/fstab <<+

${DISK_NAME}  /cloudnas  ext4  defaults  1  2

+
}

### ------------------------------------------------------------------------------------------------
###     funcCloudnasCygwin()
###         Notebook에서 /cloudnas link 생성
### ------------------------------------------------------------------------------------------------
funcCloudnasCygwin() {
    cd /
    mkdir /home/cloudnas
    ln -s /home/cloudnas cloudnas
}

### ------------------------------------------------------------------------------------------------
###		Main process
### ------------------------------------------------------------------------------------------------

### ------------------------------------------------------------------------------------------------
###     root 사용자로 작업을 하고 있는지 확인 합니다.
### ------------------------------------------------------------------------------------------------
TMPSTR=`env | grep USER`
if [ "${TMPSTR}" = "USER=root" ]; then
    echo ""
else
    echo "root 사용자로 작업 하세요."
    exit 1
fi

### ------------------------------------------------------------------------------------------------
###     중복 실행을 방지 합니다.
### ------------------------------------------------------------------------------------------------
TMPSTR=`df -m | grep cloudnas | wc -l`
if [ "${TMPSTR}" = "1" ]; then
    echo "이미 /cloudnas/ 폴더가 mount 되어 있습니다."
    echo " "
    exit 2
fi

### ------------------------------------------------------------------------------------------------
###     사용자 입력 확인
### ------------------------------------------------------------------------------------------------
if [ "$#" = "1" ]; then
    DISK_NAME=$1
else
    echo "Using : mount_cloudnas.bash DISK_NAME"
    echo "    DISK_NAME           : 마운트할 disk"
    echo "fdisk -l 명령을 사용하여 DISK_NAME을 확인 하세요"
    echo " "
    exit 3
fi

### ------------------------------------------------------------------------------------------------
###     /cloudnas/ 폴더 생성
### ------------------------------------------------------------------------------------------------
TMPSTR=`grep 'CentOS Linux release 7.' /etc/system-release | wc -l`
if [[ "${AWS_PATH}" = "/opt/aws" ]]; then
    funcCloudnasAWS
elif [[ "${TMPSTR}" = "1" ]]; then
    funcCloudnasCentOS
elif [[ "${TERM}" = "TERM=cygwin" ]]; then
    funcCloudnasCygwin
else
    echo "Error : OS 종류를 확인할 수 없습니다."
    echo " "
    exit 1
fi

### Mount된 disk를 확인 합니다.
df -m

### ================================================================================================

