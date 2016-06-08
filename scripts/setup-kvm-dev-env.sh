#!/bin/bash

script_dir=`dirname $0`
userdata_dir=${script_dir}/userdata
playbooks_dir=${script_dir}/../playbooks
group_vars_dir=${playbooks_dir}/group_vars

source ${script_dir}/kvm-settings.sh
settings=("${_OS_TEST_KVM_SETTINGS[@]}")
bridge=${OS_TEST_BRIDGE}
api_network=${OS_TEST_API_NETWORK}
tunnel_network=${OS_TEST_TUNNEL_NETWORK}
netmask=${OS_TEST_NETMASK}
gateway=${OS_TEST_GATEWAY}

for setting in "${settings[@]}"
do
    setting=($setting)
    bash ${script_dir}/create-user-data.sh ${setting[1]} \
                                           kolla \
                                           ${api_network}.${setting[5]}  \
                                           ${netmask} \
                                           ${gateway} > "${userdata_dir}/${setting[1]}.cfg"
done

HAPROXY=(${OS_TEST_HAPROXY})
controller=${OS_TEST_CONTROLLERS[0]}
controller=(${controller})
cat > ${script_dir}/admin-openrc-kvm.sh <<EOS
export OS_PROJECT_DOMAIN_ID=default
export OS_USER_DOMAIN_ID=default
export OS_PROJECT_NAME=admin
export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=password
export OS_AUTH_URL=http://${api_network}.${HAPROXY[5]}:35357
export OS_IDENTITY_API_VERSION=3
EOS

cat > ${script_dir}/demo-openrc-kvm.sh <<EOS
export OS_PROJECT_DOMAIN_ID=default
export OS_USER_DOMAIN_ID=default
export OS_PROJECT_NAME=demo
export OS_TENANT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=password
export OS_AUTH_URL=http://${api_network}.${HAPROXY[5]}:5000
export OS_IDENTITY_API_VERSION=3
EOS

cat > ${group_vars_dir}/kvm <<EOS
---
api_host: "${api_network}.${HAPROXY[5]}"
db_host: "${api_network}.${HAPROXY[5]}"
rabbit_host: "${api_network}.${HAPROXY[5]}"
api_interface: "eth0"
tunnel_interface: "eth1"
public_interface: "eth2"
EOS

echo "" > ${playbooks_dir}/kvm
for setting in "${settings[@]}"
do
  setting=($setting)
  echo "${setting[1]} ansible_ssh_host=${api_network}.${setting[5]} ansible_ssh_user=kolla" >> ${playbooks_dir}/kvm
done

echo "" >> ${playbooks_dir}/kvm
echo "[haproxy]" >> ${playbooks_dir}/kvm
echo "${HAPROXY[1]}" >> ${playbooks_dir}/kvm
echo "" >> ${playbooks_dir}/kvm

echo "[datastores]" >> ${playbooks_dir}/kvm
echo "${HAPROXY[1]}" >> ${playbooks_dir}/kvm
echo "" >> ${playbooks_dir}/kvm

echo "[controller]" >> ${playbooks_dir}/kvm
for setting in "${OS_TEST_CONTROLLERS[@]}"
do
  setting=($setting)
  echo "${setting[1]}" >> ${playbooks_dir}/kvm
done
echo "" >> ${playbooks_dir}/kvm

echo "[network]" >> ${playbooks_dir}/kvm
for setting in "${OS_TEST_NETWORKS[@]}"
do
  setting=($setting)
  echo "${setting[1]}" >> ${playbooks_dir}/kvm
done
echo "" >> ${playbooks_dir}/kvm

echo "[computes]" >> ${playbooks_dir}/kvm
for setting in "${OS_TEST_COMPUTES[@]}"
do
  setting=($setting)
  echo "${setting[1]}" >> ${playbooks_dir}/kvm
done
echo "" >> ${playbooks_dir}/kvm

echo "[blocks]" >> ${playbooks_dir}/kvm
for setting in "${OS_TEST_STORAGES[@]}"
do
  setting=($setting)
  echo "${setting[1]}" >> ${playbooks_dir}/kvm
done
echo "" >> ${playbooks_dir}/kvm

cat >> ${playbooks_dir}/kvm <<EOS
[dev:children]
haproxy
datastores
controller
network
computes
blocks
EOS
