#!/bin/bash
su -s /bin/bash -c "nova-manage db sync" nova
