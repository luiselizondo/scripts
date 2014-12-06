#!/bin/bash
# Esto no funciona
# REvisar https://github.com/hashicorp/consul-template
# 
function installConf {
	cd /tmp
	wget https://github.com/kelseyhightower/confd/releases/download/v0.6.3/confd-0.6.3-linux-amd64
	mv confd* /usr/local/bin/confd
	chmod +x /usr/local/bin/confd

	wget https://github.com/hashicorp/consul-template/releases/download/v0.3.1/consul-template_0.3.1_linux_amd64.tar.gz
	tar zxvf consul-template_0.3.1_linux_amd64.tar.gz
	cd consul-template_0.3.1_linux_amd64
	mv consul-template /usr/local/bin/consul-template
}

function configureDirectories {
	mkdir -p /etc/confd/{conf.d,templates}
}

function createConfig {
	cat > /etc/confd/conf.d/haproxy.toml <<EOF 
[template]
src = "haproxy.cfg.tmpl"
dest = "/etc/haproxy/haproxy.cfg"
reload_cmd = "/usr/sbin/service haproxy reload"
EOF
}

function createTemplate {
	cat > /etc/confd/templates/haproxy.cfg.tmpl <<EOF
defaults
  log     global
  mode    http

listen frontend 0.0.0.0:8080
  mode http
  stats enable
  stats uri /haproxy?stats
  balance roundrobin
  option httpclose
  option forwardfor
  {{range service "production.app"}}
  server {{.Address}}:{{.Port}} check
  {{end}}
EOF
}

function startConfd {
	# nohup confd -verbose -onetime -backend consul -node 127.0.0.1:8500 -confdir /etc/confd > /var/log/confd.log &
	# 
	
	consul-template \
  -consul 127.0.0.1:8500 \
  -template "/tmp/template.ctmpl:/var/www/nginx.conf:service nginx restart"
  -once

 	# consul-template -consul 10.132.187.58:8500 -template "/etc/confd/templates/nginx.tmpl:/etc/nginx/nginx.conf:service nginx restart" -once

}

function runService {
	apt-get update
	apt-get install -y haproxy
}

installConf
configureDirectories
createConfig
createTemplate
startConfd
runService