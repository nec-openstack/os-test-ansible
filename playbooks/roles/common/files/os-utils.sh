#!/bin/bash

#admin users expected
function create_or_get_project {
    local name=$1
    local id
    eval $(openstack project show -f shell -c id $name)
    if [[ -z $id ]]; then
        eval $(openstack project create -f shell -c id $name)
    fi
    echo $id
}

function create_or_get_role {
    local name=$1
    local id
    eval $(openstack role show -f shell -c id $name)
    if [[ -z $id ]]; then
        eval $(openstack role create -f shell -c id $name)
    fi
    echo $id
}

function create_or_get_user {
  local name=$1
  local password=$2
  local id
  eval $(openstack user show -f shell -c id $name)
  if [[ -z $id ]]; then
      eval $(openstack user create \
              -f shell -c id \
              --domain default \
              --password $password \
              $name)
  fi
  echo $id
}

function create_or_get_service {
  local name=$1
  local type=$2
  local description=$3
  local id
  eval $(openstack service show -f shell -c id $name)
  if [[ -z $id ]]; then
      eval $(openstack service create \
              -f shell -c id \
              --name $name \
              --description "$description" \
              $type)
  fi
  echo $id
}

function create_or_get_endpoint {
  local service=$1
  local interface=$2
  local url=$3
  local endpoint_id
  endpoint_id=$(openstack endpoint list \
      --service $service \
      --interface $interface \
      --region RegionOne \
      -c ID -f value)
  if [[ -z "$endpoint_id" ]]; then
      # Creates new endpoint
      endpoint_id=$(openstack endpoint create \
          $service $interface $url --region RegionOne -f value -c id)
  fi

  echo $endpoint_id
}
