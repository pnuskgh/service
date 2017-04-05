#!/bin/bash
### ================================================================================================
###     프로그램 명              : install_gerrit_with_httpd.bash, Version 0.00.008
###     프로그램 설명         	: Gerrit 설치 Script
###     작성자                     : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일                     : 2015.7.21 ~ 2015.8.17
### --- [History 관리] -------------------------------------------------------------------------------
###     2015.07.21, 산사랑 : 초안 작성
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
if [ "$#" = "2" ]; then
    HOST_NAME=$1
    USERNAME=$2
else
    echo "Using : install_gerrit.bash.bash HOST_NAME USERNAME"
    echo "    HOST_NAME           : Gerrit의 hostname"
    echo "    USERNAME            : 일반 사용자 ID"
    echo " "
    exit 2
fi

### ------------------------------------------------------------------------------------------------
###     사전 준비 사항
### ------------------------------------------------------------------------------------------------
/cloudnas/bin/install_git.bash

### ------------------------------------------------------------------------------------------------
###     Gerrit용 Apache HTTP Server 설치 및 환경 설정
###	    DNS에 gerrit.osscloud.biz 를 등록 합니다.
###         방화벽 설정을 합니다.
###             Inbound  : 80, 8080, 29418, 587, 465
###             Outbound : 80, 8080, 29418, 587, 465
### ------------------------------------------------------------------------------------------------
### HTTP 인증을 위해서 Apach HTTP Server 설치와 환경 설정
yum -y install httpd httpd-tools openssl mod_ssl

TMPSTR=`grep NameVirtualHost /etc/httpd/conf/httpd.conf | grep -v '#' | wc -l`
if [ "${TMPSTR}" = "0" ]; then
    echo "NameVirtualHost *:80" >> /etc/httpd/conf/httpd.conf
fi

if [ ! -e /etc/httpd/conf.d/options.conf ]; then
    cat > /etc/httpd/conf.d/options.conf <<+
TraceEnable off

## Disable Signature
ServerSignature Off

## Disable Banner
ServerTokens Prod

+
fi

if [ ! -e /etc/httpd/conf.d/vhosts.conf ]; then
    cat > /etc/httpd/conf.d/vhosts.conf <<+
