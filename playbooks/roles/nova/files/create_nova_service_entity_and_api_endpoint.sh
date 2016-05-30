#!/bin/sh
openstack user create --domain default --password $1 nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute
openstack endpoint create --region RegionOne compute public http://$2:8774/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne compute internal http://$2:8774/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne compute admin http://$2:8774/v2/%\(tenant_id\)s
