#!/bin/bash
### ================================================================================================
###     프로그램 명          : install_suitecrm.bash, Version 0.00.002
###     프로그램 설명        : SuiteCRM 설치 Script
###     작성자               : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일               : 2015.8.17 ~ 2015.8.18
### --- [History 관리] -------------------------------------------------------------------------------
###     2015.08.17, 산사랑 : 초안 작성
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
###     사용자 입력 확인
### ------------------------------------------------------------------------------------------------
if [ "$#" = "4" ]; then
    ROOTPASSWD=$1
    DATABASE=$2
    USERNAME=$3
    PASSWD=$4
else
    echo "Using : install_suitecrm.bash.bash ROOTPASSWD USERNAME PASSWD"
    echo "    ROOTPASSWD          : root DB 사용자 비밀번호"
    echo "    DATABASE            : SuiteCRM DB 이름"
    echo "    USERNAME            : SuiteCRM DB 사용자 아이디"
    echo "    PASSWD              : SuiteCRM DB 사용자 비밀번호"
    echo " "
    exit 2
fi

### ------------------------------------------------------------------------------------------------
###     MariaDB 설치 및 환경 설정
### ------------------------------------------------------------------------------------------------
if [ ! -e /etc/my.cnf ]; then
    /cloudnas/bin/install_mariadb.bash
fi

TMPSTR=`mysql -uroot -p${ROOTPASSWD} mysql -e 'show databases' | grep ${DATABASE} | wc -l`
if [ "${TMPSTR}" = "0" ]; then
    echo "MariaDB에 SuiteCRM용 데이터베이스를 생성 합니다."
    mysql -uroot -p${ROOTPASSWD} mysql <<+
create database ${DATABASE} default character set utf8;
grant all privileges on ${DATABASE}.* to '${USERNAME}'@'localhost' identified by '${PASSWD}';
flush privileges;
quit
+
fi

### ------------------------------------------------------------------------------------------------
###     Nginx 설치 및 환경 설정
### ------------------------------------------------------------------------------------------------
if [ ! -e /cloudnas/www/html/nginx-logo.png ]; then
    install_nginx.bash
fi
yum -y install php
# yum -y install php php-*
yum -y install php-fpm
yum -y install php-mbstring
yum -y install php-xml*
yum -y install php-imap
yum -y install php-mysql
yum -y install php-mcrypt
yum -y install php-gd

mkdir /var/lib/php/upload
chown apache:apache /var/lib/php/upload

crudini --set /etc/php.ini PHP cgi.fix_pathinfo 0
crudini --set /etc/php.ini PHP upload_tmp_dir '"/var/lib/php/upload"'
crudini --set /etc/php.ini PHP upload_max_filesize 10M
crudini --set /etc/php.ini PHP post_max_size 10M
crudini --set /etc/php.ini Date date.timezone Asia/Seoul
crudini --set /etc/php.ini Session session.save_path '"/var/lib/php/session"'

#crudini --set /etc/php-fpm.d/www.conf www listen 127.0.0.1:9000
#crudini --set /etc/php-fpm.d/www.conf www listen /var/run/php-fpm/php-fpm.sock

service php-fpm restart
# systemctl restart php-fpm

mkdir /cloudnas/www/html >& /dev/null

# 방화벽 종료
### To-Do : 향후 방화벽 설정할 것
systemctl stop firewalld.service
service iptables stop

if [ -e /etc/sysconfig/selinux ]; then
    ### To-Do : SELinux 설정할 것
    # SELinux 설정
    #     enforcing, permissive, disabled
    #     setenforce [ Enforcing | Permissive | 1 | 0 ]
    # getenforce
    # sestatus
    # setenforce Permissive 

    crudini --set /etc/sysconfig/selinux '' SELINUX disabled
    # reboot
fi 

echo " "
echo "vi /etc/nginx/nginx.conf 파일을 아래와 같이 설정 합니다."
echo "    index   index.html index.htm index.php;"
echo " "
echo "    server {"
echo "        location / {"
echo "            index   index.html index.htm index.php;"
echo "        }"
echo " "
echo "        location ~ \.php$ {"
echo "            try_files $uri =404;"
echo "# /etc/php-fpm.d/www.conf 파일의 [www] listen과 일치하여야 함"
echo "#            fastcgi_pass  /var/run/php-fpm/php-fpm.sock;"
echo "            fastcgi_pass  127.0.0.1:9000;"
echo "            fastcgi_index index.php;"
echo "            fastcgi_param SCRIPT_FILENAME /cloudnas/www/html$fastcgi_script_name;"
echo "            include /etc/nginx/fastcgi_params;"
echo "        }"
echo " "
echo " "

### ------------------------------------------------------------------------------------------------
###     SuiteCRM 설치 및 환경 설정
### ------------------------------------------------------------------------------------------------
mkdir /cloudnas/www/html >& /dev/null

if [ ! -e /cloudnas/install/SuiteCRM.zip ]; then
    cd /cloudnas/install
    wget 'https://suitecrm.com/component/dropfiles/?task=frontfile.download&id=35' -O SuiteCRM.zip
    unzip SuiteCRM.zip

    mv SuiteCRM-7.3-MAX /cloudnas/www/html/suitecrm
    chown -R apache:apache /cloudnas/www/html/suitecrm
fi

crudini --set /etc/php.ini PHP post_max_size 8M
crudini --set /etc/php.ini PHP upload_max_filesize 8M
service httpd restart

echo " "
echo "http://localhost/suitecrm 으로 접속하여 설정을 합니다."
if [ -e /etc/sysconfig/selinux ]; then
    echo "SELinux를 적용하려며 reboot 하세요."
fi

### ================================================================================================
