#!/bin/bash

echo "Instalando maestro-ng"

apt-get install -y python-pip python-dev build-essential
pip install --upgrade pip 
pip install --upgrade virtualenv 
apt-get install -y python-yaml

pip install --upgrade git+git://github.com/signalfuse/maestro-ng

MAESTRO_LOCATION=$(which maestro)

echo "Maestro está instalado en $MAESTRO_LOCATION"

