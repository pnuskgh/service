#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : convert_image.bash, Version 0.00.006
###     프로그램 설명   : 이미지를 포맷을 변환 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.04 ~ 2017.06.08
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
###     funcUsing()
###         사용법 표시
### ------------------------------------------------------------------------------------------------
funcUsing() {
    /bin/echo "Using : convert_image.bash [TYPE]"
    /bin/echo "        TYPE           : 이미지 타입 (raw. default, qcow2)"
    /bin/echo " "
    exit 1
}

###---  Command Line에서 입력된 인수를 검사한다.
if [[ $# = 1 ]]; then
    TYPE=qcow2
else
    TYPE=raw
fi

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
    local SOURCE_FILE_EXT=$1
    local SOURCE_FILE_TYPE=$2
    local TARGET_FILE_EXT=$3
    local TARGET_FILE_TYPE=$4

    for TMPFILE in `ls *.${SOURCE_FILE_EXT}`; do
        FILE_NAME=`basename -s .${SOURCE_FILE_EXT} ${TMPFILE}`

        if [[ -f ${FILE_NAME}.${TARGET_FILE_EXT} ]]; then
            mv ${FILE_NAME}.${TARGET_FILE_EXT} ${FILE_NAME}.${TARGET_FILE_EXT}_${TIMESTAMP}
        fi
        qemu-img convert -c -f ${SOURCE_FILE_TYPE} -O ${TARGET_FILE_TYPE} ${FILE_NAME}.${SOURCE_FILE_EXT} ${FILE_NAME}.${TARGET_FILE_EXT}
        mv ${FILE_NAME}.${SOURCE_FILE_EXT} ${FILE_NAME}.${SOURCE_FILE_EXT}_${TIMESTAMP}
    done
    return 0
}

### ------------------------------------------------------------------------------------------------
###     Main process
###         https://en.wikibooks.org/wiki/QEMU/Images
###         Convert-VHD -Path CentOS_7_64.vhdx -DestinationPath CentOS_7_64.vhd
### ------------------------------------------------------------------------------------------------
convert_image vdi  vdi   ${TYPE} ${TYPE}
convert_image vhd  vpc   ${TYPE} ${TYPE}
convert_image vhdx vhdx  ${TYPE} ${TYPE}

# qemu-img convert -f qcow2 -O raw AIWAF_VE_v4.0.2.qcow2 AIWAF_VE_v4.0.2.raw

exit 0
### ================================================================================================

