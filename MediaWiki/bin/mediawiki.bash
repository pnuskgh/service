#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : mediawiki.bash, Version 0.00.001
###     프로그램 설명   : MediaWiki를 관리 합니다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 1995.02.20 ~ 2018.03.05
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
        echo "MariaDB를 설치 하세요"
        echo "Nginx를 설치 하세요"
        echo "PHP와 PHP-FPM을 설치 하세요"
        echo "    PHP에 설치된 모듈 목록 보기"
        php72 -m
        echo -n "잠시 멈춤 ..."
        read ZZTEMP

        yum -y install ImageMagick 
        ls -alF /usr/bin/convert
        cd /usr/share/nginx/html/mediawiki
        ce images
        mkdir archive
        mkdir thumb
        mkdir temp
        mkdir deleted

        echo "브라우저로 접속하여 MediaWiki를 설치 합니다."
        echo -n "잠시 멈춤 ..."
        read ZZTEMP

        # cd /usr/share/nginx/html/mediawiki
        # vi LocalSettings.php
        #     $wgShellLocale = "ko_KR.utf8";
        #     $wgLanguageCode = "ko";
        #     $wgLocaltimezone="Asia/Seoul";
        #     $wgLocalTZoffset=+540;
        #
        #     $wgEmergencyContact = "pnuskgh@gmail.com";
        #     $wgPasswordSender = "pnuskgh@gmail.com";
        #     $wgEmailAuthentication = true;
        #     
        #     $wgEnableUploads = true;
        #     $wgUseImageResize = true;
        #     $wgUseImageMagick = true;
        #     $wgImageMagickConvertCommand = "/usr/bin/convert";
        #     $wgHashedUploadDirectory = true;

        echo "WYSIWYG-CKeditor 설치"

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

