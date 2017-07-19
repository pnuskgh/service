#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : 101_init_OSA.bash, Version 0.00.001
###     프로그램 설명   : OSA (OpenStack Ansible) CentOS 7 초기 환경 설정
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.07.19 ~ 2017.07.19
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

source ${HOME_SERVICE}/bin/config.bash > /dev/null 2>&1

### ------------------------------------------------------------------------------------------------
###    Main process
### ------------------------------------------------------------------------------------------------
yum -y upgrade
shutdown -r now


yum -y install https://rdoproject.org/repos/openstack-ocata/rdo-release-ocata.rpm
yum -y install git ntp ntpdate openssh-server python-devel sudo '@Development Tools'

#--- Chrony를 설치 한다.
#---     /service/service_sw/Chrony/bin/install.bash

#--- OpenStack git repository browser
#---     https://git.openstack.org/cgit
#---     https://git.openstack.org/cgit/openstack/openstack-ansible
cd /work
git clone -b 15.1.6 https://git.openstack.org/openstack/openstack-ansible /opt/openstack-ansible

cd /opt/openstack-ansible
scripts/bootstrap-ansible.sh

exit 0
### ================================================================================================

