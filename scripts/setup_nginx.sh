#!/bin/bash

# Install Nginx
sudo apt update
sudo apt-get install nginx

# Restart Nginx
sudo service nginx restart
# Enable Nginx to start on boot
sudo systemctl enable nginx
