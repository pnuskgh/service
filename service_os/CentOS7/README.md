# CentOS 7 Image

## Hyper-V에서 CentOS 7 이미지 생성

* 이름 : CentOS_7_64
* 세대 : 1세대
* 메모리 : 2048 MB (동적 메모리를 사용하지 않음)
* 네트워킹 : Public Switch (외부 네트워크를 사용하는 스위치)
* 하드 디스크 : CentOS_7_64.vhdx, 8 GB

* 소프트웨어 선택 : 최소 설치
* 설치 대상
** 수동으로 파티션 설정
** 표준 파티션
** "+" 버튼을 눌러 마운트 지점 추가 : /, 8191MiB, 표준 파티션, xfs 파일 시스템 (/dev/sda)
* 네트워크 및 호스트명
** 호스트 이름 : localhost.jopenbusiness.com
** 이더넷 : 켬
* 사용자 생성 : centos

## VirtualBox 5.0.30에서 CentOS 7 이미지 생성

* CentOS_7_64 (1 core / 2048MB memory / 8GB storage)
* Network : NAT, 호스트 전용 어댑터 (192.168.56.101)
* Hostname : localhost.jopenbusiness.com
* 소프트웨어 선택 : 최소 설치
* 설치 대상 : 하나의 표준 파티션으로 재설정 (/, 8192MiB, xfs, /dev/sda)
* User : CentOS 설치시 centos 사용자를 생성 한다.

## 작업 순서

* initialize.bash : CentOS 초기 환경 설정
* make_image.bash : 이미지 작성
* create_image.bash  : 배포를 위한 이미지 생성

* convert_image.bash : 이미지 포맷 변경
* scp_image.bash      : 이미지 복사
* register_image.bash : 이미지를 OpenStack에 등록

