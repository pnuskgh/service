# MariaDB 설정

001_install.bash 파일을 실행하여 MariaDB를 설치 한다.
* Enter current password for root (enter for none): 엔터
* Set root password? [Y/n] Y
* New password: myCloudAdmin1234
* Re-enter new password: myCloudAdmin1234
* Remove anonymous users? [Y/n] Y
* Disallow root login remotely? [Y/n] Y
* Remove test database and access to it? [Y/n] Y
* Reload privilege tables now? [Y/n] Y

# CentOS 7에 서비스로 등록

cp conf/mariadb.service /etc/systemd/system/multi-user.target.wants
# cp conf/mysql.service /etc/systemd/system/multi-user.target.wants
systemctl daemon-reload  

# 서비스 기동/종료

/usr/local/maria/bin/mysqld_safe --user=mariadb &  
/usr/local/maria/bin/mysqladmin -uroot -p shutdown  

cp conf/mariadb.service /etc/systemd/system/multi-user.target.wants  
chmod 777 /etc/systemd/system/multi-user.target.wants/mariadb.service  
systemctl daemon-reload
systemctl start mariadb.service  
systemctl stop mariadb.service  

/usr/local/maria/support-files/mariadb.server start  
/usr/local/maria/support-files/mariadb.server stop  



/usr/local/mysql/bin/mysqld_safe --user=mysql &  
/usr/local/mysql/bin/mysqladmin -uroot -p shutdown  

cp conf/mysql.service /etc/systemd/system/multi-user.target.wants
chmod 777 /etc/systemd/system/multi-user.target.wants/mysql.service  
systemctl daemon-reload
systemctl start mysql.service  
systemctl stop mysql.service  

/usr/local/mysql/support-files/mysql.server start  
/usr/local/mysql/support-files/mysql.server stop  

