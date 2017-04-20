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

