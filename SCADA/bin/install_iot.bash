#!/usr/bin/env bash
### ================================================================================================
###     프로그램 명     : install_iot.bash, Version 0.00.015
###     프로그램 설명   : Raspbian을 설치 한다.
###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
###     작성일          : 2018.11.01 ~ 2018.12.28
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
SOFTWARE="SCADA"

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
###         Raspbian Link : 2018.11.13 버전
###     Win32 Disk Imager : http://sourceforge.net/projects/win32diskimager/?source=directory
###     Raspbian Download : http://www.raspberrypi.org/downloads/
### ------------------------------------------------------------------------------------------------
#--- Win32 Disk Imager 사이트에서 Win32DiskImager-0.9.5-install.exe 파일을 설치 합니다.
#--- Raspberry Pi 다운로드 사이트에서 Raspbian 파일을 다운로드 합니다.
#---     2018-11-13-raspbian-stretch.img
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
###     필요한 경우, Serial (UART)를 설정 한다.
### ------------------------------------------------------------------------------------------------
#--- USB to RS232 TTL 시리얼 변환 케이블 연결
#---     VCC	: 5V (적색)			: 라즈베리파이 앞줄 2번째
#---     GND	: 검정색			: 라즈베리파이 앞줄 3번째
#---     RXD	: 수신 (흰색)			: 라즈베리파이 앞줄 4번째 <-> TXD 연동
#---     TXD	: 전송 (녹색)		:	: 라즈베리파이 앞줄 5번째 <-> RXD 연동

#--- Raspberry Pi에서 Serial 통신 설정
#---     "시작 > 기본 설정 > Raspberry Pi Configuration > Interfaces" 메뉴 선택
#---         Serial Port		: Enable
#---         Serial Console		: Enable (Putty로 접속시 설정), Disable (시리얼 통신시 설정)

vi  /boot/config.txt
    enable_uart=1
    # disable bluetooth
    dtoverlay=pi3-disable-bt
systemctl  disable  hciuart
reboot

# stty  -F  /dev/ttyAMA0  115200

#--- Windows 10에서 장치 드라이브 설치
#---     PL2303_64bit_Installer.exe 프로그램을 설치
#---     "장치 관리자 > 포트(COM & LPT) > Prolific USB-to-Serial Comm Port(COM5)" 메뉴에서 확인

#--- Putty를 사용하여 접속
#---     Serial line : COM5
#---     Speed       : 115200
#---     접속 형식   : 시리얼

### ------------------------------------------------------------------------------------------------
###     기본적인 환경을 설정 한다.
### ------------------------------------------------------------------------------------------------
#--- SSH로 접속하여 작업 한다.
#--- VNC Viewer로 접속하여 작업 한다.
vi  ~/.bashrc
    alias dir='ls -alF'
    alias show='cat ~/README.md'
    alias cdiot='cd /work/appl/obcon_iot'

#--- WiFi 설정
# cp ${TEMPLATE_DIR}/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf
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
    gpio readall

    cd /work/appl/obcon_iot

    tail -f /work/appl/obcon_iot/logs/OBCon_IoT.log
    tail -f /work/appl/obcon_iot/logs/OBCon_IoT_Daemon.log

apt  update
apt  upgrade
# reboot

# apt  install  fonts-unfonts-core  fonts-nanum  fonts-nanum-extra
apt  install  fonts-nanum  fonts-nanum-coding  fonts-nanum-extra
# reboot 

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

# crontab -e
#     * * * * * /work/bin/raspberrypi.bash

### ------------------------------------------------------------------------------------------------
###     시간 설정
### ------------------------------------------------------------------------------------------------
#--- RTC (Real Time Clock)을 사용할 예정이므로 ntp를 사용하지 않도록 설정 한다.
timedatectl set-ntp false
timedatectl status
# timedatectl set-time "2018-07-24 16:40:00"

# timedatectl list-timezones
# timedatectl set-timezone "Asia/Seoul"

systemctl disable systemd-timesyncd.service
# systemctl status systemd-timesyncd.service
# vi  /etc/systemd/timesyncd.conf

### ------------------------------------------------------------------------------------------------
###     한글 설정과 keyboard 설정
### ------------------------------------------------------------------------------------------------
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
# reboot
# matchbox-keyboard                                         #--- OnScreen Keyboard를 화면에 표시
# DISPLAY=:0.0 matchbox-keyboard

### ------------------------------------------------------------------------------------------------
###     Python3 개발 환경 구성
### ------------------------------------------------------------------------------------------------
apt  install  python3 python3-setuptools  python3-pip  python3-virtualenv  python3-venv
apt  install  python3-pyqt5*  python3-pyqtgraph
apt  install  python3-dateutil

