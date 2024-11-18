sudo apt install haproxy
# Update /etc/haproxy/haproxy.cfg
sudo mkdir -p /etc/haproxy/certs
sudo chmod -R go-rwx /etc/haproxy/certs

sudo apt-get install certbot
sudo nano /usr/local/sbin/le-renew-haproxy
sudo chmod 007 /usr/local/sbin/le-renew-haproxy
sudo crontab -e
# See haproxy_crontab_autorenew.sh
# Update /etc/apache2/sites-available/000-default.conf