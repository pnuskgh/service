#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : createRepository.bash, Version 0.00.002
###     프로그램 설명   : Git Server용 repository를 생성 한다.
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

### ----------------------------------------------------------------------------
###     funcUsing()
###                     사용법 표시
### ----------------------------------------------------------------------------
funcUsing() {
    echo "Using : createRepository.bash REPOSITORY"
    echo "        REPOSITORY     : Git 저장소 이름 (jopenbusiness.git)"
    echo " "
    exit 1
}

#---  Command Line에서 입력된 인수를 검사한다.
if [[ $# = 1 ]]; then
    REPOSITORY=$1
else
    funcUsing
fi
echo ${REPOSITORY}
exit 0



### ------------------------------------------------------------------------------------------------
###     Nginx를 설치 한다.
### ------------------------------------------------------------------------------------------------

### ------------------------------------------------------------------------------------------------
###     Git 설치 및 환경 설정 (원격 저장소 생성)
###         git:git 사용자 생성
###         git protocol은 4418 port 사용
### ------------------------------------------------------------------------------------------------
mkdir -p /work/repository/git
exit 0


### git 사용자 생성
groupadd git >& /etc/null
useradd  -d /cloudnas/home/git -m -g git git >& /etc/null

### To-Do : 사용자 입력을 받는 것이 아니라 script에서 설정한 값을 사용하도록 수정할 것
# passwd git

su - git -c '/cloudnas/bin/init_user.bash' >& /etc/null

### git 사용자로 로그인하지 못하도록 설정
TMPSTR=`grep git-shell /etc/shells | wc -l`
if [ "${TMPSTR}" = "0" ]; then
    cat >> /etc/shells <<+
/usr/bin/git-shell
+
fi
# chsh -s /usr/bin/git-shell git
# chsh -s /bin/bash git

### git 원격 접속 오류 방지
TMPSTR=`grep "PasswordAuthentication no" /etc/ssh/sshd_config | wc -l`
if [ "${TMPSTR}" = "1" ]; then
    sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    service sshd restart
fi

### remote repository 생성
mkdir /cloudnas/repo_git_master >& /etc/null
chown git:git /cloudnas/repo_git_master

### Tip : Remote Git Repository 생성
###     su - git -c 'cd /cloudnas/repo_git_master; git init --bare jopenbusiness.git'
###     su - git -c 'cd /cloudnas/repo_git_master; git init --bare localization.git'

### Tip : repository 생성
###     git clone ssh://git@osscloud.biz:/cloudnas/repo_git_master/jopenbusiness.git jopenbusiness
###     git clone ssh://git@osscloud.biz:/cloudnas/repo_git_master/localization.git localization

### ================================================================================================

