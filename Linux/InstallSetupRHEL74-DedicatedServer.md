# Phase 1

## Install RHEL 7.4 Dvd ISO on Hyper-v with Developer Subscription for MySQL 5.7 dedicated Server.

### Download RHEL 7

For download this RHEL version, first subscribe to redhat at https://developers.redhat.com/register/.

Once you are regitered, you have to go to https://access.redhat.com/management/, if requiered login again with the same credentials from developers portal.

Them, search de "active" link and click to see your available subscription (https://access.redhat.com/management/subscriptions)

The good new is that redhat developer account let you use a subscription for one year.


### Install RHEL 7

Copy/Move the ISO to the W$ server where HyperV is running. (ie C:\Users\cepxio\Documents\ISOs\).

Open HyperV Mangement and startup a new virtual machine, following de step in https://developers.redhat.com/products/rhel/hello-world/#fndtn-hyper-v.

When the RHEL installation finished, setup Network and check that the server can get to any host in the WAN.

In the GUI installation, you can create the LVM for improve MySQL IO, and create diferents partitions for binlog and relay binlogs. 
[See Install, Setup and Secure MySQL 5.7 for better partitioning descrition]

Then add proxy, user and pass to /etc/rhsm/rhsm.conf, if requiered.


### Registering RHEL Server:

+ Register

	`$ subscription-manager register --username <username> --password <password>  # Same user portal`

+ Search the Pool Id

	`$ subscription-manager list --available`

+ Attach subscription pool

	`$ subscription-manager attach --pool=8a85g9834ecbc57b016eze29dd344be4`

+ List available repositories

	`$ subscription-manager repos --list`

+ Enable one, e.g:

	`$ subscription-manager repos --enable=rhel-7-server-optional-rpms`

+ Update yum db

	`$ yum repolist`

+ Install some needed tools

	`$ yum install -y vim telnet nmap mlocate`

	(if you want add snmp monitoring)

	`$ yum install net-snmp.x86_64 net-snmp-agent-libs.x86_64 net-snmp-devel.x86_64 net-snmp-libs.x86_64 net-snmp-perl.x86_64`

+ Disable Firewall

	`$ systemctl disable firewalld`

	`$ systemctl stop firewalld`

+ Disable SELINUX

	`$ vim /etc/selinux/config`

+ Restart Server

#### You are done! Enjoy your new RHEL server.
