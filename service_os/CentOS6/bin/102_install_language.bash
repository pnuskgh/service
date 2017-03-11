#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : 102_install_language.bash, Version 0.00.001
###     프로그램 설명   : CentOS 이미지를 작성 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.05 ~ 2017.01.05
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
. config.bash > /dev/null 2>&1

### ------------------------------------------------------------------------------------------------
###     Java를 설치 한다.
### ------------------------------------------------------------------------------------------------
# yum -y install java-1.6.0-openjdk java-1.6.0-openjdk-*
# yum -y install java-1.7.0-openjdk java-1.7.0-openjdk-*
# yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-*

yum -y install java-1.7.0-openjdk

### ------------------------------------------------------------------------------------------------
###     Python을 설치 한다.
### ------------------------------------------------------------------------------------------------
# yum -y install python python-*
# yum -y install python2 python2-*
# yum -y install python3 python3-*
# yum -y install python34 python34-*

yum -y install python python-IPy python-backports python-backports-ssl_match_hostname python-chardet python-cheetah python-configobj python-decorator python-iniparse python-jsonpatch python-jsonpointer python-libs python-lxml python-markdown python-perf python-prettytable python-progressbar python-pycurl python-pygments python-pyudev python-requestbuilder python-requests python-setuptools python-six python-slip python-slip-dbus python-urlgrabber python-urllib3

yum -y install python-pip

### ------------------------------------------------------------------------------------------------
###     Perl을 설치 한다.
### ------------------------------------------------------------------------------------------------
yum -y install perl perl-Digest-HMAC perl-Digest-SHA perl-File-Temp perl-Pod-Escapes perl-Pod-Simple perl-Time-HiRes perl-libs perl-parent

### ------------------------------------------------------------------------------------------------
###     Ruby를 설치 한다.
### ------------------------------------------------------------------------------------------------
# yum -y install ruby ruby-* rubygems rubygem-*

yum -y install ruby ruby-irb ruby-libs rubygems rubygem-json

### ------------------------------------------------------------------------------------------------
###     PHP를 설치 한다.
### ------------------------------------------------------------------------------------------------
# yum -y install php php-*

yum -y install php php-common

### ------------------------------------------------------------------------------------------------
###     설치된 언어의 버전을 표시 한다.
###         CentOS release 6.8
###         Java 1.7.0_121
###         Python 2.6.6, pip 7.1.0
###         Perl 5.10.1
###         Ruby 1.8.7
###         PHP 5.3.3
### ------------------------------------------------------------------------------------------------
cat /etc/*-release | uniq
java -version
python -V
pip -V
perl -v
ruby -v
php -v

### ================================================================================================
