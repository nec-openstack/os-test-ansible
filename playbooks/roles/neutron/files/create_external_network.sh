#!/bin/sh

sleep 5

neutron net-create ext-net --router:external \
  --provider:physical_network external --provider:network_type flat

sleep 5

neutron subnet-create ext-net $1 --name ext-subnet \
  --allocation-pool start=$2,end=$3 \
  --disable-dhcp --gateway $4

