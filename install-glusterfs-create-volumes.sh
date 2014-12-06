#!/bin/bash

FQDN=$1

function createVolume {
	gluster volume create volume1 replica 2 transport tcp gluster01.$FQDN:/gluster-storage gluster02.$FQDN:/gluster-storage force
}

function startVolume {
	gluster volume start volume1

	echo "Volume started"
}

createVolume
startVolume