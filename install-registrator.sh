#!/bin/bash

PRIVATE_IP=$(ifconfig eth0 | awk -F ' *|:' '/inet addr/{print $4}')
JOIN_IP=$1

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 1 ] || die "first argument is required, $# provided"

function installRegistrator {
	echo "Installing Registrator"
	
	sleep 2 ; docker run -d \
    -v /var/run/docker.sock:/tmp/docker.sock \
    --name registrator \
    -h $HOSTNAME gliderlabs/registrator:latest consul://$JOIN_IP:8500
}

function using {
	echo "Using Private IP: $PRIVATE_IP"
	echo "Using Join IP: $JOIN_IP"
}

function configureUpstartJobs {
	cd /etc/init
	wget https://raw.githubusercontent.com/luiselizondo/scripts/master/upstart/registrator.conf
}

using
installRegistrator
configureUpstartJobs