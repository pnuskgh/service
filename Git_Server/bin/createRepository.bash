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
    echo "        REPOSITORY     : Git 저장소 이름 (jopenbusiness)"
    echo " "
    exit 1
}

#---  Command Line에서 입력된 인수를 검사한다.
if [[ $# = 1 ]]; then
    REPOSITORY=$1
else
    funcUsing
fi

### ------------------------------------------------------------------------------------------------
###     Main process
### ------------------------------------------------------------------------------------------------
chsh -s /bin/bash git

su - git -c "cd /work/repository/git; git init --bare ${REPOSITORY}.git"
# /work/jopenbusiness/authorized_keys 파일에 public key를 등록해 두면 비밀번호 없이 접속 가능
# git clone ssh://git@192.168.0.160/work/repository/git/${REPOSITORY}.git jopenbusiness

chsh -s /usr/bin/git-shell git

exit 0
### ================================================================================================

