# Ceph

## Document

Document : http://docs.ceph.com/docs/jewel/, https://wiki.ceph.com/  
* ODS : 데이터 저장/관리
* Monitor : 상태 관리
  * Monitor map, OSD map
  * PG (Placement Group) map
  * CRUSH map
* MDS (MetaData Server)

## Ceph 환경 구성

* /etc/ceph/ceph.conf
  * Section : global, osd (osd.~), mon(mon.~), client

* /var/lib/ceph/${type}

# Ceph Test 환경 구성

## Node 현황

* ceph-admin
* ceph-storage

