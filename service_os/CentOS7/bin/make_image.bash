#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : make_image.bash, Version 0.00.007
###     프로그램 설명   : CentOS 이미지를 작성 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.04 ~ 2017.03.15
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
###     crudini를 설치 한다.
### ------------------------------------------------------------------------------------------------
yum -y install crudini

### ------------------------------------------------------------------------------------------------
###     cloudinit를 설치하고 환경을 구성 한다.
###         /etc/cloud/ 폴더가 생성 된다.
###         acpid : To enable the hypervisor to reboot or shutdown an instance
###         cloud-utils-growpart : volume 사이즈 자동 조정
### ------------------------------------------------------------------------------------------------
yum -y install acpid cloud-init cloud-utils cloud-utils-growpart dracut-kernel
systemctl enable acpid

backup /etc/cloud cloud.cfg
# /usr/bin/cp -f ${TEMPLATE_DIR}/cloud.cfg /etc/cloud
# sed -i 's/disable_root: 0/disable_root: 1/g' /etc/cloud/cloud.cfg
# sed -i 's/ssh_pwauth: 1/ssh_pwauth: 0/g' /etc/cloud/cloud.cfg
chmod 664 /etc/cloud/cloud.cfg

### ------------------------------------------------------------------------------------------------
###     Storage를 설정 한다.
###        UUID 대신에 /dev/vda1을 설정 한다.
### ------------------------------------------------------------------------------------------------
backup /etc fstab
/usr/bin/cp -f ${TEMPLATE_DIR}/fstab /etc
chmod 644 /etc/fstab

### ------------------------------------------------------------------------------------------------
###     Network를 설정 한다.
###         OpenStack은 ifcfg-eth0를 사용 한다.
###         ifcfg-enp* 파일에서 UUID와 HWADDR을 제거 한다.
###         ifcfg-emp* 파일에 NM_CONTROLLED="no" 를 추가 한다.
### ------------------------------------------------------------------------------------------------
if [[ -f /etc/sysconfig/network-scripts/ifcfg-eth0 ]]; then
    backup /etc/sysconfig/network-scripts ifcfg-eth0
fi
if [[ -f /etc/sysconfig/network-scripts/ifcfg-enp0s3 ]]; then
    backup /etc/sysconfig/network-scripts ifcfg-enp0s3
fi
if [[ -f /etc/sysconfig/network-scripts/ifcfg-enp0s8 ]]; then
    backup /etc/sysconfig/network-scripts ifcfg-enp0s8
fi

/usr/bin/cp -f ${TEMPLATE_DIR}/ifcfg-eth0 /etc/sysconfig/network-scripts
chmod 644 /etc/sysconfig/network-scripts/ifcfg-eth0
rm -f /etc/sysconfig/network-scripts/ifcfg-enp0s*

#--- http://169.254.169.254/ 접속 허용
#---     NOZEROCONF=yes 추가
backup /etc/sysconfig network
/usr/bin/cp -f ${TEMPLATE_DIR}/network /etc/sysconfig
chmod 644 /etc/sysconfig/network

### ------------------------------------------------------------------------------------------------
###     Grub2 부트 로드를 설정 한다. OpenStack 사용자 콘솔에서 로그를 표시 한다.
###         rhgb quiet 삭제
###         console=tty0 console=ttyS0,115200n8 추가
### ------------------------------------------------------------------------------------------------
backup /etc/default grub
# /usr/bin/cp -f ${TEMPLATE_DIR}/grub /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX/#GRUB_CMDLINE_LINUX/g' /etc/default/grub
echo 'GRUB_CMDLINE_LINUX="crashkernel=auto console=tty0 console=ttyS0,115200n8"' >> /etc/default/grub
chmod 644 /etc/default/grub

grub2-mkconfig -o /boot/grub2/grub.cfg

### ------------------------------------------------------------------------------------------------
###     보안 설정을 한다.
###
### ------------------------------------------------------------------------------------------------
#--- 비밀번호 로그인과 root 로그인을 차단 한다.
#---     PasswordAuthentication no, PermitRootLogin no
backup /etc/ssh sshd_config
/usr/bin/cp -f ${TEMPLATE_DIR}/sshd_config /etc/ssh
chmod 600 /etc/ssh/sshd_config

#--- centos 사용자에게 sudo 권한을 부여 한다.
#---     %centos   ALL=(ALL:ALL) NOPASSWD: ALL
backup /etc sudoers
/usr/bin/cp -f ${TEMPLATE_DIR}/sudoers /etc
chmod 440 /etc/sudoers

### ------------------------------------------------------------------------------------------------
###     불필요한 서비스를 제거 한다.
### ------------------------------------------------------------------------------------------------
#--- D firewall daemon 제거
systemctl stop firewalld.service
systemctl disable firewalld.service

#--- Postfix Mail Transport Agent 제거
systemctl stop postfix.service
systemctl disable postfix.service

### ------------------------------------------------------------------------------------------------
###     Java를 설치 한다.
### ------------------------------------------------------------------------------------------------
# yum -y install java-1.6.0-openjdk java-1.6.0-openjdk-*
# yum -y install java-1.7.0-openjdk java-1.7.0-openjdk-*
# yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-*

yum -y install java-1.7.0-openjdk

### ------------------------------------------------------------------------------------------------
###     Python을 설치 한다.
### ------------------------------------------------------------------------------------------------
# yum -y install python python-*
# yum -y install python2 python2-*
# yum -y install python3 python3-*
# yum -y install python34 python34-*

yum -y install python python-IPy python-backports python-backports-ssl_match_hostname python-chardet python-cheetah python-configobj python-decorator python-firewall python-iniparse python-javapackages python-jsonpatch python-jsonpointer python-libs python-lxml python-markdown python-perf python-pillow python-prettytable python-progressbar python-pycurl python-pygments python-pyudev python-requestbuilder python-requests python-setuptools python-six python-slip python-slip-dbus python-urlgrabber python-urllib3

yum -y install python-pip

### ------------------------------------------------------------------------------------------------
###     Perl을 설치 한다.
### ------------------------------------------------------------------------------------------------
yum -y install perl perl-Carp perl-Digest perl-Digest-HMAC perl-Digest-MD5 perl-Digest-SHA perl-Encode perl-Exporter perl-File-Path perl-File-Temp perl-Filter perl-Getopt-Long perl-HTTP-Tiny perl-PathTools perl-Pod-Escapes perl-Pod-Perldoc perl-Pod-Simple perl-Pod-Usage perl-Scalar-List-Utils perl-Socket perl-Storable perl-Text-ParseWords perl-Time-HiRes perl-Time-Local perl-constant perl-libs perl-macros perl-parent perl-podlators perl-threads perl-threads-shared

### ------------------------------------------------------------------------------------------------
###     Ruby를 설치 한다.
### ------------------------------------------------------------------------------------------------
# yum -y install ruby ruby-* rubygems rubygem-*

yum -y install ruby ruby-irb ruby-libs rubygems rubygem-json

### ------------------------------------------------------------------------------------------------
###     PHP를 설치 한다.
### ------------------------------------------------------------------------------------------------
# yum -y install php php-*

yum -y install php php-common

# yum -y install php-fpm
# systemctl restart php-fpm
# systemctl enable php-fpm

### ------------------------------------------------------------------------------------------------
###     Image 생성 전 CentOS를 최신 버전으로 update 한다.
### ------------------------------------------------------------------------------------------------
yum -y update

### ================================================================================================

