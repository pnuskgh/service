#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : convert_image.bash, Version 0.00.002
###     프로그램 설명   : 이미지를 qcow2 이미지로 변환 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.04 ~ 2017.03.10
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     실행 환경을 설정 한다.
### ------------------------------------------------------------------------------------------------
source ${HOME_SERVICE}/bin/config.bash > /dev/null 2>&1
source ${UTIL_DIR}/common.bash > /dev/null 2>&1

WORKING_DIR=`dirname $0`
WORKING_DIR=${WORKING_DIR}/..
source ${WORKING_DIR}/bin/config.bash

### ------------------------------------------------------------------------------------------------
###     이미지 변환을 위한 프로그램을 설치 한다.
### ------------------------------------------------------------------------------------------------
ZZTEMP=`yum list installed | grep libguestfs-tools.noarch | wc -l`
if [[ "${ZZTEMP}" = "0" ]]; then
    yum -y install libguestfs-tools
fi

### ------------------------------------------------------------------------------------------------
###     이미지를 변환 한다.
###         https://en.wikibooks.org/wiki/QEMU/Images
###         Convert-VHD -Path CentOS_7_64.vhdx -DestinationPath CentOS_7_64.vhd
### ------------------------------------------------------------------------------------------------
cd ${WORK_DIR}/images

if [[ -f CentOS_7_64.qcow2 ]]; then
    mv CentOS_7_64.qcow2 CentOS_7_64.qcow2_${TIMESTAMP}
fi

if [[ -f CentOS_7_64.vhd ]]; then
    qemu-img convert -c -f vpc -O qcow2 CentOS_7_64.vhd CentOS_7_64.qcow2
    mv CentOS_7_64.vhd CentOS_7_64.vhd_${TIMESTAMP}
fi

if [[ -f CentOS_7_64.vhdx ]]; then
    qemu-img convert -c -f vhdx -O qcow2 CentOS_7_64.vhdx CentOS_7_64.qcow2
    mv CentOS_7_64.vhdx CentOS_7_64.vhdx_${TIMESTAMP}
fi

if [[ -f CentOS_7_64.vdi ]]; then
    qemu-img convert -c -f vdi -O qcow2 CentOS_7_64.vdi CentOS_7_64.qcow2
    mv CentOS_7_64.vdi CentOS_7_64.vdi_${TIMESTAMP}
fi

### ================================================================================================

