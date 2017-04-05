#!/bin/bash
### ================================================================================================
###     프로그램 명          : install_redmine.bash, Version 0.00.004
###     프로그램 설명        : Redmine 설치 Script
###     작성자               : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일               : 2015.7.31 ~ 2015.9.3
### --- [History 관리] -------------------------------------------------------------------------------
###     2015.07.31, 산사랑 : 초안 작성
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
USERNAME=redmine
if [ "$#" = "1" ]; then
    PASSWD=$1
else
    echo "Using : install_redmine.bash.bash PASSWD"
    echo "    PASSWD              : redmine 사용자 DB 비밀번호"
    echo " "
    exit 2
fi

### ------------------------------------------------------------------------------------------------
###     MariaDB 설치 및 환경 설정
### ------------------------------------------------------------------------------------------------
if [ ! -e /etc/my.cnf ]; then
    /cloudnas/bin/install_mariadb.bash
fi

### ------------------------------------------------------------------------------------------------
###     Ruby 설치 및 환경 설정
### ------------------------------------------------------------------------------------------------
yum install -y ruby ruby-devel 
yum install -y rubygem-rake rubygem-bundler
yum install -y ImageMagick ImageMagick-devel 
# ruby -v
# gem -v

### ------------------------------------------------------------------------------------------------
###     Redmine 설치 및 환경 설정
###         http://localhost:3000/
### ------------------------------------------------------------------------------------------------
yum groupinstall -y "Development Tools"
yum install -y openssl-devel readline-devel zlib-devel curl-devel libyaml-devel libffi-devel

gem install bundler --no-rdoc --no-ri
# bundler --version

echo "MariaDB에 redmine용 데이터베이스를 생성 합니다."
mysql -u root -p mysql <<+
create database ${USERNAME} default character set utf8;
grant all privileges on ${USERNAME}.* to '${USERNAME}'@'localhost' identified by '${PASSWD}';
flush privileges;
quit
+
# create user '${USERNAME}'@'localhost' identified by '~';
# grant all privileges on ${USERNAME}.* to '${USERNAME}'@'localhost';
# select Host, Db, User from db;

groupadd redmine >& /etc/null
useradd  -d /cloudnas/home/redmine -m -g redmine redmine >& /etc/null
su - redmine -c '/cloudnas/bin/init_user.bash'

cd ~/install
wget http://www.redmine.org/releases/redmine-3.1.0.tar.gz
tar zxvf redmine-3.1.0.tar.gz
mv redmine-3.1.0 /cloudnas/appl/redmine
chown -R redmine:redmine /cloudnas/appl/redmine

cd /cloudnas/appl/redmine
cat > config/database.yml <<+
production:
  adapter: mysql2
  database: ${USERNAME}
  host: localhost
  username: ${USERNAME}
  password: "${PASSWD}"
  encoding: utf8
+
chown redmine:redmine config/database.yml

cat > config/configuration.yml <<+
default:
  email_delivery:

  attachments_storage_path:

  autologin_cookie_name:
  autologin_cookie_path:
  autologin_cookie_secure:

  scm_subversion_command:
  scm_mercurial_command:
  scm_git_command:
  scm_cvs_command:
  scm_bazaar_command:
  scm_darcs_command:

  scm_subversion_path_regexp:
  scm_mercurial_path_regexp:
  scm_git_path_regexp:
  scm_cvs_path_regexp:
  scm_bazaar_path_regexp:
  scm_darcs_path_regexp:
  scm_filesystem_path_regexp:

  scm_stderr_log_file:

  database_cipher_key:

  rmagick_font_path:

production:
  email_delivery:
    delivery_method: :smtp
    smtp_settings:
      enable_starttls_auto: true
      address: "smtp.gmail.com"
      port: 587
      domain: "smtp.gmail.com"
      authentication: :plain
      user_name: "pnuskgh@gmail.com"
      password: "ppp"

development:

+
chown redmine:redmine config/configuration.yml

su - redmine -c 'cd /cloudnas/appl/redmine; bundle install --without development test --path vendor/bundle'

su - redmine -c 'cd /cloudnas/appl/redmine; bundle exec rake generate_secret_token'
su - redmine -c 'cd /cloudnas/appl/redmine; RAILS_ENV=production bundle exec rake db:migrate'
su - redmine -c 'cd /cloudnas/appl/redmine; RAILS_ENV=production REDMINE_LANG=ko bundle exec rake redmine:load_default_data'
# su - redmine -c 'cd /cloudnas/appl/redmine; rake generate_secret_token'
# su - redmine -c 'cd /cloudnas/appl/redmine; RAILS_ENV=production rake db:migrate'
# su - redmine -c 'cd /cloudnas/appl/redmine; RAILS_ENV=production REDMINE_LANG=ko rake redmine:load_default_data'

su - redmine -c 'cd /cloudnas/appl/redmine; ruby bin/rails server webrick -e production -b 172.31.8.78'
# su - redmine -c 'cd /cloudnas/appl/redmine; ruby bin/rails server webrick -e production -b 52.69.252.43'
# su - redmine -c 'cd /cloudnas/appl/redmine; ruby bin/rails server webrick -e production -b 192.168.10.201'

echo " "
echo "http://localhost:3000/, admin/admin 사이트로 접속 하세요"
echo " "

### ------------------------------------------------------------------------------------------------
###     Redmine용 nginx 설치 및 환경 설정
### ------------------------------------------------------------------------------------------------
if [ ! -e /cloudnas/www/html/nginx-logo.png ]; then
    install_nginx.bash
fi

echo " "
echo "vi /etc/nginx/nginx.conf 파일을 아래와 같이 설정 합니다."
echo "    server {"
echo "        listen       80;"
echo "        server_name  redmine.osscloud.biz;"
echo "        root         /cloudnas/appl/redmine/public;"
echo " "
echo "        location / {"
echo "            proxy_pass http://172.31.8.78:3000/;"
echo "        }"
echo "    }"
echo " "
echo " "

# echo "    server {"
# echo "        location /redmine/ {"
# echo "            proxy_pass http://172.31.8.78:3000/;"
# echo "        }"
# echo " "
# echo " "

### ================================================================================================
