* Git 설치 및 환경 구성
  * Git 설치
  * Bare 저장소 생성

* Git 기능 정의
  * Protocol : Local, SSH (22/tcp), Git, HTTP/HTTPS (80/tcp, 443/tcp)
    * Local : git clone /~/~.git
    * SSH : git clone ssh://user@server:/~/~.git
    * HTTP : git clone http://server/~/~.git

* Git Server 구성 방안 (https://git.wiki.kernel.org/index.php/GitHosting)
  * git daemon
  * Git + Gitolite + GitWeb(Nginx)
  * GitLab (https://about.gitlab.com/)
    * http://bluebild.iptime.org/wiki/index.php/Centos_7_GitLab_%EC%84%A4%EC%B9%98

  * RocketGit (https://rocketgit.com/)
  * Gerrit
  * Gitosis : 공개키 관리
  * Gitolite : 접근 제어
  * SCM-Manager(https://www.scm-manager.org/), GitBucket(https://github.com/gitbucket/gitbucket)

* 참고 문헌
  * http://indienote.tistory.com/80
  * http://indienote.tistory.com/81

