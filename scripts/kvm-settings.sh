#!/bin/bash

export _OS_TEST_KVM_SETTINGS=(
  "haproxy haproxy 1 1024 40 101"
  "controller controller01 2 3072 40 11"
  "network network01 1 1024 20 21"
  "compute compute01 2 2048 40 31"
  "storage storage01 1 2048 40 41"
)
