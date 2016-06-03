#!/bin/bash

PRIVATE_NETWORK_CIDR=${1:-"172.16.1.0/24"}
PRIVATE_NETWORK_GATEWAY=${2:-"172.16.1.1"}

neutron net-create private

neutron subnet-create private $PRIVATE_NETWORK_CIDR --name private\
  --gateway $PRIVATE_NETWORK_GATEWAY

neutron router-create router

neutron router-interface-add router private

neutron router-gateway-set router public
