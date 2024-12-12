#!/bin/bash
# Adds a Wordpress site. Prompts for DOMAIN variable if not defined or passed as first argument
DOMAIN=${DOMAIN}

if [ -z "$DOMAIN" ]; then
    if [ -z "$1" ]; then
        read -s -p "Enter domain name: " DOMAIN
    else
        DOMAIN=$1
    fi
fi

sudo a2ensite $DOMAIN.conf && sudo mkdir -p /var/www/$DOMAIN/public_html && sudo cp -R ~/wp/wordpress/* /var/www/$DOMAIN/public_html/ && cd /var/www/$DOMAIN/public_html && sudo chown -R www-data:www-data .
sudo service apache2 restart
#  Get certs for www
sudo certbot certonly --standalone --preferred-challenges http --http-01-port 54321 -d $DOMAIN
sudo -E bash -c 'cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem /etc/letsencrypt/live/$DOMAIN/privkey.pem > /etc/haproxy/certs/$DOMAIN.pem'
# Restart services
sudo rm /etc/letsencrypt/live/README
sudo service apache2 restart
sudo service haproxy restart
