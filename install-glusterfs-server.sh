#!/bin/bash

GLUSTER_1_IP=$1
GLUSTER_2_IP=$2
FQDN=$3

die () {
    echo >&2 "$@"
    exit 1
}

# [ "$#" -eq 1 ] || die "first argument is required, $# provided"

function updateHostsFile {
	echo "$GLUSTER_1_IP    gluster01.$FQDN" >> /etc/hosts
	echo "$GLUSTER_2_IP    gluster02.$FQDN" >> /etc/hosts
}

function updateAndInstall {
	apt-get update
	apt-get install -y python-software-properties
	add-apt-repository ppa:semiosis/ubuntu-glusterfs-3.4
	apt-get update
	apt-get install -y glusterfs-server
}

function connect {
	gluster peer probe gluster01.$FQDN
}

updateHostsFile
updateAndInstall
connect
