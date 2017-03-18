# Windows Server 2008 R2 이미지 생성

## 사전 준비 사항

* VirtualBox : https://www.virtualbox.org/wiki/Downloads
* Virtio : http://www.linux-kvm.org/page/WindowsGuestDrivers/Download_Drivers
* Cloudbase-init : https://cloudbase.it/cloudbase-init/#download

## VirtualBox 5.0.30에서 Windows Server 이미지 생성

* Windows_Server_2008_R2 (4 core / 4096MB memory / 25GB storage)
* Network : NAT
* CD 1 : win_svr_std2008_R2_64bit.ISO
* CD 2 : virtio-win-0.1.126.iso

## Windows Server 설치

* 설치할 언어 : 한국어
* 시간 및 통화 형식 : 한국어(대한민국)
* 키보드 또는 입력 방법 : Microsoft 한글 입력기
* 키보드 종류 : PC/AT 101키 호환 키보드(종류 1)
* "지금 설치" 버튼을 선택
* 운영 체제 (Operating System) : Windows Server 2008 R2 Standard(전체 설치)
* 설치 유형 (Install Type) : 사용자 지정(고급)
* 드라이버 로드 (Load driver)
  * virtio-win-0.1.1 > Balloon > 2k8R2 > amd64
  * virtio-win-0.1.1 > viostor > 2k8R2 > amd64
  * virtio-win-0.1.1 > NetKVM > 2k8R2 > amd64

## Windows Server 설정

### 원격접속(RDP) 허용

"시작 > 컴퓨터" 메뉴에서 오른쪽 마우스를 선택한 후 "속성"을 선택 한다.  
좌측에 있는 "원격 설정" 메뉴을 선택 한다.  
* "네트워크 수준 인증을 사용하여 원격 데스크톱을 실행하는 컴퓨터에서만 연결 허용" 체크  
 
 
"시작 > 관리 도구 > 원격 데스크톱 서비스 > 원격 데스크톱 세션 호스트 구성" 메뉴를 선택 한다.  
"연결"에서 "RDP-tcp"를 선택 한다.  
"연결 이름: RDP-Tcp" 아래에서 "연결 사용"으로 설정 한다.  
 
 
"시작 > 제어판 -> 시스템 및 보안 -> Windows 방화벽 -> Windows 방화벽을 통해 앱 또는 기능 허용" 메뉴를 선택 한다.  
* Windows 원격 관리 : 홈/회사(개인), 공용  
* 원격 데스크톱 : 홈/회사(개인), 공용  

### Windows 정품 인증

"시작 > 컴퓨터" 메뉴에서 오른쪽 마우스를 선택한 후 "속성"을 선택 한다.  
"제품 키 변경" 링크를 선택 한다.  
제품 키를 입력 한다.

### Windows 업데이트

"시작 > 컴퓨터" 메뉴에서 오른쪽 마우스를 선택한 후 "속성"을 선택 한다.  
"Windows Update" 메뉴를 선택 한다.  
"자동 업데이터 사용" 버튼을 선택 한다.  

### 필요한 환경 구성

각 이미지에 맞는 환경을 구성 한다.

##  Cloudbase-Init 설치

이 Step을 진행하고 나서는 더 이상 VM에 커스터마이징 할 수 없습니다.  

CD에 cloudbase.iso 파일을 추가 한다.  
CloudbaseInitSetup_0_9_9_x64.msi 파일을 실행 한다.  
* Username : Admin (자동으로 추가되는 사용자 아이디)
* Use metadata password : "--meta admin_pass=" 메타 데이터를 사용하여 비밀번호 초기 설정 허용
* User's local groups (comma separated list) : Administrators (추가되는 사용자가 소속될 그룹)
* Serial port for logging :

설치가 마무리되는 시점에, 아래 체크 박스를 선택하고 'Finish' 버튼을 클릭합니다.  
* Run Sysprep to create a generalized image. This is necessary if you plan to duplicate this instance, for example by creating a Glance image.

C:/Program Files/Cloudbase Solutions/Cloudbase-Init/conf/cloudbase-init.conf  
* logging_serial_port_settings=COM1,115200,N,8

C:/Program Files/Cloudbase Solutions/Cloudbase-Init/conf/cloudbase-init-unattend.conf  
* logging_serial_port_settings=COM1,115200,N,8

Windows를 종료하고 디스크를 이미지로 변환하여 사용 한다.

## Windows Server로 이미지 생성 후 작업

* 콘솔로 접속 한다.
* Administrator를 선택 한다.
* "로그인하기 전에 사용자 암호를 변경해야 합니다."라는 메시지가 표시되면 "확인" 버튼을 선택 한다.
* "새 암호"와 "암호 확인"을 입력 한다.
* Administrator로 로그인하여 사용하면 된다.
  * 처음 로그인할 때 시간이 조금 오래 걸리므로 기다리세요.
  * Admin으로 로그인 하려면 Admin의 비밀번호를 설정 하여야 합니다.

