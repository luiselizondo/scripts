#!/bin/bash

echo "Installing Docker"
function installDocker {
	curl -sSL https://get.docker.com/ubuntu/ | sh
}

function installConsul {
	echo "Installing Load Balancer and Service Registry"
	
	PRIVATE_IP=$(ifconfig eth1 | awk -F ' *|:' '/inet addr/{print $4}')
	$(docker run progrium/consul cmd:run $PRIVATE_IP -d -v /mnt:/data)

	echo "-------------------------------------------------------------"
	echo " "
	echo "Consul is installed"
	echo "Use this IP to connect to Consul:"
	echo " "
	echo "$PRIVATE_IP"
	echo " "
	echo "-------------------------------------------------------------"
}

function installLoadBalancer {
	echo "Installing Load Balancer HAProxy"
	echo "Not ready yet"
}

installDocker
installConsul
installLoadBalancer