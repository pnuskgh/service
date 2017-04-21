#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : register_image.bash, Version 0.00.007
###     프로그램 설명   : Controller 장비에서 이미지를 등록 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.04 ~ 2017.04.21
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
###     funcStartWith, 2016.1.9 ~ 2016.2.3, Version 0.00.003
###     Using
###         funcStartWith 문자열 비교할_문자열_목록
###         funcStartWith ${NODE} controller
### ------------------------------------------------------------------------------------------------
funcStartWith() {
    local source=$1
    local match=$2
    local tmpstr

    tmpstr=`expr match ${source} "\(^${match}\).*"`
    if [[ "${match}" == "${tmpstr}" ]]; then
        return 1
    else
        return 0
    fi
}

### ------------------------------------------------------------------------------------------------
###     register_image : Image를 OpenStack에 등록 한다.
### ------------------------------------------------------------------------------------------------
register_image() {
    local FILE_EXT=$1
    local FILE_TYPE=$2

    for IMAGE_FILE in `ls *.${FILE_EXT}`; do
        IMAGE_NAME=`basename -s .${FILE_EXT} ${IMAGE_FILE}`

        OPTIONS="--container-format bare --disk-format ${FILE_TYPE} --file ${IMAGE_FILE}"

        funcStartWith ${IMAGE_NAME} Windows_Server_
        if [[ "$?" == "1" ]]; then
            OPTIONS="--min-disk 32 --min-ram 1024"
        fi

        funcStartWith ${IMAGE_NAME} MSSQL_Server_
        if [[ "$?" == "1" ]]; then
            OPTIONS="--min-disk 64 --min-ram 1024"
        fi

        funcStartWith ${IMAGE_NAME} CentOS_
        if [[ "$?" == "1" ]]; then
            OPTIONS="--min-disk 8 --min-ram 512"
        fi

        if [[ "zz${OPTIONS}zz" = "zzzz" ]]; then
            OPTIONS="--min-disk 8 --min-ram 512"
        fi
        OPTIONS="--container-format bare --disk-format ${FILE_TYPE} ${OPTIONS} --file ${IMAGE_FILE}"

        openstack image delete ${IMAGE_NAME}_${YEAR_MONTH} > /dev/null 2>&1
        if [[ "z${FLAG_PUBLIC}z" = "zz" ]]; then
            openstack image create ${OPTIONS} --private --project ${PROJECT_ID} ${IMAGE_NAME}_${YEAR_MONTH}
        else
            openstack image create ${OPTIONS} --public ${IMAGE_NAME}_${YEAR_MONTH}
        fi
        rm  ${IMAGE_FILE}

        # openstack image set --property product_os='{ "code": "WIN_SVR_STD_2012_R2", "name": "Windows Server Standard 2012 R2", "charge_type": "month" }'
        # openstack image set --property product_os='{ "code": "WIN_SVR_STD_2008_R2", 'name": "Windows Server Standard 2008 R2", "charge_type": "month" }'
        # openstack image set --property product_dbms='{ "code": "MSSQL_SVR_2012", "name": "Microsoft SQL Server 2012 R2", "charge_type": "month" }'
        # openstack image set --property product_dbms='{ "code": "MSSQL_SVR_2008", "name": "Microsoft SQL Server 2008 R2", "charge_type": "month" }'
    done
}

### ------------------------------------------------------------------------------------------------
###     Main process
### ------------------------------------------------------------------------------------------------
source ~/openrc

register_image raw   raw
register_image qcow2 qcow2

exit 0
### ================================================================================================

