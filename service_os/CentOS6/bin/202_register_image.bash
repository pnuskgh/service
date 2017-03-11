#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : 202_register_image.bash, Version 0.00.001
###     프로그램 설명   : Controller 장비에서 이미지를 등록 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.06 ~ 2017.01.06
### ----[History 관리]------------------------------------------------------------------------------
###     수정자         	:
###     수정일         	:
###     수정 내용      	:
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     manage 장비에서 fuel 장비로 이미지를 복사 한다.
### ------------------------------------------------------------------------------------------------
cd /data/images/CentOS6/convert
scp CentOS6_64.qcow2 fuel.daoucloud.com:/root/CentOS6_64.qcow2
ssh fuel.daoucloud.com
ls -alF *.qcow2

### ------------------------------------------------------------------------------------------------
###     manage 장비에서 fuel 장비로 이미지를 복사 한다.
### ------------------------------------------------------------------------------------------------
cd  ~
scp CentOS6_64.qcow2 controller001:/root/CentOS6_64.qcow2
rm  CentOS6_64.qcow2
ssh controller001
ls -alF *.qcow2

### ------------------------------------------------------------------------------------------------
###     Image를 OpenStack에 등록 한다.
### ------------------------------------------------------------------------------------------------
cd  ~
source ~/openrc
openstack image list
openstack image delete "CentOS-6-x86-64_201701"
openstack image create --container-format bare --disk-format qcow2 --min-disk 8 --min-ram 512 --file CentOS6_64.qcow2 --private --project 5c2606329ec9424fbfd426fb8475ed4a "CentOS-6-x86-64_201702"
openstack image create --container-format bare --disk-format qcow2 --min-disk 8 --min-ram 512 --file CentOS6_64.qcow2 --public "CentOS-6-x86-64_201701"
# epel-release / java, python, perl, ruby, php 제공

### ================================================================================================

