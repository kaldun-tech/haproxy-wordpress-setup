#!/bin/bash

# Test Nginx
netstat -tlnp | grep 443
if [ $? -eq 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Nginx is up and running"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Nginx is NOT up and running"
    exit 1
fi

sudo systemctl status nginx
