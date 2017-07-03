#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : initialize.bash, Version 0.00.006
###     프로그램 설명   : Linux Namespace, Linux Bridge, Open vSwitch 초기화 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.07.03 ~ 2017.07.03
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     CentOS 7을 업데이트 한다.
### ------------------------------------------------------------------------------------------------
yum -y update

### ------------------------------------------------------------------------------------------------
###     Linux Bridge 설치
###         bridge-utils, 1.5
### ------------------------------------------------------------------------------------------------
yum -y install bridge-utils
brctl --version

### ------------------------------------------------------------------------------------------------
###     RPM 생성 환경 구성
### ------------------------------------------------------------------------------------------------
yum install -y rpm-build
yum groupinstall -y "Development Tools"
 
yum -y install openssl-devel
yum -y install kernel-devel
yum -y install python-devel kernel-debug-devel
 
mkdir -p ~/rpmbuild/SOURCES
 
### ------------------------------------------------------------------------------------------------
###     Linux Bridge와 Open vSwitch 설치
###         http://openvswitch.org/releases/
###         ovs-vsctl (Open vSwitch) 2.4.1
### ------------------------------------------------------------------------------------------------
OVS_VERSION="2.4.1"
 
yum -y install wget
cd ~/rpmbuild/SOURCES
wget http://openvswitch.org/releases/openvswitch-${OVS_VERSION}.tar.gz
tar xfz openvswitch-${OVS_VERSION}.tar.gz
rpmbuild -bb -D `uname -r` openvswitch-${OVS_VERSION}/rhel/openvswitch.spec
 
yum -y localinstall ~/rpmbuild/RPMS/x86_64/openvswitch-${OVS_VERSION}-1.x86_64.rpm
systemctl start openvswitch.service
systemctl enable openvswitch.service

ovs-vsctl --version

### ================================================================================================

