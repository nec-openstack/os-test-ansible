#!/bin/bash

if [[ $OS_TEST_HAPROXY ]]; then
  echo ${OS_TEST_HAPROXY}
else
  export OS_TEST_HAPROXY="haproxy haproxy 1 1024 40 101"
fi

if [[ $OS_TEST_CONTROLLERS ]]; then
  echo ${OS_TEST_CONTROLLERS[@]}
else
  export OS_TEST_CONTROLLERS=(
    "controller controller01 2 3072 40 11"
  )
fi

if [[ $OS_TEST_NETWORKS ]]; then
  echo ${OS_TEST_NETWORKS[@]}
else
  export OS_TEST_NETWORKS=(
    "network network01 1 1024 20 21"
  )
fi

if [[ $OS_TEST_COMPUTES ]]; then
  echo ${OS_TEST_COMPUTES[@]}
else
  export OS_TEST_COMPUTES=(
    "compute compute01 2 2048 40 31"
  )
fi

if [[ $OS_TEST_STORAGES ]]; then
  echo ${OS_TEST_STORAGES[@]}
else
  export OS_TEST_STORAGES=(
    "storage storage01 1 2048 40 41"
  )
fi

export _OS_TEST_KVM_SETTINGS=()
_OS_TEST_KVM_SETTINGS+=( "$OS_TEST_HAPROXY" )
for setting in "${OS_TEST_CONTROLLERS[@]}"
do
  _OS_TEST_KVM_SETTINGS+=( "$setting" )
done
for setting in "${OS_TEST_NETWORKS[@]}"
do
  _OS_TEST_KVM_SETTINGS+=( "$setting" )
done
for setting in "${OS_TEST_COMPUTES[@]}"
do
  _OS_TEST_KVM_SETTINGS+=( "$setting" )
done
for setting in "${OS_TEST_STORAGES[@]}"
do
  _OS_TEST_KVM_SETTINGS+=( "$setting" )
done
