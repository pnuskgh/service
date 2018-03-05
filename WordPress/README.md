# WordPress 설치

## 사전 준비 사항

* Nginx 설치  
* MariaDB 설치
  * 방화벽에서 3306/tcp port를 연다.

## WordPress 설치

${HOME_SERVICE}/service_sw/Nginx/bin/001_install.bash  
${HOME_SERVICE}/service_sw/Nginx/bin/101_install_php.bash  

${HOME_SERVICE}/service_sw/MariaDB/bin/001_install.bash  

* setup_db.bash 파일을 실행하여 Database를 생성하고 접근 권한을 설정
* install.bash 파일을 실행하여 WordPress 설치
* http://공인IP/ 사이트로 접속하여 WordPress 설정 (생략)
  * "Let's go!' 버튼을 선택 한다.
  * Database 접속 정보를 입력한 후 "저장하기" 버튼을 선택 한다.
    * 데이터베이스 이름 : wordpress
    * 사용자명 : wpuser
    * 비밀번호 : 
    * 데이터베이스 호스트 : 
    * 테이블 접두어 : wp_

## WordPress 관리자 설정

http://공인IP/ 사이트로 접속 한다.  
* 사이트 제목 : 
* 사용자명 : 
* 비밀번호 : 
* 비밀번호 확인 : 
* 이메일 주소 : 
* 검색 엔진 접근 여부 : 

관리자로 접속하려면  
http://공인IP/wp-login.php 사이트로 로그인 한다.

