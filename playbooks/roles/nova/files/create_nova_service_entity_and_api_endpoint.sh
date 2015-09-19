#!/bin/sh
openstack user create --password $1 nova
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute service" compute
openstack endpoint create \
--publicurl http://controller:8774/v2/%\(tenant_id\)s \
--internalurl http://controller:8774/v2/%\(tenant_id\)s \
--adminurl http://controller:8774/v2/%\(tenant_id\)s \
--region RegionOne \
compute

