#!/bin/bash
source /opt/local/bin/os-utils.sh

create_or_get_user heat $1
get_or_add_user_project_role admin heat service
create_or_get_service heat orchestration "Orchestration"
create_or_get_service heat-cfn cloudformation "Orchestration"

create_or_get_endpoint orchestration public http://$2:8004/v1/%\(tenant_id\)s
create_or_get_endpoint orchestration internal http://$2:8004/v1/%\(tenant_id\)s
create_or_get_endpoint orchestration admin http://$2:8004/v1/%\(tenant_id\)s
create_or_get_endpoint cloudformation public http://$2:8000/v1
create_or_get_endpoint cloudformation internal http://$2:8000/v1
create_or_get_endpoint cloudformation admin http://$2:8000/v1
