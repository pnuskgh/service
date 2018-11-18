#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : install_raspbian.bash, Version 0.00.001
###     프로그램 설명   : Raspbian을 설치 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2018.11.01 ~ 2018.11.17
### ----[History 관리]------------------------------------------------------------------------------
###     수정자          :
###     수정일          :
###     수정 내용       :
### --- [Copyright] --------------------------------------------------------------------------------
###     Copyright (c) 1995~2018 pnuskgh, 오픈소스 비즈니스 컨설팅
###     All rights reserved.
### ================================================================================================

### ------------------------------------------------------------------------------------------------
###     실행 환경을 설정 한다.
### ------------------------------------------------------------------------------------------------
SOFTWARE="RaspberryPi"

if [[ "z${HOME_SERVICE}z" == "zz" ]]; then
    export HOME_SERVICE="/service"
fi
WORKING_DIR="${HOME_SERVICE}/${SOFTWARE}"
source ${HOME_SERVICE}/bin/config.bash > /dev/null 2>&1

if [[ -f ${WORKING_DIR}/bin/config.php ]]; then
    source ${WORKING_DIR}/bin/config.php
else
    TIMESTAMP=`date +%Y%m%d_%H%M%S`
    BACKUP_DIR=${WORKING_DIR}/backup
    TEMPLATE_DIR=${WORKING_DIR}/template
fi

### ------------------------------------------------------------------------------------------------
###     Raspberry Pi 7인치 Touch Screen 연결
###     해상도 : 800 * 480
### ------------------------------------------------------------------------------------------------
#---    빨간선으로 라즈베리파이 2번을 터치스크린의 1번에 연결 한다.          3
#---    검은선으로 라즈베리파이 3번을 터치스크린의 5번에 연결 한다.

### ------------------------------------------------------------------------------------------------
###     Raspbian 설치
###     Win32 Disk Imager : http://sourceforge.net/projects/win32diskimager/?source=directory
###     Raspbian Download : http://www.raspberrypi.org/downloads/
### ------------------------------------------------------------------------------------------------
#--- Win32 Disk Imager 사이트에서 Win32DiskImager-0.9.5-install.exe 파일을 설치 합니다.
#--- Raspberry Pi 다운로드 사이트에서 Raspbian 파일을 다운로드 합니다.
#---     2018-10-09-raspbian-stretch.img      : GUI 모드  (설치)
#---     2018-10-09-raspbian-stretch-lite.img : Text 모드 (보류)
#--- Win32 Disk Imager로 Micro SD 카드에 img 파일을 설치 합니다.

#--- Raspberry Pi로 부팅하여 SSH 서비스와 VNC 서비스를 실행 합니다.
#---    "South Korea", "Korean", "Seoul"을 선택 한다.
systemctl  start   ssh.service
systemctl  enable  ssh.service

systemctl  start   vncserver-x11-serviced.service
systemctl  enable  vncserver-x11-serviced.service

passwd                                  #--- pi/raspberry 사용자의 비밀번호를 변경 한다. 

### ------------------------------------------------------------------------------------------------
###     기본적인 환경을 설정 한다.
### ------------------------------------------------------------------------------------------------
#--- SSH로 접속하여 작업 한다.
#--- VNC Viewer로 접속하여 작업 한다.
vi  ~/.bashrc
    alias dir='ls -alF'
    alias show='cat ~/README.md'

#--- WiFi 설정
/usr/bin/wpa_passphrase myhome '비밀번호'

vi  /etc/wpa_supplicant/wpa_supplicant.conf
    ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
    update_config=1
    country=US
 
    network={
        ssid="myhome"
        psk=암호화된_비밀번호
        priority=1

        scan_ssid=1
        proto=RSN
        key_mgmt=WPA.PSK
        key_mgmt=NONE
        pairwise=CCMP
        group=CCMP
        auth_alg=OPEN
    }

iwconfig
iwlist wlan0 scan                                          #--- WiFi Country를 US로 설정할 것
reboot

wpa_cli -i wlan0 reconfigure
ifdown wlan0
ifup   wlan0

vi  ~/README.md
    raspi-config

    iwconfig
    iwlist wlan0 scan
    wpa_cli -i wlan0 reconfigure

    pinout

    cd /work/appl/OBCon_RaspberryPi

apt  update
apt  upgrade
reboot

# apt  install  fonts-unfonts-core  fonts-nanum  fonts-nanum-extra
apt  install  fonts-nanum  fonts-nanum-coding  fonts-nanum-extra
reboot 

