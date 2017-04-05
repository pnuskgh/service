#!/bin/bash
### ================================================================================================
###     프로그램 명          : install_jenkins.bash, Version 0.00.004
###     프로그램 설명        : Jenkins 설치 Script
###     작성자               : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일               : 2015.7.31 ~ 2015.8.4
### --- [History 관리] -------------------------------------------------------------------------------
###     2015.07.31, 산사랑 : 초안 작성
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2015 산사랑, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

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
###     JDK 설치 및 환경 설정
### ------------------------------------------------------------------------------------------------
yum install -y java-1.8.0-openjdk
# yum install -y java-1.7.0-openjdk
# yum install -y java-1.6.0-openjdk

### ------------------------------------------------------------------------------------------------
###     Jenkins 설치 및 환경 설정
###          Home                       : /var/lib/jenkins/ - 첫 실행시 war 파일이 여기에 배포됨
###         설정 파일                   : /etc/sysconfig/jenkins
###                                            JENKINS_PORT="8080"
###                                            JENKINS_AJP_PORT="8009"
###         Cache                      : /var/cache/jenkins/
###         Logs                       : /var/log/jenkins
###         War 파일                   : /usr/lib/jenkins/jenkins.war
### ------------------------------------------------------------------------------------------------
if [ ! -e /etc/yum.repos.d/jenkins.repo ]; then
    wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
    # wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
    rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key

    yum install -y jenkins

    crudini --set /etc/sysconfig/jenkins '' JENKINS_PORT '"8090"'

    service jenkins restart
    # chkconfig jenkins on
fi

echo " "
echo " "
echo " "
echo "Jenkins 사이트에서 환경 설정"
echo "    http://www.osscloud.biz:8090/ 사이트로 접속 합니다."
echo "    Jenkins 관리 -> Configure Global Security 메뉴를 선택 합니다."
echo "        Enable security : check"
echo "        Jenkins’ own user database : check"
echo "            사용자의 가입 허용 : check"
echo "        Project-based Matrix Authorization Strategy : check"
echo "            pnuskgh 사용자 추가 : 모든 권한 부여"
echo "            consult 사용자 추가 : 필요한 권한 부여"
echo "        SAVE 버튼을 눌러 저장 합니다."
echo "    pnuskgh, consult 사용자를 생성 합니다."
echo "    pnuskgh 사용자로 로그인하여 "사용자의 가입 허용"의 체크를 해제 합니다."
echo " "

### ------------------------------------------------------------------------------------------------
###     Jenkins용 nginx 설치 및 환경 설정
### ------------------------------------------------------------------------------------------------
if [ ! -e /cloudnas/www/html/nginx-logo.png ]; then
    install_nginx.bash
fi

echo " "
echo "vi /etc/nginx/nginx.conf 파일을 아래와 같이 설정 합니다."
echo "    server {"
echo "        listen       80;"
echo "        server_name  jenkins.osscloud.biz;"
echo " "
echo "        location / {"
echo "            proxy_pass http://127.0.0.1:8090;
echo "        }"
echo "    }"
echo " "
echo " "

### ================================================================================================
