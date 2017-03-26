# MSSQL(Microsoft SQL) Server 이미지 생성

## 사전 준비 사항

* Windows Server 2012 R2 이미지 (4 core / 4096 GB memory / 100 GB storage)
  * 이미지 이름 : MSSQL_for_Windows_Server_2012 (SQL Server 2012 R2)
* Windows Server 2008 R2 이미지 (4 core / 6144 GB memory / 100 GB storage)
  * 이미지 이름 : MSSQL_for_Windows_Server_2008 (SQL Server 2008 R2)
  * Microsoft .NET Framework 설치
  * 업데이트된 Windows Installer를 설치

## 설치 파일

* SW_DVD9_SQL_Svr_Standard_Edtn_2012w_SP3_64Bit_Korean_MLF_X20-66886.ISO
* SW_DVD9_SQL_Svr_Standard_Edtn_2008_R2_Korean_MLF_X16-29608.ISO
  * SW_DVD5_NTRL_SQL_Svr_DC_Ent_Std_Wkgrp_Web_SmBiz_Dev_2008_R2SP3_Korean_X19-78394.ISO

## MSSQL(Microsoft SQL) Server 설치 for Windows Server 2012

setup.exe 파일을 실행 한다.  

* "설치 > 새 SQL Server 독립 실행형 설치 또는 기존 설치에 기능 추가" 메뉴를 선택하여 설치를 시작 한다.  
* 제품 키 : 제품 키를 입력 한다.

* 설치 지원 규칙 : "다음"을 선택 한다.
* 설치 역할 : "SQL Server 기능 설치"를 선택 한다.  
* 기능 선택 : "모두 선택" 버튼을 선택 한다.  
* 설치 규칙 : "다음"을 선택 한다.
* 인스턴스 구성 : "기본 인스턴스"를 선택 한다.  
* 디스크 공간 요구 사항 : "다음"을 선택 한다.
* 서버 구성 : "다음"을 선택 한다.
* 데이터베이스 엔진 구성 :
  * "혼합 모드"를 선택한 후 암호를 입력 한다. (sa / 비밀1234!@#$)
  * "현재 사용자 추가" 버튼을 선택하여 사용자를 추가 한다.
* Analysis Services 구성 : "현재 사용자 추가" 버튼을 선택 한다.
* Reporting Services 구성 : 아래와 같이 구성 한다.
  * Reporting Services 기본 모드 : 설치 및 구성
  * Reporting Services SharePoint 통합 모드 : 설치만
* Distributed Replay Controller : "현재 사용자 추가" 버튼을 선택 한다.
* Distributed Replay Client : "다음"을 선택 한다.
* 오류 보고 : "다음"을 선택 한다.
* 설치 구성 규칙 : "다음"을 선택 한다.
* 설치 준비 : "설치"를 선택 한다.

## MSSQL(Microsoft SQL) Server 설치 확인 for Windows Server 2012

SQL Server Management Studio 프로그램을 실행 한다.
* 서버 유형 : 데이터베이스 엔진
* 서버 이름 : 생략
* 인증 : SQL Server 인증
  * 로그인 : sa
  * 암호 : 비밀1234!@#$

"연결" 버튼을 선택 한다.

## MSSQL(Microsoft SQL) Server 설치 for Windows Server 2008

setup.exe 파일을 실행 한다.

* Microsoft .NET Framework와 업데이트된 Windows Installer를 설치 하라는 메시지가 나오면 "확인" 버튼을 눌러 설치를 진행 한다.

* "설치 > 새로 설치하거나 기존 설치에 기능을 추가합니다." 메뉴를 선택하여 설치를 시작 한다.
* 제품 키 : 제품 키를 입력 한다.

* 설치 지원 규칙 : "다음"을 선택 한다.
* 설치 역할 : "SQL Server 기능 설치"를 선택 한다.
* 기능 선택 : "모두 선택" 버튼을 선택 한다.
* 설치 규칙 : "다음"을 선택 한다.
* 인스턴스 구성 : "기본 인스턴스"를 선택 한다.
* 디스크 공간 요구 사항 : "다음"을 선택 한다.
* 서버 구성 : "다음"을 선택 한다.
  * "~ 자격 증명이 잘못되었습니다." 오류가 발생하면 아래와 같이 설정 한다.
  * SQL Server 에이전트 : NT AUTHORITY\SYSTEM
  * SQL Server Database Engine : NT AUTHORITY\SYSTEM
  * SQL Server Analysis Services : NT AUTHORITY\NetworkService
  * SQL Server Reporting Services : NT AUTHORITY\NetworkService
* 데이터베이스 엔진 구성 :
  * "혼합 모드"를 선택한 후 암호를 입력 한다. (sa / 비밀1234!@#$)
  * "현재 사용자 추가" 버튼을 선택하여 사용자를 추가 한다.
* Analysis Services 구성 : "현재 사용자 추가" 버튼을 선택 한다.
* Reporting Services 구성 : 아래와 같이 구성 한다.
  * 기본 모드 기본 구성을 설치 합니다.
* 오류 보고 : "다음"을 선택 한다.
* 설치 구성 규칙 : "다음"을 선택 한다.
* 설치 준비 : "설치"를 선택 한다.

## MSSQL(Microsoft SQL) Server 설치 확인 for Windows Server 2008

Microsoft SQL Server Management Studio 프로그램을 실행 한다.
* 서버 유형 : 데이터베이스 엔진
* 서버 이름 : 생략
* 인증 : SQL Server 인증
  * 로그인 : sa
  * 암호 : 비밀1234!@#$

"연결" 버튼을 선택 한다.

## Cloudbase-Init 설치

https://github.com/pnuskgh/service/tree/develop/service_os/Windows_Server_2012_R2 참조

