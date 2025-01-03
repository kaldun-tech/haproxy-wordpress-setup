# haproxy-wordpress-setup

## Set up HAProxy and LAMP stack with WordPress

1. Check timezone is correct using `timedatectl`.

- Use the `list-timezones` and `set-timezone` arguments to list and set timezones appropriately.

2. Add your user: `./scripts/setup_user.sh [user]`

- Update `/etc/ssh/sshd_config` with the correct port
- Reboot or `sudo service ssh restart`

3. Setup PHP: `./scripts/setup_php.sh`
4. Setup Adminer: `./scripts/setup_adminer.sh`
5. Install Varnish: `./scripts/install_varnish.sh`

- Update config files: `/etc/default/varnish` `/etc/varnish/default.vcl` `/lib/systemd/system/varnish.service`
- Restart Varnish: `./scripts/restart_varnish.sh`

6. Define certificate folders for each domain name in `/etc/letsencrypt/live`
7. Create a cron job to renew certificates at 3 AM daily

- Run `./scripts/setup_crontab.sh`
- Test with `sudo crontab -e` and check the cron job is added
- Verify crontab syntax is correct: `crontab -l | crontab -`

8. Setup HAProxy: `./scripts/setup_haproxy.sh`

- Update `/etc/haproxy/haproxy.cfg` `/usr/local/sbin/le-renew-haproxy`
- Set executable: `sudo chmod 007 /usr/local/sbin/le-renew-haproxy`
- For each domain copy and update the file `/etc/apache2/sites-available/000-default.conf` as `[DOMAIN].conf`
- Enable each site by creating a symbolic link to the corresponding config file in sites-enabled: `sudo ln -s /etc/apache2/sites-available/[DOMAIN].conf /etc/apache2/sites-enabled/`

9. Setup Apache

- Update PHP settings in `/etc/php/8.1/apache2/php.ini`
- Update Apache2 configuration `/etc/apache2/apache2.conf`
- Enable Apache modules: `./scripts/setup_apache2.sh`
- Verify Apache configuration: `sudo apache2ctl -t`
- Test with `./scripts/tests/test_lamp.sh`

10. Configure the `setup_mysql.sh` script

- Set the `MYSQL_NAME MYSQL_USER MYSQL_PASSWORD` environment variables using the `export <var>=<value>` keyword.
- `MYSQL_NAME` defaults to `wordpress` if not defined.
- Run the script, enter root password when prompted: `./scripts/setup_mysql.sh`
- Test with `./scripts/tests/test_mysql.sh`

11. Place certificate autorenew script in `/usr/local/sbin/le-renew-haproxy`
12. Configure the `add_wp_site.sh [DOMAIN]` script

- Set the `DOMAIN` environment variable using `export DOMAIN=<value>`
- Copy the default configuration to your domain: `sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$DOMAIN.conf`
- Configure `/etc/apache2/sites-available/$DOMAIN.conf`
- Run script to add a Wordpress site: `./scripts/add_wp_site.sh [DOMAIN]`

13. Check WordPress config is added to the correct directory: `/var/www/DOMAIN/public_html/wp-config.php`

- Customize configuration appropriately

14. Test with `/scripts/test_wordpress.sh [DOMAIN]`

- Check Apache error logs: `sudo tail -f /var/log/apache2/error.log | grep 1bc `

## Optional: Setup and test Nginx for load balancing, reverse proxy and security

- Copy `etc/nginx/sites-available/default.conf` to your `/etc/nginx/sites-available` folder
- For each domain copy and customize `default.conf` to `[DOMAIN].conf`
- Run `./scripts/setup_nginx.sh`
- Create symbolic links for each domain `sudo ln -s /etc/nginx/sites-available/[DOMAIN].conf /etc/nginx/sites-enabled/`
- Reload configuration `sudo nginx -s reload`
- Test with `./scripts/test/test_nginx.sh`

## Additional testing and troubleshooting

When you run into trouble check the logs:

- Apache: `/var/log/apache2/error.log`
- Nginx: `/var/log/nginx/error.log`
- MySQL: `/var/log/mysql/error.log`
- PHP: `/var/log/php8.1-fpm.log`
- HAProxy: `/var/log/haproxy.log`
- Varnish: `/var/log/varnish.log`
- Let's Encrypt: `/var/log/letsencrypt/letsencrypt.log`

1. Check MySQL connection and WordPress database

- Log into your MySQL server using the command line: `mysql -u <user> -p`
- If you can connect successfully, your MySQL is running properly.
- Once connected to MySQL, list the databases: `SHOW DATABASES;`
- Ensure your WordPress database is listed.

2. Test WordPress installation:

- Open a web browser and navigate to your server's IP address or domain name.
- If you see the WordPress installation page or your WordPress site, it indicates that Apache/Nginx and PHP are working correctly with WordPress.

3. Check WordPress configuration:

- Verify the file in your WordPress root directory `/var/www/DOMAIN/public_html/wp-config.php` contains the correct database credentials.

4. Review server logs:

- Check Apache/Nginx error logs for any PHP or MySQL related errors: `sudo tail -f /var/log/apache2/error.log`
- or `sudo tail -f /var/log/nginx/error.log`

5. Test basic PHP processing:

- Copy `/scripts/test/test_php.php` to `/var/www/html`
- Open the test file through your web browser `http://DOMAIN/test_php.php`
- Observe the PHP version info is displayed
- Cleanup the file `rm -f /var/www/html/test_php.php`

6. Check WordPress functionality:

- Log into the WordPress admin panel (usually at /wp-admin)
- Create a test post or page to ensure the database is writable

## Future improvements

- Look into a more robust configuration management tool like Ansible or Puppet to manage configuration.
- Add scripts to automate certificate renewal and SSL termination.
- Configure WordPress to use the HAProxy load balancer.
- Implement security best practices, such as using environment variables or a secrets manager to store sensitive information.
- Add error handling mechanisms to handle unexpected errors.
