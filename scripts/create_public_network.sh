#!/bin/sh

PUBLIC_NETWORK_CIDR=10.2.0.0/24
START_IP_ADDRESS=10.2.0.201
END_IP_ADDRESS=10.2.0.250

neutron net-create public --router:external --provider:physical_network public --provider:network_type flat

neutron subnet-create public $PUBLIC_NETWORK_CIDR --name public \
  --allocation-pool start=$START_IP_ADDRESS,end=$END_IP_ADDRESS \
  --disable-dhcp

