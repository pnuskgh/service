#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : nginx.bash, Version 0.00.001
###     프로그램 설명   : HAProxy Service 테스트를 위한 web server를 설정 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.02.20 ~ 2017.02.20
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
###     Nginx 설치
###     nginx/1.10.2
### ------------------------------------------------------------------------------------------------
# yum -y install epel-release
# yum -y update
# systemctl stop firewalld
# systemctl disable firewalld

yum -y install nginx 
systemctl restart nginx.service
systemctl enable nginx.service
nginx -v

### ------------------------------------------------------------------------------------------------
###     Web 환경 구성
###         PHP 5.4.16
### ------------------------------------------------------------------------------------------------
yum -y install php-fpm
systemctl restart php-fpm.service
systemctl enable php-fpm.service
php -v

cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf_org

vi /etc/nginx/nginx.conf
#--- /data/swimage/HAProxy/files/nginx.conf 사용

systemctl restart php-fpm.service
systemctl restart nginx.service

vi /usr/share/nginx/html/phpinfo.php
# web01<br/>
# <?=$_SERVER['REMOTE_ADDR'];?><br/>
# <?=$_SERVER['HTTP_X_FORWARDED_FOR']?><br/>
# <?php phpinfo() ?>

nginx -t
tail -f /var/log/nginx/nginx.log

#--- 방화벽에서 80/tcp port를 열 것
curl http://localhost/phpinfo.php | head -n 3

### ================================================================================================

