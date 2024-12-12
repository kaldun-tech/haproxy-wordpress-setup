# haproxy-wordpress-setup

## Set up HAProxy with WordPress on Linux

0. Check timezone is correct using `timedatectl list-timezones` and `set-timezone` arguments
1. Add your user: `./setup_user.sh [user]`

- Update `/etc/ssh/sshd_config` with the correct port
- Reboot or `sudo service ssh restart`

2. Setup PHP: `./setup_php.sh`
3. Setup Adminer: `./setup_adminer.sh`
4. Install Varnish: `./install_varnish.sh`

- Update config files: `/etc/default/varnish` `/etc/varnish/default.vcl` `/lib/systemd/system/varnish.service`
- Restart Varnish: `./restart_varnish.sh`

5. Define certificate folders for each domain name in `/etc/letsencrypt/live`
6. Setup HAProxy: `./setup_haproxy.sh`

- Update `/etc/haproxy/haproxy.cfg` `/usr/local/sbin/le-renew-haproxy`
- Set executable: `sudo chmod 007 /usr/local/sbin/le-renew-haproxy`
- Update crontab: `sudo crontab haproxy_crontab_autorenew.cron`
- Update `/etc/apache2/sites-available/000-default.conf`

7. Setup Wordpress

- Update PHP settings in `/etc/php/8.1/apache2/php.ini`
- Update Apache2 configuration `/etc/apache2/apache2.conf`
- Enable Apache modules: `./setup_apache2.sh`

8. Configure the `setup_mysql.sh` script

- Set the `MYSQL_NAME MYSQL_USER MYSQL_PASSWORD` environment variables using the `export <var>=<value>` keyword.
- `MYSQL_NAME` defaults to `wordpress` if not defined.
- Run the script, it prompts for the root password: `./setup_mysql.sh`

9. Place certificate autorenew script in `/usr/local/sbin/le-renew-haproxy`
10. Configure the `add_wp_site.sh` script

- Set the `DOMAIN` environment variable using `export DOMAIN=<value>`
- Copy the default domain configuration `sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$DOMAIN.conf`
- Configure `/etc/apache2/sites-available/$DOMAIN.conf`
- Run script to add Wordpress sites: `./add_wp_site.sh`

11. Update WordPress config: `/var/www/$DOMAIN/public_html/wp-config.php`

- Check Apache error logs: `sudo tail -f /var/log/apache2/error.log | grep 1bc `

## Testing

1. Check MySQL connection and WordPress database

- Log into your MySQL server using the command line: `mysql -u <user> -p`
- If you can connect successfully, your MySQL is running properly.
- Once connected to MySQL, list the databases: `SHOW DATABASES;`
- Ensure your WordPress database is listed.

2. Test WordPress installation:

- Open a web browser and navigate to your server's IP address or domain name.
- If you see the WordPress installation page or your WordPress site, it indicates that Apache/Nginx and PHP are working correctly with WordPress.

3. Check WordPress configuration:

- Verify the wp-config.php file in your WordPress root directory contains the correct database credentials.

4. Review server logs:

- Check Apache/Nginx error logs for any PHP or MySQL related errors: `sudo tail -f /var/log/apache2/error.log`
- or `sudo tail -f /var/log/nginx/error.log`

5. Test PHP processing:

- Create a simple PHP file (e.g., test.php) in your web root with the following content: `<?php phpinfo(); ?>`
- Access this file through your web browser to ensure PHP is working correctly.

6. Check WordPress functionality:

- Log into the WordPress admin panel (usually at /wp-admin)
- Create a test post or page to ensure the database is writable

## Future improvements

- Look into a more robust configuration management tool like Ansible or Puppet to manage configuration.
- Add scripts to automate certificate renewal and SSL termination.
- Configure WordPress to use the HAProxy load balancer.
- Implement security best practices, such as using environment variables or a secrets manager to store sensitive information.
- Add error handling mechanisms to handle unexpected errors.
