#!/bin/bash

echo "Instalando maestro-ng"

apt-get update
apt-get install -y python-pip python-dev build-essential python-yaml
/usr/local/bin/pip install --upgrade pip 
/usr/local/bin/pip install --upgrade virtualenv 

/usr/local/bin/pip install --upgrade git+git://github.com/signalfuse/maestro-ng

MAESTRO_LOCATION=$(which maestro)

echo "Maestro está instalado en $MAESTRO_LOCATION"

