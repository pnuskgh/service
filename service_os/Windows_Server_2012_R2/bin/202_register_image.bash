#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : 202_register_image.bash, Version 0.00.002
###     프로그램 설명   : Controller 장비에서 이미지를 등록 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.04 ~ 2017.02.14
### ----[History 관리]------------------------------------------------------------------------------
###     수정자         	:
###     수정일         	:
###     수정 내용      	:
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

IMAGE_NAME="Windows_Server_2012_R2"
BASE_FOLDER="/data/images/${IMAGE_NAME}"
. ${BASE_FOLDER}/bin/config.bash
OPTIONS="--container-format bare --disk-format qcow2 --min-disk 32 --min-ram 1024"

### ------------------------------------------------------------------------------------------------
###     manage 장비에서 fuel 장비로 이미지를 복사 한다.
### ------------------------------------------------------------------------------------------------
scp ${BASE_FOLDER}/convert/${IMAGE_NAME}.qcow2 fuel.daoucloud.com:/var/zzimage/${IMAGE_NAME}.qcow2
ssh fuel.daoucloud.com
ls -alF /var/zzimage/*.qcow2

### ------------------------------------------------------------------------------------------------
###     fuel 장비에서 controller001 장비로 이미지를 복사 한다.
### ------------------------------------------------------------------------------------------------
cd  ~
scp /var/zzimage/${IMAGE_NAME}.qcow2 controller001:/root/${IMAGE_NAME}.qcow2
rm  ${IMAGE_NAME}.qcow2
ssh controller001
ls -alF *.qcow2

### ------------------------------------------------------------------------------------------------
###     Image를 OpenStack에 등록 한다.
### ------------------------------------------------------------------------------------------------
cd  ~
source ~/openrc
openstack image list
openstack image delete "${IMAGE_NAME}_201702"
#--- pnuskgh@daou.com, pnuskgh@daou.co.kr
# openstack image create ${OPTIONS} --file ${IMAGE_NAME}.qcow2 --private --project 5c2606329ec9424fbfd426fb8475ed4a "${IMAGE_NAME}_201702"
# openstack image create ${OPTIONS} --file ${IMAGE_NAME}.qcow2 --private --project 931979efb16548d5afdc0ed715470e35 "${IMAGE_NAME}_201702"
openstack image create ${OPTIONS} --file ${IMAGE_NAME}.qcow2 --public "${IMAGE_NAME}_201702"

### ================================================================================================

