This is ansible playbooks to deploy OpenStack for testing purpose.
Only Ubuntu 14.04 is tested.
This installs the following OpenStack projects:

* Keystone
* Glance
* Nova
* Neutron
* Horizon
* Cinder
* Heat

## How to use

### Deploy OpenStack using vagrant

#### Install OpenStack

<pre>
$ cd playbooks
$ vagrant up
$ ansible-playbook -i dev site.yml
</pre>

#### Create virtual networks

<pre>
$ scp -P 2222 -i /home/hid-nakamura/.vagrant.d/insecure_private_key ./scripts/* vagrant@localhost:/home/vagrant/
$ vagrant ssh controller
$ source admin-openrc.sh
$ ./create_public_network.sh
$ source demo-openrc.sh
$ ./create_private_network.sh
</pre>

### Deploy OpenStack using uvt-kvm

#### Pre requirements

* uvt-kvm
* setup bridge named "br0"

#### Install Openstack

    $ uvt-simplestreams-libvirt sync release=trusty arch=amd64
    $ # Please modify network settings
    $ bash scripts/setup-kvm-dev-env.sh
    $ bash scripts/kvm-up.sh
    $ cd playbooks
    $ ansible-playbook -i kvm -e@group_vars/kvm site.yml

#### Create virtual networks

    $ source scripts/admin-openrc-kvm.sh
    $ bash scripts/create_public_network.sh "192.168.203.0/24" \
                                            "192.168.203.60" \
                                            "192.168.203.99"
    $ source scripts/demo-openrc-kvm.sh
    $ bash scripts/create_private_network.sh

#### Destroy environment

    $ bash scripts/kvm-destroy.sh

## Result

<pre>

--------------------------------------------
                      |
 +------------+  +----------+  +----------+  +----------+
 |            |  |          |  |          |  |          |
 | controller |  | network  |  | compute1 |  |  block1  |
 |            |  |          |  |          |  |          |
 +------------+  +----------+  +----------+  +----------+
       |              |  |          |   |         |
       |              |  ------------   |         |
       |              |                 |         |
 ---------------------------------------------------------

 </pre>

## License

Apache License, Version 2.0
