#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : iops_check.bash, Version 0.00.001
###     프로그램 설명   : Storage IOPS 검사
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.06.01 ~ 2017.06.01
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

RELATION_DIR="$(dirname $0)"
WORKING_DIR="$(cd -P ${RELATION_DIR}/.. && pwd)"
source ${WORKING_DIR}/bin/config.bash

DATA_VOLUME="/data"
FIO_OPTIONS="--directory=${DATA_VOLUME} --name fio_test_file --direct=1 --numjobs=16 --time_based --runtime=60 --group_reporting --norandommap"

### ------------------------------------------------------------------------------------------------
###     funcUsing, 2016.6.1 ~ 2016.6.1, Version 0.00.001
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    echo "Using : iops_check.bash COMMAND [OPTIONS]"
    echo "        COMMAND              : 실행할 명령 (create_volume, check_volume)"
    echo "        OPTIONS              : 명령 옵션"
    echo " "
    exit 2
}

### ------------------------------------------------------------------------------------------------
###     create_volume, 2016.6.1 ~ 2016.6.1, Version 0.00.001
###     Volume 생성
### ------------------------------------------------------------------------------------------------
create_volume() {
    local OPTIONS=$*

    lsblk
    df -h
    mkdir -p ${DATA_VOLUME}

    #--- create volume
    # yum -y install xfsprogs             #--- For mkfs.xfs
    mkfs.ext4 /dev/vdd
    mount /dev/vdd ${DATA_VOLUME}


    #--- create LVM : Volume별로 반복한다
    yum -y install lvm2 lvm2-*

    # 반복 : /dev/vdd, /dev/vde, /dev/vdf
    fdisk /dev/vdd
    # n p 1 엔터 엔터
    # t 8e
    # w
    fdisk -l

    # 반복 : /dev/vdd1, /dev/vde1, /dev/vdf1
    DEVICE_DRIVE="/dev/vdd1"
    pvcreate ${DEVICE_DRIVE}

    vgcreate vg_data /dev/vdd1 /dev/vde1 /dev/vdf1
    lvcreate -l 100%FREE -n lv_data vg_data
    # ??scan, ??display

    mkfs.ext4 /dev/vg_data/lv_data
    mount /dev/vg_data/lv_data ${DATA_VOLUME}
}

### ------------------------------------------------------------------------------------------------
###     check_volume, 2016.6.1 ~ 2016.6.1, Version 0.00.001
###     IOPS 측정
### ------------------------------------------------------------------------------------------------
check_volume() {
    local OPTIONS=$*

    dd if=/dev/zero of=/dev/vdd bs=16M
    dd if=/dev/zero of=/dev/vg_data/lv_data bs=16M
    # dd if=/dev/urandom of=/dev/sda bs=16M

    yum -y install fio

    cd /work
    fio --rw=randwrite --bs=4k --size=1G ${FIO_OPTIONS}
    rm -f ${DATA_VOLUME}/fio*

    fio --rw=randread --bs=4k --size=1G ${FIO_OPTIONS}
    rm -f ${DATA_VOLUME}/fio*

    fio --rw=write --bs=4k --size=1G ${FIO_OPTIONS}
    rm -f ${DATA_VOLUME}/fio*

    fio --rw=read --bs=4k --size=1G ${FIO_OPTIONS}
    rm -f ${DATA_VOLUME}/fio*




}

### ------------------------------------------------------------------------------------------------
###     Main Process
### ------------------------------------------------------------------------------------------------
###---  Command Line에서 입력된 인수를 검사한다.
if [[ 0 < $# ]]; then
    COMMAND=$1
    shift
    OPTIONS=$*
else
    funcUsing
fi
exit 0

case ${COMMAND} in
    create_volume)
        create_volume ${OPTIONS}
        ;;
    check_volume)
        check_volume ${OPTIONS}
        ;;
    *)
        funcUsing
        ;;
esac
exit 0

### ================================================================================================

