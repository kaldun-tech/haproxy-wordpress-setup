NAME="dev.redpawpacks.com" && sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$NAME.conf && sudo a2ensite $NAME.conf && sudo mkdir -p /var/www/$NAME/public_html && sudo cp -R ~/wp/wordpress/* /var/www/$NAME/public_html/ && cd /var/www/$NAME/public_html && sudo chown -R www-data:www-data .
# Edit the /etc/apache2/sites-available/$NAME.conf file to suit your needs
sudo service apache2 restart
# Make the DB
NAME="dev.redpawpacks.com" && sudo mysql --user=root --password=Yellowparrot43@ --execute="CREATE DATABASE $NAME;CREATE USER $NAME@localhost;SET PASSWORD FOR $NAME@localhost = 'Yellowparrot43@';ALTER USER '$NAME'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Yellowparrot43@';GRANT ALL PRIVILEGES ON $NAME.* TO $NAME@localhost;FLUSH PRIVILEGES;"
#  Get Certs, do it twice to get www
DOMAIN='dev.redpawpacks.com' && sudo certbot certonly --standalone --preferred-challenges http --http-01-port 54321 -d $DOMAIN

DOMAIN='dev.redpawpacks.com' sudo -E bash -c 'cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem /etc/letsencrypt/live/$DOMAIN/privkey.pem > /etc/haproxy/certs/$DOMAIN.pem'
# Restart services
sudo rm /etc/letsencrypt/live/README
sudo service apache2 restart
sudo service haproxy restart
# Update /var/www/$DOMAIN/public_html/wp-config.php
sudo tail -f /var/log/apache2/error.log | grep 1bc 