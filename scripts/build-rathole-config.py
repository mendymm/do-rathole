#!/usr/bin/env python3
import secrets
import os

secret_token = secrets.token_urlsafe(64)


def get_server_host():
    with open("rathole-domain.txt", "r") as f:
        return f.read().strip()


def write_caddyfile(server_host):
    caddyfile = f"""
{server_host} {{
    reverse_proxy /whatsapp_webhook/* localhost:8080
}}
"""
    with open("config/Caddyfile", "w") as f:
        f.write(caddyfile)


def write_server_config():
    global secret_token
    server_config = f"""
# server.toml
[server]
bind_addr = "0.0.0.0:2333" # `2333` specifies the port that rathole listens for clients

[server.services.web_server]
token = "{secret_token}"
bind_addr = "127.0.0.1:8080" #
"""
    with open("config/rathole-server.toml", "w") as fw:
        fw.write(server_config)


def write_client_config(server_host: str):
    global secret_token
    client_config = f"""
[client]
remote_addr = "{server_host}:2333" 

[client.services.web_server]
token = "{secret_token}" # Must be the same with the server to pass the validation
local_addr = "127.0.0.1:8080" # The address of the service that needs to be forwarded
"""
    with open("config/rathole-client.toml", "w") as fw:
        fw.write(client_config)


def main():
    if not os.path.exists("config"):
        os.mkdir("config")
    server_host = get_server_host()
    write_client_config(server_host)
    write_server_config()
    write_caddyfile(server_host)


main()
