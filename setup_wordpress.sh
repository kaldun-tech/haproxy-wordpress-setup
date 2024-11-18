cd ~  
mkdir wp  
cd ~/wp
wget http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz 

#For getting Certs: Ubuntu 16+
sudo certbot certonly --standalone --dry-run --preferred-challenges http --http-01-port 54321 -d linkedguerilla.com 

sudo certbot certonly --standalone --preferred-challenges http --http-01-port 54321 -d sarcina.betterbetterbetter.website --dry-run

sudo certbot renew --standalone --preferred-challenges http --http-01-port 54321  

DOMAIN='sarcina.betterbetterbetter.website' sudo -E bash -c 'cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem /etc/letsencrypt/live/$DOMAIN/privkey.pem > /etc/haproxy/certs/$DOMAIN.pem'

sudo rm /etc/letsencyrpt/live/README

################### For First Site Cert ####################

sudo service haproxy stop
DOMAIN='test.elikeetch.com' && sudo certbot certonly --standalone --dry-run  --preferred-challenges http --http-01-port 80 -d $DOMAIN
DOMAIN='www.test.elikeetch.com' && sudo certbot certonly --standalone --preferred-challenges http --http-01-port 80 -d $DOMAIN

DOMAIN='test.elikeetch.com' sudo -E bash -c 'cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem /etc/letsencrypt/live/$DOMAIN/privkey.pem > /etc/haproxy/certs/$DOMAIN.pem'

DOMAIN='www.communitybootstrap.com' sudo -E bash -c 'cat /etc/letsencrypt/live/$DOMAIN/fullchain.pem /etc/letsencrypt/live/$DOMAIN/privkey.pem > /etc/haproxy/certs/$DOMAIN.pem'

sudo service haproxy restart
sudo service varnish restart
sudo service apache2 restart

# Update PHP settings in /etc/php/8.1/php.ini
# Update /etc/apache2/apache2.conf
sudo a2enmod rewrite
