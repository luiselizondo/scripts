#!/bin/bash
#
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

function installAndUpdate {
	apt-get update
	apt-get install -y python-software-properties
	add-apt-repository ppa:semiosis/ubuntu-glusterfs-3.4
	apt-get update
	apt-get install -y glusterfs-client
}

function mountVolume {
	mkdir /storage-pool
	mount -t glusterfs gluster01.$FQDN:/volume1 /storage-pool
	df
}

updateHostsFile
installAndUpdate
mountVolume