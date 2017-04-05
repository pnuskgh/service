#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : install.bash, Version 0.00.001
###     프로그램 설명   : NFS Server를 설치 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.04.05 ~ 2017.04.05
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

RELATION_DIR="$(dirname $0)"
WORKING_DIR="$(cd -P ${RELATION_DIR}/.. && pwd)"
source ${WORKING_DIR}/bin/config.bash

### ------------------------------------------------------------------------------------------------
###     Volume Mount
###         Volume : /dev/vdd
###         Folder : /data
### ------------------------------------------------------------------------------------------------
yum -y install xfsprogs

df -h
lsblk

mkfs.xfs  /dev/vdd
# mkfs.ext4 /dev/vdd

mkdir -p /data
mount -t xfs /dev/vdd /data
# mount -t ext4 /dev/vdd /data
echo "/dev/vdd /data xfs  defaults 0 0" >> /etc/fstab
# echo "/dev/vdd /data ext4  defaults 1 2" >> /etc/fstab

### ------------------------------------------------------------------------------------------------
###     NFS Server 설치
###        NFS Server : 192.168.0.121
###        NFS Client : 192.168.0.122
### ------------------------------------------------------------------------------------------------
yum -y install nfs-utils

systemctl restart rpcbind.service
systemctl enable  rpcbind.service

systemctl restart nfs-server.service
systemctl enable  nfs-server.service

# showmount -e 127.0.0.1

# vi /etc/idmapd.conf
#     Domain=~

#--- [Path] [Client_IP](Options)
#--- Options
#---     ro (Default), rw, aync (Default), async
#---     root_squash : Client의 root를 익명 사용자(nobody)로 매핑 (Default)
#---     all_squash  : 모든 사용자를 익명 사용자(nobody)로 매핑
#---     secure      : 마운트 요청시 1024 port 이하로 할당 허용 (Default)
#---     insecure    : 마운트 요청시 1024 port 이상도 할당 허용
#---     anonuid=<uid>, anongid=<gid>
echo "/data 192.168.0.122(rw,async,no_subtree_check,no_root_squash)" > /etc/exports
chmod 644 /etc/exports

systemctl restart nfs-server.service
# mount -l | grep data

### ------------------------------------------------------------------------------------------------
###     방화벽 설정
### ------------------------------------------------------------------------------------------------
# firewall-cmd --add-service=nfs --permanent
# firewall-cmd --reload

### ================================================================================================

