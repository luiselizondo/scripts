#!/bin/bash

echo "Installing Docker"
function installDocker {
	curl -sSL https://get.docker.com/ubuntu/ | sh
}

function installConsul {
	echo "Installing Load Balancer and Service Registry"
	
	PRIVATE_IP=$(ifconfig eth1 | awk -F ' *|:' '/inet addr/{print $4}')
	docker run --name consul -d \
		-h $HOSTNAME \
		-v /mnt:/data \
		-p $PRIVATE_IP:8300:8300 \
		-p $PRIVATE_IP:8301:8301 \
		-p $PRIVATE_IP:8301:8301/udp \
		-p $PRIVATE_IP:8302:8302 \
		-p $PRIVATE_IP:8302:8302/udp \
		-p $PRIVATE_IP:8400:8400 \
		-p $PRIVATE_IP:8500:8500 \
		-p 172.17.42.1:53:53/udp \
		progrium/consul -server -advertise $PRIVATE_IP -bootstrap-expect 3

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