apt  install  sqlite3

mkdir -p /work/appl/obcon_iot
chown pi:pi /work/appl/obcon_iot
cd /work/appl/obcon_iot

pip3 install configparser

apt  install  libatlas3-base
pip3 install  numpy
pip3 install  pandas
pip3 install  matplotlib

#--- GPIO 개발 환경 구성
apt  install  python3-gpiozero python3-rpi.gpio python3-pigpio
pip3 install  spidev
#--- "시작 > 기본 설정 > Raspberry Pi Configuration > Interfacesa > SPI"를 "Enable"로 설정 한다.
reboot
ls -alF /dev/spidev0.0 /dev/spidev0.1

#--- Serial (UART) 개발 환경 구성
# apt  install  python3-serial
pip3  install  pyserial

#--- Arduino 통합 개발 환경 설치
#--- http://thrillfighter.tistory.com/583
#---     https://www.arduino.cc/en/Main/Software : arduino-1.8.7-windows.exe
# apt install arduino

#--- Touch Screen 사용 준비
#---     https://github.com/linusg/rpi_backlight
#---          /etc/udev/rules.d/backlight-permissions.rules
pip3  install  rpi_backlight

vi  /etc/udev/rules.d/backlight-permissions.rules
    SUBSYSTEM=="backlight",RUN+="/bin/chmod 666 /sys/class/backlight/%k/brightness /sys/class/backlight/%k/bl_power"

#--- Input Device 사용 준비
pip3 install evdev

### ------------------------------------------------------------------------------------------------
###     obcon_iot 프로그램 로딩 후 설정
### ------------------------------------------------------------------------------------------------
mkdir  -p  /work/appl/obcon_iot
cd  /work/appl/obcon_iot

cp config_override.conf_old config_override.conf
chmod  755  *.bash

cd /work/appl/obcon_iot/interfaces/TouchScreen
chmod  755  timeout  run-timeout.bash


# crontab -e
#    * * * * * /work/bin/raspberrypi.bash
#    0 1 * * * /usr/bin/python3 /work/appl/obcon_iot/WatchDog.py
#    * * * * * /work/appl/obcon_iot/OBCon_IoT_Daemon.bash  watchdog

#--- Python을 서비스로 등록
# vi /etc/systemd/system/obcon_daemon.service
#     [Unit]
#     After=multi-user.target
#     
#     [Service]
#     ExecStart=/usr/bin/python3 /work/appl/obcon_iot/OBCon_IoT_Daemon.py
#     
#     [Install]
#     WantedBy=default.target
# systemctl daemon-reload
# 
# systemctl  enable  obcon_daemon
# systemctl  start   obcon_daemon
# systemctl  status  obcon_daemon

# apt  list  --installed
# pip3  list
# pip3  freeze

cd /home/pi/Desktop
ln -s /work/appl/obcon_iot/OBCon_IoT.bash OBCon_IoT.bash
ln -s /work/appl/obcon_iot/OBCon_IoT_No.bash OBCon_IoT_No.bash

### ------------------------------------------------------------------------------------------------
###     pigpio를 설정 한다.
### ------------------------------------------------------------------------------------------------
#--- "시작 > 기본 설정 > Raspberry Pi Configuration > Interfaces" 메뉴를 선택 한다.
#--- "Remote GPIO"를 "Enable"로 설정 한다.
systemctl  enable  pigpiod.service
systemctl  start   pigpiod.service	

#--- Windows에서 pigpio를 설치 한다.
#--- export PIGPIO_ADDR=soft, export PIGPIO_PORT=8888
#--- pigpio.pi('hostname', 8888)

### ------------------------------------------------------------------------------------------------
###     Raspberry Pi에 CPP 개발 환경 구성
### ------------------------------------------------------------------------------------------------
#--- Raspberry에서 c++ 개발 환경 설정
apt install openssh-server g++ gdb gdbserver

#--- WiringPi 2.46 설치
apt install wiringpi
gpio -v
gpio readall

# gcc -o hello hello.c
# ./hello

### ------------------------------------------------------------------------------------------------
###     ADS1256 설정
### ------------------------------------------------------------------------------------------------
#--- BCM2835 설치
# vi  /boot/config.txt
#     dtparam=spi=on
# 
# lsmod | egrep '2835|spi'
#     spidev                 16384  0
#     snd_bcm2835            32768  1
#     snd_pcm                98304  1 snd_bcm2835
#     snd                    69632  5 snd_timer,snd_bcm2835,snd_pcm
#     i2c_bcm2835            16384  0
#     spi_bcm2835            16384  0