#--- 한글 설정 (폰트 포함)
#---     http://rpie.tistory.com/1
#---     사용 가능한 한글 입력기에는 ibus, nabi, fcitx 등의 한글 입력기가 있습니다.
#---     -   ibus 에서는 로케일 설정이 한국으로 되어 있을때 한글 키보드 전환이 불가능한 버그
#---     -   fcitx 의 경우 별문제는 없었으나 라즈비안에서 입력기 선택에서 fcitx 가 안보이는 버그
#---         im-config -n fcitx 를 실행하면 입력기 지정이 가능
#--- 한영 전환키 : Shift_Space
apt  install  nabi  imhangul-gtk2  imhangul-gtk3  im-config  zenity
#--- im-config -n hangul
#--- "시작 > 기본 설정 > 입력기" 메뉴를 선택 한다.
#---     "확인"을 선택 한다.
#---     "예"를 선택 한다.
#---     "cjkv"를 선택한 후 "확인" 버튼을 선택 한다.

# apt  install  fcitx fcitx-hangul
# apt  install  ibus  ibus-hangul
# vi  ~/.bashrc
#    export  GTK_IM_MODULE=ibus
#    export  XMODIFIERS=@im=ibus
#    export  QT_IM_MODULE=ibus
# reboot
# 
# ibus  version                                               #--- IBus 1.5.14
# #--- "시작 > 기본 설정 > IBus 환경 설정"에서 IBus를 시작하도록 설정 한다.
# #--- "IBus 환경 설정 > 기본설정 > 입력 방식" 메뉴에서 "한국어-Hangul"을 선택 한다.
# 
# #--- 화면 상단의 한글/영어 선택 아이콘에서 한글을 선택 한다.
# #--- 태극 문양을 선택한 후 "설정"을 선택 한다.
# #--- "한영전환키"에서 "추가" 버튼을 선택한 후 "shift_space"를 추가 한다,
# #---     한글 선택 : alt + left_shift / shift_space

# #--- raspi-config 설정 생략
# # raspi-config
# #--- "4 Localisation Options" 선택 
# #---     "1 Change Locale" :
# #---         en_GB.UTF-8, en_US.UTF-8, ko_KR.UTF8 (디폴트), ko_KR.ECU-KR 선택
# #---     "2 Change Timezone" : Asia > Seoul
# #---     "3 Change Keyboard Layout"
# #---         Generic 105-key (Intl) PC > Other > Korean > Korean - Korean (101/104 key compatible) > The default for the keyboard layout > No compose key
# #---         일반 105키(국제 버전) PC > 기타 > 한국어 > 한국어 - 한국어(101/104키 호환) > 기본 키보드 배치 > Compose 키 없음
# #---             Control+Alt+백스페이스 키를 누르면 X 서버를 중단합니까? "아니오"
# #---     "4 Change Wi-fi Country" : US Unite States     (KR Korea (South) 사용 않음)

#--- OnScreen Keyboard 설치
#---     https://wiki.archlinux.org/index.php/Linux_console/Keyboard_configuration
#--- 한글 키보드 : http://kalten.tistory.com/25
#---     http://blog.naver.com/PostView.nhn?blogId=dowkim10&logNo=120109769191
apt  install  matchbox-keyboard
reboot
# matchbox-keyboard                                         #--- OnScreen Keyboard를 화면에 표시
# DISPLAY=:0.0 matchbox-keyboard

#--- IP 확인
mkdir  -p  /work/bin
cd  /work/bin
vi  raspberrypi.bash
    #!/usr/bin/env bash
    IPADDR=`/sbin/ip addr list eth0  | /bin/grep 'inet ' | /usr/bin/awk '{print \$2}'`
    /usr/bin/curl http://www.obcon.biz/raspberrypi.php?ip=raspbian2_eth0_${IPADDR}

    IPADDR=`/sbin/ip addr list wlan0 | /bin/grep 'inet ' | /usr/bin/awk '{print \$2}'`
    /usr/bin/curl http://www.obcon.biz/raspberrypi.php?ip=raspbian2_wlan0_${IPADDR}

chmod  755  raspberrypi.bash

crontab -e
    * * * * * /work/bin/raspberrypi.bash

### ------------------------------------------------------------------------------------------------
###     Python3 개발 환경 구성
### ------------------------------------------------------------------------------------------------
apt  install  python3 python3-setuptools  python3-pip  python3-virtualenv  python3-venv
apt  install  python3-pyqt5*  python3-pyqtgraph
apt  install  python3-dateutil

mkdir -p /work/appl/OBCon_RaspberryPi
cd /work/appl/OBCon_RaspberryPi

pip3 install configparser
pip3 install matplotlib
pip3 install numpy
pip3 install pandas

#--- GPIO 개발 환경 구성
apt  install  python3-gpiozero python3-rpi.gpio python3-pigpio
pip3 install  spidev
#--- "시작 > 기본 설정 > Raspberry Pi Configuration > Interfacesa > SPI"를 "Enable"로 설정 한다.
reboot
ls -alF /dev/spidev0.0 /dev/spidev0.1

crontab -e
    * * * * * /work/appl/OBCon_RaspberryPi/OBCon_SCADA_Daemon.bash  watchdog


# apt  list  --installed
# pip  list
# pip  freeze

### ================================================================================================

