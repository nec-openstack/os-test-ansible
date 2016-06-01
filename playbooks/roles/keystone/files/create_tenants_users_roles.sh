#!/bin/bash
openstack project create --domain default --description "Admin Project" admin
openstack user create --domain default --password $1 admin
openstack role create admin
openstack role add --project admin --user admin admin
openstack project create --domain default --description "Service Project" service
openstack project create --domain default --description "Demo Project" demo
openstack user create --domain default --password $2 demo
openstack role create user
openstack role add --project demo --user demo user

