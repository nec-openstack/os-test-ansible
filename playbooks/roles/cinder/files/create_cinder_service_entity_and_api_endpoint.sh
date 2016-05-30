#!/bin/sh
openstack user create --domain default --password $1 cinder
openstack role add --project service --user cinder admin
openstack service create --name cinder --description "OpenStack Block Storage" volume
openstack service create --name cinderv2 --description "OpenStack Block Storage" volumev2
openstack endpoint create --region RegionOne volume public http://$2:8776/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne volume internal http://$2:8776/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne volume admin http://$2:8776/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne volumev2 public http://$2:8776/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne volumev2 internal http://$2:8776/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne volumev2 admin http://$2:8776/v2/%\(tenant_id\)s
