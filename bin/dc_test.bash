#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : dc_testall.bash, Version 0.00.001
###     프로그램 설명   : 클라우드 홈페이지 단위 테스트
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
###     Main
### ------------------------------------------------------------------------------------------------
cd ${DC_TESTS}
phpunit TestAll

# phpunit SampleTest.php
# phpunit --bootstrap ${THEME}/include/Sample.php ${THEME}/tests/SampleTest.php

exit 0

### ================================================================================================

