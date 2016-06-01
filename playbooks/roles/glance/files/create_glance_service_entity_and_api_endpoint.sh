#!/bin/bash
source /opt/local/bin/os-utils.sh

create_or_get_user glance $1
get_or_add_user_project_role admin glance service
create_or_get_service glance image "OpenStack Image service"
create_or_get_endpoint image public http://$2:9292
create_or_get_endpoint image internal http://$2:9292
create_or_get_endpoint image admin http://$2:9292
