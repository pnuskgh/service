# MSSQL(Microsoft SQL) Server 이미지 생성

## 사전 준비 사항

* Windows Server 2012 R2 이미지
* Windows Server 2008 R2 이미지

* VirtualBox 이미지 이름 : MSSQL_for_Windows_Server_2012
* Volume 용량 100 GB

## 설치 파일

* SW_DVD9_SQL_Svr_Standard_Edtn_2012w_SP3_64Bit_Korean_MLF_X20-66886.ISO
* SW_DVD5_NTRL_SQL_Svr_DC_Ent_Std_Wkgrp_Web_SmBiz_Dev_2008_R2SP3_Korean_X19-78394.ISO
* SW_DVD9_SQL_Svr_Standard_Edtn_2008_R2_Korean_MLF_X16-29608.ISO

## MSSQL(Microsoft SQL) Server 설치 for Windows Server 2012

setup.exe 파일을 실행 한다.  

* "설치 > 새 SQL Server 독립 실행형 설치 또는 기존 설치에 기능 추가" 메뉴를 선택하여 설치를 시작 한다.  
* "설치 역할"에서 "SQL Server 기능 설치"를 선택 한다.  
* "기능 선택"에서 "모두 선택" 버튼을 선택 한다.  
* "인스턴스 구성"에서 "기본 인스턴스"를 선택 한다.  
* "데이터베이스 엔진 구성"에서 "혼합 모드"를 선택한 후 암호를 입력 한다. (sa / 비밀1234!@#$)
  * "현재 사용자 추가" 버튼을 선택하여 사용자를 추가 한다.
* "Analysis Services 구성"에서 "현재 사용자 추가" 버튼을 선택 한다.
* "Reporting Services 구성"에서 아래와 같이 구성 한다.
  * Reporting Services 기본 모드 : 설치 및 구성
  * Reporting Services SharePoint 통합 모드 : 설치만
* "Distributed Replay Controller"에서 "현재 사용자 추가" 버튼을 선택 한다.

## MSSQL(Microsoft SQL) Server 설정 for Windows Server 2012


