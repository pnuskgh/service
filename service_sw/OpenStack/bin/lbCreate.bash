#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : lbCreate.bash, Version 0.00.001
###     프로그램 설명   : CLI로 Load Balance(LBaaSv2)를 생성 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.04.06 ~ 2017.04.06
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

DOMAIN_NAME="daoucloud"
PROJECT_NAME="clouddev@daou.co.kr"

LB_NAME="lb_cloud_home"
SUBNET_NAME="default-subnet1"

LISTENER_NAME_01="listener_cloud_home_http"
LISTENER_PROTOCOL_01="HTTP"
LISTENER_PORT_01="80"
POOL_NAME_01="pool_cloud_home_http"

LISTENER_NAME_02="listener_cloud_home_https"
LISTENER_PROTOCOL_02="TCP"
LISTENER_PROTOCOL_02="HTTPS"
LISTENER_PORT_02="443"
POOL_NAME_02="pool_cloud_home_https"

source ~/openrc.v3
DOMAIN_ID=`openstack domain list | grep ${DOMAIN_NAME} | nawk '{ print $2 }'`
PROJECT_ID=`openstack project list --domain ${DOMAIN_ID} | grep ${PROJECT_NAME} | nawk '{ print $2 }'`

#--- Load Balance 생성
source ~/openrc
LB_ID=`neutron lbaas-loadbalancer-create --tenant-id ${PROJECT_ID} --name ${LB_NAME} ${SUBNET_NAME} | grep " id  " | nawk '{ print $4 }'`
# neutron lbaas-loadbalancer-create --tenant-id ${PROJECT_ID} --name ${LB_NAME} ${SUBNET_NAME}
# neutron lbaas-loadbalancer-list
neutron lbaas-loadbalancer-show ${LB_ID}

#--- Listener 생성
# LISTENER_ID=`neutron lbaas-listener-create --loadbalancer ${LB_ID} --protocol HTTP --protocol-port 80 --name listener_http | grep " id  " | nawk '{ print $4 }'`

LISTENER_ID_01=`neutron lbaas-listener-create --tenant-id ${PROJECT_ID} --loadbalancer ${LB_ID} --protocol ${LISTENER_PROTOCOL_01} --protocol-port ${LISTENER_PORT_01} --name ${LISTENER_NAME_01} | grep " id  " | nawk '{ print $4 }'`
sleep 5
LISTENER_ID_02=`neutron lbaas-listener-create --tenant-id ${PROJECT_ID} --loadbalancer ${LB_ID} --protocol ${LISTENER_PROTOCOL_02} --protocol-port ${LISTENER_PORT_02} --name ${LISTENER_NAME_02} | grep " id  " | nawk '{ print $4 }'`
neutron lbaas-listener-list
# LISTENER_ID_01="84ab0fa6-3e19-455d-865c-410089ae62d3"
# LISTENER_ID_02="a3b0b964-b365-493b-a4c6-272d4bce4d65"

#--- Pool 생성
---     LEAST_CONNECTIONS, ROUND_ROBIN, SOURCE_IP
POOL_ID_01=`neutron lbaas-pool-create --tenant-id ${PROJECT_ID} --lb-algorithm SOURCE_IP --listener ${LISTENER_ID_01} --protocol ${LISTENER_PROTOCOL_01} --name ${POOL_NAME_01} | grep " id  " | nawk '{ print $4 }'`
sleep 5
POOL_ID_02=`neutron lbaas-pool-create --tenant-id ${PROJECT_ID} --lb-algorithm SOURCE_IP --listener ${LISTENER_ID_02} --protocol ${LISTENER_PROTOCOL_02} --name ${POOL_NAME_02} | grep " id  " | nawk '{ print $4 }'`
neutron lbaas-pool-list
# POOL_ID_01="ef80c9ce-05d3-406e-908f-d9e5cb0c9d22"
# POOL_ID_02="28795044-3ef3-4c80-9cea-e3a7db11f3cd"

neutron lbaas-member-create --tenant-id ${PROJECT_ID} --subnet ${SUBNET_NAME} --address 192.168.0.62 --protocol-port ${LISTENER_PORT_01} ${POOL_ID_01}
sleep 5
neutron lbaas-member-create --tenant-id ${PROJECT_ID} --subnet ${SUBNET_NAME} --address 192.168.0.76 --protocol-port ${LISTENER_PORT_01} ${POOL_ID_01}
neutron lbaas-member-list ${POOL_ID_01}

