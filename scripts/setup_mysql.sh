#/bin/bash
# Setup MySQL. Prompts for a root password
# Define database name, user and password using the MYSQL_NAME, MYSQL_USER and MYSQL_PASSWORD environment variables
MYSQL_NAME=${MYSQL_NAME:-wordpress}
MYSQL_USER=${MYSQL_USER}
MYSQL_PASSWORD=${MYSQL_PASSWORD}

# Add validation for required environment variables
if [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ]; then
    echo "Error: MYSQL_USER and MYSQL_PASSWORD must be set"
    exit 1
fi

# Prompt for root password
read -s -p "Enter root password: " ROOT_PASSWORD

# Install MySQL
sudo apt-get install mysql-server mysql-client
# Secure MySQL
sudo mysql_secure_installation
# Create Wordpress DB
sudo mysql -u root -p${ROOT_PASSWORD} --execute="CREATE DATABASE $MYSQL_NAME;"
sudo mysql -u root -p${ROOT_PASSWORD} --execute="CREATE USER $MYSQL_USER@localhost IDENTIFIED BY '$MYSQL_PASSWORD';"
sudo mysql -u root -p${ROOT_PASSWORD} --execute="GRANT ALL PRIVILEGES ON $MYSQL_NAME.* TO '$MYSQL_USER'@'localhost';"
sudo mysql -u root -p${ROOT_PASSWORD} --execute="FLUSH PRIVILEGES;"
# Correct permissions for crontab cert renewal
sudo chmod 007 /usr/local/sbin/le-renew-haproxy

# Test MySQL connection after setup
if ! mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; then
    echo "Error: MySQL connection test failed"
    exit 1
fi
