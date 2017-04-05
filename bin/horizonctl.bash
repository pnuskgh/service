#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : horizonctl.bash, Version 0.00.002
###     프로그램 설명   : Horizon 관리
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2016.5.9 ~ 2016.5.11
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2016 산사랑, All rights reserved.
### ================================================================================================

if [[ "${SERVER_FOLDER}" == "" ]]; then
    echo "SERVER_FOLDER 환경 변수를 설정 하세요."
    echo " "
    exit 1
fi

. ${SERVER_FOLDER}/bin/config.bash > /dev/null 2>&1
. ${SERVER_FOLDER}/bin/utilCommon.bash > /dev/null 2>&1

### ------------------------------------------------------------------------------------------------
###     funcUsing, 2016.5.9 ~ 2016.5.11, Version 0.00.002
###     사용법을 표시 합니다.
### ------------------------------------------------------------------------------------------------
funcUsing() {
    info "Using : horizonctl.bash COMMAND OPTIONS"
    info "        COMMAND              : 실행할 명령"
    info "        OPTIONS              : 명령 옵션"

    info "    COMMAND"
    info "        plugin_panel PLUGIN_NAME DASHBOARD_NAME PANEL_NAME : Plugin 생성 및 관리"
    info "        dashboard DASHBOARD_NAME PANEL_NAME : Dashboard 생성 및 관리"

    info " "
    exit 1
}

### ------------------------------------------------------------------------------------------------
###     funcPluginPanel, 2016.5.9 ~ 2016.5.9, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcPluginPanel() {
    local PLUGIN=''
    local DASHBOARD=''
    local PANAL=''

    if [[ $# != 3 ]]; then
        funcUsing
    fi
    PLUGIN=$1
    DASHBOARD=$2
    PANAL=$3

    #--- Plugin Folder 생성
    cd ${CUSTOM_DIR}/horizon
    rm -rf ${PLUGIN}
    mkdir ${PLUGIN}

    cd ${PLUGIN}
    touch setup.py
    touch setup.cfg
    touch LICENSE
    touch MANIFEST.in
    touch README.rst
    touch babel-django.cfg
    touch babel-djangojs.cfg

    mkdir ${PLUGIN}
    cd ${PLUGIN}
    touch __init__.py
    
    mkdir enabled
    touch enabled/_31000_${PLUGIN}.py

    mkdir api
    touch api/__init__.py
    touch api/my_rest_api.py
    touch api/myservice.py

    mkdir content
    touch content/__init__.py
    mkdir content/${PANAL}
    touch content/${PANAL}/__init__.py
    touch content/${PANAL}/panel.py
    touch content/${PANAL}/tests.py
    touch content/${PANAL}/urls.py
    touch content/${PANAL}/views.py
    mkdir -p content/${PANAL}/templates/${PANAL}
    touch content/${PANAL}/templates/${PANAL}/index.html
 
    mkdir -p static/dashboard/${DASHBOARD}/${PLUGIN}/${PANAL}
    touch static/dashboard/${DASHBOARD}/${PLUGIN}/${PANAL}/${PANAL}.html
    touch static/dashboard/${DASHBOARD}/${PLUGIN}/${PANAL}/${PANAL}.js
    touch static/dashboard/${DASHBOARD}/${PLUGIN}/${PANAL}/${PANAL}.scss

    mkdir locale
    touch locale/django.pot
    touch locale/djangojs.pot
    mkdir -p locale/ko_KR/LC_MESSAGES
    touch locale/ko_KR/LC_MESSAGES/django.po
    touch locale/ko_KR/LC_MESSAGES/djangojs.po
}

### ------------------------------------------------------------------------------------------------
###     funcDashboard, 2016.5.11 ~ 2016.5.11, Version 0.00.001
### ------------------------------------------------------------------------------------------------
funcDashboard() {
    local DASHBOARD=''
    local PANAL=''

    if [[ $# != 2 ]]; then
        funcUsing
    fi
    DASHBOARD=$1
    PANAL=$2

    #--- Plugin Folder 생성
    cd ${CUSTOM_DIR}/horizon
    rm -rf ${DASHBOARD}
    mkdir ${DASHBOARD}

    cd ${DASHBOARD}
    touch __init__.py
    touch dashboard.py

    mkdir -p ${PANAL}/templates/${PANAL}
    touch ${PANAL}/__init__.py
    touch ${PANAL}/panel.py
    touch ${PANAL}/tests.py
    touch ${PANAL}/urls.py
    touch ${PANAL}/views.py
    touch ${PANAL}/templates/${PANAL}/index.html

    mkdir -p static/${DASHBOARD}/css
    touch static/${DASHBOARD}/css/${DASHBOARD}.css
    mkdir -p static/${DASHBOARD}/js
    touch static/${DASHBOARD}/js/${DASHBOARD}.js

    mkdir -p templates/${DASHBOARD}
    touch templates/${DASHBOARD}/base.html
}

### ------------------------------------------------------------------------------------------------
###     Main, 2016.5.9 ~ 2016.5.9, Version 0.00.001
### ------------------------------------------------------------------------------------------------
###---  Command Line에서 입력된 인수를 검사한다.
if [[ 0 < $# ]]; then
    COMMAND=$1
    shift
    OPTIONS=$*
else
    funcUsing
fi

case ${COMMAND} in
    plugin_panel)
        funcPluginPanel ${OPTIONS}
        ;;
    dashboard)
        funcDashboard ${OPTIONS}
        ;;
    *)
        funcUsing
        ;;
esac
exit 0

### ================================================================================================
