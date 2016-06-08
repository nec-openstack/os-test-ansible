#!/bin/bash

script_dir=`dirname $0`

source ${script_dir}/kvm-settings.sh
bridge=${OS_TEST_BRIDGE}
api_network=${OS_TEST_API_NETWORK}
tunnel_network=${OS_TEST_TUNNEL_NETWORK}
netmask=${OS_TEST_NETMASK}
gateway=${OS_TEST_GATEWAY}
settings=("${_OS_TEST_KVM_SETTINGS[@]}")

for setting in "${settings[@]}"
do
    setting=($setting)
    echo "Destroy ${setting[1]} node..."
    uvt-kvm destroy ${setting[1]}
done
