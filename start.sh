#!/usr/bin/env bash

# copy the config so we don't overrite the orig
cp -f /data/bud.json $(hostname)_bud.json
# replace any refrence to backend_ip so we can link containers
sed -e "s/backend_ip/$(cat /etc/hosts | grep backend | awk '{print $1}')/" -i /data/$(hostname)_bud.json

exec bud -c /data/$(hostname)_bud.json
