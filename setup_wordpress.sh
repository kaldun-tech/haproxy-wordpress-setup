#!/bin/bash
# Sets up Wordpress
# Requires the $DOMAIN variable to be defined or as first argument
# Requires the $HTTP_PORT variable to be defined or as second argument
cd ~  
mkdir wp  
cd ~/wp
wget http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz 

if [ -z "$DOMAIN" ]; then
    if [ -z "$1" ]; then
        echo "Please define a domain name"
        exit 1
    else
        DOMAIN=$1
    fi
fi
if [ -z "$HTTP_PORT" ]; then
    if [ -z "$2" ]; then
        echo "Please define a HTTP port"
        exit 1
    else
        HTTP_PORT=$2
    fi
fi

# Stop haproxy service
sudo service haproxy stop
# For getting Certs: Ubuntu 16+. See https://certbot.eff.org/
sudo certbot certonly --standalone --dry-run --preferred-challenges http --http-01-port $HTTP_PORT -d $DOMAIN
# Test automatic renewal
sudo certbot renew --standalone --preferred-challenges http --http-01-port $HTTP_PORT  
# Install Certs
sudo -E bash -c 'cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem /etc/letsencrypt/live/$DOMAIN/privkey.pem > /etc/haproxy/certs/$DOMAIN.pem'
sudo rm /etc/letsencyrpt/live/README
# Restart services
sudo service haproxy restart
sudo service varnish restart
sudo service apache2 restart
