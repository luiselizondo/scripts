#!/bin/bash

echo "Instalando el registro privado de Docker"

docker run \
  -e SETTINGS_FLAVOR=local \
  -e STORAGE_PATH=/registry \
  -p 80:5000 \
  -v /registry:/registry \
  -d registry
  
echo "Felicidades, ahora ya puedes crear tags con:"
echo "docker tag id example.com/nombre y hacer push con:"
echo "docker push example.com/nombre"