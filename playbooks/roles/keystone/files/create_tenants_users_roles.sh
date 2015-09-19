#!/bin/sh
openstack project create --description "Admin Project" admin
openstack user create --password $1 admin
openstack role create admin
openstack role add --project admin --user admin admin
openstack project create --description "Service Project" service
openstack project create --description "Demo Project" demo
openstack user create --password $2 demo
openstack role create user
openstack role add --project demo --user demo user

