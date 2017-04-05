#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : install.bash, Version 0.00.001
###     프로그램 설명   : NFS Client를 설치 한다.
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
###     NFS Server 설치
###        NFS Server : 192.168.0.121
###        NFS Client : 192.168.0.122
### ------------------------------------------------------------------------------------------------
yum -y install nfs-utils

# vi /etc/idmapd.conf
#     Domain=~

systemctl restart rpcbind.service
systemctl enable  rpcbind.service

df -hT
lsblk

mkdir -p /data
mount -t nfs 192.168.0.121:/data /data

echo "192.168.0.121:/data    /data    nfs defaults    0    0" >> /etc/fstab
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

