#!/bin/bash

bridge=${1:-"br0"}
api_network=${2:-"192.168.203"}
tunnel_network=${3:-"192.168.204"}
netmask=${4:-"255.255.0.0"}
gateway=${5:-"192.168.11.1"}

script_dir=`dirname $0`

source ${script_dir}/kvm-settings.sh
settings=("${_OS_TEST_KVM_SETTINGS[@]}")

for setting in "${settings[@]}"
do
    setting=($setting)
    echo "Destroy ${setting[1]} node..."
    uvt-kvm destroy ${setting[1]}
done
