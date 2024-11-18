#  0 3 * * * /usr/local/sbin/le-renew-haproxy

#            CERTBOT
# BEGIN autorenew script for multiple domains 
#            CERTBOT


#!/bin/bash
certbot renew --standalone --preferred-challenges http --http-01-port 54321  

sudo bash -c "rm /etc/letsencrypt/live/README"

for i in $( ls /etc/letsencrypt/live ); do

web_service='haproxy'
domain=$i
http_01_port='54321'
combined_file="/etc/haproxy/certs/${domain}.pem"
exp_limit=30;

echo ""
echo "############################################################"
echo "########   $domain  :  ($days_exp days left)    ########"
echo "############################################################"
echo ""


cert_file="/etc/letsencrypt/live/$domain/fullchain.pem"
key_file="/etc/letsencrypt/live/$domain/privkey.pem"

if [ ! -f $cert_file ]; then
  echo "[ERROR] certificate file not found for domain $domain."
fi

exp=$(date -d "`openssl x509 -in $cert_file -text -noout|grep "Not After"|cut -c 25-`" +%s)
datenow=$(date -d "now" +%s)
days_exp=$(echo \( $exp - $datenow \) / 86400 |bc)


  echo "Creating $combined_file with latest certs..."
  sudo bash -c "cat /etc/letsencrypt/live/$domain/fullchain.pem /etc/letsencrypt/live/$domain/privkey.pem > $combined_file"

  echo "Renewal process finished for domain $domain"

done


  echo "Reloading $web_service"
  /usr/sbin/service $web_service reload

#END autorenew script