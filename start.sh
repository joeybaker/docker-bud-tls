#!/usr/bin/env bash
# unoffical bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

function start_bud(){
  local backend
  local backend_ip
  local backend_port

  # if there's no linked container, just use the IP of the host
  if [ -z ${BACKEND_PORT+x} ]; then
    backend_ip=$(netstat -nr | grep '^0\.0\.0\.0' | awk '{print $2}')
  # else, get the IP of the linked container
  else
    # Docker sets this var based on linking as "backend"
    #                               remove the  tcp://
    backend="$(echo $BACKEND_PORT | cut -c 7-)"
    #                             get just the ip
    backend_ip="$(echo $backend | cut -d ':' -f1)"
    backend_port="$(echo $backend | cut -d ':' -f2-)"
  fi

  # copy the config so we don't overrite the orig
  cp -f /data/bud.json $(hostname)_bud.json
  # replace any refrence to backend_ip so we can link containers
  # or just get to the host container
  echo "Setting backend ip to: $backend_ip"
  sed -e "s/backend_ip/$backend_ip/" -i /data/$(hostname)_bud.json
  if [ -z ${backend_port+x} ]; then
    # unset, do nothing
    echo 'no backend port to set'
  else
    sed -e "s/backend_port/$backend_port/" -i /data/$(hostname)_bud.json
  fi

  # start bud
  exec /opt/bud/bud -c /data/$(hostname)_bud.json
}
start_bud
