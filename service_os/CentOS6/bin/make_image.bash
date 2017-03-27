#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : 101_make_image.bash, Version 0.00.002
###     프로그램 설명   : CentOS 이미지를 작성 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.06 ~ 2017.01.10
### ----[History 관리]------------------------------------------------------------------------------
###     수정자         	:
###     수정일         	:
###     수정 내용      	:
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     실행 환경을 설정 한다.
### ------------------------------------------------------------------------------------------------
. config.bash > /dev/null 2>&1

# BASE_DIR=/data/images/CentOS6
# TIMESTAMP=`date +%Y%m%d_%H%M%S`

### ------------------------------------------------------------------------------------------------
###     centos 사용자를 생성 한다.
### ------------------------------------------------------------------------------------------------
groupadd centos
useradd -m -g centos -s /bin/bash centos
# passwd centos

### ------------------------------------------------------------------------------------------------
###     cloudinit를 설치하고 환경을 구성 한다.
###         /etc/cloud/ 폴더가 생성 된다.
###         acpid : To enable the hypervisor to reboot or shutdown an instance
###         cloud-utils-growpart : volume 사이즈 자동 조정
### ------------------------------------------------------------------------------------------------
yum -y install acpid cloud-init cloud-utils cloud-utils-growpart dracut-kernel dracut-modules-growroot

#--- Storage 용량을 8GB에서 전체 용량(예, 100GB로 설정되도록 작업 한다.
rpm -qa kernel | sed 's/^kernel-//'  | xargs -I {} dracut -f /boot/initramfs-{}.img {}

cp /etc/cloud/cloud.cfg ${BASE_DIR}/backup/cloud.cfg_${TIMESTAMP}
# /bin/cp -f ${BASE_DIR}/files/cloud.cfg /etc/cloud
# chmod 664 /etc/cloud/cloud.cfg

chkconfig acpid on

### ------------------------------------------------------------------------------------------------
###     Storage를 설정 한다.
###        UUID 대신에 /dev/vda1 (ext4)을 설정 한다.
### ------------------------------------------------------------------------------------------------
cp /etc/fstab ${BASE_DIR}/backup/fstab_${TIMESTAMP}
/bin/cp -f ${BASE_DIR}/files/fstab /etc
chmod 644 /etc/fstab

### ------------------------------------------------------------------------------------------------
###     Network를 설정 한다.
###        OpenStack은 ifcfg-eth0를 사용 한다.
### ------------------------------------------------------------------------------------------------
cp /etc/sysconfig/network-scripts/ifcfg-eth0 ${BASE_DIR}/backup/ifcfg-eth0_${TIMESTAMP}
cp /etc/sysconfig/network-scripts/ifcfg-eth1 ${BASE_DIR}/backup/ifcfg-eth1_${TIMESTAMP}
/bin/cp -f ${BASE_DIR}/files/ifcfg-eth0 /etc/sysconfig/network-scripts
chmod 644 /etc/sysconfig/network-scripts/ifcfg-eth0
rm -f /etc/sysconfig/network-scripts/ifcfg-eth1

#--- NIC 정보를 삭제 한다.
cp /etc/udev/rules.d/70-persistent-net.rules ${BASE_DIR}/backup/70-persistent-net.rules_${TIMESTAMP}
/bin/cp -f /dev/null /lib/udev/rules.d/75-persistent-net-generator.rules
rm -f /etc/udev/rules.d/70-persistent-net.rules

#--- http://169.254.169.254/ 접속 허용
#---     NOZEROCONF=yes 추가
cp /etc/sysconfig/network ${BASE_DIR}/backup/network_${TIMESTAMP}
/bin/cp -f ${BASE_DIR}/files/network /etc/sysconfig/network
chmod 644 /etc/sysconfig/network

### ------------------------------------------------------------------------------------------------
###     Grub 부트 로드를 설정 한다. OpenStack 사용자 콘솔에서 로그를 표시 한다.
###         # crashkernel=auto  KEYBOARDTYPE=pc KEYTABLE=ko rd_NO_LVM rd_NO_DM rhgb quiet
###         console=ttyS0,115200 crashkernel=auto SYSFONT=latarcyrheb-sun16  KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM
###         rhgb quiet 삭제
###         console=ttyS0,115200 추가
### ------------------------------------------------------------------------------------------------
cp /boot/grub/grub.conf ${BASE_DIR}/backup/grub.conf_${TIMESTAMP}
/bin/cp -f ${BASE_DIR}/files/grub.conf /boot/grub/grub.conf
chmod 600 /boot/grub/grub.conf

### ------------------------------------------------------------------------------------------------
###     보안 설정을 한다.
### ------------------------------------------------------------------------------------------------
#--- 비밀번호 로그인과 root 로그인을 차단 한다.
#---     PasswordAuthentication no, PermitRootLogin no
cp /etc/ssh/sshd_config  ${BASE_DIR}/backup/sshd_config_${TIMESTAMP}
/bin/cp -f ${BASE_DIR}/files/sshd_config /etc/ssh/sshd_config
chmod 600 /etc/ssh/sshd_config

#--- centos 사용자에게 sudo 권한을 부여 한다.
#---     %centos   ALL=(ALL:ALL) NOPASSWD: ALL
cp /etc/sudoers ${BASE_DIR}/backup/sudoers_${TIMESTAMP}
/bin/cp -f ${BASE_DIR}/files/sudoers /etc/sudoers
chmod 440 /etc/sudoers

### ------------------------------------------------------------------------------------------------
###     불필요한 서비스를 제거 한다.
### ------------------------------------------------------------------------------------------------
# systemctl disable {SERVICE_NAME}

### ================================================================================================

#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : 102_install_language.bash, Version 0.00.001
###     프로그램 설명   : CentOS 이미지를 작성 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.05 ~ 2017.01.05
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
. config.bash > /dev/null 2>&1

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

yum -y install python python-IPy python-backports python-backports-ssl_match_hostname python-chardet python-cheetah python-configobj python-decorator python-iniparse python-jsonpatch python-jsonpointer python-libs python-lxml python-markdown python-perf python-prettytable python-progressbar python-pycurl python-pygments python-pyudev python-requestbuilder python-requests python-setuptools python-six python-slip python-slip-dbus python-urlgrabber python-urllib3

yum -y install python-pip

### ------------------------------------------------------------------------------------------------
###     Perl을 설치 한다.
### ------------------------------------------------------------------------------------------------
yum -y install perl perl-Digest-HMAC perl-Digest-SHA perl-File-Temp perl-Pod-Escapes perl-Pod-Simple perl-Time-HiRes perl-libs perl-parent

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

### ------------------------------------------------------------------------------------------------
###     설치된 언어의 버전을 표시 한다.
###         CentOS release 6.8
###         Java 1.7.0_121
###         Python 2.6.6, pip 7.1.0
###         Perl 5.10.1
###         Ruby 1.8.7
###         PHP 5.3.3
### ------------------------------------------------------------------------------------------------
cat /etc/*-release | uniq
java -version
python -V
pip -V
perl -v
ruby -v
php -v

### ================================================================================================