mkdir -p /work/download
cd /work/download

# #--- http://www.airspayce.com/mikem/bcm2835/
# #---     http://www.airspayce.com/mikem/bcm2835/bcm2835-1.57.tar.gz
# #---     https://www.waveshare.com/wiki/File:Bcm2835-1.45.tar.gz
# #---     https://www.waveshare.com/wiki/File:Bcm2835-1.39.tar.gz
# wget http://www.airspayce.com/mikem/bcm2835/bcm2835-1.57.tar.gz
# gzip -d bcm2835-1.57.tar.gz
# tar xvf bcm2835-1.57.tar
# # tar zxvf bcm2835-1.57.tar
# 
# cd bcm2835-1.57
# ./configure
# make
# make check
# make install
# 
# dir /proc/device-tree/soc/ranges

#--- High-Precision-AD-DA-Board-Code 설치
#---     https://www.waveshare.com/wiki/File:High-Precision-AD-DA-Board-Code.7z
#---     interfaces/ADS1256/ 폴더에 업로드
cd /work/download
wget  https://www.waveshare.com/w/upload/5/5e/High-Precision-AD-DA-Board-Code.7z
#--- 압축을 풀어 interfaces/ADS1256/ 폴더에 AD-DA/, ADS1256/, DAC8532/ 폴더를 생성 한다.

#--- SPI Python 모듈 제작 준비
#---     https://github.com/fabiovix/py-ads1256
#---     https://github.com/kizniche/pyadda
cd /work/download
wget  https://codeload.github.com/jaxbulsara/pyadda/zip/master -O pyadda-master.zip
unzip pyadda-master.zip
#--- setup.py, wrapper.h, wrapper.c 파일을 interfaces/ADS1256/ADS1256/ 폴더로 복사 한다.

#--- 테스트 및 모듈 제작
cd /work/appl/obcon_iot/interfaces/ADS1256/ADS1256
make
# gcc ads1256_test.c -o ads1256_test -lbcm2835
./ads1256_test

#--- setup.py, wrapper.h, wrapper.c 파일 작성 한다.
python3 setup.py install
# python3 channel_read_example.py
python3 ads1256_test.py

### ------------------------------------------------------------------------------------------------
###     MQTT (Message Queuing Telemetry Transport) 환경 구성
###     http://mosquitto.org/
### ------------------------------------------------------------------------------------------------
apt  install  mosquitto

vi  /etc/mosquitto/mosquitto.conf
    allow_anonymous false
    password_file /etc/mosquitto/passwd

# cp ${TEMPLATE_DIR}/passwd /etc/mosquitto/passwd
touch  /etc/mosquitto/passwd
mosquitto_passwd -b /etc/mosquitto/passwd 아이디 비밀번호     #--- 사용자 추가/수정
mosquitto_passwd -D /etc/mosquitto/passwd 아이디              #--- 사용자 삭제

systemctl  restart  mosquitto.service
systemctl  enable   mosquitto.service

netstat -tln | grep 1883

pip3 install paho-mqtt
# apt  install  paho-mqtt

### ------------------------------------------------------------------------------------------------
###     절전 : 화면 보호기, Backlight off
###     -   화면 보호기 default : 10분
### ------------------------------------------------------------------------------------------------
#--- 화면 보호기
#---     https://wiki.archlinux.org/index.php/XScreenSaver
apt install xscreensaver
# "시작 > 기본 설정 > 화면보호기" 메뉴에서 설정
#     표시 모드
#         모드 : Disable Screen Saver

# nouse "시작 > 기본 설정 > 화면보호기" 메뉴에서 설정
#     표시 모드
#         모드 : Blank Screen Only
#         화면 꺼지는 시간 : 1분
#         화면 보호기 변경 시간 : 1분
#     고급 설정
#         전원 관리 사용 : 선택 않음
#         Quick Power-off in Blank Only Mode : 선택
#     vi  /home/pi/.xscreensaver

# vi  /boot/cmdline.txt
#     consoleblank=300                                        #--- 화면이 꺼지기까지 대기하는 초
#     consoleblank=0                                          #--- 화면이 절대 꺼지지 않음
# cat /sys/module/kernel/parameters/consoleblank

# vi  /etc/lightdm/lightdm.conf
#     #--- -s 0  : Screen Saver timeout : 0
#     #--- -dpms : Display Power Manager Service 끄기
#     [SeatDefaults]
#     # [Seat:*]
#     xserver-command=X -s 0 -dpms

