#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : check_bridge.bash, Version 0.00.006
###     프로그램 설명   : Linux Bridge를 테스트 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.07.03 ~ 2017.07.03
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     Promisc 모드로 변경
### ------------------------------------------------------------------------------------------------
ip addr list 
ifconfig eth0 0.0.0.0 promisc up     
vi  /etc/sysctl.conf
    net.ipv4.ip_forward = 1

### ------------------------------------------------------------------------------------------------
###     Linux Bridge check
### ------------------------------------------------------------------------------------------------
BRIDGE_NAME="br0"

ip addr list
brctl show
 
#--- Linux Bridge 추가
brctl addbr ${BRIDGE_NAME}
brctl show
  
brctl addif br0 eth0                  #--- br0 Bridge에 eth0 NIC 연결 
# brctl delbr br0
# brctl delif br0 eth0
# brctl stp br0 off         #--- br0 Bridge에서 stp off (off : default) 
 
 
### ------------------------------------------------------------------------------------------------
###     Linux Bridge clear
### ------------------------------------------------------------------------------------------------

### ================================================================================================

