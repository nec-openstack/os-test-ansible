#!/bin/sh

PUBLIC_NETWORK_CIDR=203.0.113.0/24
START_IP_ADDRESS=203.0.113.101
END_IP_ADDRESS=203.0.113.200
DNS_RESOLVER=8.8.4.4
PUBLIC_NETWORK_GATEWAY=203.0.113.1

neutron net-create public --router:external --provider:physical_network public --provider:network_type flat

neutron subnet-create public $PUBLIC_NETWORK_CIDR --name public \
  --allocation-pool start=$START_IP_ADDRESS,end=$END_IP_ADDRESS \
  --dns-nameserver $DNS_RESOLVER --disable-dhcp --gateway $PUBLIC_NETWORK_GATEWAY

