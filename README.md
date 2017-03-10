# CentOS 환경에서 service 관리

## History

* 2017.03.10 ~ 2017.03.10, Version 0.00.003

## 작업 환경 설정

yum -y install epel-release  
yum -y git  

cd /  
git clone https://github.com/pnuskgh/service.git  
git config --global push.default simple  

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

