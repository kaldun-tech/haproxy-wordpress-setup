#!/bin/bash

sudo cp etc/cron.d/haproxy-cert-renewal /etc/cron.d/haproxy-cert-renewal
sudo cp usr/local/sbin/le-renew-haproxy /usr/local/sbin/le-renew-haproxy
# Correct permissions
sudo chmod 007 /usr/local/sbin/le-renew-haproxy
# Test the script
sudo /usr/local/sbin/le-renew-haproxy
# Restart cron
sudo service cron restart
