#!/bin/bash
FQDN=$1

die () {
    echo >&2 "$@"
    exit 1
}

# [ "$#" -eq 1 ] || die "first argument is required, $# provided"


echo "Montando volume"
mkdir /storage-pool
mount -t glusterfs gluster01.$FQDN:/volume1 /storage-pool

echo "gluster01.$FQDN:/volume1 /storage-pool glusterfs defaults" >> /etc/fstab
df
