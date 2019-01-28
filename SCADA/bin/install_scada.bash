#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : install_scada.bash, Version 0.00.005
###     프로그램 설명   : KT UCloud Biz와 VirtualBox에 SCADA 환경을 구성 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2018.12.19 ~ 2019.01.07
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2019 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     실행 환경을 설정 한다.
### ------------------------------------------------------------------------------------------------
SOFTWARE="SCADA"

if [[ "z${HOME_SERVICE}z" == "zz" ]]; then
    export HOME_SERVICE="/service"
fi
WORKING_DIR="${HOME_SERVICE}/${SOFTWARE}"
source ${HOME_SERVICE}/bin/config.bash > /dev/null 2>&1

if [[ -f ${WORKING_DIR}/bin/config.php ]]; then
    source ${WORKING_DIR}/bin/config.php
else
    TIMESTAMP=`date +%Y%m%d_%H%M%S`
    BACKUP_DIR=${WORKING_DIR}/backup
    TEMPLATE_DIR=${WORKING_DIR}/template
fi

### ------------------------------------------------------------------------------------------------
###     설치 환경을 구성 한다.
### ------------------------------------------------------------------------------------------------
#--- KT UCloud Biz (https://ucloudbiz.kt.com/console/main)
#---     "ucloud server > Server 네트워킹" 메뉴에서 IP를 추가로 신청 한다.
#---     "ucloud server > 클라우드 서버리스트" 메뉴에서 가상 서버를 신청 한다.
#---         Centos 7.2 64bit
#---         1 vCore / 1 GB Memory / 20 GB Disk (22,500원/월)
#---         Port : 22/tcp, 80/tcp, 3306/tcp, 502/tcp
#---     211.252.87.34      scada.obcon.biz

#--- VirtualBox 5.2.22
#---     가상 서버
#---         OBCon_SCADA, Linux, Red Hat (64-bit)
#---         2 vCore / 2 GB Memory / 100 GB Disk
#---     CentOS-7-x86_64-DVD-1804.iso
#---     192.68.56.171      scada.obcon.co.kr

#--- 호스팅케이알(www.hosting.kr)에서 hostname을 등록 한다.
#---     "도메인 > 부가서비스 > 네임서버 설정 관리" 메뉴를 선택 한다.
#---     도메인을 선택한 후 "조회/변경 신청" 버튼을 선택 한다.
#---     
#---     
#---     "도메인 > 정보 변경 > 호스트 관리" 메뉴를 선택 한다.
#---     211.252.87.34      scada.obcon.biz

### ------------------------------------------------------------------------------------------------
###     CentOS 7 64 bits를 설치 한다.
### ------------------------------------------------------------------------------------------------
/service/CentOS7/bin/init.bash

/service/CentOS7/bin/init_before.bash
/service/Chrony/bin/install.bash

### ------------------------------------------------------------------------------------------------
###     MariaDB를 설치 한다.
### ------------------------------------------------------------------------------------------------
/service/MariaDB/bin/install.bash

### ------------------------------------------------------------------------------------------------
###     Python 3.4을 설치 한다.
### ------------------------------------------------------------------------------------------------
#--- KT UCloud Biz에서는 OpenSSL 1.0.2k를 설치 한다.
/service/OpenSSL/bin/openssl.bash

# yum -y install python34 python34-*
yum -y install python34

### ------------------------------------------------------------------------------------------------
###     Node.js를 설치 한다.
### ------------------------------------------------------------------------------------------------
/service/Nodejs/bin/nodejs.bash
# npm  install  ~  --save
# npm  install  -g ~  
# npm  install                                              #--- package.json를 기준으로 설치

### ------------------------------------------------------------------------------------------------
###     방화벽 설정
###     https://www.lesstif.com/pages/viewpage.action?pageId=22053128
###     Conf : /usr/lib/firewalld/
### ------------------------------------------------------------------------------------------------
systemctl start firewalld.service
systemctl enable firewalld.service

firewall-cmd --permanent --zone=public --add-port=80/tcp
firewall-cmd --permanent --zone=public --add-port=502/tcp
firewall-cmd --reload
firewall-cmd --list-all

### ------------------------------------------------------------------------------------------------
###     OBCon_SCADA를 구성 한다.
### ------------------------------------------------------------------------------------------------
#--- /work/appl/obcon_scada/ 폴더 사용
# cd   /work/install
# wget  https://codeload.github.com/IoTKETI/Mobius/zip/master  -O  Mobius-master.zip
# unzip Mobius-master.zip
# mv   Mobius-master  /work/appl/obcon_scada

mkdir -p /work/appl/obcon_scada
chown centos:centos /work/appl/obcon_scada
cd  /work/appl/obcon_scada

#--- FTP로 obcon_scada 파일을 업로드 합니다.
vi  package.json

npm  install

### ------------------------------------------------------------------------------------------------
###     Notebook에서 Database 접속 설정을 한다.
### ------------------------------------------------------------------------------------------------
#--- scadadb Database 생성
ROOTPASSWORD='ppp'
DATABASE='scadadb'
USER='scada'
PASSWORD='ppp'

mysql -uroot -p${ROOTPASSWORD} mysql <<+
create database ${DATABASE};
show databases;

grant all privileges on ${DATABASE}.* to ${USER}@localhost identified by '${PASSWORD}';
grant all privileges on ${DATABASE}.* to ${USER}@'%' identified by '${PASSWORD}';
flush privileges;

select Host, User, Password from user order by User, Host;
select Host, Db, User from db order by User, Db, Host;
exit

+

#--- scadadatadb Database 생성
ROOTPASSWORD='ppp'
DATABASE='scadadatadb'
USER='scada'
PASSWORD='ppp'

mysql -uroot -p${ROOTPASSWORD} mysql <<+
create database ${DATABASE};
show databases;

grant all privileges on ${DATABASE}.* to ${USER}@localhost identified by '${PASSWORD}';
grant all privileges on ${DATABASE}.* to ${USER}@'%' identified by '${PASSWORD}';
flush privileges;

select Host, User, Password from user order by User, Host;
select Host, Db, User from db order by User, Db, Host;
exit

+

#--- Windows의 DBeaver 5.3.2에서 접속 설정

### ================================================================================================

