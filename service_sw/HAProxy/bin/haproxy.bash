#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : haproxy.bash, Version 0.00.001
###     프로그램 설명   : HAProxy Service를 준비 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.02.15 ~ 2017.02.15
### ----[History 관리]------------------------------------------------------------------------------
###     수정자         	:
###     수정일         	:
###     수정 내용      	:
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     실행 환경을 설정 한다.
### ------------------------------------------------------------------------------------------------
. config.bash > /dev/null 2>&1

### ------------------------------------------------------------------------------------------------
###     HAProxy 설치 및 환경 구성
###     Version : HA-Proxy version 1.5.18 2016/05/10
###     다우클라우드 HAProxy Version : HA-Proxy version 1.6.3 2015/12/25
###     http://haproxy.1wt.eu/download/1.4/doc/configuration.txt
### ------------------------------------------------------------------------------------------------
yum -y install tcping
yum -y install traceroute

yum -y install haproxy
systemctl restart haproxy.service
systemctl enable haproxy.service
haproxy -v

echo "환경 설정 파일 : /etc/haproxy/haproxy.cfg"
echo " "

#--- curl http://192.168.0.13/phpinfo.php | head -n 3
#--- curl http://192.168.0.14/phpinfo.php | head -n 3

#--- curl http://192.168.0.46/phpinfo.php | head -n 3
#--- curl http://203.217.212.16/phpinfo.php | head -n 3
#--- netstat -an | grep LISTEN | grep 80

### ------------------------------------------------------------------------------------------------
###     Service Architecture
###     1. Single Node
###        1-1. HAProxy
###        1-2. HAProxy + Network Namespace + Keepalive
###     2. Dual Node
###        2-1. HAProxy + Network Namespace + Keepalive
###
###     Service Model
###     1. HTTP
###     2. HTTPS
###     3. TCP
###     4. UDP
###     -  Transparency
###     -  Performance
### ------------------------------------------------------------------------------------------------






### ================================================================================================

