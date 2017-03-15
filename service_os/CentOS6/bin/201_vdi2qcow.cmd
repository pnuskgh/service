rem ### ================================================================================================
rem ###     프로그램 명     : 201_vdi2qcow.cmd, Version 0.00.001
rem ###     프로그램 설명   : VirtualBox의 vdi 이미지를 qcow2 이미지로 변환 한다.
rem ###     작성자          : 산사랑 (pnuskgh@gmail.com, www.jopenbusiness.com)
rem ###     작성일          : 2017.01.06 ~ 2017.01.06
rem ### ----[History 관리]------------------------------------------------------------------------------
rem ###     수정자         	:
rem ###     수정일         	:
rem ###     수정 내용      	:
rem ### --- [Copyright] --------------------------------------------------------------------------------
rem ###     Copyright (c) 1995~2017 pnuskgh, 오픈소스 비즈니스 컨설팅
rem ###     All rights reserved.
rem ### ================================================================================================

rem ### ------------------------------------------------------------------------------------------------
rem ###     VirtualBox의 vdi 이미지를 qcow2 이미지로 변환 한다.
rem ###         qcow2를 VirtualBox에서 지원하지 않는다는 오류가 발생함
rem ### ------------------------------------------------------------------------------------------------
d:
cd D:/001_work/VirtualBox/Images

cd CentOS6_64
"C:/Program Files/Oracle/VirtualBox/VBoxManage" clonehd  CentOS6_64.vdi CentOS6_64.qcow2 --format qcow2
cd ..

pause ...

rem ### ================================================================================================
