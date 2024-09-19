#! /bin/bash

set -uex

wget 'https://github.com/caddyserver/caddy/releases/download/v2.8.4/caddy_2.8.4_linux_amd64.tar.gz'
tar xfv caddy_2.8.4_linux_amd64.tar.gz
rm LICENSE README.md caddy_2.8.4_linux_amd64.tar.gz


