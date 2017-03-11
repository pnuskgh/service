====================================================================================================
*** OS Image 생성 ***

----------------------------------------------------------------------------------------------------
--- CentOS 6.0

-   CentOS 6.0 Image : http://cloud.centos.org/centos/6/images/
    http://mirror.centos.org/centos/6/os/x86_64/
    http://isoredirect.centos.org/centos/6/isos/x86_64/

-   참고 문헌
    http://docs.openstack.org/image-guide/index.html



-   VirtualBox에서 CentOS 6 (64 bits)를 설치 한다.
    VM의 이름은 CentOS_6_64로 설정 한다.
    Storage는 8GB로 설정 한다.
    Network는 NAT와 호스트 전용 어댑터를 설정 한다.
    Install or upgrade an existing system 메뉴를 선택 한다.
    최소 설치를 한다.                                      : Basic Server를 설치 한다.
    
-   VM의 network를 설정 한다.
    -   UUID와 HWADDR (MAC addresses) 제거
    -   NM_CONTROLLED="no"
    vi /etc/sysconfig/network-scripts/ifcfg-eth0
        DEVICE=eth0
        TYPE=Ethernet
        ONBOOT=yes
        NM_CONTROLLED=no
        BOOTPROTO=dhcp                                      #--- dhcp를 지원 하여야 한다.
        DEFROUTE=yes
        PEERDNS=yes
        PEERROUTES=yes
        IPV4_FAILURE_FATAL=yes
        IPV6INIT=no
        NAME="System eth0"

    vi /etc/sysconfig/network-scripts/ifcfg-eth1
        DEVICE=eth1
        TYPE=Ethernet
        ONBOOT=yes
        NM_CONTROLLED=no
        BOOTPROTO=none
        IPADDR=192.168.10.101
        PREFIX=24
        GATEWAY=192.168.10.1
        DEFROUTE=no
        IPV4_FAILURE_FATAL=yes
        IPV6INIT=no
        NAME="System eth1"
        
    vi /etc/sysconfig/network
        NETWORKING=yes
        HOSTNAME=centos6.daouidc.com

    service network restart
    ### yum -y remove NetworkManager

-   To enable the hypervisor to reboot or shutdown an instance    
    yum -y install acpid
    chkconfig acpid on

-   VM의 초기 환경을 구성 한다.
    yum -y update
    yum -y install epel-release

-   Image Init backup
    shutdown -h now
    CentOS_6_64_1_init.vdi 파일을 생성 한다


-   VM에 cloud-init를 설정 한다.
    yum -y install cloud-init
    
    -   vi /etc/cloud/cloud.cfg
    
    groupadd centos
    useradd -m -g centos -s /bin/bash centos
    passwd centos
    
-   vi /etc/sysconfig/network
    NOZEROCONF=yes

-   vi /boot/grub/menu.lst
    serial --unit=0 --speed=115200
    terminal --timeout=10 console serial
    # Edit the kernel line to add the console entries
    kernel ... console=tty0 console=ttyS0,115200n8

-   디스크 정리
    rm -rf /etc/udev/rules.d/70-persistent-net.rules
    rm -rf /lib/udev/write_net_rules
    
    
    
    virt-sysprep -d CentOS_6_64_1.qcow2

    
-   VM의 Storage를 설정 한다.
    -   vi /etc/fstab
        # /dev/mapper/vg_centos6-lv_root /                       ext4    defaults        1 1
        # UUID=94978355-fdff-4e9b-b542-1aeb76e90707 /boot                   ext4    defaults        1 2
        # /dev/mapper/vg_centos6-lv_swap swap                    swap    defaults        0 0
        # tmpfs                   /dev/shm                tmpfs   defaults        0 0
        # devpts                  /dev/pts                devpts  gid=5,mode=620  0 0
        # sysfs                   /sys                    sysfs   defaults        0 0
        # proc                    /proc                   proc    defaults        0 0

        /dev/mapper/vg_centos6-lv_root /                       ext4    defaults        1 1
        /dev/sda1                      /boot                   ext4    defaults        1 2
        /dev/mapper/vg_centos6-lv_swap swap                    swap    defaults        0 0
        tmpfs                   /dev/shm                tmpfs   defaults        0 0
        devpts                  /dev/pts                devpts  gid=5,mode=620  0 0
        sysfs                   /sys                    sysfs   defaults        0 0
        proc                    /proc                   proc    defaults        0 0
    -   /dev/vda1

