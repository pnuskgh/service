#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : init_centos.bash, Version 0.00.009
###     프로그램 설명   : CentOS 7을 초기화 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.04 ~ 2017.10.07
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
# WORKING_DIR="/service/service_os/CentOS7"
source ${WORKING_DIR}/bin/config.bash

### ------------------------------------------------------------------------------------------------
###     EPEL 레파지토리를 추가 한다.
### ------------------------------------------------------------------------------------------------
yum -y install epel-release

### ------------------------------------------------------------------------------------------------
###     CentOS 7을 업데이트 한다.
### ------------------------------------------------------------------------------------------------
yum -y update

### ------------------------------------------------------------------------------------------------
###     불필요한 패키지와 서비스를 제거 한다.
### ------------------------------------------------------------------------------------------------
yum -y remove NetworkManager

### ------------------------------------------------------------------------------------------------
###     centos 사용자가 없을 경우 사용자를 추가 한다.
### ------------------------------------------------------------------------------------------------
# groupadd centos
# useradd -d /home/centos -s /usr/bin/bash -m -g centos centos

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
###     필요한 서비스를 활성화 한다.
### ------------------------------------------------------------------------------------------------
#--- firewall daemon 제거
systemctl start firewalld.service
systemctl enable firewalld.service

#--- Postfix Mail Transport Agent 제거
systemctl start postfix.service
systemctl enable postfix.service

### ------------------------------------------------------------------------------------------------
###     불필요한 서비스를 제거 한다.
### ------------------------------------------------------------------------------------------------

### ------------------------------------------------------------------------------------------------
###     Java를 설치 한다.
### ------------------------------------------------------------------------------------------------
# yum -y install java-1.6.0-openjdk java-1.6.0-openjdk-*
# yum -y install java-1.7.0-openjdk java-1.7.0-openjdk-*
# yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-*

yum -y install java-1.7.0-openjdk

### ------------------------------------------------------------------------------------------------
###     Python을 설치 한다.
###         https://hostpresto.com/community/tutorials/how-to-serve-python-apps-using-uwsgi-and-nginx-on-centos-7/
### ------------------------------------------------------------------------------------------------
# yum -y install python python-*
# yum -y install python2 python2-*
# yum -y install python3 python3-*
# yum -y install python34 python34-*

yum -y install python python-IPy python-backports python-backports-ssl_match_hostname python-chardet python-cheetah python-configobj python-decorator python-firewall python-iniparse python-javapackages python-jsonpatch python-jsonpointer python-libs python-lxml python-markdown python-perf python-pillow python-prettytable python-progressbar python-pycurl python-pygments python-pyudev python-requestbuilder python-requests python-setuptools python-six python-slip python-slip-dbus python-urlgrabber python-urllib3

yum -y install python-pip python-devel gcc
# pip install virtualenv 
# virtualenv myprojectenv
# myprojectenv/bin/activate
# myprojectenv/bin/deactivate
# pip install uwsgi
# uwsgi --version
# vi myproject/wsgi.py
#     def application(environ, start_response):
#         start_response('200 OK', [('Content-Type', 'text/html')])
#         return ["<h1 style='color:blue'>Testing Success!</h1>"]
# uwsgi --socket 0.0.0.0:8080 --protocol=http -w wsgi
# http://공인IP:8080/

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
${WORKING_DIR}/bin/install_php.bash

### ================================================================================================

