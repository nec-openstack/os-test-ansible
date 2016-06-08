#!/bin/bash

host_pattern=${1:-""}

script_dir=`dirname $0`
userdata_dir=${script_dir}/userdata

source ${script_dir}/kvm-settings.sh
settings=("${_OS_TEST_KVM_SETTINGS[@]}")
_settings=("${settings[@]}")
bridge=${OS_TEST_BRIDGE}
api_network=${OS_TEST_API_NETWORK}
tunnel_network=${OS_TEST_TUNNEL_NETWORK}
netmask=${OS_TEST_NETMASK}
gateway=${OS_TEST_GATEWAY}

function check_host {
  local host_name=$1
  if [[ ${host_pattern} = "" ]]; then
    return 0
  fi
  if [[ ${setting[1]} =~ ${host_pattern} ]]; then
    return 0
  else
    return 1
  fi
}

function wait_host {
  local target=$1
  echo "Waiting ${target}..."
  ((count = 100))
  while [[ $count -ne 0 ]] ; do
    ping -c 1 ${target}
    rc=$?
    if [[ $rc -eq 0 ]] ; then
        ((count = 1))
    fi
    ((count = count - 1))
  done

  if [[ $rc -eq 0 ]] ; then
    echo "Connected: ${target}"
  else
    exit 1
  fi
}

function ssh_target {
  local target=$1
  local script=$2
  ssh kolla@${target} -o StrictHostKeyChecking=no \
                         -o UserKnownHostsFile=/dev/null \
                         "sudo sh -c \"${script}\""
}

for setting in "${settings[@]}"
do
    setting=($setting)
    if check_host ${setting[1]}; then
      echo "Creating ${setting[1]} node..."
      uvt-kvm create ${setting[1]} release=trusty \
                --bridge ${bridge} --cpu ${setting[2]} \
                --memory ${setting[3]} --disk ${setting[4]} \
                --user-data ${userdata_dir}/${setting[1]}.cfg
    fi
done

for setting in "${_settings[@]}"
do
    setting=($setting)
    if check_host ${setting[1]}; then
      echo "Setup ${setting[1]}"
      wait_host ${api_network}.${setting[5]}

      if [[ ${setting[0]} = 'network' ]] || [[ ${setting[0]} = 'compute' ]]; then
        echo "Attach interface for tunnel to ${setting[1]}"
        virsh attach-interface --type bridge \
                               --source ${bridge} \
                               --model virtio \
                               ${setting[1]}
        sleep 1
        ssh_target ${api_network}.${setting[5]} "echo 'auto eth1' > /etc/network/interfaces.d/eth1.cfg"
        ssh_target ${api_network}.${setting[5]} "echo 'iface eth1 inet static' >> /etc/network/interfaces.d/eth1.cfg"
        ssh_target ${api_network}.${setting[5]} "echo '  address ${tunnel_network}.${setting[6]}' >> /etc/network/interfaces.d/eth1.cfg"
        ssh_target ${api_network}.${setting[5]} "echo '  netmask ${netmask}' >> /etc/network/interfaces.d/eth1.cfg"
        ssh_target ${api_network}.${setting[5]} "echo '  gateway ${gateway}' >> /etc/network/interfaces.d/eth1.cfg"
        ssh_target ${api_network}.${setting[5]} "echo '  dns-nameservers 8.8.8.8' >> /etc/network/interfaces.d/eth1.cfg"
        ssh_target ${api_network}.${setting[5]} "ifdown eth1"
        ssh_target ${api_network}.${setting[5]} "ifup eth1"
      fi

      if [[ ${setting[0]} = 'network' ]]; then
        echo "Attach interface for public to ${setting[1]}"
        virsh attach-interface --type bridge \
                               --source ${bridge} \
                               --model virtio \
                               ${setting[1]}
        sleep 1
        ssh_target ${api_network}.${setting[5]} "echo 'auto eth2' > /etc/network/interfaces.d/eth2.cfg"
        ssh_target ${api_network}.${setting[5]} "echo 'iface eth2 inet manual' >> /etc/network/interfaces.d/eth2.cfg"
        ssh_target ${api_network}.${setting[5]} "echo '  up ip link set dev eth2 up' >> /etc/network/interfaces.d/eth2.cfg"
        ssh_target ${api_network}.${setting[5]} "echo '  down ip link set dev eth2 down' >> /etc/network/interfaces.d/eth2.cfg"
        ssh_target ${api_network}.${setting[5]} "ifdown eth2"
        ssh_target ${api_network}.${setting[5]} "ifup eth2"
      fi
    fi

done
