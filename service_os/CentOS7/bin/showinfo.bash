#!/bin/bash
### ============================================================================
###     프로그램 명             : showinfo.bash, Version 0.00.005
###     프로그램 설명           : Centos 정보를 표시 합니다.
###     작성자                  : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일                  : 2002.07.15 ~ 2017.03.10
### ----[History 관리]----------------------------------------------------------
###     수정자                  :
###     수정일                  :
###     수정 내용               :
### --- [Copyright] ------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ============================================================================

### ----------------------------------------------------------------------------
###     Main process
### ----------------------------------------------------------------------------
echo 'CentOS Ver.               :' `cat /etc/*-release | grep release | uniq`
echo 'CPU 개수                  :' `/bin/cat /proc/cpuinfo | /bin/grep processor | /usr/bin/wc -l` CPU
echo 'Memory (MB)               :' `cat /proc/meminfo | grep MemTotal`
echo 'Storage                   :' `df -h | grep /dev/sd`
echo ' '

java -version | grep version
echo ' '

python -V
echo '    PIP version           :' `pip -V`
echo ' '

echo 'Perl version              :' `perl -v | grep subversion`
echo ' '

echo 'Ruby version              :' `ruby -v`
echo ' '

echo 'PHP version               :' `php -v | grep built`
echo '    Zend Engine version   :' `php -v | grep Engine`
echo ' '

### ============================================================================

