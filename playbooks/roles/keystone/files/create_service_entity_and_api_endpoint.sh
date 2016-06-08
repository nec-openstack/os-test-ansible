#!/bin/bash
source /opt/local/bin/os-utils.sh

create_or_get_service keystone identity "OpenStack Identity"
create_or_get_endpoint identity public "http://$1:5000/v3"
create_or_get_endpoint identity internal "http://$1:5000/v3"
create_or_get_endpoint identity admin "http://$1:35357/v3"
