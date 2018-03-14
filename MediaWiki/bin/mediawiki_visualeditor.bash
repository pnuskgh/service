#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : mediawiki_visualeditor.bash, Version 0.00.001
###     프로그램 설명   : MediaWiki에 VisualEditor을 설치 합니다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2018.03.09 ~ 2018.03.09
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2018 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     초기 환경을 설정 합니다.
### ------------------------------------------------------------------------------------------------
if [[ "z${HOME_SERVICE}z" == "zz" ]]; then
    export HOME_SERVICE="/service"
fi

source ${HOME_SERVICE}/bin/config.bash > /dev/null 2>&1

SOFTWARE="MediaWiki"
if [[ -f ${HOME_SERVICE}/${SOFTWARE}/bin/config.php ]]; then
    source ${HOME_SERVICE}/${SOFTWARE}/bin/config.php
fi

### ------------------------------------------------------------------------------------------------
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    echo "Using : mediawiki.bash COMMAND [OPTIONS]"
    echo "        COMMAND              : help, install, status"
    echo "        OPTIONS              : ..."
    echo " "
    exit 2
}

### ------------------------------------------------------------------------------------------------
###     Status를 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcStatus() {
    echo " "
}

### ------------------------------------------------------------------------------------------------
###     Command Line Argument를 확인 합니다.
### ------------------------------------------------------------------------------------------------
if [[ $# == 1 ]]; then
    COMMAND=$1
    OPTIONS="null"
elif [[ $# == 2 ]]; then
    COMMAND=$1
    OPTIONS=$2
else
    funcUsing
fi

### ------------------------------------------------------------------------------------------------
###     Main process
### ------------------------------------------------------------------------------------------------
case ${COMMAND} in
    help)
        funcUsing
        ;;
    install)
        #--- https://www.mediawiki.org/wiki/Extension:VisualEditor
        #--- https://www.howtoforge.com/tutorial/how-to-install-visualeditor-for-mediawiki-on-centos-7/
        #--- Parsoid 설치
        cd /work/install
        wget https://kojipkgs.fedoraproject.org//packages/http-parser/2.7.1/3.el7/x86_64/http-parser-2.7.1-3.el7.x86_64.rpm
        rpm -ivh http-parser-2.7.1-3.el7.x86_64.rpm
        yum -y install nodejs npm vim-enhanced git

        mkdir -p /opt/parsoid
        git clone https://gerrit.wikimedia.org/r/p/mediawiki/services/parsoid /opt/parsoid
        cd /opt/parsoid
        npm install
     
        cp localsettings.example.js localsettings.js

        cp config.example.yaml config.yaml

        vi /etc/systemd/system/parsoid.service
        systemctl daemon-reload
systemctl start parsoid
systemctl enable parsoid
netstat -plntu

firewall-cmd --add-port=8000/tcp --permanent
firewall-cmd --reload

        #--- VisualEditor 설치
cd /usr/share/nginx/html
cd extensions
git clone -b REL1_30 https://gerrit.wikimedia.org/r/p/mediawiki/extensions/VisualEditor.git

cd VisualEditor
git submodule update --init

cd ..
chown -R nginx:nginx VisualEditor

cd ..
vi LocalSettings.php
    $wgDefaultUserOptions['visualeditor-enable'] = 1;
    $wgHiddenPrefs[] = 'visualeditor-enable';
    #$wgDefaultUserOptions['visualeditor-enable-experimental'] = 1;
    $wgVirtualRestConfig['modules']['parsoid'] = array(
        'url' => 'http://localhost:8000',
        'domain' => 'localhost',
        'prefix' => 'localhost'
    );



        ;;
    status)
        funcStatus
        ;;
    *)
        funcUsing
        ;;
esac
echo " "

exit 0
### ================================================================================================

