#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : bash_env.bash, Version 0.00.007
###     프로그램 설명   : Linux 환경 설정 정보
###     작성자          : 산사랑 (consult@jopenbusiness.com, www.jopenbusiness.com)
###     작성일          : 2013.5.12 ~ 2016.2.1
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2016 산사랑, All rights reserved.
### ================================================================================================
#--- 환경 설정 파일에 ". /data/bin/bash_env.bash"를 추가 하세요.

export SERVER_FOLDER=/data

alias dir='ls -alF'
alias dird='ls -alF | grep /'
# alias vi=vim
alias ff="find . -type f"

# export LANG=ko_KR.utf8

export CDPATH=.:${SERVER_FOLDER}:${SERVER_FOLDER}/custom:${SERVER_FOLDER}/link:/var/www/html/wp-content:/var/www/html/wp-content/custom
export PATH=${PATH}:${SERVER_FOLDER}/bin:/var/www/html/wp-content/custom/lib/vendor/bin:/data/appl/rally/bin

export PS1='[\u@\h \W] '
# export PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
export EDITOR=vim

### ------------------------------------------------------------------------------------------------
###     Application별 설정
### ------------------------------------------------------------------------------------------------
alias gitpush='git push origin HEAD:refs/for/master'
alias phoronix=phoronix-test-suits

if [[ -f /data/appl/rally/etc/bash_completion.d/rally.bash_completio ]]; then
    . /data/appl/rally/etc/bash_completion.d/rally.bash_completio
fi 

#--- Pacemaker/Corosync
export OCF_ROOT=/usr/lib/ocf


alias log="tail -f /data/link/html/wp-content/debug.log"
alias logerror="tail -f /var/log/httpd/error_log"
alias cdwork="cd /var/www/html/wp-content/themes/Avada-Child-Theme"
alias phpcs="/var/www/html/wp-content/custom/lib/vendor/bin/phpcs --standard=/var/www/html/wp-content/custom/lib/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards/PSR2/ruleset.xml" 

### ================================================================================================
