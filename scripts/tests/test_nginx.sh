#!/bin/bash

# Test Nginx
netstat -tlnp | grep 443
if [ $? -eq 0 ]; then
    echo "Nginx is up and running"
else
    echo "Nginx is not up and running"
    exit 1
fi

sudo systemctl status nginx
