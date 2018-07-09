#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : init_before.bash, Version 0.00.008
###     프로그램 설명   : CentOS에서 사용할 /service를 생성 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.04 ~ 2018.07.09
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2018 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     /service 폴더를 생성 한다.
### ------------------------------------------------------------------------------------------------
yum -y install epel-release
yum -y install git

git config --global user.name "Mountain Lover"
git config --global user.email consult@jopenbusiness.com
git config --global push.default simple

git config --global --list
git config --list

cd /
git clone https://github.com/pnuskgh/service.git
cd /service
git checkout develop

source /service/bin/bash_profile.bash

echo 'source /service/bin/bash_profile.bash' >> /root/.bash_profile

### ------------------------------------------------------------------------------------------------
###     /work 폴더를 생성 한다.
### ------------------------------------------------------------------------------------------------
mkdir /work                             > /dev/null 2>&1
mkdir -p /work/backup                   > /dev/null 2>&1
mkdir -p /work/bin                      > /dev/null 2>&1
mkdir -p /work/conf                     > /dev/null 2>&1
mkdir -p /work/custom                   > /dev/null 2>&1
mkdir -p /work/install                  > /dev/null 2>&1
mkdir -p /work/template                 > /dev/null 2>&1
mkdir -p /work/upload                   > /dev/null 2>&1
mkdir -p /work/zztemp                   > /dev/null 2>&1

### ================================================================================================

