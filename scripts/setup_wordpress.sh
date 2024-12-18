#!/bin/bash
# Sets up Wordpress
# Requires the $DOMAIN variable to be defined or as first argument
# Requires the $HTTP_PORT variable to be defined or as second argument
cd ~  
mkdir wp  
cd ~/wp
wget http://wordpress.org/latest.tar.gz || handle_error "Failed to download WordPress"
tar -xzvf latest.tar.gz || handle_error "Failed to extract WordPress"

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

# Install Wordpress command line interface via Composer
# Install PHP and Composer dependencies
sudo apt-get install -y composer php-curl php-cli php-xml php-zip php-intl php-mysql php-gd php-mbstring php-xml php-xmlrpc php-soap php-imagick php-json php-redis php-memcached

# Install WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

# Add WP-CLI to PATH if not already present
if ! grep -q "wp-cli" ~/.bashrc; then
    echo 'export PATH="$PATH:/usr/local/bin"' >> ~/.bashrc
    source ~/.bashrc
fi

# Verify installation
wp --info
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

# Configure wp-config.php
cd wordpress
cp wp-config-sample.php wp-config.php

# Add security keys and salts for Wordpress authentication
curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> wp-config.php

# Add performance optimizations
cat >> wp-config.php <<EOF

# Performance optimizations
define('WP_CACHE', true); # Enable caching
define('WP_POST_REVISIONS', 5); # Limit post revisions
define('EMPTY_TRASH_DAYS', 7); # Empty trash after 7 days
define('WP_MEMORY_LIMIT', '256M'); # Increase memory limit

# Security hardening
define('DISALLOW_FILE_EDIT', true); # Disable file editing
define('FORCE_SSL_ADMIN', true); # Force SSL for admin
define('WP_DEBUG', false); # Disable debug mode
EOF

# Set proper permissions
find . -type d -exec chmod 755 {} \;
find . -type f -exec chmod 644 {} \;

# Install essential security plugins via WP-CLI
# Wordfence firewall: https://wordpress.org/plugins/wordfence/
wp plugin install wordfence --activate || handle_error "Failed to install Wordfence"
# Limit Login Attempts Reloaded protects against brute force attacks: https://wordpress.org/plugins/limit-login-attempts-reloaded/
wp plugin install limit-login-attempts-reloaded --activate || handle_error "Failed to install Limit Login Attempts Reloaded"
# WP Security Audit Log: https://wordpress.org/plugins/wp-security-audit-log/
wp plugin install wp-security-audit-log --activate || handle_error "Failed to install security audit log"

# Install caching plugin to improve performance
wp plugin install w3-total-cache --activate

# Add error handling function
handle_error() {
    echo "Error: $1"
    # Don't need explicit exit here - cleanup will be triggered
    return 1
}

# Add cleanup function
cleanup() {
    if [ $? -ne 0 ]; then
        echo "Installation failed, cleaning up..."
        cd ~
        # Remove WordPress directory if it exists
        [ -d "wp" ] && rm -rf wp
        # Remove downloaded archive if it exists
        [ -f "latest.tar.gz" ] && rm latest.tar.gz
        echo "Cleanup completed"
        exit 1  # Ensure script exits with error status
    else
        # Clean up successful installation
        echo "Installation successful, removing temporary files..."
        [ -f "latest.tar.gz" ] && rm latest.tar.gz
        echo "Cleanup completed"
    fi
}

# Set trap
trap cleanup EXIT
