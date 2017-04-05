#!/bin/bash
### ================================================================================================
###     프로그램 명              : install_maven, Version 0.00.001
###     프로그램 설명         	: Maven 설치 Script
###     작성자                     : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일                     : 2015.8.10 ~ 2015.8.10
### --- [History 관리] -------------------------------------------------------------------------------
###     2015.08.10, 산사랑 : 초안 작성
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2015 산사랑, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     Maven 설치 및 환경 설정
### ------------------------------------------------------------------------------------------------
if [ -e /cloudnas/appl/maven ]; then
    echo " "
else
    ### root 사용자로 작업을 하고 있는지 확인 합니다.
    TMPSTR=`env | grep USER`
    if [ "${TMPSTR}" = "USER=root" ]; then
        echo ""
    else
        echo "root 사용자로 작업 하세요."
        exit 1
    fi

    cd /cloudnas/install
    wget http://mirror.apache-kr.org/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz
    tar -zxvf apache-maven-3.3.3-bin.tar.gz
    mv apache-maven-3.3.3 /cloudnas/appl/maven
fi

TMPSTR=`grep MAVEN_OPTS ~/.bash_profile | wc -l` >& /etc/null
if [ "${TMPSTR}" = "0" ]; then
    TMPSTR=$
    cat >> ~/.bash_profile <<+

export M2_HOME="/cloudnas/appl/maven"
export M2=${TMPSTR}{M2_HOME}/bin
export MAVEN_OPTS="-Xms256m -Xmx512m"
export PATH=${TMPSTR}{M2}:${TMPSTR}{PATH}

+
    source ~/.bash_profile
fi
mvn -version

### ================================================================================================
