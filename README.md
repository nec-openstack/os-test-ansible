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

#### Result

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
