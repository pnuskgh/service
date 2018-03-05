## Hyper-V에서 CentOS 7 이미지 생성

* 이름 : CentOS_7_64
* 세대 : 1세대
* 메모리 : 2048 MB (동적 메모리를 사용하지 않음)
* 네트워킹 : Public Switch (외부 네트워크를 사용하는 스위치)
* 하드 디스크 : CentOS_7_64.vhdx, 8 GB

* 소프트웨어 선택 : 최소 설치
* 설치 대상
  * 수동으로 파티션 설정
  * 표준 파티션
  * "+" 버튼을 눌러 마운트 지점 추가 : /, 8191MiB, 표준 파티션, ext4 파일 시스템 (/dev/sda)
* 네트워크 및 호스트명
  * 호스트 이름 : localhost.jopenbusiness.com
  * 이더넷 : 켬
* 사용자 생성 : centos

## VirtualBox 5.0.30에서 CentOS 7 이미지 생성

* CentOS_7_64 (1 core / 2048MB memory / 8GB storage)
* Network : NAT, 호스트 전용 어댑터 (192.168.56.101)
* Hostname : localhost.jopenbusiness.com
* 소프트웨어 선택 : 최소 설치
* 설치 대상 : 하나의 표준 파티션으로 재설정 (/, 8192MiB, xfs, /dev/sda)
* User : CentOS 설치시 centos 사용자를 생성 한다.

## Folders

* bin/ : 실행 파일
* conf/ : 설정 파일
* template : 템플릿 파일

## Files

* bin/centos.bash : CentOS 관리 프로그램
  * centos_init.bash

# OS Image를 생성

## Image Source

### Ubuntu Server

* http://cloud-images.ubuntu.com/
* http://cloud-images.ubuntu.com/trusty/current/
* http://uec-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img

### Windows

* http://www.cloudbase.it/ws2012r2/
* https://cloudbase.it/windows-cloud-images/

# Volume 사이즈 조정

* Size 증가
  * VBoxManage 명령어의 modifyhd를 사용하여 disk 크기를 증가 한다.
  * Windows의 디스크 관리 화면에서 드라이브의 볼륨을 증가 한다.
cd L:\work\repo_VirtualBox\OpenStack_Images\Windows_Server_2012_R2
"C:/Program Files/Oracle/VirtualBox/VBoxManage" modifyhd Windows_Server_2012_R2.vdi --resize 102400

* Size 감소
  * Windows의 디스크 관리 화면에서 드라이브의 볼륨을 감소 한다.
  * VirtualBox에서 새로운 볼륨을 생성 한다.
  * VBoxManage 명령어의 clonehd를 사용하여 디스크를 복제 한다.
  * 복제한 디스크로 기존 디스크를 교체 한다.
  * Windows의 디스크 관리 화면에서 드라이브의 볼륨을 증가 한다.
cd L:\work\repo_VirtualBox\OpenStack_Images\Windows_Server_2012_R2
"C:/Program Files/Oracle/VirtualBox/VBoxManage" createmedium --filename Windows_Server_2008_R2_1.vdi --size 40960
"C:/Program Files/Oracle/VirtualBox/VBoxManage" clonehd Windows_Server_2012_R2.vdi Windows_Server_2012_R2_1.vdi --existing

# 참고 문헌

* http://jiming.tistory.com/39

# CentOS 7

## CentOS 7 초기 설정
init_centos.bash

# CentOS 7 Image

## Hyper-V에서 CentOS 7 이미지 생성

* 이름 : CentOS_7_64
* 세대 : 1세대
* 메모리 : 2048 MB (동적 메모리를 사용하지 않음)
* 네트워킹 : Public Switch (외부 네트워크를 사용하는 스위치)
* 하드 디스크 : CentOS_7_64.vhdx, 8 GB

* 소프트웨어 선택 : 최소 설치
* 설치 대상
  * 수동으로 파티션 설정
  * 표준 파티션
  * "+" 버튼을 눌러 마운트 지점 추가 : /, 8191MiB, 표준 파티션, ext4 파일 시스템 (/dev/sda)
* 네트워크 및 호스트명
  * 호스트 이름 : localhost.jopenbusiness.com
  * 이더넷 : 켬
* 사용자 생성 : centos

## VirtualBox 5.0.30에서 CentOS 7 이미지 생성

* CentOS_7_64 (1 core / 2048MB memory / 8GB storage)
* Network : NAT, 호스트 전용 어댑터 (192.168.56.101)
* Hostname : localhost.jopenbusiness.com
* 소프트웨어 선택 : 최소 설치
* 설치 대상 : 하나의 표준 파티션으로 재설정 (/, 8192MiB, xfs, /dev/sda)
* User : CentOS 설치시 centos 사용자를 생성 한다.

## 작업 순서

* initialize.bash     : CentOS 초기 환경 설정
* make_image.bash     : 이미지 작성
* create_image.bash   : 배포를 위한 이미지 생성

* /service/bin/convert_image.bash  : 이미지 포맷 변경
* /service/bin/scp_image.bash      : 이미지 복사
* /service/bin/register_image.bash : 이미지를 OpenStack에 등록

