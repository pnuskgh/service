#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : 002_init_mariadb.bash, Version 0.00.001
###     프로그램 설명   : MariaDB를 초기화 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2017.01.19 ~ 2017.01.19
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
source ${UTIL_DIR}/common.bash > /dev/null 2>&1

WORKING_DIR=`dirname $0`
WORKING_DIR=${WORKING_DIR}/..
source ${WORKING_DIR}/bin/config.bash





### ------------------------------------------------------------------------------------------------
###     init_mariadb 명령어를 생성 한다.
### ------------------------------------------------------------------------------------------------
# /usr/bin/cp -f /data/swimage/mariadb/bin/002_init_mariadb.bash /usr/bin/init_mariadb
# chmod 744 /usr/bin/init_mariadb

### ------------------------------------------------------------------------------------------------
###     MariaDB root 사용자의 비밀번호를 입력 받는다.
### ------------------------------------------------------------------------------------------------
/bin/clear

RTCD=false
for CNT_LOOP in 1 2 3; do
    /bin/echo -n "MariaDB root 사용자의 비밀번호를 입력 하세요 : "
    read PASSWORD_01

    /bin/echo -n "MariaDB root 사용자의 비밀번호를 다시 입력 하세요 : "
    read PASSWORD_02

    if [ "${PASSWORD_01}" = "${PASSWORD_02}" ]; then
        echo "ok"
        RTCD=true
        break
    else
        echo "오류 : 비밀번호가 서로 일치하지 않습니다."
        echo " "
        echo " "
    fi
done

if [ "${RTCD}" = "false" ]; then
    echo "오류 : 비빌번호가 3번 일치하지 않아 종료 합니다."
    echo "       다시 시도해 주세요."
    echo " "
    exit
fi
echo " "
echo " "

exit
### ------------------------------------------------------------------------------------------------
###     MariaDB root 사용자의 비밀번호를 설정 한다.
###         SET PASSWORD FOR '아이디'@'%' = PASSWORD('패스워드'); 
###
###         GRANT USAGE ON *.* TO '아이디'@'%' IDENTIFIED BY '패스워드';
###
###         UPDATE mysql.user SET Password=PASSWORD('패스워드') WHERE User='아이디' AND Host='%';
###         FLUSH PRIVILEGES;
### ------------------------------------------------------------------------------------------------
MARK="'"
echo "#!/usr/bin/env bash" > /tmp/init
echo mysqladmin -uroot -pdemo1234 password ${MARK}${PASSWORD_01}${MARK} >> /tmp/init
chmod 700 /tmp/init
/tmp/init

/bin/rm -f /tmp/init > /dev/null 2>&1
/bin/rm -f /usr/bin/init_mariadb > /dev/null 2>&1

echo "비밀번호 설정이 완료 되었습니다."
echo " "

### ================================================================================================

