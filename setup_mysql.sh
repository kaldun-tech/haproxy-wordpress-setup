#/bin/bash
# Setup MySQL. Prompts for a root password
# Define database name, user and password using the DB_NAME, DB_USER and DB_PASSWORD environment variables
DB_NAME=${DB_NAME:-wordpress}
DB_USER=${DB_USER}
DB_PASSWORD=${DB_PASSWORD}

# Prompt for root password
read -s -p "Enter root password: " ROOT_PASSWORD

# Install MySQL
sudo apt-get install mysql-server mysql-client
# Secure MySQL
sudo mysql_secure_installation
# Create Wordpress DB
sudo mysql -u root -p${ROOT_PASSWORD} --execute="CREATE DATABASE $DB_NAME;"
sudo mysql -u root -p${ROOT_PASSWORD} --execute="CREATE USER $DB_USER@localhost IDENTIFIED BY '$DB_PASSWORD';"
sudo mysql -u root -p${ROOT_PASSWORD} --execute="GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@localhost;"
sudo mysql -u root -p${ROOT_PASSWORD} --execute="FLUSH PRIVILEGES;"
# Correct permissions for crontab cert renewal
sudo chmod 007 /usr/local/sbin/le-renew-haproxy
