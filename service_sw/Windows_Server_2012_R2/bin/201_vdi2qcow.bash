#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : 201_vdi2qcow.bash, Version 0.00.002
###     프로그램 설명   : VirtualBox의 vdi 이미지를 qcow2 이미지로 변환 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.04 ~ 2017.02.14
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

. /data/images/Windows_Server_2012_R2/bin/config.bash
BASE_FOLDER="/data/images/Windows_Server_2012_R2"
IMAGE_NAME="Windows_Server_2012_R2"

### ------------------------------------------------------------------------------------------------
###     VirtualBox의 vdi 이미지를 qcow2 이미지로 변환 한다.
###         IDC_DOC_manage 장비에서 작업 한다.
### ------------------------------------------------------------------------------------------------
# yum -y install libguestfs-tools

# mkdir -p ${BASE_FOLDER}/convert

#--- 사전에 /data/images/Windows_Server_2008_R2/convert/ 폴더에 Windows_Server_2008_R2.vdi 파일을 업로드 하여야 한다.
cd ${BASE_FOLDER}/convert
# rm Windows_Server_2008_R2.qcow2
mv ${IMAGE_NAME}.qcow2 ${IMAGE_NAME}.qcow2_${TIMESTAMP}
echo qemu-img convert -c -f vdi -O qcow2 ${IMAGE_NAME}.vdi ${IMAGE_NAME}.qcow2
qemu-img convert -c -f vdi -O qcow2 ${IMAGE_NAME}.vdi ${IMAGE_NAME}.qcow2
ls -alF ${BASE_FOLDER}/convert

### ================================================================================================
