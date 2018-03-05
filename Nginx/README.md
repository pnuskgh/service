# Nginx 설치후 설정
  
cd /etc/nginx  
mkdir sites-enabled  
mkdir sites-available  
  
vi /etc/nginx/nginx.conf  
    http {  
        charset UTF-8;  
  
    include /etc/nginx/sites-enabled/*.conf;

# Nginx 환경 구성

Nginx version : nginx/1.10.2

systemctl restart nginx.service  
systemctl reload nginx.service         #--- 환경 설정 정보를 다시 가져온다.  
nginx -t                               #--- Nginx 설치 파일을 검사 한다.  

* Document Root : /usr/share/nginx/html

* /etc/nginx/nginx.conf
* /etc/nginx/conf.d/*.conf
  * /usr/share/nginx/modules/*.conf
* /etc/nginx/default.d/*.conf

* /var/log/nginx/access.log
* /var/log/nginx/error.log

# PHP-FPM 환경 구성

PHP 5.4.16 (cli, fpm-fcgi)  
Zend Engine v2.4.0  

systemctl restart php-fpm.service

* /etc/php.ini
  * date.timezone = Asia/Seoul
  * upload_max_filesize = 20M
  * post_max_size = 30M
* /etc/php.d/*.ini
* /etc/php-fpm.conf
* /etc/php-fpm.d/www.conf
  * user = nginx
  * group = nginx
  * security.limit_extensions = .php
  * listen = /var/run/php-fpm/php-fpm.sock
* /etc/php-fpm.d/*.conf
  * 127.0.0.1:9000

* /var/log/php-fpm/error.log
  * /var/log/php-fpm/www-error.log
  * /var/log/php-fpm/www-slow.log

