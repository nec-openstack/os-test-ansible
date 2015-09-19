#!/bin/sh

openstack service create --name keystone --description "OpenStack Identity" identity
openstack endpoint create --publicurl http://controller:5000/v2.0 --internalurl http://controller:5000/v2.0 --adminurl http://controller:35357/v2.0 --region RegionOne identity

