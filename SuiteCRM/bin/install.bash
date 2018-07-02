#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : install.bash, Version 0.00.003
###     프로그램 설명   : SuiteCRM을 설치 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.09.14 ~ 2018.06.12
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

RELATION_DIR="$(dirname $0)"
WORKING_DIR="$(cd -P ${RELATION_DIR}/.. && pwd)"
# WORKING_DIR="/service/service_sw/SuiteCRM"
source ${WORKING_DIR}/bin/config.bash

### ------------------------------------------------------------------------------------------------
###     MariaDB 설치
### ------------------------------------------------------------------------------------------------
#--- MariaDB를 설치할 것
systemctl start mariadb.service

### ------------------------------------------------------------------------------------------------
###     PHP 설치
###     SuiteCRM 지원 플랫폼 : https://docs.suitecrm.com/admin/compatibility-matrix/
### ------------------------------------------------------------------------------------------------
yum install remi-release
yum install php71 php71-php php71-php-cli php71-php-common php71-php-fpm php71-php-gd php71-php-imap php71-php-json php71-php-mbstring php71-php-mysqlnd php71-php-opcache php71-php-pdo php71-php-pecl-crypto php71-php-mcrypt php71-php-pecl-zip php71-php-process php71-php-soap php71-php-xml php71-php-xmlrpc php71-runtime

vi  /etc/opt/remi/php71/php.ini
#vi /etc/php.ini
#    upload_tmp_dir = "/var/lib/php/upload"
#    session.save_path = "/var/lib/php/session"
#    memory_limit = 128M
#    upload_max_filesize = 20M
#    post_max_size = 20M
#    date.timezone = Asia/Seoul

mkdir -p /var/lib/php/session
mkdir -p /var/lib/php/upload
chown nginx:nginx /var/lib/php/session
chown nginx:nginx /var/lib/php/upload

vi  /etc/opt/remi/php71/php.d/20-mbstring.ini
#   ; Enable mbstring extension module
#   extension=mbstring.so
#   
#   mbstring.language = UTF-8
#   mbstring.internal_encoding = UTF-8
#   mbstring.http_input = UTF-8
#   mbstring.http_output = UTF-8
#   
#   mbstring.encoding_translation = On
#   mbstring.detect_order = UTF-8,EUC-KR,SJIS
#   mbstring.substitute_character = none
#   
#   mbstring.script_encoding = UTF-8

# vi  /etc/opt/remi/php71/php.d/30-mcrypt.ini
#   ; Enable mcrypt extension module
#   extension=mcrypt

vi  /etc/opt/remi/php71/php.d/40-crypto.ini
#   ; Enable 'Wrapper for OpenSSL Crypto Library' extension module
#   extension=crypto.so

vi  /etc/opt/remi/php71/php.d/www.conf
#   [www]
#   user = nginx
#   group = nginx
#   listen = /var/opt/remi/php71/run/php-fpm/www.sock
#   listen.owner = nginx
#   listen.group = nginx
#   listen.mode = 0660
#   listen.allowed_clients = 127.0.0.1
#   security.limit_extensions = .php .php3 .php4 .php5 .php7

systemctl start php71-php-fpm.service

### ------------------------------------------------------------------------------------------------
###     Nginx 설치
### ------------------------------------------------------------------------------------------------
#--- Nginx를 설치할 것
vi  /etc/nginx/nginx.conf
#    http {
#        client_max_body_size 10M;
#        charset             UTF-8;
#        server {
#            charset      UTF-8;
#            client_max_body_size 10M;
#            location / {
#                rewrite ^/mediawiki([^?]*)(?:\?(.*))? /mediawiki/index.php?title=$1&$2 last;
#                index index.html index.htm index.php;
#            }
#
#            location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
#                try_files $uri /mediawiki/index.php?title=$1&$args;
#                expires max;
#                log_not_found off;
#            }
#
#            location /wordpress/ {
#                try_files $uri $uri/ /wordpress/index.php?$args;
#                index index.php index.html;
#            }
#
#            location /test/wordpress/ {
#                try_files $uri $uri/ /test/wordpress/index.php?$args;
#                index index.php index.html;
#            }
#
#            location ~ \.(php)$ {
#                root /usr/share/nginx/html;
#                try_files $uri =404;
#                # fastcgi_pass  127.0.0.1:9000;
#                # fastcgi_pass unix:/var/run/php-fpm/www.sock;
#                fastcgi_pass unix:/var/opt/remi/php71/run/php-fpm/www.sock;
#                fastcgi_index index.php;
#                fastcgi_read_timeout 180;
#                fastcgi_buffers 16 16k;
#                fastcgi_buffer_size 32k;
#
#                include fastcgi.conf;
#            }
#        }
#    }

# cd /var/opt/remi/php71/lib
# chown -R nginx:nginx *

systemctl start nginx.service

### ------------------------------------------------------------------------------------------------
###     SuiteCRM 설치
###     https://suitecrm.com/download
### ------------------------------------------------------------------------------------------------
#--- 설치할 SuiteCRM 소스를 아래 폴더에 위치 한다.
#---     SuiteCRM-7.8.6.zip 파일을 notebook에서 업로드 한다.
yum -y install unzip
cd /usr/share/nginx/html
unzip /home/centos/zztemp/SuiteCRM-7.8.6.zip
mv SuiteCRM-7.8.6 suitecrm
chown -R nginx:nginx suitecrm

#--- Network로 Database 접속 허용
# chcon -R -t httpd_sys_content_rw_t /var/www/html 
setsebool httpd_can_network_connect_db=on 
setsebool httpd_can_network_connect=on 
setsebool httpd_can_sendmail=on 
setsebool httpd_unified=on

# crontab -e -u nginx
#     * * * * * cd /usr/share/nginx/html/suitecrm; php -f cron.php > /dev/null 2>&1 

#--- http://demo.obcon.biz/suitecrm

### ================================================================================================

