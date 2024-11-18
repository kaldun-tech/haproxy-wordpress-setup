# haproxy-wordpress-setup

Scripts to set up HAProxy with WordPress on a Linux server

0. Check timezone is correct with timedatectl list-timezones and set-timezone
1. Add your user by editing and running: setup_user.sh
2. Setup Adminer
3. Setup Apache2
4. Setup HAProxy
5. Setup Wordpress
6. Setup MySQL
7. Autorenew script in /usr/local/sbin/le-renew-proxy
8. Add Wordpress sites
