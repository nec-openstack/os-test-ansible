#!/bin/bash

# Grab a numbered field from python prettytable output
# Fields are numbered starting with 1
# Reverse syntax is supported: -1 is the last field, -2 is second to last, etc.
# get_field field-number
function get_field {
    local data field
    while read data; do
        if [ "$1" -lt 0 ]; then
            field="(\$(NF$1))"
        else
            field="\$$(($1 + 1))"
        fi
        echo "$data" | awk -F'[ \t]*\\|[ \t]*' "{print $field}"
    done
}

# Gets or creates a domain
# Usage: get_or_create_domain <name> <description>
function get_or_create_domain {
    local domain_id
    # Gets domain id
    domain_id=$(
        # Gets domain id
        openstack domain show $1 \
            -f value -c id 2>/dev/null ||
        # Creates new domain
        openstack domain create $1 \
            --description "$2" \
            -f value -c id
    )
    echo $domain_id
}

#admin users expected
function create_or_get_project {
    local name=$1
    local description=$2
    local domain=${3:-'default'}
    local id
    eval $(openstack project show --domain $domain -f shell -c id $name)
    if [[ -z $id ]]; then
        eval $(openstack project create \
                -f shell -c id \
                --domain $domain \
                --description $description \
                $name)
    fi
    echo $id
}

# Gets or creates role
# Usage: create_or_get_role <name>
function create_or_get_role {
    local role_id
    role_id=$(
        # Creates role with --or-show
        openstack role create $1 \
            --or-show -f value -c id
    )
    echo $role_id
}

function create_or_get_user {
  local name=$1
  local password=$2
  local domain=${3:-'default'}
  local id
  eval $(openstack user show -f shell -c id $name)
  if [[ -z $id ]]; then
      eval $(openstack user create \
              -f shell -c id \
              --domain ${domain} \
              --password $password \
              $name)
  fi
  echo $id
}

# Gets or adds user role to project
# Usage: get_or_add_user_project_role <role> <user> <project>
function get_or_add_user_project_role {
    local user_role_id
    # Gets user role id
    user_role_id=$(openstack role list \
        --user $2 \
        --column "ID" \
        --project $3 \
        --column "Name" \
        | grep " $1 " | get_field 1)
    if [[ -z "$user_role_id" ]]; then
        # Adds role to user and get it
        openstack role add $1 \
            --user $2 \
            --project $3
        user_role_id=$(openstack role list \
            --user $2 \
            --column "ID" \
            --project $3 \
            --column "Name" \
            | grep " $1 " | get_field 1)
    fi
    echo $user_role_id
}

# Gets or adds user role to domain
# Usage: get_or_add_user_domain_role <role> <user> <domain>
function get_or_add_user_domain_role {
    local user_role_id
    # Gets user role id
    user_role_id=$(openstack role list \
        --user $2 \
        --column "ID" \
        --domain $3 \
        --column "Name" \
        | grep " $1 " | get_field 1)
    if [[ -z "$user_role_id" ]]; then
        # Adds role to user and get it
        openstack role add $1 \
            --user $2 \
            --domain $3
        user_role_id=$(openstack role list \
            --user $2 \
            --column "ID" \
            --domain $3 \
            --column "Name" \
            | grep " $1 " | get_field 1)
    fi
    echo $user_role_id
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