-   VM에 cloud-init를 설정 한다.
    yum -y install acpid cloud-init cloud-utils cloud-utils-growpart dracut-kernel dracut dracut-modules-growroot
    
    -   vi /etc/cloud/cloud.cfg
        users:
            - daou                                          #--- 로그인시 사용할 사용자 지정

        disable_root: 0                                     #--- 1. root로 로그인 금지
        ssh_pwauth:   1                                     #--- 1. ssh에서 password로 로그인 허용
        ssh_deletekeys:   0
        # preserve_hostname: False
        
        system_info:
          default_user:
            name: centos
            lock_passwd: true
        
    rm -rf /var/lib/cloud/*

-   VM을 OpenStack에 올리기 위해 취향대로 설정 합니다.
    systemctl disable {SERVICE_NAME}                        #--- 불필요한 서비스를 제거 한다.

    yum -y install net-tools vim tcpdump mtr traceroute tcptraceroute telnet ping
    
    vi /etc/ssh/sshd_config
        PasswordAuthentication no
        PermitRootLogin no
    
    visudo
        %sudo   ALL=(ALL:ALL) NOPASSWD: ALL
    
    groupadd cloud
    useradd -m -g sudo -s /bin/bash cloud
    passwd cloud
    
    passwd -d root
    
    rm -r /etc/udev/rules.d/70-persistent-net.rules
    rm -r /lib/udev/write_net_rules
    
    vi /etc/sysconfig/network-scripts/ifcfg-eth0
    
    

    vi /root/.ssh/authorized_keys
        no-port-forwarding,no-agent-forwarding,no-X11-forwarding,command="echo 'Please login as the user \"centos\" rather than the user \"root\".';echo;sleep 10" ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAoMfoVXmwBOjs0R73i/aFfhubw84qr3RZDRKDvW5JbTyY5zvRwR9MunhvTPEw68dwnVEh6JURU1/rpPrvo5+w5qaButUjXjK0fiyiQQGAEGNQOX9aNzOt9Db8ZpBLLswnZd9tdsj1+7ApzJ8LxSObauxsqumQIGn59booCU6buLD0sxdlU1UxNK1wwEIzytcKc4VMcuixFEq9qJMv3jq0Dhr3Q== manage001@daouidc.com    

    
    
-   VM을 종료 한다.
    rm -f /var/cache/yum/*

    cp /dev/null /root/.bash_history
    history -c
    
    rm -f ~root/.bash_history
    rm -f ~root/.ssh/authorized_keys
    rm -f ~daou/.bash_history
    rm -f ~daou/.ssh/authorized_keys
    
    rm -fr /var/lib/cloud/*
    shutdown -h now



-   manage001 node에서 VM disk를 변환 한다.
    -   yum -y install libguestfs-tools

    mv CentOS_6_61_1.vdi CentOS_6_64_1.vdi
    qemu-img convert -c -f vdi -O qcow2 CentOS_6_64_1.vdi CentOS_6_64_1.qcow2
    
    openstack image list
    openstack image delete "CentOS 6_1, test"
    openstack image create --container-format bare --disk-format qcow2 --min-disk 8 --min-ram 512 --file CentOS_6_64_1.qcow2 --public "CentOS 6_1, test"



    
    
    

[root@cent7 ~]# vi /etc/cloud/cloud.cfg
    #users:  ----- 이 두 줄을 주석처리한다.. 
    # - default -- 사실 해도 되는지는 잘 모르겠으나, 이렇게 하니깐 잘되었다... 쩝~
     
    disable_root: false
    ssh_pwauth: false

grub2-mkconfig -o /boot/grub2/grub.cfg


[root@cent7 ~]# vi /etc/sysconfig/selinux
    SELINUX=disabled
    SELINUXTYPE=targeted


[root@cent7 ~]# vi /etc/sysconfig/network
NOZEROCONF=yes



/var/log/cloud*



-   Trouble shooting
    the superblock could not read or does not describe a correct ext2 filesystem.
    /dev/sda1
    
filename must be either an absolute



====================================================================================================
