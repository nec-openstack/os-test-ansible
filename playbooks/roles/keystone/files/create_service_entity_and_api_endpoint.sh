#!/bin/sh

openstack service create --name keystone --description "OpenStack Identity" identity
openstack endpoint create --region RegionOne identity public http://controller:5000/v2.0
openstack endpoint create --region RegionOne identity internal http://controller:5000/v2.0
openstack endpoint create --region RegionOne identity admin http://controller:35357/v2.0
