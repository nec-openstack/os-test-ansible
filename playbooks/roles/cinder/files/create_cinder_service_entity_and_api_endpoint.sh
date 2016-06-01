#!/bin/sh
source /opt/local/bin/os-utils.sh

create_or_get_user cinder $1
get_or_add_user_project_role admin cinder service
create_or_get_service cinder volume "OpenStack Block Storage"
create_or_get_service cinderv2 volumev2 "OpenStack Block Storage"
create_or_get_endpoint volume public http://$2:8776/v1/%\(tenant_id\)s
create_or_get_endpoint volume internal http://$2:8776/v1/%\(tenant_id\)s
create_or_get_endpoint volume admin http://$2:8776/v1/%\(tenant_id\)s
create_or_get_endpoint volumev2 public http://$2:8776/v2/%\(tenant_id\)s
create_or_get_endpoint volumev2 internal http://$2:8776/v2/%\(tenant_id\)s
create_or_get_endpoint volumev2 admin http://$2:8776/v2/%\(tenant_id\)s
