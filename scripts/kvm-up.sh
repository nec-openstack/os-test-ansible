#!/bin/bash

bridge=${1:-"br0"}

script_dir=`dirname $0`
userdata_dir=${script_dir}/userdata

settings=(
  "haproxy 1 1024 40 0"
  "controller01 2 3072 40 0"
  "network01 1 1024 20 2"
  "compute01 2 2048 40 1"
  "storage01 1 2048 40 0"
)

for setting in "${settings[@]}"
do
    setting=($setting)
    echo "Creating ${setting[0]} node..."
    uvt-kvm create ${setting[0]} release=trusty \
              --bridge ${bridge} --cpu ${setting[1]} \
              --memory ${setting[2]} --disk ${setting[3]} \
              --user-data ${userdata_dir}/${setting[0]}.cfg

    for i in `seq 1 ${setting[4]}`;
    do
      if [[ $i -gt 0 ]]; then
        echo "Attach interface to ${setting[0]}:${i}"
        virsh attach-interface --type bridge \
                               --source ${bridge} \
                               --model virtio \
                               ${setting[0]}
      fi
    done;
done
