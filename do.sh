#!/bin/bash -xe
make clean
make

semanage port -d -t cfengine_serverd_port_t -p tcp 5308
semodule -r cfengine
semodule -i cfengine.pp
semanage port -a -t cfengine_serverd_port_t -p tcp 5308

restorecon -R /var/cfengine/ /var/log/
read -p "Continue? "

for i in monitord serverd execd
do 
	systemctl restart cf-$i.service
done

