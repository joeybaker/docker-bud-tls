#!/usr/bin/env bash
# unoffical bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

function start_bud(){
  local backend
  local backend_ip
  local backend_port

  # if docker has not defined a backend port just go, else put it in the config
  if [ -z ${BACKEND_PORT+x} ]; then
    backend_ip=$(netstat -nr | grep '^0\.0\.0\.0' | awk '{print $2}')
  else
    # Docker sets this var based on linking as "backend"
    #                               remove the  tcp://
    backend="$(echo $BACKEND_PORT | cut -c 7-)"
    #                             get just th ip
    backend_ip="$(echo $backend | cut -d ':' -f1)"
    backend_port="$(echo $backend | cut -d ':' -f2-)"
  fi

  echo "Setting backend ip to: $backend_ip"
  local bud_json=$(
    cat /data/bud.json |
    # set the write backend ip
    sed "s/backend_ip/$backend_ip/"
  )

  # if we need to set the backend port, do that
  if [ -z ${backend_port+x} ]; then
    # unset, do nothing
    echo "no backend port to set"
  else
    bud_json=$(echo $bud_json | sed "s/backend_port/$backend_port/")
  fi

  echo $bud_json | /opt/bud/bud -p
}
start_bud
