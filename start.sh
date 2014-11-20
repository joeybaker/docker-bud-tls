#!/usr/bin/env bash
# unoffical bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

function start_bud(){
  # Docker sets this var based on linking as "backend"
  #                               remove the  tcp://
  local backend="$(echo $BACKEND_PORT | cut -c 7-)"
  #                             get just th ip
  local backend_ip="$(echo $backend | cut -d ':' -f1)"
  local backend_port="$(echo $backend | cut -d ':' -f2-)"

  # copy the config so we don't overrite the orig
  cp -f /data/bud.json $(hostname)_bud.json
  echo "Backend IP curl: "
  curl "$backend"
  # replace any refrence to backend_ip so we can link containers
  echo "Setting backend ip to: $backend_ip"
  sed -e "s/backend_ip/$backend_ip/" -i /data/$(hostname)_bud.json
  sed -e "s/backend_port/$backend_port/" -i /data/$(hostname)_bud.json
  exec /opt/bud/bud -c /data/$(hostname)_bud.json
  # cleanup after ourselves since bud needs a file
  rm -f /data/$(hostname)_bud.json
}
start_bud
