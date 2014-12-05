#!/bin/bash

echo "Actualizando"
apt-get update
apt-get install -y python-pip python-dev build-essential python-yaml
/usr/bin/pip install --upgrade pip 
/usr/bin/pip install --upgrade virtualenv 

echo "Instalando maestro-ng"
/usr/bin/pip install --upgrade git+git://github.com/signalfuse/maestro-ng

MAESTRO_LOCATION=$(which maestro)
PRIVATE_IP="$(ifconfig eth1 | awk -F ' *|:' '/inet addr/{print $4}')"

echo "Maestro está instalado en $MAESTRO_LOCATION"
echo "Maestro esta usando la IP interna $PRIVATE_IP"