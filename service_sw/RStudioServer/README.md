* R 설치 정보 (R version 3.3.3 (2017-03-06))
  * 홈 디렉토리 : /usr/lib64/R
  * 라이브러리 설치 폴더 : /usr/lib64/R/library
  * R_SHARE_DIR=/usr/share/R
  * R_INCLUDE_DIR=/usr/include/R
  * R_DOC_DIR=/usr/share/doc/R-3.3.3

* R Studio 1.0.143
  * License : https://www.rstudio.com/products/rstudio/download2/
  * Download : https://www.rstudio.com/products/rstudio/download-server/
  * 홈 디렉토리 : /usr/lib/rstudio-server
  * 설정 파일 : /etc/rstudio/rserver.conf, /etc/rstudio/rsession.conf

* R Studio Server 설치  
wget https://download2.rstudio.org/rstudio-server-rhel-1.0.143-x86_64.rpm  
yum install --nogpgcheck rstudio-server-rhel-1.0.143-x86_64.rpm  

* R Studio Server 설정
  * 한글 설정 : "Tools > Global Options... > Code > Saving > Default text encoding"을 "UTF-8"로 설정 한다.
