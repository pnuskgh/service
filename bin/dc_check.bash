#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : dc_check.bash, Version 0.00.001
###     프로그램 설명   : 클라우드 홈페이지에서 사용하는 WordPress 소스 관리
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2016.8.1 ~ 2016.8.1
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2016 산사랑, All rights reserved.
### ================================================================================================

if [[ "${SERVER_FOLDER}" == "" ]]; then
    echo "SERVER_FOLDER 환경 변수를 설정 하세요."
    echo " "
    exit 1
fi

. ${SERVER_FOLDER}/bin/config.bash > /dev/null 2>&1
. ${SERVER_FOLDER}/bin/utilCommon.bash > /dev/null 2>&1

### ------------------------------------------------------------------------------------------------
###     funcUsing, 2016.8.1 ~ 2016.8.1, Version 0.00.001
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    info "Using : dc_check.bash"
    info " "
    exit 2
}

### ------------------------------------------------------------------------------------------------
###     Main
### ------------------------------------------------------------------------------------------------

#--- PHP 파일의 Coding Style Guide 준수 여부 확인
cd ${DC_THEME}
phpcs functions.php page-raw.php include
# phpcbf functions.php page-raw.php include

#--- Unit Test 진행
cd ${DC_TESTS}
phpunit TestAll

#--- PHPDoc 생성
cd ${DC_CUSTOM}
rm -rf docs
mkdir docs
phpdoc run -d src -t docs

echo "http://home.daouidc.com/docs/index.html"

exit 0

### ================================================================================================

