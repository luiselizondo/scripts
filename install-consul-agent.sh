#!/bin/bash

PRIVATE_IP=$(ifconfig eth1 | awk -F ' *|:' '/inet addr/{print $4}')

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 1 ] || die "first argument is required, $# provided"

function installConsulAgent {
	echo "Installing Consul Agent"
	
	docker run --name consul \
		-h $HOSTNAME \
		-p $PRIVATE_IP:8300:8300 \
		-p $PRIVATE_IP:8301:8301 \
		-p $PRIVATE_IP:8301:8301/udp \
		-p $PRIVATE_IP:8302:8302 \
		-p $PRIVATE_IP:8302:8302/udp \
		-p $PRIVATE_IP:8400:8400 \
		-p $PRIVATE_IP:8500:8500 \
		-p 172.17.42.1:53:53/udp \
		-d progrium/consul -server -advertise $PRIVATE_IP -join $1

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

function using {
	echo "Using Private IP: $PRIVATE_IP"
	echo "Using Join IP: $1"
}

using
installConsulAgent
installRegistrator