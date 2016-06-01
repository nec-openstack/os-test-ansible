#!/bin/sh
source /opt/local/bin/os-utils.sh

create_or_get_user neutron $1
get_or_add_user_project_role admin neutron service
create_or_get_service neutron network "OpenStack Networking"
create_or_get_endpoint network public http://$2:9696
create_or_get_endpoint network internal http://$2:9696
create_or_get_endpoint network admin http://$2:9696
