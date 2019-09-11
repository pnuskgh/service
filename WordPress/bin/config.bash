#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : config.bash, Version 0.00.002
###     프로그램 설명   : Bash Script를 실행하기 위한 환경을 설정 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.03.28 ~ 2017.03.30
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

# BACKUP_DIR=${WORKING_DIR}/backup
BACKUP_DIR=/work/backup
TEMPLATE_DIR=${WORKING_DIR}/template

TIMESTAMP=`date +%Y%m%d_%H%M%S`

### ------------------------------------------------------------------------------------------------
###     Nginx와 MariaDB 설정
### ------------------------------------------------------------------------------------------------
DOCUMENT_ROOT=/usr/share/nginx/html
PASSWD_ROOT='myCloudAdmin1234'

### ------------------------------------------------------------------------------------------------
###     WordPress 설정
### ------------------------------------------------------------------------------------------------
DB_HOST=localhost
DB_NAME=wordpress
DB_USER=wpuser
DB_PASSWORD=myService1234
WORDPRESS_DB_PREFIX='wp_'

### ================================================================================================