neutron lbaas-member-create --tenant-id ${PROJECT_ID} --subnet ${SUBNET_NAME} --address 192.168.0.62 --protocol-port ${LISTENER_PORT_02} ${POOL_ID_02}
sleep 5
neutron lbaas-member-create --tenant-id ${PROJECT_ID} --subnet ${SUBNET_NAME} --address 192.168.0.76 --protocol-port ${LISTENER_PORT_02} ${POOL_ID_02}
neutron lbaas-member-list ${POOL_ID_02}




neutron lbaas-healthmonitor-create --tenant-id ${PROJECT_ID} --type HTTP --delay 5 --max-retries 3 --timeout 5 --http-method GET --expected-codes 200 --url-path /lb_health_check.php --pool ${POOL_ID_01}
neutron lbaas-healthmonitor-create --tenant-id ${PROJECT_ID} --type TCP  --delay 5 --max-retries 3 --timeout 5 --pool ${POOL_ID_02}
# neutron lbaas-healthmonitor-create --tenant-id ${PROJECT_ID} --type PING --delay 5 --max-retries 3 --timeout 5 --pool ${POOL_ID_02}
neutron lbaas-healthmonitor-list


neutron floatingip-list
neutron floatingip-create admin_floating_net
neutron floatingip-associate --fixed-ip-address 10.0.0.4 1133bbb2-2a3f-4054-97f0-73d29a8b29b8 d737e2ce-cd6a-487c-b83b-f6775910b3b3
neutron floatingip-list




echo "Domain       : ${DOMAIN_NAME}, ${DOMAIN_ID}"
echo "Project      : ${PROJECT_NAME}, ${PROJECT_ID}"
echo "Load Balance : ${LB_NAME}, ${LB_ID}"
echo " "



source ~/openrc
# neutron lbaas-member-delete ${MEMBER_ID} ${POOL_ID}
neutron lbaas-pool-delete ${POOL_ID_02}
neutron lbaas-pool-delete ${POOL_ID_01}
neutron lbaas-listener-delete ${LISTENER_ID_02}
neutron lbaas-listener-delete ${LISTENER_ID_01}
neutron lbaas-loadbalancer-delete ${LB_ID}
exit 0



SERVER_NAME="myCentOS7_001"
SERVER_ID=`openstack server list --project ${PROJECT_ID} | grep ${SERVER_NAME} | nawk '{ print $2 }'`
echo "-   SERVER_NAME : ${SERVER_NAME}"
echo "-   SERVER_ID : ${SERVER_ID}"
echo " "

source ~/openrc
PORT_ID=`nova interface-list ${SERVER_ID} | grep ACTIVE | nawk '{ print $4 }'`
PORT_KEY=`nova interface-list ${SERVER_ID} | grep ACTIVE | nawk '{ print substr($4, 0, 12) }'`
IPTABLE_KEY=`nova interface-list ${SERVER_ID} | grep ACTIVE | nawk '{ print substr($4, 0, 11) }'`
echo "-   PORT_ID : ${PORT_ID}"
echo "-   PORT_KEY : ${PORT_KEY}"
echo "-   IPTABLE_KEY : ${IPTABLE_KEY}"
echo " "

echo "Run in compute node"
echo "brctl show | grep ${PORT_KEY}"
echo "tcpdump -i tap${PORT_KEY} -n -e icmp"
echo " "

echo "Run in instance"
echo "    방화벽에서 ICMP port가 열려 있어야 한다."
echo "    ping -c 3 192.168.0.11"
echo "    ping -c 3 192.168.0.12"
echo " "

echo "Run in compute node"
echo "iptables -S | grep ${IPTABLE_KEY}"
echo "iptables -L | grep ${IPTABLE_KEY}"

source ~/openrc.v3


exit





IMAGE_NAME="image_zzaa"

SNAPSHOT_ID=`cinder snapshot-list --all-tenants=1 | grep ${IMAGE_NAME} | nawk '{ print $2 }'`
VOLUME_ID=`cinder snapshot-list --all-tenants=1 | grep ${IMAGE_NAME} | nawk '{ print $4 }'`

echo "-   SNAPSHOT_ID : ${SNAPSHOT_ID}"
echo " "

echo "-   ${VOLUME_ID} volume의 snapshot 목록"
rbd snap ls volumes/volume-${VOLUME_ID}
echo " "

echo "-   ${SNAPSHOT_ID} snapshot의 children 목록"
rbd children volumes/volume-${VOLUME_ID}@snapshot-${SNAPSHOT_ID}
echo " "

### ================================================================================================

