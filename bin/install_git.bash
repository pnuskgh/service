#!/bin/bash
### ================================================================================================
###     프로그램 명              : install_git.bash, Version 0.00.007
###     프로그램 설명         	: Git 설치 Script
###     작성자                     : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일                     : 2015.7.21 ~ 2015.8.3
### --- [History 관리] -------------------------------------------------------------------------------
###     2015.07.21, 산사랑 : 초안 작성
###     2015.07.30, 산사랑 : install_git.bash로 파일 분리
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2015 산사랑, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###             Main process
### ------------------------------------------------------------------------------------------------

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
### ------------------------------------------------------------------------------------------------
TMPSTR=`git --version | grep "git version" | wc -l`
if [ "${TMPSTR}" = "0" ]; then 
    yum -y install git
    git --version
fi

### ------------------------------------------------------------------------------------------------
###     Git 설치 및 환경 설정 (원격 저장소 생성)
###         git:git 사용자 생성
###         git protocol은 4418 port 사용
### ------------------------------------------------------------------------------------------------
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

