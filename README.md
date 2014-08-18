# Docker container for [bud-tls](https://github.com/indutny/bud)

Docker container for Bud, a TLS terminator for superheroes.

## Dependencies

[dockerfile/nodejs](https://github.com/dockerfile/nodejs)

## Installation

1. Install [Docker](https://www.docker.io/).

2. `docker pull joeybaker/bud-tls`

## Usage
### default usage
Create a folder that contains your bud config and all certs. This will live at `/data` in the container, so refer to the certs by this absolute path in your config.

Sample directory to mount as `/data`
```bash
ls ~/bud
keys
  - key.pem
  - cert.pem
bud.json
```

Sample `bud.json`.
```json
{
  "workers": 1,
  "user": "bud", // specify the user and group.
  "group": "bud",
  "frontend": {
    "port": 443,
    "host": "0.0.0.0",
    "cert": "/data/keys/cert.pem", // your keys are now relative to /data
    "key": "/data/keys/key.pem",
  },
  "balance": "roundrobin",
  "backend": [{
    "port": 8000,
    "host": "127.0.0.1",
  }]
}
`
```

```bash
sudo docker run -d -v ~/bud:/data -p 443:443  joeybaker/bud-tls
```

### forward a port for another docker container
In your bud.json
```json
  "backend": [{
    "port": backend_port, // must be set to backend_port so the config script can dynamicall replace with the other container's port
    "host": "backend_ip", // must set to backend_ip so the config script can dynamically replace this with the other container's ip
  }]
```

Then, run the docker command with `--link`. `backendContainer` is the name of the container you want to expose. You must expose it as `backend`.
```bash
sudo docker run -d -v ~/bud:/data -p 443:443 --link backendContainer:backend joeybaker/bud-tls
```
