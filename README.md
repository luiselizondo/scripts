
### Install Docker Registry
		
		curl -sSL https://raw.githubusercontent.com/luiselizondo/scripts/master/install-docker-registry.sh | sh

### Install Maestro-ng

		curl -sSL https://raw.githubusercontent.com/luiselizondo/scripts/master/install-maestro-ng.sh | bash

### Install Consul and Load Balancer

		curl -sSL https://raw.githubusercontent.com/luiselizondo/scripts/master/install-lb.sh | bash

### Install Docker on Server and Configure it to talk to Maestro-NG

		curl -sSL https://raw.githubusercontent.com/luiselizondo/scripts/master/install-docker.sh | bash -s 10.132.187.57

### Install Consul Agent

		curl -sSL https://raw.githubusercontent.com/luiselizondo/scripts/master/install-consul-agent.sh | bash -s IP_DE_LB

### Install GlusterFS/NFS

		curl -sSL https://raw.githubusercontent.com/luiselizondo/scripts/master/install-glusterfs-server.sh | bash