#!/bin/bash

MAESTRO_IP = $1

curl -sSL https://get.docker.com/ubuntu/ | sh

echo "Configuring Docker"
echo 'DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --dns 8.8.8.8 --dns 8.8.4.4"' >> /etc/default/docker
service docker restart

echo "Configuring IP Tables"

iptables -A INPUT -p tcp --dport 2375-s $MAESTRO_IP -j ACCEPT
iptables -A INPUT -p tcp --dport 2375-j DROP

iptables-save
iptables-save > /etc/iptables.rules