#!/bin/bash
# Install HAProxy
sudo apt install haproxy
sudo mkdir -p /etc/haproxy/certs
sudo chmod -R go-rwx /etc/haproxy/certs
# Install Certbot
sudo apt-get install certbot