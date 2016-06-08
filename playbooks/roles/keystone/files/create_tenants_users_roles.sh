#!/bin/bash
source /opt/local/bin/os-utils.sh

get_or_create_domain default "Default Domain"
create_or_get_project admin "Admin Project" default
create_or_get_user admin $1 default
create_or_get_role admin
get_or_add_user_project_role admin admin admin
create_or_get_project service "Service Project" default
create_or_get_project demo "Demo Project" default
create_or_get_user demo $2 default
create_or_get_role user
get_or_add_user_project_role user demo demo
