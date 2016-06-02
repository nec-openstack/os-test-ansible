#!/bin/bash

bridge=${1:-"br0"}
api_network=${2:-"192.168.203"}
tunnel_network=${3:-"192.168.204"}
netmask=${4:-"255.255.0.0"}
gateway=${5:-"192.168.11.1"}

script_dir=`dirname $0`
userdata_dir=${script_dir}/userdata
playbooks_dir=${script_dir}/../playbooks
group_vars_dir=${playbooks_dir}/group_vars

source ${script_dir}/kvm-settings.sh
settings=("${_OS_TEST_KVM_SETTINGS[@]}")

for setting in "${settings[@]}"
do
    setting=($setting)
    bash ${script_dir}/create-user-data.sh ${setting[1]} \
                                           kolla \
                                           ${api_network}.${setting[5]}  \
                                           ${netmask} \
                                           ${gateway} > "${userdata_dir}/${setting[1]}.cfg"
done

cat > ${group_vars_dir}/kvm <<EOS
---
api_host: ${api_network}.11
api_interface: "eth0"
tunnel_interface: "eth1"
public_interface: "eth2"
EOS

cat > ${playbooks_dir}/kvm <<EOS
haproxy ansible_ssh_host=${api_network}.101 ansible_ssh_user=kolla
controller ansible_ssh_host=${api_network}.11 ansible_ssh_user=kolla
network ansible_ssh_host=${api_network}.21 ansible_ssh_user=kolla
compute1 ansible_ssh_host=${api_network}.31 ansible_ssh_user=kolla
block1 ansible_ssh_host=${api_network}.41 ansible_ssh_user=kolla

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
