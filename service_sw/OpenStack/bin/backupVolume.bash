#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : backupVolume, Version 0.00.001
###     프로그램 설명   : Volume를 백업 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.04.12 ~ 2017.04.12
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

DOMAIN_NAME="daoucloud"
PROJECT_NAME="pnuskgh@daou.com"
SERVER_NAME="BackupInstance"

source ~/openrc.v3
DOMAIN_ID=`openstack domain list | grep ${DOMAIN_NAME} | nawk '{ print $2 }'`
PROJECT_ID=`openstack project list --domain ${DOMAIN_ID} | grep ${PROJECT_NAME} | nawk '{ print $2 }'`
SERVER_ID=`openstack server list --project ${PROJECT_ID} | grep ${SERVER_NAME} | nawk '{ print $2 }'`

echo "Domain       : ${DOMAIN_NAME}, ${DOMAIN_ID}"
echo "Project      : ${PROJECT_NAME}, ${PROJECT_ID}"
echo "Server       : ${SERVER_NAME}, ${SERVER_ID}"

# echo "DOMAIN_ID=${DOMAIN_ID}"
# echo "PROJECT_ID=${PROJECT_ID}"
# echo "SERVER_ID=${SERVER_ID}"

### ------------------------------------------------------------------------------------------------
###     Main process
###     Backup의 문제점
###         1.  Incremental backup이 되지 않음
###             https://bugs.launchpad.net/cinder/+bug/1578036
###             https://github.com/openstack/os-brick/commit/d47508bace35d9eaa58945a291ecd700b1eda72c
###             http://inter6.tistory.com/8
###         2.  Backup 동안 Server가 멈춤
### ------------------------------------------------------------------------------------------------
source /root/openrc

# cinder list --all-tenants
cinder list --tenant ${PROJECT_ID}

VOLUME_ATTACH_NAME="BackupVolumeAttach"
VOLUME_ATTACH_ID=`cinder list --tenant ${PROJECT_ID} | grep ${VOLUME_ATTACH_NAME} | nawk '{ print $2 }'`
VOLUME_NOATTACH_NAME="BackupVolumeNoattach"
VOLUME_NOATTACH_ID=`cinder list --tenant ${PROJECT_ID} | grep ${VOLUME_NOATTACH_NAME} | nawk '{ print $2 }'`
INSTANCE_VOLUME_ID=`cinder list --tenant ${PROJECT_ID} | grep ${SERVER_ID} | grep -v ${VOLUME_ATTACH_NAME} | nawk '{ print $2 }'`

# echo "INSTANCE_VOLUME_ID=${INSTANCE_VOLUME_ID}"
# echo "VOLUME_ATTACH_ID=${VOLUME_ATTACH_ID}"
# echo "VOLUME_NOATTACH_ID=${VOLUME_NOATTACH_ID}"



#--- Noattach Volume 백업
BACKUP_NOATTACH_001=`cinder backup-create --name backupVolumeNoattach_001 ${VOLUME_NOATTACH_ID} | grep " id  " | nawk '{ print $4 }'`
cinder backup-show ${BACKUP_NOATTACH_001}

BACKUP_NOATTACH_002=`cinder backup-create --name backupVolumeNoattach_002 --incremental ${VOLUME_NOATTACH_ID} | grep " id  " | nawk '{ print $4 }'`
cinder backup-show ${BACKUP_NOATTACH_002}

ceph df
cinder backup-list

#--- Noattach Volume 복원
cinder backup-restore --volume ${NEW_VOLUME_ID} ${BACKUP_NOATTACH_001}

cinder backup-delete ${BACKUP_NOATTACH_001}



#--- Attach Volume 백업
BACKUP_ATTACH_001=`cinder backup-create --name backupVolumeAttach_001 --force ${VOLUME_ATTACH_ID} | grep " id  " | nawk '{ print $4 }'`
cinder backup-show ${BACKUP_ATTACH_001}

BACKUP_ATTACH_002=`cinder backup-create --name backupVolumeAttach_002 --incremental --force ${VOLUME_ATTACH_ID} | grep " id  " | nawk '{ print $4 }'`
cinder backup-show ${BACKUP_ATTACH_002}

ceph df
cinder backup-list

#--- Attach Volume 복원
cinder backup-restore --volume ${NEW_VOLUME_ID} ${BACKUP_NOATTACH_001}

cinder backup-delete ${BACKUP_NOATTACH_001}



#--- Instance root Volume 백업
BACKUP_INSTANCE_001=`cinder backup-create --name backupInstance_001 --force ${INSTANCE_VOLUME_ID} | grep " id  " | nawk '{ print $4 }'`
cinder backup-show ${BACKUP_INSTANCE_001}

BACKUP_INSTANCE_002=`cinder backup-create --name backupInstance_002 --incremental --force ${INSTANCE_VOLUME_ID} | grep " id  " | nawk '{ print $4 }'`
cinder backup-show ${BACKUP_INSTANCE_002}

ceph df
cinder backup-list

#--- Instance root Volume 복원
cinder backup-restore --volume ${NEW_VOLUME_ID} ${BACKUP_NOATTACH_001}

cinder backup-delete ${BACKUP_NOATTACH_001}

exit 0
### ================================================================================================

