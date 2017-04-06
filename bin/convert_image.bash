#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : convert_image.bash, Version 0.00.004
###     프로그램 설명   : 이미지를 포맷을 변환 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.04 ~ 2017.04.06
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     Include
### ------------------------------------------------------------------------------------------------
if [[ "z${HOME_SERVICE}z" == "zz" ]]; then
    export HOME_SERVICE="/service"
fi

source ${HOME_SERVICE}/bin/config.bash > /dev/null 2>&1

### ------------------------------------------------------------------------------------------------
###     이미지 변환을 위한 프로그램을 설치 한다.
### ------------------------------------------------------------------------------------------------
ZZTEMP=`yum list installed | grep libguestfs-tools.noarch | wc -l`
if [[ "${ZZTEMP}" = "0" ]]; then
    yum -y install libguestfs-tools
fi

### ------------------------------------------------------------------------------------------------
###     Convert Image Function
### ------------------------------------------------------------------------------------------------
convert_image() {
    local FILE_EXT=$1
    local TARGET=$2

    for TMPFILE in `ls *.${FILE_EXT}`; do
        FILE_NAME=`basename -s .${FILE_EXT} ${TMPFILE}`

        if [[ -f ${FILE_NAME}.qcow2 ]]; then
            mv ${FILE_NAME}.qcow2 ${FILE_NAME}.qcow2_${TIMESTAMP}
        fi
        qemu-img convert -c -f ${TARGET} -O qcow2 ${FILE_NAME}.${FILE_EXT} ${FILE_NAME}.qcow2
        mv ${FILE_NAME}.${FILE_EXT} ${FILE_NAME}.${FILE_EXT}_${TIMESTAMP}
    done
    return 0
}

convert_raw_image() {
    local FILE_EXT=$1
    local TARGET=$2

    for TMPFILE in `ls *.${FILE_EXT}`; do
        FILE_NAME=`basename -s .${FILE_EXT} ${TMPFILE}`

        if [[ -f ${FILE_NAME}.raw ]]; then
            mv ${FILE_NAME}.raw ${FILE_NAME}.raw_${TIMESTAMP}
        fi
        qemu-img convert -f ${TARGET} -O raw ${FILE_NAME}.${FILE_EXT} ${FILE_NAME}.raw
        mv ${FILE_NAME}.${FILE_EXT} ${FILE_NAME}.${FILE_EXT}_${TIMESTAMP}
    done
    return 0
}

### ------------------------------------------------------------------------------------------------
###     이미지를 변환 한다.
###         https://en.wikibooks.org/wiki/QEMU/Images
###         Convert-VHD -Path CentOS_7_64.vhdx -DestinationPath CentOS_7_64.vhd
### ------------------------------------------------------------------------------------------------

convert_raw_image vdi  vdi
convert_raw_image vhd  vpc
convert_raw_image vhdx vhdx

exit 0
### ================================================================================================

