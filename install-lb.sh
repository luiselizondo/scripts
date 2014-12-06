#!/bin/bash

PRIVATE_IP=$(ifconfig eth1 | awk -F ' *|:' '/inet addr/{print $4}')

echo "Installing Docker"
function installDocker {
	curl -sSL https://get.docker.com/ubuntu/ | sh
}

function installConsul {
	echo "Installing Load Balancer and Service Registry"
	
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
	echo "Installing Load Balancer Nginx"
	apt-get install -y nginx

	cp /etc/nginx/sites-enabled/default /etc/nginx/default-disabled
	rm /etc/nginx/sites-enabled
}

function installConsulTemplate {
	echo "Installing Consul Template"
	cd /tmp
	wget https://github.com/hashicorp/consul-template/releases/download/v0.3.1/consul-template_0.3.1_linux_amd64.tar.gz
	tar zxvf consul-template_0.3.1_linux_amd64.tar.gz
	cd consul-template_0.3.1_linux_amd64
	mv consul-template /usr/local/bin/consul-template
	chmod +x /usr/local/bin/consul-template
	which consul-template
}

function configureConsulTemplateWithNginx {
	echo "Visit https://hashicorp.com/blog/introducing-consul-template.html"
}

function using {
	echo "Using Private IP: $PRIVATE_IP"
}

using
installDocker
installConsul
installLoadBalancer
installConsulTemplate
configureConsulTemplateWithNginx