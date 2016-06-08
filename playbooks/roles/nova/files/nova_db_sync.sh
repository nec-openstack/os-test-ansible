#!/bin/bash
su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/bash -c "nova-manage db sync" nova
