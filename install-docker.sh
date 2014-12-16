#!/bin/bash

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 1 ] || die "first argument is required, $# provided"

curl -sSL https://get.docker.com/ubuntu/ | sh

echo "Configuring Docker"
echo 'DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --dns 8.8.8.8 --dns 8.8.4.4 --insecure-registry docker.iiiepe.net:80"' >> /etc/default/docker
service docker restart

echo "Configuring IP Tables"

iptables -A INPUT -p tcp --dport 2375 -s $1 -j ACCEPT
iptables -A INPUT -p tcp --dport 2375 -j DROP

iptables-save
iptables-save > /etc/iptables.rules