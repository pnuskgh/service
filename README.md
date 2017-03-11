# CentOS 환경에서 service 관리

## History

* 2017.03.10 ~ 2017.03.15, Version 0.00.008

## 작업 환경 설정

yum -y install epel-release  
yum -y install git  
git config --global user.name "Mountain Lover"  
git config --global user.email consult@jopenbusiness.com  
git config --global push.default simple  

cd /  
git clone https://github.com/pnuskgh/service.git  
cd /service
git checkout develop

source /service/bin/bash_profile.bash  

## CentOS 7 환경 설정

* CentOS 7
* Python 2.7.5
* Git 1.8.3.1

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

