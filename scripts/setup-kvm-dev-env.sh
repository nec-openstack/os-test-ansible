#!/bin/bash

network_address=${1:-"192.168.203"}
netmask=${2:-"255.255.0.0"}
gateway=${3:-"192.168.11.1"}

script_dir=`dirname $0`
userdata_dir=${script_dir}/userdata
playbooks_dir=${script_dir}/../playbooks
group_vars_dir=${playbooks_dir}/group_vars

settings=(
  "haproxy 101"
  "controller01 11"
  "network01 21"
  "compute01 31"
  "storage01 41"
)

for setting in "${settings[@]}"
do
    setting=($setting)
    bash ${script_dir}/create-user-data.sh ${setting[0]} \
                                           operator \
                                           ${network_address}.${setting[1]}  \
                                           ${netmask} \
                                           ${gateway} > "${userdata_dir}/${setting[0]}.cfg"
done

cat > ${group_vars_dir}/kvm <<EOS
---
api_host: ${network_address}/11
api_interface: "eth0"
tunnel_interface: "eth1"
public_interface: "eth3"
EOS

cat > ${playbooks_dir}/kvm <<EOS
haproxy ansible_ssh_host=${network_address}.101 ansible_ssh_user=operator
controller ansible_ssh_host=${network_address}.11 ansible_ssh_user=operator
network ansible_ssh_host=${network_address}.21 ansible_ssh_user=operator
compute1 ansible_ssh_host=${network_address}.31 ansible_ssh_user=operator
block1 ansible_ssh_host=${network_address}.41 ansible_ssh_user=operator

[haproxy]
haproxy

[controller]
controller

[network]
network

[computes]
compute1

[blocks]
block1

[dev:children]
haproxy
controller
network
computes
blocks
EOS
