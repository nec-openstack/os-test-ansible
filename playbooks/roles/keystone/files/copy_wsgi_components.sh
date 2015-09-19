#!/bin/sh
curl http://git.openstack.org/cgit/openstack/keystone/plain/httpd/keystone.py?h=stable/kilo \
| tee /var/www/cgi-bin/keystone/main /var/www/cgi-bin/keystone/admin

