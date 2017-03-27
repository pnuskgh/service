# CentOS 환경에서 service 관리

## History

* 2017.03.10 ~ 2017.03.27, Version 0.00.046

## 작업 환경 설정

yum -y install epel-release  
yum -y install git  
* apt-get install git-core  

git config --global user.name "Mountain Lover"  
git config --global user.email consult@jopenbusiness.com  
git config --global push.default simple  
* Git 1.8.3에서만 사용
* Git 1.7.1에서는 사용하지 말 것

git config --global --list  
git config --list  

cd /  
git clone https://github.com/pnuskgh/service.git  
cd /service  
git checkout develop  

source /service/bin/bash_profile.bash  

echo 'source /service/bin/bash_profile.bash' >> /root/.bash_profile  
mkdir /work

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

