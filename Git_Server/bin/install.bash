#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : install.bash, Version 0.00.002
###     프로그램 설명   : Git을 설치하고 구성 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.19 ~ 2017.06.16
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
###     root 사용자로 작업을 하고 있는지 확인 합니다.
### ------------------------------------------------------------------------------------------------
TMPSTR=`env | grep USER`
if [ "${TMPSTR}" = "USER=root" ]; then
    echo ""
else
    echo "root 사용자로 작업 하세요."
    exit 1
fi

### ------------------------------------------------------------------------------------------------
###     Git 설치
###         git version 1.8.3.1
### ------------------------------------------------------------------------------------------------
TMPSTR=`git --version | grep "git version" | wc -l`
if [ "${TMPSTR}" = "0" ]; then
    yum -y install git
fi

git --version

### ------------------------------------------------------------------------------------------------
###     Git 환경 설정 (원격 저장소 생성)
###         git:git 사용자 생성
###         git protocol은 4418 port 사용
### ------------------------------------------------------------------------------------------------
#--- git 사용자 생성
groupadd git >& /etc/null
useradd  -d /home/git -m -g git git >& /etc/null

# /bin/echo -n "git 사용자의 암호를 입력 하세요 : "
passwd git

#--- git 사용자로 로그인하지 못하도록 설정
TMPSTR=`grep git-shell /etc/shells | wc -l`
if [ "${TMPSTR}" = "0" ]; then
    cat >> /etc/shells <<+
/usr/bin/git-shell
+
fi
chsh -s /usr/bin/git-shell git
# chsh -s /bin/bash git

#--- git 원격 접속 오류 방지
TMPSTR=`grep "PasswordAuthentication no" /etc/ssh/sshd_config | wc -l`
if [ "${TMPSTR}" = "1" ]; then
    sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    service sshd restart
fi

#--- git repository 생성
mkdir -p /work/repository/git > /dev/null 2>&1
chown git:git /work/repository/git

exit 0
### ================================================================================================

