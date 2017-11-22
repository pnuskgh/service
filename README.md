# CentOS 환경에서 service 관리

## 작업 환경 설정 for git 1.8.3 (CentOS 7)

yum -y install epel-release  
yum -y install git  

git config --global user.name "Mountain Lover"  
git config --global user.email consult@jopenbusiness.com  
git config --global push.default simple  

git config --global --list  
git config --list  

cd /  
git clone https://github.com/pnuskgh/service.git  
cd /service  
git checkout develop  

source /service/bin/bash_profile.bash  

echo 'source /service/bin/bash_profile.bash' >> /root/.bash_profile  
mkdir /work

## 작업 환경 설정 for git 1.7.1 (CentOS 6)

.ssh/id_rsa, id_rsa.pub 파일에 Git 접속을 위한 키를 저장 한다.  

yum -y install epel-release  
yum -y install git  
* apt-get install git-core  

git config --global user.name "Mountain Lover"  
git config --global user.email consult@jopenbusiness.com  

git config --global --list  
git config --list  

cd /  
git clone git@github.com:pnuskgh/service.git    
cd /service  
git checkout develop  

source /service/bin/bash_profile.bash  

echo 'source /service/bin/bash_profile.bash' >> /root/.bash_profile  
mkdir /work  

## CentOS 7 환경 설정

* CentOS 7
* Python 2.7.5
* Git 1.8.3.1

## Git 접속 방법 변경
vi /service/.git/config  
    [remote "origin"]  
        url = https://github.com/pnuskgh/service.git  
        url = git@github.com:pnuskgh/service.git  

## Git 주요 명령어

cd /  
git clone https://github.com/pnuskgh/service.git  

git status  

git add ~  
git commit -m '~'  
git push  

git pull  

## Bash 매뉴얼

* https://github.com/denysdovhan/bash-handbook/blob/master/translations/ko-KR/README.md

# Linux 폴더 구조

## /service/

* bin/ : 공통으로 사용하는 실행 파일
* conf/ : 공통으로 사용하는 설정 파일
* service_os/ : OS S/W
* service_sw/ : Software
* util/ : 공통으로 사용하는 유틸리티

## /work/

* backup/ : Backup/Restore
* bin/ : Linux별로 사용하는 실행 파일
* conf/ : Linux별로 사용하는 설정 파일
* custom/ : 커스터마이징된 소스 저장
* install/ : 설치 프로그램
* template/ : 템플릿

