#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : openstackctl.bash, Version 0.00.003
###     프로그램 설명   : OpenStack 관리
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2016.2.12 ~ 2016.5.4
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2016 산사랑, All rights reserved.
### ================================================================================================

if [[ "${SERVER_FOLDER}" == "" ]]; then
    echo "SERVER_FOLDER 환경 변수를 설정 하세요."
    echo " "
    exit 1
fi

. ${SERVER_FOLDER}/bin/config.bash > /dev/null 2>&1
. ${SERVER_FOLDER}/bin/utilCommon.bash > /dev/null 2>&1

### ------------------------------------------------------------------------------------------------
###     funcUsing, 2016.2.12 ~ 2016.5.4, Version 0.00.002
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    info "Using : openstackctl.bash NODES COMMAND OPTIONS"
    info "        COMMAND              : 실행할 명령"
    info "        OPTIONS              : 명령 옵션"

    info "    COMMAND"
    info "        flavor               : Flavor 생성"
    info "        image                : Image 생성"
    info "        volumeType           : Volume Type 생성"

    info "        resource [project_id]: Resource 사용"
    info "        billing [project_id] : Billing용 Resource 사용"

    info " "
    exit 1
}

### ------------------------------------------------------------------------------------------------
###     funcFlavor, 2016.2.12 ~ 2016.2.25, Version 0.00.002
### ------------------------------------------------------------------------------------------------
funcFlavor() {
    local FLAVOR

    FLAVOR=`openstack flavor list | egrep -v '(---)|Ephemeral' | awk '{ print $4 }'`
    for flavor in ${FLAVOR}; do
        openstack flavor delete ${flavor}
    done

    openstack flavor create --vcpus 1 --ram 512    --disk 10 --public m1.micro
    openstack flavor create --vcpus 1 --ram 1024   --disk 10 --public m1.tiny

    openstack flavor create --vcpus 1 --ram 2048   --disk 20 --public c1.small
    openstack flavor create --vcpus 2 --ram 4096   --disk 20 --public c1.medium
    openstack flavor create --vcpus 4 --ram 8192   --disk 20 --public c1.large
    openstack flavor create --vcpus 8 --ram 16384  --disk 20 --public c1.xlarge
    openstack flavor create --vcpus 16 --ram 32768 --disk 20 --public c1.2xlarge
    openstack flavor create --vcpus 32 --ram 65536 --disk 20 --public c1.4xlarge

    openstack flavor list
}

### ------------------------------------------------------------------------------------------------
###     funcImage, 2016.2.25 ~ 2016.2.25, Version 0.00.001
###     ssh -i ~.pem centos@~
###     ssh -i ~.pem ubuntu@~
###     https://cloudbase.it/windows-cloud-images/#download
###     Administrator / 첫 로그인시 비밀번호 설정
### ------------------------------------------------------------------------------------------------
funcImage() {
    cd install

#   rm -f CentOS-7-x86_64-GenericCloud.qcow2
#   rm -f CentOS-6-x86_64-GenericCloud.qcow2
#   rm -f ubuntu-14.04-server-cloudimg-amd64-disk1.img
#   rm -f ubuntu-15.04-server-cloudimg-amd64-disk1.img

#   wget http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2
#   wget http://cloud.centos.org/centos/6/images/CentOS-6-x86_64-GenericCloud.qcow2
#   wget http://cloud-images.ubuntu.com/releases/14.04/release/ubuntu-14.04-server-cloudimg-amd64-disk1.img
#   wget http://cloud-images.ubuntu.com/releases/15.04/release/ubuntu-15.04-server-cloudimg-amd64-disk1.img
#   # gzip -d windows_server_2012_r2_standard_eval_kvm_20151021.qcow2.gz

    openstack image delete "CentOS 7, x86_64"
    openstack image create --container-format bare --disk-format qcow2 --min-disk 8 --min-ram 512 --file CentOS-7-x86_64-GenericCloud.qcow2 --public "CentOS 7, x86_64"

    openstack image delete "CentOS 6, x86_64"
    openstack image create --container-format bare --disk-format qcow2 --min-disk 8 --min-ram 512 --file CentOS-6-x86_64-GenericCloud.qcow2 --public "CentOS 6, x86_64"

    openstack image delete "Ubuntu 14.04.3 LTS"
    openstack image create --container-format bare --disk-format qcow2 --min-disk 8 --min-ram 512 --file ubuntu-14.04-server-cloudimg-amd64-disk1.img --public "Ubuntu 14.04.3 LTS"

    openstack image delete "Ubuntu 15.04"
    openstack image create --container-format bare --disk-format qcow2 --min-disk 8 --min-ram 512 --file ubuntu-15.04-server-cloudimg-amd64-disk1.img --public "Ubuntu 15.04"

    openstack image delete "Windows Server 2012 R2 Std Eval"
    openstack image create --container-format bare --disk-format qcow2 --min-disk 20 --min-ram 1024 --file windows_server_2012_r2_standard_eval_kvm_20151021.qcow2 --public "Windows Server 2012 R2 Std Eval"

    openstack image list
}

### ------------------------------------------------------------------------------------------------
###     funcVolumeType, 2016.2.25 ~ 2016.2.25, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcVolumeType() {
    openstack volume type delete normal
    openstack volume type create --public --description Normal normal

    cinder encryption-type-delete encrypt
    openstack volume type delete encrypt

    openstack volume type create --public --description Encrypt encrypt
    cinder encryption-type-create --cipher aes-xts-plain64 --key_size 512 --control_location front-end encrypt nova.volume.encryptors.luks.LuksEncryptor

    openstack volume type list
    cinder encryption-type-list
}

### ------------------------------------------------------------------------------------------------
###     funcResource, 2016.5.4 ~ 2016.5.4, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcResource() {
    if [[ 0 < $# ]]; then
        funcResourceProject $*
    else
       funcResourceAll
    fi

}

funcResourceAll() {
    openstack project list --long
    openstack user list --long
}


funcResourceProject() {
    local PROJECT_ID=$1

    openstack user list --project ${PROJECT_ID} --long

    openstack server list --project ${PROJECT_ID} --long

}

### ------------------------------------------------------------------------------------------------
###     funcBilling, 2016.5.4 ~ 2016.5.4, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcBilling() {
    local PROJECT_ID="all"

    if [[ 0 < $# ]]; then
        TARGET_NODE=$1
    fi

}

### ------------------------------------------------------------------------------------------------
###     Main
### ------------------------------------------------------------------------------------------------
###---  Command Line에서 입력된 인수를 검사한다.
if [[ 0 < $# ]]; then
    COMMAND=$1
    shift
    OPTIONS=$*
else
    funcUsing
fi

case ${COMMAND} in
    flavor)
        funcFlavor ${OPTIONS}
        ;;
    image)
        funcImage ${OPTIONS}
        ;;
    volumeType)
        funcVolumeType ${OPTIONS}
        ;;
    resource)
        funcResource ${OPTIONS}
        ;;
    billing)
        funcBilling ${OPTIONS}
        ;;
    *)
        funcUsing
        ;;
esac
exit 0

### ================================================================================================

