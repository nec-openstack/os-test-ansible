#!/bin/sh
openstack domain create --description "Stack projects and users" heat
openstack user create --domain heat --password $1 heat_domain_admin
openstack role add --domain heat --user heat_domain_admin admin
openstack role create heat_stack_owner
openstack role add --project demo --user demo heat_stack_owner
openstack role create heat_stack_user

