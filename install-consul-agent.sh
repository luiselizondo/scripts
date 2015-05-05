#!/bin/bash

PRIVATE_IP=$(ifconfig eth0 | awk -F ' *|:' '/inet addr/{print $4}')
JOIN_IP=$1

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 1 ] || die "first argument is required, $# provided"

function installConsulAgent {
	echo "Installing Consul Agent"
	
	sleep 2 ; docker run --name consul \
		-h $HOSTNAME \
		-p $PRIVATE_IP:8300:8300 \
		-p $PRIVATE_IP:8301:8301 \
		-p $PRIVATE_IP:8301:8301/udp \
		-p $PRIVATE_IP:8302:8302 \
		-p $PRIVATE_IP:8302:8302/udp \
		-p $PRIVATE_IP:8400:8400 \
		-p $PRIVATE_IP:8500:8500 \
		-p 172.17.42.1:53:53/udp \
		-d progrium/consul -advertise $PRIVATE_IP -join $JOIN_IP

	echo "-------------------------------------------------------------"
	echo " "
	echo "Consul agent is installed and connected to $JOIN_IP"
	echo " "
	echo "-------------------------------------------------------------"
}

function installRegistrator {
	echo "Installing Registrator"
	
	sleep 2 ; docker run -d \
    -v /var/run/docker.sock:/tmp/docker.sock \
    --name registrator \
    -h $HOSTNAME progrium/registrator consul://$PRIVATE_IP:8500
}

function using {
	echo "Using Private IP: $PRIVATE_IP"
	echo "Using Join IP: $JOIN_IP"
}

function configureUpstartJobs {
	cd /etc/init
	wget https://raw.githubusercontent.com/luiselizondo/scripts/master/upstart/consul.conf
	wget https://raw.githubusercontent.com/luiselizondo/scripts/master/upstart/registrator.conf
}

using
installConsulAgent
installRegistrator
configureUpstartJobs
