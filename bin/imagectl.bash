#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : imagectl.bash, Version 0.00.001
###     프로그램 설명   : Image 생성 관리
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2016.3.31 ~ 2016.3.31
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2016 산사랑, All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     funcUsing, 2016.3.31 ~ 2016.3.31, Version 0.00.001
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    echo "Using : imagectl.bash COMMAND OPTIONS"
    echo "        COMMAND              : 실행할 명령"
    echo "        OPTIONS              : 명령 옵션"

    echo "    COMMAND"
    echo "        centos7              : CentOS 7, 64 bits 설정"
    echo "        centos6              : CentOS 6, 64 bits 설정"
    echo "        upload file name     : 이미지 upload"

    echo " "
    exit 1
}

### ------------------------------------------------------------------------------------------------
###     funcUpload, 2016.3.31 ~ 2016.3.31, Version 0.00.001
###     To-Do : 향후 정보만 보여주는 것이 아니라 실제 처리하는 형태로 수정 필요
### ------------------------------------------------------------------------------------------------
funcUpload() {
    # yum -y install libguestfs-tools

    cat <<EOF
qemu-img convert -c -f vdi -O qcow2 CentOS_7_64.vdi CentOS_7_64.qcow2

source ~/openrc
openstack image list
openstack image delete "CentOS 7 (daou)"
openstack image create --container-format bare --disk-format qcow2 --min-disk 8 --min-ram 512 --file CentOS_7_64.qcow2 --public "CentOS 7 (daou)"
 
EOF

    echo "Reserved"
}

### ------------------------------------------------------------------------------------------------
###     funcCentos7, 2016.3.31 ~ 2016.3.31, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcCentos7() {
    #--- Package 관리
    yum -y remove NetworkManager
    yum -y update
    yum -y install epel-release

    yum -y install acpid cloud-init cloud-utils cloud-utils-growpart dracut-kernel dracut dracut-modules-growroot

    #--- 사용자 관리
    groupadd centos
    useradd -m -g centos -s /bin/bash centos
    # passwd centos

    #--- Storage 설정
    sed -i '/sda1/d' /etc/fstab         #--- OS 설치시 수정한 것 때문에 산사랑만 사용 합니다.
    sed -i '/UUID/d' /etc/fstab
    echo "/dev/vda1               /boot                   xfs     defaults        0 0" >> /etc/fstab

    #--- Network 설정
    rm -f /etc/sysconfig/network-scripts/ifcfg-enp0s*
    cat <<EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE="eth0"
BOOTPROTO="dhcp"
ONBOOT="yes"
TYPE="Ethernet"
USERCTL="yes"
PEERDNS="yes"
IPV6INIT="no"
PERSISTENT_DHCLIENT="1"
EOF

    sed -i '/NOZEROCONF/d' /etc/sysconfig/network
    echo "NOZEROCONF=yes" >> /etc/sysconfig/network

    #--- Grub2 설정
    cat <<EOF > /etc/default/grub
GRUB_TIMEOUT=1
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL="serial console"
GRUB_SERIAL_COMMAND="serial --speed=115200"
GRUB_CMDLINE_LINUX="console=tty0 crashkernel=auto console=ttyS0,115200"
GRUB_DISABLE_RECOVERY="true"    
EOF
    grub2-mkconfig -o /boot/grub2/grub.cfg

    #--- 보안 설정을 한다.
    sed -i '/PasswordAuthentication/d' /etc/ssh/sshd_config
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

    sed -i 's/PermitRootLogin/# PermitRootLogin/g' /etc/ssh/sshd_config
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config

    #--- visudo
    #---     %centos   ALL=(ALL:ALL) NOPASSWD: ALL
    passwd -d root

    #--- 취향에 맞도록 VM을 설정 한다.
    #---     불필요한 서비스 제거
    # systemctl disable {SERVICE_NAME} 
   
    yum -y install net-tools vim tcpdump mtr traceroute tcptraceroute telnet ping
    
    #--- VM을 종료 한다.
    rm -f /var/cache/yum/*

    /usr/bin/cp -f /dev/null /root/.bash_history
    history -c
    
    rm -f ~root/.bash_history
    rm -f ~root/.ssh/authorized_keys
    rm -f ~centos/.bash_history
    rm -f ~centos/.ssh/authorized_keys
    
    rm -fr /var/lib/cloud/*
    # shutdown -h now
}

### ------------------------------------------------------------------------------------------------
###     funcCentos6, 2016.3.31 ~ 2016.3.31, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcCentos6() {
    echo "Reserved"
}

### ------------------------------------------------------------------------------------------------
###     Main, 2016.3.31 ~ 2016.3.31, Version 0.00.001
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
    upload)
        funcUpload ${OPTIONS}
        ;;
    centos7)
        funcCentos7 ${OPTIONS}
        ;;
    centos6)
        funcCentos6 ${OPTIONS}
        ;;
    *)
        funcUsing
        ;;
esac
exit 0

### ================================================================================================
