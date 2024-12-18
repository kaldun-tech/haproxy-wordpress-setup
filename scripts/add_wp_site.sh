#!/bin/bash
# Adds a Wordpress site. Prompts for DOMAIN variable if not defined or passed as first argument

# Add error handling function
handle_error() {
    echo "Error: $1"
    return 1
}

# Add cleanup function
cleanup() {
    if [ $? -ne 0 ]; then
        echo "Site setup failed, cleaning up..."
        # Optionally remove failed installation
        if [ -d "/var/www/$DOMAIN" ]; then
            echo "Removing failed installation directory..."
            sudo rm -rf "/var/www/$DOMAIN"
        fi
        # Restore from backup if it exists
        if [ -d "$backup_dir" ]; then
            echo "Restoring from backup..."
            sudo cp -R "$backup_dir"/* "/var/www/$DOMAIN/"
        fi
    fi
}

# Set trap
trap cleanup EXIT

# Validate domain
DOMAIN=${DOMAIN}
if [ -z "$DOMAIN" ]; then
    if [ -z "$1" ]; then
        read -s -p "Enter domain name: " DOMAIN
        [ -z "$DOMAIN" ] && handle_error "Domain name cannot be empty"
    else
        DOMAIN=$1
    fi
fi

# Create backup
backup_dir="/var/www/backups/${DOMAIN}/$(date +%Y%m%d_%H%M%S)"
sudo mkdir -p "$backup_dir" || handle_error "Failed to create backup directory"
if [ -d "/var/www/$DOMAIN" ]; then
    sudo cp -R "/var/www/$DOMAIN" "$backup_dir" || handle_error "Backup failed"
fi

# Setup site structure
sudo a2ensite $DOMAIN.conf || handle_error "Failed to enable Apache site"
sudo mkdir -p /var/www/$DOMAIN/public_html || handle_error "Failed to create website directory"
sudo cp -R ~/wp/wordpress/* /var/www/$DOMAIN/public_html/ || handle_error "Failed to copy WordPress files"
cd /var/www/$DOMAIN/public_html || handle_error "Failed to change directory"
sudo chown -R www-data:www-data . || handle_error "Failed to set permissions"

# Restart Apache
sudo service apache2 restart || handle_error "Failed to restart Apache"

# Setup SSL
sudo certbot certonly --standalone --preferred-challenges http --http-01-port 54321 -d $DOMAIN || handle_error "Failed to obtain SSL certificate"
sudo -E bash -c 'cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem /etc/letsencrypt/live/$DOMAIN/privkey.pem > /etc/haproxy/certs/$DOMAIN.pem' || handle_error "Failed to setup HAProxy certificate"

# Cleanup and restart services
sudo rm /etc/letsencrypt/live/README
sudo service apache2 restart || handle_error "Failed to restart Apache"
sudo service haproxy restart || handle_error "Failed to restart HAProxy"
sudo systemctl daemon-reload || handle_error "Failed to reload systemd"

echo "WordPress site successfully set up for $DOMAIN"
