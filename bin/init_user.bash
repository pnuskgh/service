#!/bin/bash
### ================================================================================================
###     프로그램 명              : init_user.bash, Version 0.00.001
###     프로그램 설명         	: 사용자별 환경 설정
###     작성자                     : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일                     : 2015.8.3 ~ 2015.8.3
### --- [History 관리] -------------------------------------------------------------------------------
###     2015.08.03, 산사랑 : 초안 작성
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2015 산사랑, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================
### To-Do : 사용자 id를 받아 init_user.bash를 처리하는 로직 추가

### ------------------------------------------------------------------------------------------------
###     funcInitFolder()
###         Folder 설정을 합니다.
### ------------------------------------------------------------------------------------------------
funcInitFolder() {
    cd ~
    mkdir install >& /dev/null
    mkdir repo_git >& /dev/null
    mkdir zztemp >& /dev/null
}


### ------------------------------------------------------------------------------------------------
###     funcInitRoot()
###         root 사용자의 환경을 설정 합니다.
### ------------------------------------------------------------------------------------------------
funcInitRoot() {
    funcInitFolder

    ### 필수 Utility 설치
    yum -y install wget
}

### ------------------------------------------------------------------------------------------------
###     funcInitUser()
###         일반 사용자의 환경을 설정 합니다.
### ------------------------------------------------------------------------------------------------
funcInitUser() {
    funcInitFolder

    git config --global user.name "consult"
    git config --global user.email "consult@jopenbusiness.com"
    git config --global color.ui auto
    git config --global alias.st status
    git config --global core.editor vim
    git config --global merge.tool vimdiff
    git config --global push.default simple
    git config --list

    echo " "
    echo "수작업으로 아래 작업을 진행 합니다"
    echo " "
    echo "vi ~/.ssh/id_rsa"
    echo "   사용자의 private key를 등록 합니다."
    echo "chmod 0600 ~/.ssh/id_rsa"
}


### ------------------------------------------------------------------------------------------------
###		Main process
### ------------------------------------------------------------------------------------------------

### ------------------------------------------------------------------------------------------------
###     사용자의 환경을 설정 합니다
### ------------------------------------------------------------------------------------------------
TMPSTR=`grep bash_env.bash ~/.bash_profile | wc -l`
if [ "${TMPSTR}" = "0" ]; then
    echo " " >> ~/.bash_profile
    echo "source /cloudnas/conf/bash_env.bash" >> ~/.bash_profile
    echo " " >> ~/.bash_profile
fi
source ~/.bash_profile

TMPSTR=`env | grep USER`
if [ "${TMPSTR}" = "USER=root" ]; then
    funcInitRoot
elif [ "${TMPSTR}" = "USER=root" ]; then
    funcInitFolder
else
    funcInitUser
fi

### ================================================================================================

