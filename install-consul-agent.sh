#!/bin/bash

PRIVATE_IP=$(ifconfig eth1 | awk -F ' *|:' '/inet addr/{print $4}')

function installConsulAgent {
	echo "Installing Consul Agent"
	
	JOIN_IP=$1

	$(docker run progrium/consul cmd:run $PRIVATE_IP::$JOIN_IP -d)

	echo "-------------------------------------------------------------"
	echo " "
	echo "Consul agent is installed and connected to $JOIN_IP"
	echo " "
	echo "-------------------------------------------------------------"
}

function installRegistrator {
	echo "Installing Registrator"
	
	docker run -d \
    -v /var/run/docker.sock:/tmp/docker.sock \
    -h $HOSTNAME progrium/registrator consul://$PRIVATE_IP:8500
}

installConsulAgent
installRegistrator