#!/bin/sh
openstack user create --domain default --password $1 heat
openstack role add --project service --user heat admin
openstack service create --name heat --description "Orchestration" orchestration
openstack service create --name heat-cfn --description "Orchestration" cloudformation
openstack endpoint create --region RegionOne orchestration public http://$2:8004/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne orchestration internal http://$2:8004/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne orchestration admin http://$2:8004/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne cloudformation public http://$2:8000/v1
openstack endpoint create --region RegionOne cloudformation internal http://$2:8000/v1
openstack endpoint create --region RegionOne cloudformation admin http://$2:8000/v1
