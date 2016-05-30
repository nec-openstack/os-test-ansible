#!/bin/sh
openstack user create --domain default --password $1 neutron
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --region RegionOne network public http://$2:9696
openstack endpoint create --region RegionOne network internal http://$2:9696
openstack endpoint create --region RegionOne network admin http://$2:9696
