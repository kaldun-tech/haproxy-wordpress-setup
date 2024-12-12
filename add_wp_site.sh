#!/bin/bash
# Adds a Wordpress site. Prompts for domain if not defined or passed as first argument
# Define database name, user and password using the MYSQL_NAME, MYSQL_USER and MYSQL_PASSWORD environment variables
MYSQL_NAME=${MYSQL_NAME:-wordpress}
MYSQL_USER=${MYSQL_USER}
MYSQL_PASSWORD=${MYSQL_PASSWORD}
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
# Make the DB
sudo mysql --user=root --password=$MYSQL_PASSWORD --execute="CREATE DATABASE $MYSQL_NAME;CREATE USER $DB_USER@localhost;SET PASSWORD FOR $DB_USER@localhost = '$MYSQL_PASSWORD';ALTER USER '$DB_USER'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_PASSWORD';GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@localhost;FLUSH PRIVILEGES;"
#  Get Certs, do it twice to get www
sudo certbot certonly --standalone --preferred-challenges http --http-01-port 54321 -d $DOMAIN

sudo -E bash -c 'cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem /etc/letsencrypt/live/$DOMAIN/privkey.pem > /etc/haproxy/certs/$DOMAIN.pem'
# Restart services
sudo rm /etc/letsencrypt/live/README
sudo service apache2 restart
sudo service haproxy restart
