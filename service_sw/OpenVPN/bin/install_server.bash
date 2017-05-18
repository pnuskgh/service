#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : install_server.bash, Version 0.00.001
###     프로그램 설명   : OpenVPN을 구성 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.05.18 ~ 2017.05.18
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

OPENVPN_SERVER_IP="203.217.211.48"
OPENVPN_SERVER_PORT="443"

### ------------------------------------------------------------------------------------------------
###     OpenVPN 설치
### ------------------------------------------------------------------------------------------------
yum -y install openvpn easy-rsa

### ------------------------------------------------------------------------------------------------
###     Easy RSA로 Key 관리
###         CA             : ca.crt, ca.key
###         OpenVPN Server : server.crt, server.key
###         OpenVPN Client : john.crt, john.key
### ------------------------------------------------------------------------------------------------
# rm -rf /etc/openvpn/easy-rsa/keys/*
mkdir -p /etc/openvpn/easy-rsa/keys
cp -rf /usr/share/easy-rsa/2.0/* /etc/openvpn/easy-rsa
cp -f /etc/openvpn/easy-rsa/openssl-1.0.0.cnf /etc/openvpn/easy-rsa/openssl.cnf

cd /etc/openvpn/easy-rsa
#--- KEY_~ 환경변수만 수정
source ./vars
./clean-all

#--- CA key 생성 : ca.crt, ca.key, index.txt, serial
./build-ca

#--- OpenVPN Server용 key 생성 : 01.pem, index.txt, index.txt.attr, serial, server.crt/csr/key
./build-key-server server

#--- OpenVPN Client용 key 생성 : 02.pem, index.txt, index.txt.attr, serial, john.crt/csr/key
./build-key john

#--- Diffie-Hellman file 생성 : dh2048.pem
./build-dh

### ------------------------------------------------------------------------------------------------
###     OpenVPN 설정
### ------------------------------------------------------------------------------------------------
/bin/cp -f ${WORKING_DIR}/template/server.conf /etc/openvpn/server.conf

systemctl start openvpn@server.service
systemctl -f enable openvpn@server.service
netstat -ant | grep 443

### ------------------------------------------------------------------------------------------------
###     Routing & Forwarding Rules
### ------------------------------------------------------------------------------------------------
yum -y install iptables-services

systemctl stop firewalld.service
systemctl disable firewalld.service
systemctl start iptables.service
systemctl enable iptables.service

iptables -t nat -A POSTROUTING -s 10.11.0.0/24 -j SNAT --to ${OPENVPN_SERVER_IP}
# iptables-save > ${WORKING_DIR}/backup/iptables_${TIMESTAMP}.rules
# vi ${WORKING_DIR}/backup/iptables_${TIMESTAMP}.rules
# iptables-restore < ${WORKING_DIR}/backup/iptables_${TIMESTAMP}.rules
iptables -L
iptables -t nat -L

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

### ================================================================================================

