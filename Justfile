

server_host := `cat rathole-domain.txt`
ssh_host := "root@" + server_host


default:
  just --list

host:
  echo {{server_host}}

ssh:
  ssh {{ssh_host}}

start:
  #!/usr/bin/env bash
  set -ue
  # create the resorces
  # build the config 
  ./scripts/build-rathole-config.py
  # scp the configs to the server
  scp config/rathole-server.toml {{ssh_host}}:
  scp config/Caddyfile {{ssh_host}}:
  # scp the scripts to the server
  scp scripts/run-server-tmux.sh {{ssh_host}}:
  scp scripts/run-caddy.sh {{ssh_host}}:
  scp scripts/download-caddy.sh {{ssh_host}}:
  # ensure the rathole bin is downloaded
  ./scripts/download-rathole.sh
  # scp the rathole binary to the server
  scp bin/rathole {{ssh_host}}:
  # run the download-caddy script
  ssh {{ssh_host}} "./download-caddy.sh"
  # start the rathole server
  ssh {{ssh_host}} "./run-server-tmux.sh"
  # start caddy
  ssh {{ssh_host}} "./run-caddy.sh"
  echo "https srever address https://{{server_host}}"
  # run the rathole client
  ./bin/rathole -c config/rathole-client.toml





