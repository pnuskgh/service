#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : register_image.bash, Version 0.00.006
###     프로그램 설명   : Controller 장비에서 이미지를 등록 한다.
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
###     funcUsing() : 사용법 표시
### ------------------------------------------------------------------------------------------------
funcUsing() {
    /bin/echo "Using : register_image.bash YEAR_MONTH [FLAG_PUBLIC] [PROJECT_ID]"
    /bin/echo "        YEAR_MONTH     : 년월 확장자 설정"
    /bin/echo "        FLAG_PUBLIC    : public, private (Default)"
    /bin/echo "        PROJECT_ID     : private인 경우 Project ID"
    /bin/echo " "
    exit 1
}

### ------------------------------------------------------------------------------------------------
###     Command Line에서 입력된 인수를 검사한다.
### ------------------------------------------------------------------------------------------------
FLAG_PUBLIC=""                                             #--- Default는 private
PROJECT_ID="5c2606329ec9424fbfd426fb8475ed4a"              #--- Default Project ID
if [[ $# = 3 ]]; then
    YEAR_MONTH=$1
    FLAG_PUBLIC=$2
    PROJECT_ID=$3
elif [[ $# = 2 ]]; then
    YEAR_MONTH=$1
    FLAG_PUBLIC=$2
elif [[ $# = 1 ]]; then
    YEAR_MONTH=$1
else
    funcUsing
fi

### ------------------------------------------------------------------------------------------------
###     Image를 OpenStack에 등록 한다.
### ------------------------------------------------------------------------------------------------
cd ~
source ~/openrc

for IMAGE_FILE in `ls *.qcow2`; do
    IMAGE_NAME=`basename -s .qcow2 ${IMAGE_FILE}`

    if [[ "zz${IMAGE_NAME}zz" = "zzCentOS_7_64zz" ]]; then
        OPTIONS="--container-format bare --disk-format qcow2 --min-disk 8 --min-ram 512 --file ${IMAGE_FILE}"
    elif [[ "zz${IMAGE_NAME}zz" = "zzCentOS_6_64zz" ]]; then
        OPTIONS="--container-format bare --disk-format qcow2 --min-disk 8 --min-ram 512 --file ${IMAGE_FILE}"
    elif [[ "zz${IMAGE_NAME}zz" = "zzMSSQL_Server_2012_R2zz" ]]; then
        OPTIONS="--container-format bare --disk-format qcow2 --min-disk 64 --min-ram 1024 --file ${IMAGE_FILE}"
    elif [[ "zz${IMAGE_NAME}zz" = "zzMSSQL_Server_2008_R2zz" ]]; then
        OPTIONS="--container-format bare --disk-format qcow2 --min-disk 64 --min-ram 1024 --file ${IMAGE_FILE}"
    else
        OPTIONS="--container-format bare --disk-format qcow2 --min-disk 32 --min-ram 1024 --file ${IMAGE_FILE}"
    fi

    openstack image delete ${IMAGE_NAME}_${YEAR_MONTH}
    if [[ "z${FLAG_PUBLIC}z" = "zz" ]]; then
        openstack image create ${OPTIONS} --private --project ${PROJECT_ID} ${IMAGE_NAME}_${YEAR_MONTH}
    else
        openstack image create ${OPTIONS} --public ${IMAGE_NAME}_${YEAR_MONTH}
        echo openstack image set --property product_os='{ "code": "WIN_SVR_STD_2012_R2", "name": "Windows Server Standard 2012 R2", "charge_type": "month" }'
        echo openstack image set --property product_os='{ "code": "WIN_SVR_STD_2008_R2", 'name": "Windows Server Standard 2008 R2", "charge_type": "month" }'
        echo openstack image set --property product_dbms='{ "code": "MSSQL_SVR_2012", "name": "Microsoft SQL Server 2012 R2", "charge_type": "month" }'
        echo openstack image set --property product_dbms='{ "code": "MSSQL_SVR_2008", "name": "Microsoft SQL Server 2008 R2", "charge_type": "month" }'
    fi

    rm  ${IMAGE_FILE}
done

for IMAGE_FILE in `ls *.raw`; do
    IMAGE_NAME=`basename -s .raw ${IMAGE_FILE}`

    if [[ "zz${IMAGE_NAME}zz" = "zzCentOS_7_64zz" ]]; then
        OPTIONS="--container-format bare --disk-format raw --min-disk 8 --min-ram 512 --file ${IMAGE_FILE}"
    elif [[ "zz${IMAGE_NAME}zz" = "zzCentOS_6_64zz" ]]; then
        OPTIONS="--container-format bare --disk-format raw --min-disk 8 --min-ram 512 --file ${IMAGE_FILE}"
    elif [[ "zz${IMAGE_NAME}zz" = "zzMSSQL_Server_2012_R2zz" ]]; then
        OPTIONS="--container-format bare --disk-format raw --min-disk 64 --min-ram 1024 --file ${IMAGE_FILE}"
    elif [[ "zz${IMAGE_NAME}zz" = "zzMSSQL_Server_2008_R2zz" ]]; then
        OPTIONS="--container-format bare --disk-format raw --min-disk 64 --min-ram 1024 --file ${IMAGE_FILE}"
    else
        OPTIONS="--container-format bare --disk-format raw --min-disk 32 --min-ram 1024 --file ${IMAGE_FILE}"
    fi

    openstack image delete ${IMAGE_NAME}_${YEAR_MONTH}
    if [[ "z${FLAG_PUBLIC}z" = "zz" ]]; then
        openstack image create ${OPTIONS} --private --project ${PROJECT_ID} ${IMAGE_NAME}_${YEAR_MONTH}
    else
        openstack image create ${OPTIONS} --public ${IMAGE_NAME}_${YEAR_MONTH}
    fi

    rm  ${IMAGE_FILE}
done

exit 0
### ================================================================================================

