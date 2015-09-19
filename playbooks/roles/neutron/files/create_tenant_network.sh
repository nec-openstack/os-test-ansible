#!/bin/sh
neutron net-create demo-net

sleep 5

neutron subnet-create demo-net $1\
  --name demo-subnet --gateway $2
neutron router-create demo-router

sleep 5

neutron router-interface-add demo-router demo-subnet

sleep 5

neutron router-gateway-set demo-router ext-net



