#!/usr/bin/bash
export LC_ALL=C
export OS_NO_CACHE='true'
export OS_TENANT_NAME='admin'
export OS_PROJECT_NAME='admin'
export OS_USERNAME='admin'
export OS_PASSWORD='비밀번호'
export OS_AUTH_URL='http://10.10.10.2:5000/v2.0/'
export OS_AUTH_STRATEGY='keystone'
export OS_REGION_NAME='RegionOne'
export CINDER_ENDPOINT_TYPE='internalURL'
export GLANCE_ENDPOINT_TYPE='internalURL'
export KEYSTONE_ENDPOINT_TYPE='internalURL'
export NOVA_ENDPOINT_TYPE='internalURL'
export NEUTRON_ENDPOINT_TYPE='internalURL'
export OS_ENDPOINT_TYPE='internalURL'
export MURANO_REPO_URL='http://storage.apps.openstack.org/'

export OS_ENDPOINT=http://10.10.10.2:35357/v2.0/
export OS_CACERT=/data/custom/rally/provision/ca-certificates.crt