#--- DPMS (Display Power Management)
#---     https://wiki.archlinux.org/index.php/Display_Power_Management_Signaling
apt install xfce4-power-manager
# "시작 > 기본 설정 > 전원 관리자" 메뉴에서 설정

#--- https://github.com/timothyhollabaugh/pi-touchscreen-timeout
#---     주의 : 화면 보호기의 기능을 끄세요.
# cd /work/download
# git clone https://github.com/timothyhollabaugh/pi-touchscreen-timeout.git
# cd pi-touchscreen-timeout

cd  /work/appl/obcon_iot/interfaces/TouchScreen
gcc timeout.c -o timeout
# dir /dev/input/event*
# ./timeout 60 event1
/bin/cp timeout /usr/local/bin/timeout

# cd  /work/appl/obcon_iot
# /bin/cp -f /work/appl/obcon_iot/rc.local /etc/rc.local
# /bin/echo 0 > /sys/class/backlight/rpi_backlight/bl_power
# /usr/bin/nice -n 19 /work/appl/obcon_iot/interfaces/Touchscreen/timeout 60 event0 &

# setterm -powersave off -powerdown 0 -blank 0
# xset q                                                      #--- 설정 조회
# # xset dpms force off
# systemctl status rpi-display-backlight
# echo 0 > /sys/class/backlight/rpi_backlight/bl_power        #--- On
# echo 1 > /sys/class/backlight/rpi_backlight/bl_power        #--- Off
# 
# cat  /sys/class/backlight/rpi_backlight/bl_power

### ------------------------------------------------------------------------------------------------
###     자동 실행 등록
### ------------------------------------------------------------------------------------------------
reboot 

/bin/cp  -f  /work/appl/obcon_iot/rc.local /etc/rc.local

# /bin/cp  -f  /work/appl/obcon_iot/obcondaemon.service /lib/systemd/system
# systemctl daemon-reload
# systemctl enable obcondaemon.service
# systemctl start  obcondaemon.service

/bin/cp  -f  /work/appl/obcon_iot/OBCon.desktop  /etc/xdg/autostart

# /bin/cp  -f  /work/appl/obcon_iot/obcon.service       /lib/systemd/system
# systemctl daemon-reload
# systemctl enable obcon.service
# systemctl start  obcon.service

crontab -e
    * * * * * /work/bin/raspberrypi.bash
    0 1 * * * /usr/bin/python3 /work/appl/obcon_iot/WatchDog.py
    * * * * * /work/appl/obcon_iot/OBCon_IoT_Daemon.bash  watchdog

### ------------------------------------------------------------------------------------------------
###     기본 설정
### ------------------------------------------------------------------------------------------------
# "시작 > 기본 설정" 메뉴에서 다음을 설정 한다.
# "Raspberry Pi Configurationi > Interfaces" 메뉴를 선택 한다.
#     SSH : Enable
#     VNC : Enable
#     SPI : Enable
#     I2C : Enable
#     Serial Port : Enable
#     Serial Console : Enable
#     Remote GPIO : Disable (사용할 경우에는 Enable로 설정)
# "화면 보호기" 메뉴를 선택 한다.
#     "표시 모드" 탭에서 "Disable Screen Saver" 모드를 선택 한다.
# "전원 관리자" 메뉴를 선택 한다.
#     "시스템" 탭에서 "시스템이 대기 상태에 진입할 때 화면 잠금"을 선택하지 않는다.
#     "화면" 탭에서 "화면 전력 관리 조정"을 선택하지 않는다.

# WiFi를 끄고 reboot 한다.








### ------------------------------------------------------------------------------------------------
###     Windows에 CPP 개발 환경 구성
###         https://makersweb.net/qt/6258
### ------------------------------------------------------------------------------------------------
#--- Visual Studio Community 2017 설정
#---     "C++을 사용한 Linux 개발" 설치

#--- EClipse cpp 설치
#---     https://www.eclipse.org/ide/

#--- Raspberry Pi Toolchain 설치
#---     http://gnutoolchains.com/raspberry/
#---         raspberry-gcc6.3.0-r3.exe
#--- raspberry-gcc6.3.0-r3.exe 설치
#---
#--- sysroot 동기화
#---    반드시 최초 1회 실행
#---    반드시 Raspberry Pi에 새로운 라이브러리를 설치한 경우 실행
#--- TOOLS/UpdateSysroot.bat

#--- EClipse 환경 설정
#---     "Help > Install New Software > --All Available Sites--" 메뉴를 선택 한다.
#---         XXX "Mobile and Device Development" 설치
#---         C/C++ GCC Cross Compiler Support
#---         C/C++ Remote Launch
#---         Remote System Explorer User Actions

### ================================================================================================

