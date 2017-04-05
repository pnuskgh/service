#!/bin/bash
### ================================================================================================
###     프로그램 명              : install_nginx.bash, Version 0.00.001
###     프로그램 설명         	: MariaDB 설치 Script
###     작성자                     : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일                     : 2015.9.3 ~ 2015.9.3
### --- [History 관리] -------------------------------------------------------------------------------
###     2015.09.03, 산사랑 : 초안 작성
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2015 산사랑, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     root 사용자로 작업을 하고 있는지 확인 합니다.
### ------------------------------------------------------------------------------------------------
TMPSTR=`env | grep USER`
if [ "${TMPSTR}" = "USER=root" ]; then
    echo " "
else
    echo "root 사용자로 작업 하세요."
    exit 1
fi

### ------------------------------------------------------------------------------------------------
###     Nginx 설치 및 환경 설정
### ------------------------------------------------------------------------------------------------
TMPSTR=`yum list | grep nginx | wc -l`
if [ "${TMPSTR}" = "0" ]; then
    TMPSTR='\$'
    cat > /etc/yum.repos.d/nginx.repo <<+
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/${TMPSTR}releasever/${TMPSTR}basearch/
gpgcheck=0
enabled=1
+
    sleep 3
fi

if [ ! -e /cloudnas/www/html/nginx-logo.png ]; then
    yum -y install nginx
    sed -i -e 's/#gzip/gzip/g' /etc/nginx/nginx.conf
    cp /usr/share/nginx/html/* /cloudnas/www/html

    service nginx restart
    # systemctl restart nginx.service
fi

sed -i -e 's/\/usr\/share\/nginx\/html/\/cloudnas\/www\/html/g' /etc/nginx/nginx.conf

### ================================================================================================
