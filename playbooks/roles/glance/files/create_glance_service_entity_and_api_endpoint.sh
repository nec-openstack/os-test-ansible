openstack user create --domain default --password $1 glance
openstack role add --project service --user glance admin
openstack service create --name glance --description "OpenStack Image service" image
openstack endpoint create --region RegionOne image public http://$2:9292
openstack endpoint create --region RegionOne image internal http://$2:9292
openstack endpoint create --region RegionOne image admin http://$2:9292
