#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : init.bash, Version 0.00.010
###     프로그램 설명   : CentOS를 초기화 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.04 ~ 2019.01.07
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2018 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     실행 환경을 설정 한다.
### ------------------------------------------------------------------------------------------------
SOFTWARE="CentOS7"

if [[ "z${HOME_SERVICE}z" == "zz" ]]; then
    export HOME_SERVICE="/service"
fi
WORKING_DIR="${HOME_SERVICE}/${SOFTWARE}"
source ${HOME_SERVICE}/bin/config.bash > /dev/null 2>&1

if [[ -f ${WORKING_DIR}/bin/config.php ]]; then
    source ${WORKING_DIR}/bin/config.php
else
    TIMESTAMP=`date +%Y%m%d_%H%M%S`
    BACKUP_DIR=${WORKING_DIR}/backup
    TEMPLATE_DIR=${WORKING_DIR}/template
fi

### ------------------------------------------------------------------------------------------------
###     centos, root 사용자 설정
### ------------------------------------------------------------------------------------------------
#--- centos 사용자 생성
# groupadd centos
# useradd -d /home/centos -s /usr/bin/bash -m -g centos centos
# echo "centos        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

#--- 비밀번호 변경
passwd
passwd centos

#--- Putty로 접속할 수 있는 준비를 한다.
cd ~centos
mkdir -p .ssh
chown centos:centos .ssh

cd .ssh
vi authorized_keys                                          #--- 로그인을 위한 public key를 등록한다.
chown centos:centos authorized_keys
chmod 600 authorized_keys

### ------------------------------------------------------------------------------------------------
###     EPEL 레파지토리를 추가 한다.
### ------------------------------------------------------------------------------------------------
#--- KT UCloud Biz에서 epel-release 설치
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

#--- VirtualBox에서 epel-release 설치
yum -y install epel-release

yum repolist  

### ------------------------------------------------------------------------------------------------
###     CentOS 7을 업데이트 한다.
### ------------------------------------------------------------------------------------------------
cat /etc/*-release | grep release | uniq
cat /proc/cpuinfo | grep processor

yum -y update

### ------------------------------------------------------------------------------------------------
###     불필요한 패키지와 서비스를 제거 한다.
### ------------------------------------------------------------------------------------------------
yum -y remove NetworkManager

### ------------------------------------------------------------------------------------------------
###     Hostname을 설정 합니다.
### ------------------------------------------------------------------------------------------------
hostnamectl status
# hostnamectl set-hostname www.obcon.biz

### ------------------------------------------------------------------------------------------------
###     기본 package를 설치 한다.
### ------------------------------------------------------------------------------------------------
yum -y install wget unzip zip
# yum -y install net-tools

### ------------------------------------------------------------------------------------------------
###     기본 환경을 설정 한다.
### ------------------------------------------------------------------------------------------------
# localectl list-locales | grep -i ko_KR
localectl set-locale LANG=ko_KR.UTF-8

TZ=Asia/Seoul; export TZ

# vi  ~/.vimrc
#     set encoding=utf-8
#     set fileencodings=utf-8,euc-kr

### ------------------------------------------------------------------------------------------------
###     SELinux를 설정 한다.
### ------------------------------------------------------------------------------------------------
#--- SELinux 설정 : Enforcing, Permissive, Disable
getenforce
sestatus

setenforce 0
vi  /etc/sysconfig/selinux
    SELINUX=disabled

### ================================================================================================

