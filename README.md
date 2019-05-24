# CentOS 환경에서 service 관리

## History

* 2017.03.10 ~ 2017.04.07, Version 0.00.074

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

# Github Page
* https://pnuskgh.github.io/service/
* https://pnuskgh.github.io/ : pnuskgh.github.io repository가 사용

