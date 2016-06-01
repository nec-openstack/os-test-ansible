#!/bin/bash
su -s /bin/bash -c "cinder-manage db sync" cinder
