#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : check_netns.bash, Version 0.00.006
###     프로그램 설명   : Linux Network Namespace를 테스트 한다.
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
###     Linux Network Namespace check
### ------------------------------------------------------------------------------------------------
NAMESPACE_NAME="samplens"
 
ip addr list
ping -c 3 localhost
 
#--- Network Namespace 생성
ip netns add ${NAMESPACE_NAME}
ip netns list
 
# ip netns exec ${NAMESPACE_NAME} ip addr list
ip netns exec ${NAMESPACE_NAME} bash
    ip addr list
    ping -c 3 localhost
 
    ip link set lo up
    ip addr list
    ping -c 3 localhost
    exit
 
#--- Veth Pair 생성
#---     두개의 interface가 pair로 동작하는 인터페이스
#---     하나로 들어온 입력이 다른쪽으로 나가도록 동작 한다.
ip link add veth_host type veth peer name veth_guest
ip addr list
ip netns exec ${NAMESPACE_NAME} ip addr list

#--- Interface를 Network Namespace에 할당
ip link set veth_guest netns ${NAMESPACE_NAME}
ip addr list
ip netns exec ${NAMESPACE_NAME} ip addr list
 
ip link set veth_host up
ip netns exec ${NAMESPACE_NAME} ip link set veth_guest up
ip addr list
ip netns exec ${NAMESPACE_NAME} ip addr list
 
#--- IP 할당
ip addr add 10.0.128.101/24 dev veth_host
ip netns exec ${NAMESPACE_NAME} ip addr add 10.0.128.102/24 dev veth_guest
ip addr list
ip netns exec ${NAMESPACE_NAME} ip addr list

ping -c 3 10.0.128.101
ping -c 3 10.0.128.102

### ------------------------------------------------------------------------------------------------
###     Linux Network Namespace clear
### ------------------------------------------------------------------------------------------------
ip link del veth_host
ip netns del ${NAMESPACE_NAME}

### ================================================================================================

