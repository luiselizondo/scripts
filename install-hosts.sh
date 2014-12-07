#!/bin/bash

read -p "Enter FQDN: " FQDN
read -p "Enter Maestro-NG Internal IP: " MAESTROIP
read -p "Enter Load Balancer Internal IP: " LBIP
read -p "Enter how many hosts do you want to configure: " HOSTCOUNT

echo "$MAESTROIP    maestro.$FQDN" 
echo "$LBIP	    lb.$FQDN"
echo "IP 	    node1.$FQDN"
