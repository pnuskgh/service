#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : setup_site_url.bash, Version 0.00.001
###     프로그램 설명   : WordPress Site URL 정보를 변경 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.03.30 ~ 2017.03.30
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     funcUsing()
###         사용법 표시
### ------------------------------------------------------------------------------------------------
funcUsing() {
    /bin/echo "Using : setup_site_url.bash DATABASE USER SITEURL [PASSWORD]"
    /bin/echo "        DATABASE       : Database"
    /bin/echo "        USER           : Database 사용자"
    /bin/echo "        SITEURL        : http 또는 https로 시작하는 Site URL"
    /bin/echo "        PASSWORD       : Database 사용자의 암호"
    /bin/echo " "
    exit 1
}

###---  Command Line에서 입력된 인수를 검사한다.
if [[ $# = 3 ]]; then
    /bin/echo -n "Database 사용자의 암호를 입력 하세요 : "
    read PASSWORD
elif [[ $# = 4 ]]; then
    PASSWORD=$4
else
    funcUsing
fi
DATABASE=$1
USER=$2
SITEURL=$3

### ------------------------------------------------------------------------------------------------
###     Main process
### ------------------------------------------------------------------------------------------------
mysql -u${USER} -p${PASSWORD} ${DATABASE} <<+
update wp_options 
   set option_value = "${SITEURL}"
 where option_name = "siteurl" or option_name = "home";
commit;

select option_id, option_name, option_value 
  from wp_options 
 where option_name = 'siteurl' or option_name = 'home';

exit

+

exit 0
### ================================================================================================

