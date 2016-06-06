#!/bin/bash
source /opt/local/bin/os-utils.sh

get_or_create_domain heat "Stack projects and users"
create_or_get_user heat_domain_admin $1 heat
get_or_add_user_domain_role admin heat_domain_admin heat
create_or_get_role heat_stack_owner
get_or_add_user_project_role heat_stack_owner demo demo
create_or_get_role heat_stack_user