# Load my vhosts
Include vhosts.d/*.conf

+
fi

mkdir /etc/httpd/vhosts.d >& /etc/null
if [ ! -e /etc/httpd/vhosts.d/gerrit.conf ]; then
    cat > /etc/httpd/vhosts.d/gerrit.conf <<+
<VirtualHost *:80>
    ServerName ${HOST_NAME}
    ServerAlias ${HOST_NAME}

    ProxyRequests Off
    ProxyVia Off
    ProxyPreserveHost On

    <Proxy *>
                Order deny,allow
                Allow from all
    </Proxy>

    <Location /login/>
                AuthType Basic
                AuthName "Gerrit Code Review"
                Require valid-user
                AuthUserFile /etc/httpd/gerrit.htpasswd
    </Location>

    ProxyPass / http://127.0.0.1:8080/
</VirtualHost>

+
fi

if [ ! -e /etc/httpd/gerrit.htpasswd ]; then
    ### 관리자 (pnuskgh)와 사용자 (consult) 등록
    echo "pnuskgh 사용자의 암호를 설정 하세요."
    htpasswd -c /etc/httpd/gerrit.htpasswd pnuskgh
    echo " "

    echo "pnuskgh 사용자의 암호를 설정 하세요."
    htpasswd /etc/httpd/gerrit.htpasswd consult
    echo " "
fi

service httpd restart

### ------------------------------------------------------------------------------------------------
###     Gerrit 설치와 환경 설정
### ------------------------------------------------------------------------------------------------
mkdir /cloudnas/appl/gerrit >& /etc/null
chown git:git /cloudnas/appl/gerrit

# chsh -s /bin/bash git
su - git -c 'mkdir install' >& /etc/null
if [ ! -e ~git/install/gerrit-2.11.2.war ]; then
    su - git -c 'cd install; wget https://www.gerritcodereview.com/download/gerrit-2.11.2.war'
fi

if [ ! -e /cloudnas/appl/gerrit/etc/gerrit.config ]; then
    su - git -c 'java -jar ~/install/gerrit-2.11.2.war init -d /cloudnas/appl/gerrit'
    # Create '/cloudnas/appl/gerrit' [Y/n]?
    # Location of Git repositories   [git]: /cloudnas/repo_git_master
    # Database server type           [h2]:
    # Type                           [LUCENE/?]:
    # Authentication method          [OPENID/?]: http
    # Get username from custom HTTP header [y/N]?
    # SSO logout URL                 :
    # Install Verified label         [y/N]?
    # SMTP server hostname           [localhost]: smtp.gmail.com
    # SMTP server port               [(default)]: 587               # 465
    # SMTP encryption                [NONE/?]: tls                  # ssl
    # SMTP username                  [git]: pnuskgh
    # pnuskgh@gmail.com's password   :
    #               confirm password :
    # Run as                         [git]:
    # Java runtime                   [/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.79.x86_64/jre]:
    # Copy gerrit-2.11.2.war to /cloudnas/appl/gerrit/bin/gerrit.war [Y/n]?
    # Listen on address              [*]:
    # Listen on port                 [29418]:
    # 
    # Gerrit Code Review is not shipped with Bouncy Castle Crypto SSL v151
    # Download and install it now [Y/n]?
    # 
    # Gerrit Code Review is not shipped with Bouncy Castle Crypto Provider v151
    # Download and install it now [Y/n]?
    # 
    # Behind reverse proxy           [y/N]? Y
    # Proxy uses SSL (https://)      [y/N]?
    # Subdirectory on proxy server   [/]:
    # Listen on address              [*]:                                    <-  127.0.0.1
    # Listen on port                 [8081]: 8080
    # Canonical URL                  [http://127.0.0.1/]: http://gerrit.osscloud.biz
    #
    # Install plugin reviewnotes version v2.11.2 [y/N]?
    # Install plugin replication version v2.11.2 [y/N]?
    # Install plugin download-commands version v2.11.2 [y/N]?
    # Install plugin singleusergroup version v2.11.2 [y/N]?
    # Install plugin commit-message-length-validator version v2.11.2 [y/N]?

    ### Tip : 설정 파일 - vim /cloudnas/appl/gerrit/etc/gerrit.config

    su - git -c 'cd /cloudnas/appl/gerrit; ./bin/gerrit.sh restart'
fi
# chsh -s /usr/bin/git-shell git

### ------------------------------------------------------------------------------------------------
###     Git review 설치 및 설정
###         git push origin HEAD:refs/for/master
###         git review -R
### ------------------------------------------------------------------------------------------------
# yum -y install python27 python27-*
easy_install pip
pip install git-review

# mkdir -p ~/.config/git-review
# cat > ~/.config/git-review/git-review.conf <<+
# [gerrit]
# defaultremote = origin
# +

### ------------------------------------------------------------------------------------------------
###     Gerrit 사이트 설정
### ------------------------------------------------------------------------------------------------
echo " "
echo " "
echo " "
echo "도움말 : http://gerrit.osscloud.biz:8080/Documentation/user-upload.html"
echo " "
echo "http://${HOST_NAME}/ 사이트로 접속하여 gerrit를 사용 합니다."
echo "    관리자 : pnuskgh /"
echo "    사용자 : consult /" 
echo " "
echo "pnuskgh gerrit 사용자의 public key를 생성 합니다."
echo "    ssh-keygen -t rsa"
echo "        사이트에서 pnuskgh 사용자의 SSH Public Keys에 ~/.ssh/id_rsa.pub 파일의 내용을 등록 합니다."
echo "consult gerrit 사용자의 public key를 생성 합니다."
echo "    su - ${USERNAME} -c 'ssh-keygen -t rsa'"
echo "        사이트에서 consult 사용자의 SSH Public Keys에 ~/.ssh/id_rsa.pub 파일의 내용을 등록 합니다."
echo " "
echo "사용자에 대해서 이메일이 인증되어 있어야 합니다."
echo "    500번 오류가 발생할 경우"
echo "        https://accounts.google.com/ContinueSignIn?sarp=1&scc=1&plt=AKgnsbuAN"
echo "        https://www.google.com/settings/security/lesssecureapps"
echo "        https://g.co/allowaccess"

echo " "
echo " "
echo "jopenbusiness Remote Git repository 생성"
echo "    http://${HOST_NAME}/ 사이트에 pnuskgh 사용자로 로그인하여 작업 합니다."
echo "    Projects -> Create New Project 메뉴에서 jopenbusiness 프로젝트를 생성 합니다."
echo "        Project Name : jopenbusiness"
echo "        Rights Inherit From : All-Projects"
echo "        Create initial empty commit : 체크"
echo "    People -> Create New Group 메뉴에서 jopenbusiness 그룹을 생성 합니다."
echo "    People -> List Groups -> jopenbusiness -> Members 메뉴에서 consult 사용자를 추가 합니다."
echo " "

### ================================================================================================
