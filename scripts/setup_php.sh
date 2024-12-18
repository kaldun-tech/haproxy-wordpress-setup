#!/bin/bash
sudo apt-get install -y language-pack-en-base
sudo LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php

sudo apt-get install php8.1 php8.1-mysql php8.1-curl php8.1-gd php8.1-intl php-pear php8.1-imagick php8.1-imap php8.1-memcache php8.1-ps php8.1-pspell php8.1-snmp php8.1-sqlite php8.1-tidy php8.1-xmlrpc php8.1-xsl libapache2-mod-php8.1

sudo apt-get install mysql-server mysql-client
sudo mysqld --initialize

# Add PHP optimization
sudo tee /etc/php/8.1/apache2/conf.d/wordpress-recommended.ini <<EOF
upload_max_filesize = 64M
post_max_size = 64M
max_execution_time = 300
max_input_vars = 3000
memory_limit = 256M
opcache.enable=1
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4000
opcache.revalidate_freq=60
opcache.fast_shutdown=1
EOF

sudo service apache2 restart
