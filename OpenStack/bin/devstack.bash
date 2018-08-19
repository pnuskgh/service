#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : devstack.bash, Version 0.00.001
###     프로그램 설명   : DevStack을 사용하여 OpenStack을 설치 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2018.08.19 ~ 2018.08.19
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     stack 사용자를 추가 한다.
### ------------------------------------------------------------------------------------------------
useradd -d /home/stack -s /usr/bin/bash -m -g centos stack
echo "stack        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

passwd stack

### ------------------------------------------------------------------------------------------------
###     DevStack을 다운로드 한다.
### ------------------------------------------------------------------------------------------------
su - stack
# git clone https://git.openstack.org/cgit/openstack-dev/devstack
git clone https://git.openstack.org/cgit/openstack-dev/sandbox
# git clone https://git.openstack.org/openstack-dev/devstack
cd devstack
git checkout stable/queens
# git checkout stable/pike
# git checkout stable/ocata
# git checkout stable/newton

### ------------------------------------------------------------------------------------------------
###     OpenStack을 설치하고 확인 한다.
### ------------------------------------------------------------------------------------------------
cp samples/local.conf local.conf
vi local.conf
    HOST_IP=192.168.56.151

http://192.168.56.151/horizon
# This is your host IP address: 192.168.56.151
# This is your host IPv6 address: ::1
# Horizon is now available at http://192.168.56.151/dashboard
# Keystone is serving at http://192.168.56.151/identity/
# The default users are: admin and demo
# The password: nomoresecret

### ================================================================================================

