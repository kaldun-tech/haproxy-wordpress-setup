# haproxy-wordpress-setup

Scripts to set up HAProxy with WordPress on a Linux server

0. Check timezone is correct using `timedatectl list-timezones` and `set-timezone` arguments
1. Add your user: `setup_user.sh [user]`

- Update `/etc/ssh/sshd_config` with 21212
- Reboot or `sudo service ssh restart`

2. Setup PHP: `setup_php.sh`
3. Setup Adminer: `setup_adminer.sh`
4. Install Varnish: `install_varnish.sh`

- Update config files: `/etc/default/varnish` `/lib/systemd/system/varnish.service` `/etc/varnish/default.vcl`
- Restart Varnish: `restart_varnish.sh`

5. Define certificates for domain names in `/etc/letsencrypt/live`
6. Setup HAProxy: `setup_haproxy.sh`

- Update `/etc/haproxy/haproxy.cfg`, `/usr/local/sbin/le-renew-haproxy`
- Set executable: `sudo chmod 007 /usr/local/sbin/le-renew-haproxy`
- Update crontab: `sudo crontab haproxy_crontab_autorenew.cron`
- Update `/etc/apache2/sites-available/000-default.conf`

7. Setup Wordpress

- Update PHP settings in `/etc/php/8.1/php.ini`
- Update Apache2 configuration `/etc/apache2/apache2.conf`
- Enable Apache modules: `sudo a2enmod rewrite`

8. Setup MySQL: `setup_mysql.sh [NAME]`
9. Place certificate autorenew script in `/usr/local/sbin/le-renew-proxy`
10. Add Wordpress sites: `add_wp_site.sh [NAME] [MYSQL_PASSWORD]`

# Future improvements

- Look into a more robust configuration management tool like Ansible or Puppet to manage configuration.
- Add scripts to automate certificate renewal and SSL termination.
- Configure WordPress to use the HAProxy load balancer.
- Implement security best practices, such as using environment variables or a secrets manager to store sensitive information.
- Add error handling mechanisms to handle unexpected errors.
