#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : register_image.bash, Version 0.00.003
###     프로그램 설명   : Controller 장비에서 이미지를 등록 한다.
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
###     Image를 OpenStack에 등록 한다.
### ------------------------------------------------------------------------------------------------
cd ~
source ~/openrc

FLAG_PUBLIC=$1
PROJECT_ID="5c2606329ec9424fbfd426fb8475ed4a"

IMAGE_FILE="CentOS_7_64.qcow2"
IMAGE_NAME="CentOS_7_x86_64_201703"
OPTIONS="--container-format bare --disk-format qcow2 --min-disk 8 --min-ram 512 --file ${IMAGE_FILE}"

# openstack image list
openstack image delete ${IMAGE_NAME}
if [[ "z${FLAG_PUBLIC}z" = "zz" ]]; then
    openstack image create ${OPTIONS} --private --project ${PROJECT_ID} ${IMAGE_NAME}
else
    openstack image create ${OPTIONS} --public ${IMAGE_NAME}
fi

rm  ${IMAGE_FILE}

### ================================================================================================

