#!/bin/sh
source /opt/local/bin/os-utils.sh

create_or_get_user nova $1
get_or_add_user_project_role admin nova service
create_or_get_service nova compute "OpenStack Compute"
create_or_get_endpoint compute public http://$2:8774/v2/%\(tenant_id\)s
create_or_get_endpoint compute internal http://$2:8774/v2/%\(tenant_id\)s
create_or_get_endpoint compute admin http://$2:8774/v2/%\(tenant_id\)s
