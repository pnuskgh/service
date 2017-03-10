#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : register_image.bash, Version 0.00.002
###     프로그램 설명   : Controller 장비에서 이미지를 등록 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.04 ~ 2017.02.22
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     manage 장비에서 fuel 장비로 이미지를 복사 한다.
### ------------------------------------------------------------------------------------------------
cd /data/osimage/CentOS7/convert
ssh fuel.daoucloud.com rm /var/zzimage/CentOS7_64.qcow2
scp CentOS7_64.qcow2 fuel.daoucloud.com:/var/zzimage/CentOS7_64.qcow2
ssh fuel.daoucloud.com
cd /var/zzimage
ls -alF /var/zzimage/*.qcow2

### ------------------------------------------------------------------------------------------------
###     manage 장비에서 fuel 장비로 이미지를 복사 한다.
### ------------------------------------------------------------------------------------------------
cd  ~
ssh controller001 rm /root/CentOS7_64.qcow2
scp CentOS7_64.qcow2 controller001:/root/CentOS7_64.qcow2
rm  CentOS7_64.qcow2
ssh controller001
ls -alF *.qcow2

### ------------------------------------------------------------------------------------------------
###     Image를 OpenStack에 등록 한다.
### ------------------------------------------------------------------------------------------------
cd  ~
source ~/openrc
openstack image list
openstack image delete "CentOS-7-x86-64_201702"
openstack image create --container-format bare --disk-format qcow2 --min-disk 8 --min-ram 512 --file CentOS7_64.qcow2 --public "CentOS-7-x86-64_201702"
#--- pnuskgh@daou.com, pnuskgh@daou.co.kr
openstack image create --container-format bare --disk-format qcow2 --min-disk 8 --min-ram 512 --file CentOS7_64.qcow2 --private --project 5c2606329ec9424fbfd426fb8475ed4a "CentOS-7-x86-64_201702"
openstack image create --container-format bare --disk-format qcow2 --min-disk 8 --min-ram 512 --file CentOS7_64.qcow2 --private --project 931979efb16548d5afdc0ed715470e35 "CentOS-7-x86-64_201702"
# epel-release / java, python, perl, ruby, php 제공

rm  CentOS7_64.qcow2

### ================================================================================================

