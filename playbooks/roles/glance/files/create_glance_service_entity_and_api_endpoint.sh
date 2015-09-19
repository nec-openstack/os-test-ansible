openstack user create --password $1 glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image service" image
openstack endpoint create \
--publicurl http://controller:9292 \
--internalurl http://controller:9292 \
--adminurl http://controller:9292 \
--region RegionOne \
image


