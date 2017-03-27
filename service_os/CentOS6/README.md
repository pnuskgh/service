# CentOS 6 Image

## VirtualBox 5.0.30에서 CentOS 6 이미지 생성

* CentOS_6_64 (1 core / 2048MB memory / 8GB storage)
* Network : NAT, 호스트 전용 어댑터 (192.168.56.101)

## CentOS 6 설치
* "Install or upgrade an existing systemi" 메뉴를 선택 한다.
* Disc Found에서 "Skip" 버튼을 선택 한다.
* 언어에서 "Korean (한국어)"를 선택 한다.
* 키보드에서 "한국어"를 선택 한다.
* "기본 저장 장치"를 선택 한다.
  * "예, 모든 데이터를 삭제 합니다." 버튼을 선택 한다.
* 호스트명 : localhost.jopenbusiness.com
  * "네트워크 설정" 버튼을 선택 한다.
  * System eth0에서 "자동으로 연결"을 체크 한다.
  * System eth1에서 "자동으로 연결"을 체크 한다.
* 시간대를 "아시아/서울(Seoul)"을 선택 한다.
  * "시스템의 시간을 UTC에 맞춤"을 체크 한다.
* Root 암호 : 원하는 암호를 입력 한다.
* "모든 공간 사용"을 체크 한다.
  * "파티션 레이아웃 확인 및 변경"을 체크 한다.
* "재설정" 버튼을 선택하여 파티션 정보를 모두 삭제 한다.
  * "만들기" 버튼을 선택 한다.
  * "표준 파티션"을 체크하고 "생성" 버튼을 선택 한다.
    * 마운트 지점 : /
    * 파일 시스템 유형 : ext4
    * "가능한 최대 용량으로 채움" 선택
* "/dev/sda 상에 부트로더 설치"를 선택 한다.
* "Minimal" 설치를 선택 한다.

## 작업 순서

* initialize.bash     : CentOS 초기 환경 설정
* make_image.bash     : 이미지 작성
* create_image.bash   : 배포를 위한 이미지 생성

* convert_image.bash  : 이미지 포맷 변경
* scp_image.bash      : 이미지 복사
* register_image.bash : 이미지를 OpenStack에 등록

# 참고 문헌
* CentOS 6.0 Image : http://cloud.centos.org/centos/6/images/
  * http://mirror.centos.org/centos/6/os/x86_64/
  * http://isoredirect.centos.org/centos/6/isos/x86_64/

* http://docs.openstack.org/image-guide/index.html

