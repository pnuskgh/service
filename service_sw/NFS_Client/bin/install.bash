#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : install.bash, Version 0.00.002
###     프로그램 설명   : NFS Client를 설치 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.04.05 ~ 2017.04.10
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
###     환경 설정을 한다.
###     NFS_OPTIONS : [Path] [Client_IP](Options)
###         ro (Default), rw, aync (Default), async
###         root_squash    : Client의 root를 익명 사용자(nobody)로 매핑 (Default)
###         no_root_squash : Client의 root를 서버의 root로 매핑
###         all_squash     : 모든 사용자를 익명 사용자(nobody)로 매핑
###         secure         : 마운트 요청시 1024 port 이하로 할당 허용 (Default)
###         insecure       : 마운트 요청시 1024 port 이상도 할당 허용
### ------------------------------------------------------------------------------------------------
NFS_SERVER="192.168.0.121"
VOLUME_NAME="/dev/vdd"
VOLUME_FORMAT="xfs"
MOUNT_SERVER="/data"
NFS_OPTIONS="rw,no_root_squash"
# NFS_OPTIONS="ro,all_squash"
# NFS_OPTIONS="rw,async,no_subtree_check,no_root_squash"

NFS_CLIENT="192.168.0.122"
MOUNT_CLIENT="/data"

### ------------------------------------------------------------------------------------------------
###     NFS Client 설치
### ------------------------------------------------------------------------------------------------
yum -y install nfs-utils

# vi /etc/idmapd.conf
#     Domain=~

systemctl restart rpcbind.service
systemctl enable  rpcbind.service

# df -hT
# lsblk

mkdir -p ${MOUNT_CLIENT}
mount -t nfs ${NFS_SERVER}:${MOUNT_SERVER} ${MOUNT_CLIENT}

echo "${NFS_SERVER}:${MOUNT_SERVER} ${MOUNT_CLIENT}  nfs defaults    0    0" >> /etc/fstab
mount -l

#--- 동적 NFS 마운트
# yum -y install autofs
# vi /etc/auto.master
#     /- /etc/auto.mount
# 
# vi /etc/auto.mount
#     /mntdir -fstype=nfs,rw ~:/home
# 
# mkdir /mntdir
# cat /proc/mounts | grep mntdir

### ================================================================================================

